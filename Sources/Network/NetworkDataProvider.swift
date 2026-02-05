// NetworkDataProvider.swift
// iOS-Widget-Development-Kit
//
// Network Data Support for Widgets
// Created by Muhittin Camdali

import Foundation
import Combine

// MARK: - Network Configuration

/// Network request configuration
public struct NetworkConfiguration {
    public let timeout: TimeInterval
    public let cachePolicy: URLRequest.CachePolicy
    public let retryCount: Int
    public let retryDelay: TimeInterval
    
    public init(
        timeout: TimeInterval = 30,
        cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad,
        retryCount: Int = 2,
        retryDelay: TimeInterval = 1
    ) {
        self.timeout = timeout
        self.cachePolicy = cachePolicy
        self.retryCount = retryCount
        self.retryDelay = retryDelay
    }
    
    public static let `default` = NetworkConfiguration()
    public static let fastRefresh = NetworkConfiguration(timeout: 10, cachePolicy: .reloadIgnoringLocalCacheData, retryCount: 1)
    public static let cachePriority = NetworkConfiguration(timeout: 60, cachePolicy: .returnCacheDataDontLoad, retryCount: 0)
}

// MARK: - Network Error

/// Widget-specific network errors
public enum WidgetNetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingFailed(Error)
    case networkError(Error)
    case timeout
    case serverError(Int)
    case rateLimited
    case cancelled
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL provided"
        case .noData:
            return "No data received from server"
        case .decodingFailed(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .timeout:
            return "Request timed out"
        case .serverError(let code):
            return "Server returned error code: \(code)"
        case .rateLimited:
            return "Rate limited - try again later"
        case .cancelled:
            return "Request was cancelled"
        }
    }
}

// MARK: - Network Data Provider

/// Primary network data provider for widgets
public final class NetworkDataProvider {
    public static let shared = NetworkDataProvider()
    
    private let session: URLSession
    private let cache = URLCache(
        memoryCapacity: 10 * 1024 * 1024,  // 10 MB
        diskCapacity: 50 * 1024 * 1024,     // 50 MB
        directory: nil
    )
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        configuration.waitsForConnectivity = true
        configuration.urlCache = cache
        
