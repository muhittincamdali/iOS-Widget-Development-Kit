// TimelineManager.swift
// iOS-Widget-Development-Kit
//
// Advanced Timeline Management System
// Created by Muhittin Camdali

import Foundation
import WidgetKit
import Combine

// MARK: - Timeline Policy

/// Widget update policy configuration
public enum WidgetUpdatePolicy {
    /// Update at specific date
    case atDate(Date)
    
    /// Update after specific interval
    case afterInterval(TimeInterval)
    
    /// Update at end of day
    case endOfDay
    
    /// Update at start of next hour
    case nextHour
    
    /// Update every X minutes
    case every(minutes: Int)
    
    /// Never update automatically
    case never
    
    /// Custom date calculation
    case custom((Date) -> Date)
    
    public func nextUpdateDate(from date: Date = Date()) -> Date? {
        switch self {
        case .atDate(let targetDate):
            return targetDate
            
        case .afterInterval(let interval):
            return date.addingTimeInterval(interval)
            
        case .endOfDay:
            let calendar = Calendar.current
            return calendar.startOfDay(for: date.addingTimeInterval(86400))
            
        case .nextHour:
            let calendar = Calendar.current
            var components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
            components.hour! += 1
            return calendar.date(from: components)
            
        case .every(let minutes):
            return date.addingTimeInterval(Double(minutes * 60))
            
        case .never:
            return nil
            
        case .custom(let calculator):
            return calculator(date)
        }
    }
}

// MARK: - Timeline Entry Protocol

/// Protocol for timeline entries
public protocol WidgetTimelineEntry: TimelineEntry {
    var relevance: TimelineEntryRelevance? { get }
    var isPlaceholder: Bool { get }
}

/// Default implementation
extension WidgetTimelineEntry {
    public var relevance: TimelineEntryRelevance? { nil }
    public var isPlaceholder: Bool { false }
}

// MARK: - Timeline Builder

/// Builder for creating widget timelines
public final class TimelineBuilder<Entry: TimelineEntry> {
    private var entries: [Entry] = []
    private var policy: TimelineReloadPolicy = .atEnd
    
    public init() {}
    
    /// Add a single entry
    @discardableResult
    public func addEntry(_ entry: Entry) -> Self {
        entries.append(entry)
        return self
    }
    
    /// Add multiple entries
    @discardableResult
    public func addEntries(_ newEntries: [Entry]) -> Self {
        entries.append(contentsOf: newEntries)
        return self
    }
    
    /// Set reload policy
    @discardableResult
    public func reloadPolicy(_ policy: TimelineReloadPolicy) -> Self {
        self.policy = policy
        return self
    }
    
    /// Set reload after interval
    @discardableResult
    public func reloadAfter(_ interval: TimeInterval) -> Self {
        self.policy = .after(Date().addingTimeInterval(interval))
        return self
    }
    
    /// Set reload at end
    @discardableResult
    public func reloadAtEnd() -> Self {
        self.policy = .atEnd
        return self
    }
    
    /// Set never reload
    @discardableResult
    public func neverReload() -> Self {
        self.policy = .never
        return self
    }
    
    /// Build the timeline
    public func build() -> Timeline<Entry> {
        Timeline(entries: entries, policy: policy)
    }
}

// MARK: - Smart Timeline Provider

/// Base class for smart timeline providers with caching and optimization
public protocol SmartTimelineProvider: TimelineProvider {
    associatedtype DataType
    
    /// Fetch fresh data
    func fetchData() async throws -> DataType
    
    /// Create entry from data
    func createEntry(from data: DataType, date: Date, isPlaceholder: Bool) -> Entry
    
    /// Update policy
    var updatePolicy: WidgetUpdatePolicy { get }
    
    /// Cache duration in seconds
    var cacheDuration: TimeInterval { get }
    
    /// Number of timeline entries to generate
    var timelineEntryCount: Int { get }
}

extension SmartTimelineProvider {
    public var cacheDuration: TimeInterval { 300 } // 5 minutes default
    public var timelineEntryCount: Int { 5 }
    
    public func placeholder(in context: Context) -> Entry {
        let placeholderData: DataType? = nil
        return createEntry(from: placeholderData as! DataType, date: Date(), isPlaceholder: true)
    }
    
    public func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            do {
                let data = try await fetchData()
                
                var entries: [Entry] = []
                let currentDate = Date()
                
                // Generate timeline entries
                for i in 0..<timelineEntryCount {
                    guard let nextDate = updatePolicy.nextUpdateDate(from: currentDate.addingTimeInterval(Double(i) * cacheDuration)) else {
                        continue
                    }
                    entries.append(createEntry(from: data, date: nextDate, isPlaceholder: false))
                }
                
                if entries.isEmpty {
                    entries.append(createEntry(from: data, date: currentDate, isPlaceholder: false))
                }
                
                let nextUpdate = updatePolicy.nextUpdateDate(from: currentDate) ?? currentDate.addingTimeInterval(cacheDuration)
                let timeline = Timeline(entries: entries, policy: .after(nextUpdate))
                
                completion(timeline)
            } catch {
                // Return placeholder on error
                let entry = createEntry(from: nil as! DataType, date: Date(), isPlaceholder: true)
                let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60)))
                completion(timeline)
            }
        }
    }
}

