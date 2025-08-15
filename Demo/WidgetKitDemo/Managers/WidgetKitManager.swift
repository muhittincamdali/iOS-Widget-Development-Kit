import Foundation
import SwiftUI
import WidgetKit
import Combine

/// Manager class for handling all widget-related operations in the demo app
@available(iOS 16.0, *)
@MainActor
public class WidgetKitManager: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published public var availableWidgets: [WidgetModel] = []
    @Published public var activeWidgets: [WidgetModel] = []
    @Published public var enableHomeScreen: Bool = true
    @Published public var enableLockScreen: Bool = true
    @Published public var enableLiveActivities: Bool = true
    @Published public var enableDynamicIsland: Bool = true
    @Published public var isConfigured: Bool = false
    
    // MARK: - Private Properties
    
    private var configuration = WidgetConfiguration()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    public init() {
        loadAvailableWidgets()
        setupObservers()
    }
    
    // MARK: - Public Methods
    
    /// Configures the widget manager with custom settings
    public func configure(_ block: (inout WidgetConfiguration) -> Void) {
        block(&configuration)
        isConfigured = true
        applyConfiguration()
    }
    
    /// Creates a new widget with specified parameters
    public func createWidget(type: WidgetType, size: WidgetSize, content: AnyView) async throws -> WidgetModel {
        let widget = WidgetModel(
            id: UUID().uuidString,
            type: type,
            size: size,
            title: "New Widget",
            subtitle: "Custom widget",
            icon: "square.grid.2x2",
            isActive: false,
            lastUpdated: Date()
        )
        
        availableWidgets.append(widget)
        
        // Request widget timeline reload
        WidgetCenter.shared.reloadAllTimelines()
        
        return widget
    }
    
    /// Activates a widget
    public func activateWidget(_ widget: WidgetModel) async throws {
        guard let index = availableWidgets.firstIndex(where: { $0.id == widget.id }) else {
            throw WidgetError.widgetNotFound
        }
        
        availableWidgets[index].isActive = true
        activeWidgets.append(availableWidgets[index])
        
        // Update widget timeline
        WidgetCenter.shared.reloadTimelines(ofKind: widget.kind)
    }
    
    /// Deactivates a widget
    public func deactivateWidget(_ widget: WidgetModel) async throws {
        guard let availableIndex = availableWidgets.firstIndex(where: { $0.id == widget.id }) else {
            throw WidgetError.widgetNotFound
        }
        
        availableWidgets[availableIndex].isActive = false
        activeWidgets.removeAll { $0.id == widget.id }
        
        // Update widget timeline
        WidgetCenter.shared.reloadTimelines(ofKind: widget.kind)
    }
    
    /// Updates widget content
    public func updateWidget(_ widget: WidgetModel, with data: WidgetData) async throws {
        guard let index = availableWidgets.firstIndex(where: { $0.id == widget.id }) else {
            throw WidgetError.widgetNotFound
        }
        
        availableWidgets[index].lastUpdated = Date()
        
        // Store widget data for timeline provider
        UserDefaults.standard.set(try? JSONEncoder().encode(data), forKey: "widget_data_\(widget.id)")
        
        // Reload widget timeline
        WidgetCenter.shared.reloadTimelines(ofKind: widget.kind)
    }
    
    /// Refreshes all widgets
    public func refreshAllWidgets() async {
        WidgetCenter.shared.reloadAllTimelines()
        
        for index in availableWidgets.indices {
            availableWidgets[index].lastUpdated = Date()
        }
    }
    
    /// Gets widget statistics
    public func getWidgetStatistics() -> WidgetStatistics {
        return WidgetStatistics(
            totalWidgets: availableWidgets.count,
            activeWidgets: activeWidgets.count,
            homeScreenWidgets: availableWidgets.filter { $0.type == .homeScreen }.count,
            lockScreenWidgets: availableWidgets.filter { $0.type == .lockScreen }.count,
            liveActivities: availableWidgets.filter { $0.type == .liveActivity }.count
        )
    }
    
    // MARK: - Private Methods
    
    private func loadAvailableWidgets() {
        // Load sample widgets for demo
        availableWidgets = [
            WidgetModel(
                id: "weather",
                type: .homeScreen,
                size: .medium,
                title: "Weather Widget",
                subtitle: "Current weather conditions",
                icon: "cloud.sun.fill",
                isActive: true,
                lastUpdated: Date()
            ),
            WidgetModel(
                id: "calendar",
                type: .homeScreen,
                size: .small,
                title: "Calendar Widget",
                subtitle: "Upcoming events",
                icon: "calendar",
                isActive: true,
                lastUpdated: Date()
            ),
            WidgetModel(
                id: "fitness",
                type: .lockScreen,
                size: .small,
                title: "Fitness Widget",
                subtitle: "Activity rings",
                icon: "figure.walk",
                isActive: false,
                lastUpdated: Date()
            ),
            WidgetModel(
                id: "stocks",
                type: .homeScreen,
                size: .large,
                title: "Stocks Widget",
                subtitle: "Market overview",
                icon: "chart.line.uptrend.xyaxis",
                isActive: false,
                lastUpdated: Date()
            ),
            WidgetModel(
                id: "music",
                type: .lockScreen,
                size: .small,
                title: "Music Widget",
                subtitle: "Now playing",
                icon: "music.note",
                isActive: true,
                lastUpdated: Date()
            ),
            WidgetModel(
                id: "news",
                type: .homeScreen,
                size: .medium,
                title: "News Widget",
                subtitle: "Top headlines",
                icon: "newspaper",
                isActive: false,
                lastUpdated: Date()
            ),
            WidgetModel(
                id: "battery",
                type: .lockScreen,
                size: .small,
                title: "Battery Widget",
                subtitle: "Device battery status",
                icon: "battery.75",
                isActive: true,
                lastUpdated: Date()
            ),
            WidgetModel(
                id: "reminders",
                type: .homeScreen,
                size: .small,
                title: "Reminders Widget",
                subtitle: "Today's tasks",
                icon: "checklist",
                isActive: false,
                lastUpdated: Date()
            )
        ]
        
        // Filter active widgets
        activeWidgets = availableWidgets.filter { $0.isActive }
    }
    
    private func setupObservers() {
        // Observe widget configuration changes
        NotificationCenter.default.publisher(for: .widgetConfigurationChanged)
            .sink { [weak self] _ in
                Task { @MainActor in
                    await self?.refreshAllWidgets()
                }
            }
            .store(in: &cancellables)
    }
    
    private func applyConfiguration() {
        enableHomeScreen = configuration.enableHomeScreenWidgets
        enableLockScreen = configuration.enableLockScreenWidgets
        enableLiveActivities = configuration.enableLiveActivities
        enableDynamicIsland = configuration.enableDynamicIsland
    }
}