        session = URLSession(configuration: configuration)
    }
    
    /// Fetch decodable data from URL
    public func fetch<T: Decodable>(
        _ type: T.Type,
        from url: URL,
        configuration: NetworkConfiguration = .default
    ) async throws -> T {
        var lastError: Error = WidgetNetworkError.networkError(NSError(domain: "", code: -1))
        
        for attempt in 0...configuration.retryCount {
            if attempt > 0 {
                try await Task.sleep(nanoseconds: UInt64(configuration.retryDelay * 1_000_000_000))
            }
            
            do {
                var request = URLRequest(url: url)
                request.timeoutInterval = configuration.timeout
                request.cachePolicy = configuration.cachePolicy
                
                let (data, response) = try await session.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw WidgetNetworkError.networkError(NSError(domain: "Invalid response", code: -1))
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    do {
                        let decoded = try JSONDecoder().decode(type, from: data)
                        return decoded
                    } catch {
                        throw WidgetNetworkError.decodingFailed(error)
                    }
                    
                case 429:
                    throw WidgetNetworkError.rateLimited
                    
                case 500...599:
                    throw WidgetNetworkError.serverError(httpResponse.statusCode)
                    
                default:
                    throw WidgetNetworkError.serverError(httpResponse.statusCode)
                }
                
            } catch is CancellationError {
                throw WidgetNetworkError.cancelled
            } catch let error as WidgetNetworkError {
                lastError = error
                // Don't retry certain errors
                if case .decodingFailed = error { throw error }
                if case .rateLimited = error { throw error }
            } catch {
                lastError = WidgetNetworkError.networkError(error)
            }
        }
        
        throw lastError
    }
    
    /// Fetch with custom decoder
    public func fetch<T: Decodable>(
        _ type: T.Type,
        from url: URL,
        decoder: JSONDecoder,
        configuration: NetworkConfiguration = .default
    ) async throws -> T {
        var request = URLRequest(url: url)
        request.timeoutInterval = configuration.timeout
        request.cachePolicy = configuration.cachePolicy
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw WidgetNetworkError.serverError((response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        
        return try decoder.decode(type, from: data)
    }
    
    /// Fetch raw data
    public func fetchData(from url: URL, configuration: NetworkConfiguration = .default) async throws -> Data {
        var request = URLRequest(url: url)
        request.timeoutInterval = configuration.timeout
        request.cachePolicy = configuration.cachePolicy
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw WidgetNetworkError.serverError((response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        
        return data
    }
    
    /// Fetch with POST request
    public func post<T: Decodable, U: Encodable>(
        _ type: T.Type,
        to url: URL,
        body: U,
        configuration: NetworkConfiguration = .default
    ) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = configuration.timeout
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw WidgetNetworkError.serverError((response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        
        return try JSONDecoder().decode(type, from: data)
    }
    
    /// Clear URL cache
    public func clearCache() {
        cache.removeAllCachedResponses()
    }
}

// MARK: - Cached Network Provider

/// Network provider with built-in caching layer
public final class CachedNetworkProvider<T: Codable> {
    private let networkProvider = NetworkDataProvider.shared
    private let cacheManager = TimelineCacheManager.shared
    private let cacheKey: String
    private let cacheDuration: TimeInterval
    
    public init(cacheKey: String, cacheDuration: TimeInterval = 300) {
        self.cacheKey = cacheKey
        self.cacheDuration = cacheDuration
    }
    
    /// Fetch data with cache fallback
    public func fetch(from url: URL, forceRefresh: Bool = false) async throws -> T {
        // Check cache first (unless force refresh)
        if !forceRefresh, let cached: T = cacheManager.retrieve(T.self, forKey: cacheKey) {
            return cached
        }
        
        // Fetch from network
        let data = try await networkProvider.fetch(T.self, from: url)
        
        // Store in cache
        cacheManager.store(data, forKey: cacheKey, expiration: cacheDuration)
        
        return data
    }
    
    /// Get cached data only
    public func getCached() -> T? {
        cacheManager.retrieve(T.self, forKey: cacheKey)
    }
    
    /// Clear this provider's cache
    public func clearCache() {
        cacheManager.clear(forKey: cacheKey)
    }
}

// MARK: - API Endpoint Builder

/// Builder for constructing API endpoints
public final class APIEndpointBuilder {
    private var baseURL: String
    private var path: String = ""
    private var queryItems: [URLQueryItem] = []
    private var headers: [String: String] = [:]
    
    public init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    @discardableResult
    public func path(_ path: String) -> Self {
        self.path = path
        return self
    }
    
    @discardableResult
    public func appendPath(_ segment: String) -> Self {
        self.path += "/\(segment)"
        return self
    }
    
    @discardableResult
    public func query(_ name: String, value: String) -> Self {
        queryItems.append(URLQueryItem(name: name, value: value))
        return self
    }
    
    @discardableResult
    public func query(_ items: [String: String]) -> Self {
        for (name, value) in items {
            queryItems.append(URLQueryItem(name: name, value: value))
        }
        return self
    }
    
    @discardableResult
    public func header(_ name: String, value: String) -> Self {
        headers[name] = value
        return self
    }
    
    public func build() -> URL? {
        var components = URLComponents(string: baseURL + path)
        if !queryItems.isEmpty {
            components?.queryItems = queryItems
        }
        return components?.url
    }
    
    public func buildRequest() -> URLRequest? {
        guard let url = build() else { return nil }
        var request = URLRequest(url: url)
        for (name, value) in headers {
            request.setValue(value, forHTTPHeaderField: name)
        }
        return request
    }
}

// MARK: - Background Refresh Support

/// Background refresh coordinator for widgets
public final class BackgroundRefreshCoordinator {
    public static let shared = BackgroundRefreshCoordinator()
    
    private let userDefaults = UserDefaults(suiteName: "group.widget.background") ?? .standard
    
    private init() {}
    
    /// Schedule background refresh
    public func scheduleBackgroundRefresh(identifier: String, afterInterval: TimeInterval) {
        let nextRefresh = Date().addingTimeInterval(afterInterval)
        userDefaults.set(nextRefresh, forKey: "bg_refresh_\(identifier)")
    }
    
    /// Check if background refresh is due
    public func isRefreshDue(identifier: String) -> Bool {
        guard let scheduledDate = userDefaults.object(forKey: "bg_refresh_\(identifier)") as? Date else {
            return true
        }
        return Date() >= scheduledDate
    }
    
    /// Mark refresh as completed
    public func markRefreshCompleted(identifier: String) {
        userDefaults.removeObject(forKey: "bg_refresh_\(identifier)")
    }
    
    /// Get last refresh date
    public func lastRefreshDate(identifier: String) -> Date? {
        userDefaults.object(forKey: "bg_last_refresh_\(identifier)") as? Date
    }
    
    /// Record refresh timestamp
    public func recordRefresh(identifier: String) {
        userDefaults.set(Date(), forKey: "bg_last_refresh_\(identifier)")
    }
}

// MARK: - Data Sync Manager

/// Manages data synchronization between app and widget
public final class WidgetDataSyncManager {
    public static let shared = WidgetDataSyncManager()
    
    private let sharedDefaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private init() {
        sharedDefaults = UserDefaults(suiteName: "group.widget.data") ?? .standard
    }
    
    /// Share data with widget
    public func shareData<T: Encodable>(_ data: T, key: String) throws {
        let encoded = try encoder.encode(data)
        sharedDefaults.set(encoded, forKey: key)
        
        // Notify widgets of data change
        WidgetReloadManager.shared.reloadAllWidgets()
    }
    
    /// Retrieve shared data
    public func retrieveData<T: Decodable>(_ type: T.Type, key: String) throws -> T? {
        guard let data = sharedDefaults.data(forKey: key) else {
            return nil
        }
        return try decoder.decode(type, from: data)
    }
    
    /// Remove shared data
    public func removeData(key: String) {
        sharedDefaults.removeObject(forKey: key)
    }
    
    /// Observe data changes
    public func observeChanges<T: Decodable>(
        _ type: T.Type,
        key: String,
        handler: @escaping (T?) -> Void
    ) -> NSObjectProtocol {
        NotificationCenter.default.addObserver(
            forName: UserDefaults.didChangeNotification,
            object: sharedDefaults,
            queue: .main
        ) { [weak self] _ in
            let data = try? self?.retrieveData(type, key: key)
            handler(data)
        }
    }
}

// MARK: - Polling Manager

/// Manages periodic data polling for widgets
public final class PollingManager {
    public static let shared = PollingManager()
    
    private var pollingTasks: [String: Task<Void, Never>] = [:]
    private let queue = DispatchQueue(label: "polling.manager.queue")
    
    private init() {}
    
    /// Start polling for data
    public func startPolling<T: Decodable>(
        identifier: String,
        url: URL,
        type: T.Type,
        interval: TimeInterval,
        handler: @escaping (Result<T, Error>) -> Void
    ) {
        stopPolling(identifier: identifier)
        
        let task = Task {
            while !Task.isCancelled {
                do {
                    let data = try await NetworkDataProvider.shared.fetch(type, from: url)
                    await MainActor.run {
                        handler(.success(data))
                    }
                } catch {
                    await MainActor.run {
                        handler(.failure(error))
                    }
                }
                
                try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
            }
        }
        
        queue.sync {
            pollingTasks[identifier] = task
        }
    }
    
    /// Stop polling
    public func stopPolling(identifier: String) {
        queue.sync {
            pollingTasks[identifier]?.cancel()
            pollingTasks.removeValue(forKey: identifier)
        }
    }
    
    /// Stop all polling
    public func stopAllPolling() {
        queue.sync {
            pollingTasks.values.forEach { $0.cancel() }
            pollingTasks.removeAll()
        }
    }
}