// MARK: - Timeline Cache Manager

/// Manages caching for timeline data
public final class TimelineCacheManager {
    public static let shared = TimelineCacheManager()
    
    private let cache = NSCache<NSString, CacheEntry>()
    private let defaults: UserDefaults
    
    private init() {
        defaults = UserDefaults(suiteName: "group.widget.timeline") ?? .standard
        cache.countLimit = 50
        cache.totalCostLimit = 10 * 1024 * 1024 // 10 MB
    }
    
    /// Cache entry wrapper
    private class CacheEntry {
        let data: Data
        let timestamp: Date
        let expiration: TimeInterval
        
        var isExpired: Bool {
            Date().timeIntervalSince(timestamp) > expiration
        }
        
        init(data: Data, timestamp: Date, expiration: TimeInterval) {
            self.data = data
            self.timestamp = timestamp
            self.expiration = expiration
        }
    }
    
    /// Store data in cache
    public func store<T: Encodable>(_ value: T, forKey key: String, expiration: TimeInterval = 300) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        let entry = CacheEntry(data: data, timestamp: Date(), expiration: expiration)
        cache.setObject(entry, forKey: key as NSString)
        
        // Also persist to UserDefaults for cross-process access
        defaults.set(data, forKey: "cache_\(key)")
        defaults.set(Date(), forKey: "cache_timestamp_\(key)")
        defaults.set(expiration, forKey: "cache_expiration_\(key)")
    }
    
    /// Retrieve data from cache
    public func retrieve<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        // Check in-memory cache first
        if let entry = cache.object(forKey: key as NSString), !entry.isExpired {
            return try? JSONDecoder().decode(type, from: entry.data)
        }
        
        // Check UserDefaults
        guard let data = defaults.data(forKey: "cache_\(key)"),
              let timestamp = defaults.object(forKey: "cache_timestamp_\(key)") as? Date,
              let expiration = defaults.double(forKey: "cache_expiration_\(key)") as Double? else {
            return nil
        }
        
        let age = Date().timeIntervalSince(timestamp)
        if age > expiration {
            clear(forKey: key)
            return nil
        }
        
        return try? JSONDecoder().decode(type, from: data)
    }
    
    /// Clear specific cache entry
    public func clear(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
        defaults.removeObject(forKey: "cache_\(key)")
        defaults.removeObject(forKey: "cache_timestamp_\(key)")
        defaults.removeObject(forKey: "cache_expiration_\(key)")
    }
    
    /// Clear all cache
    public func clearAll() {
        cache.removeAllObjects()
    }
}

// MARK: - Widget Reload Manager

/// Centralized widget reload management
public final class WidgetReloadManager {
    public static let shared = WidgetReloadManager()
    
    private var reloadTimers: [String: Timer] = [:]
    private let queue = DispatchQueue(label: "widget.reload.queue")
    
    private init() {}
    
    /// Reload all widgets
    public func reloadAllWidgets() {
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    /// Reload specific widget kind
    public func reloadWidget(kind: String) {
        WidgetCenter.shared.reloadTimelines(ofKind: kind)
    }
    
    /// Schedule periodic reload
    public func schedulePeriodicReload(kind: String, interval: TimeInterval) {
        queue.async { [weak self] in
            self?.cancelScheduledReload(kind: kind)
            
            let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
                self?.reloadWidget(kind: kind)
            }
            
            self?.reloadTimers[kind] = timer
            RunLoop.current.add(timer, forMode: .common)
        }
    }
    
    /// Cancel scheduled reload
    public func cancelScheduledReload(kind: String) {
        queue.async { [weak self] in
            self?.reloadTimers[kind]?.invalidate()
            self?.reloadTimers.removeValue(forKey: kind)
        }
    }
    
    /// Get current widget configurations
    public func getCurrentConfigurations(completion: @escaping ([WidgetInfo]) -> Void) {
        WidgetCenter.shared.getCurrentConfigurations { result in
            switch result {
            case .success(let infos):
                completion(infos)
            case .failure:
                completion([])
            }
        }
    }
}

// MARK: - Timeline Refresh Strategy

/// Strategy pattern for timeline refresh decisions
public protocol TimelineRefreshStrategy {
    func shouldRefresh(lastUpdate: Date, currentDate: Date) -> Bool
    func nextRefreshDate(from date: Date) -> Date
}