// MARK: - Supporting Types

@available(iOS 16.0, *)
public struct WidgetModel: Identifiable, Codable {
    public let id: String
    public let type: WidgetType
    public let size: WidgetSize
    public let title: String
    public let subtitle: String
    public let icon: String
    public var isActive: Bool
    public var lastUpdated: Date
    
    public var kind: String {
        return "com.widgetkit.demo.\(id)"
    }
}

public enum WidgetType: String, Codable, CaseIterable {
    case homeScreen = "home_screen"
    case lockScreen = "lock_screen"
    case standBy = "stand_by"
    case liveActivity = "live_activity"
    case dynamicIsland = "dynamic_island"
    
    public var displayName: String {
        switch self {
        case .homeScreen: return "Home Screen"
        case .lockScreen: return "Lock Screen"
        case .standBy: return "StandBy"
        case .liveActivity: return "Live Activity"
        case .dynamicIsland: return "Dynamic Island"
        }
    }
}

public enum WidgetSize: String, Codable, CaseIterable {
    case small = "small"
    case medium = "medium"
    case large = "large"
    case extraLarge = "extra_large"
    
    public var displayName: String {
        switch self {
        case .small: return "Small"
        case .medium: return "Medium"
        case .large: return "Large"
        case .extraLarge: return "Extra Large"
        }
    }
    
    public var dimensions: CGSize {
        switch self {
        case .small: return CGSize(width: 155, height: 155)
        case .medium: return CGSize(width: 329, height: 155)
        case .large: return CGSize(width: 329, height: 345)
        case .extraLarge: return CGSize(width: 329, height: 382)
        }
    }
}

public struct WidgetConfiguration {
    public var enableHomeScreenWidgets: Bool = true
    public var enableLockScreenWidgets: Bool = true
    public var enableLiveActivities: Bool = true
    public var enableDynamicIsland: Bool = true
    public var refreshInterval: TimeInterval = 300 // 5 minutes
    public var enableBackgroundRefresh: Bool = true
    public var enableInteractions: Bool = true
    public var enableDeepLinking: Bool = true
}

public struct WidgetData: Codable {
    public let content: [String: Any]
    public let timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case content
        case timestamp
    }
    
    public init(content: [String: Any], timestamp: Date = Date()) {
        self.content = content
        self.timestamp = timestamp
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        
        // Decode content as Data and convert to dictionary
        if let data = try? container.decode(Data.self, forKey: .content),
           let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            content = dict
        } else {
            content = [:]
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(timestamp, forKey: .timestamp)
        
        // Encode content dictionary as Data
        if let data = try? JSONSerialization.data(withJSONObject: content) {
            try container.encode(data, forKey: .content)
        }
    }
}

public struct WidgetStatistics {
    public let totalWidgets: Int
    public let activeWidgets: Int
    public let homeScreenWidgets: Int
    public let lockScreenWidgets: Int
    public let liveActivities: Int
}

public enum WidgetError: LocalizedError {
    case widgetNotFound
    case invalidConfiguration
    case activationFailed
    case updateFailed
    
    public var errorDescription: String? {
        switch self {
        case .widgetNotFound:
            return "Widget not found"
        case .invalidConfiguration:
            return "Invalid widget configuration"
        case .activationFailed:
            return "Failed to activate widget"
        case .updateFailed:
            return "Failed to update widget"
        }
    }
}

// MARK: - Notifications

extension Notification.Name {
    static let widgetConfigurationChanged = Notification.Name("widgetConfigurationChanged")
    static let widgetActivated = Notification.Name("widgetActivated")
    static let widgetDeactivated = Notification.Name("widgetDeactivated")
    static let widgetUpdated = Notification.Name("widgetUpdated")
}