/// Time-based refresh strategy
public struct TimeBasedRefreshStrategy: TimelineRefreshStrategy {
    let interval: TimeInterval
    
    public init(interval: TimeInterval) {
        self.interval = interval
    }
    
    public func shouldRefresh(lastUpdate: Date, currentDate: Date) -> Bool {
        currentDate.timeIntervalSince(lastUpdate) >= interval
    }
    
    public func nextRefreshDate(from date: Date) -> Date {
        date.addingTimeInterval(interval)
    }
}

/// Battery-aware refresh strategy
public struct BatteryAwareRefreshStrategy: TimelineRefreshStrategy {
    let normalInterval: TimeInterval
    let lowBatteryInterval: TimeInterval
    let lowBatteryThreshold: Float
    
    public init(
        normalInterval: TimeInterval = 900,
        lowBatteryInterval: TimeInterval = 3600,
        lowBatteryThreshold: Float = 0.2
    ) {
        self.normalInterval = normalInterval
        self.lowBatteryInterval = lowBatteryInterval
        self.lowBatteryThreshold = lowBatteryThreshold
    }
    
    private var currentInterval: TimeInterval {
        #if os(iOS)
        let batteryLevel = UIDevice.current.batteryLevel
        if batteryLevel >= 0 && batteryLevel < lowBatteryThreshold {
            return lowBatteryInterval
        }
        #endif
        return normalInterval
    }
    
    public func shouldRefresh(lastUpdate: Date, currentDate: Date) -> Bool {
        currentDate.timeIntervalSince(lastUpdate) >= currentInterval
    }
    
    public func nextRefreshDate(from date: Date) -> Date {
        date.addingTimeInterval(currentInterval)
    }
}

/// Content-aware refresh strategy
public struct ContentAwareRefreshStrategy: TimelineRefreshStrategy {
    let contentCheckInterval: TimeInterval
    let hasNewContent: () -> Bool
    
    public init(
        contentCheckInterval: TimeInterval = 300,
        hasNewContent: @escaping () -> Bool
    ) {
        self.contentCheckInterval = contentCheckInterval
        self.hasNewContent = hasNewContent
    }
    
    public func shouldRefresh(lastUpdate: Date, currentDate: Date) -> Bool {
        let timeElapsed = currentDate.timeIntervalSince(lastUpdate) >= contentCheckInterval
        return timeElapsed && hasNewContent()
    }
    
    public func nextRefreshDate(from date: Date) -> Date {
        date.addingTimeInterval(contentCheckInterval)
    }
}

// MARK: - Timeline Metrics

/// Tracks timeline performance metrics
public final class TimelineMetrics {
    public static let shared = TimelineMetrics()
    
    private let defaults = UserDefaults(suiteName: "group.widget.metrics") ?? .standard
    private let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
    
    private init() {}
    
    /// Record timeline generation
    public func recordTimelineGeneration(kind: String, entryCount: Int, duration: TimeInterval) {
        let key = "metrics_\(kind)"
        var metrics = getMetrics(for: key)
        
        metrics["lastGeneration"] = dateFormatter.string(from: Date())
        metrics["entryCount"] = entryCount
        metrics["generationDuration"] = duration
        metrics["totalGenerations"] = (metrics["totalGenerations"] as? Int ?? 0) + 1
        
        defaults.set(metrics, forKey: key)
    }
    
    /// Record timeline refresh
    public func recordRefresh(kind: String, source: RefreshSource) {
        let key = "refresh_\(kind)"
        var refreshes = defaults.array(forKey: key) as? [[String: Any]] ?? []
        
        refreshes.append([
            "timestamp": dateFormatter.string(from: Date()),
            "source": source.rawValue
        ])
        
        // Keep last 100 refreshes
        if refreshes.count > 100 {
            refreshes = Array(refreshes.suffix(100))
        }
        
        defaults.set(refreshes, forKey: key)
    }
    
    /// Get metrics for widget
    public func getMetrics(for kind: String) -> [String: Any] {
        defaults.dictionary(forKey: "metrics_\(kind)") ?? [:]
    }
    
    /// Refresh source enum
    public enum RefreshSource: String {
        case automatic
        case manual
        case push
        case backgroundTask
    }
}

// MARK: - Convenience Extensions

extension Timeline {
    /// Create a single-entry timeline
    public static func single(_ entry: Entry, policy: TimelineReloadPolicy = .atEnd) -> Timeline<Entry> {
        Timeline(entries: [entry], policy: policy)
    }
    
    /// Create timeline that refreshes at specific intervals
    public static func refreshing(entries: [Entry], interval: TimeInterval) -> Timeline<Entry> {
        let nextRefresh = Date().addingTimeInterval(interval)
        return Timeline(entries: entries, policy: .after(nextRefresh))
    }
}
