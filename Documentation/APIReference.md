# API Reference

## WidgetEngine

The core widget engine that manages widget lifecycle and performance.

### Properties

```swift
public static let shared: WidgetEngine
public var currentConfiguration: WidgetConfiguration?
public var performanceMetrics: WidgetPerformanceMetrics
```

### Methods

#### registerTemplate(_:)
Registers a widget template with the engine.

```swift
public func registerTemplate(_ template: WidgetTemplate)
```

**Parameters:**
- `template`: The widget template to register

#### createWidget(with:)
Creates a widget view with the specified configuration.

```swift
public func createWidget(with configuration: WidgetConfiguration) -> some View
```

**Parameters:**
- `configuration`: Widget configuration

**Returns:** Widget view

#### updateWidget(_:with:)
Updates a widget with new data.

```swift
public func updateWidget(_ widgetId: String, with data: WidgetData)
```

**Parameters:**
- `widgetId`: Widget identifier
- `data`: New data to update

#### configurePerformance(_:)
Configures widget performance settings.

```swift
public func configurePerformance(_ settings: WidgetPerformanceSettings)
```

**Parameters:**
- `settings`: Performance configuration

#### getAnalytics()
Returns analytics data.

```swift
public func getAnalytics() -> WidgetAnalytics
```

**Returns:** Analytics data

## WidgetTemplate

Base protocol for all widget templates.

### Properties

```swift
var identifier: String { get }
var displayName: String { get }
var description: String { get }
var supportedSizes: [WidgetFamily] { get }
```

### Methods

#### createWidget(configuration:)
Creates widget view with configuration.

```swift
func createWidget(configuration: WidgetConfiguration) -> AnyView
```

#### validateConfiguration(_:)
Validates configuration.

```swift
func validateConfiguration(_ configuration: WidgetConfiguration) -> Bool
```

#### getDefaultConfiguration()
Returns default configuration.

```swift
func getDefaultConfiguration() -> WidgetConfiguration
```

## WidgetConfiguration

Configuration for widget setup.

### Properties

```swift
public let id: String
public let templateIdentifier: String
public let widgets: [WidgetDefinition]
public let settings: WidgetSettings
```

### Initializer

```swift
public init(id: String, templateIdentifier: String, widgets: [WidgetDefinition], settings: WidgetSettings)
```

## WidgetDefinition

Definition of a widget instance.

### Properties

```swift
public let id: String
public let type: WidgetType
public let dataSourceIdentifier: String?
public let customization: WidgetCustomization
```

### Initializer

```swift
public init(id: String, type: WidgetType, dataSourceIdentifier: String? = nil, customization: WidgetCustomization)
```

## WidgetCustomization

Customization options for widget appearance.

### Properties

```swift
public let backgroundColor: Color
public let textColor: Color
public let accentColor: Color
public let cornerRadius: CGFloat
public let padding: EdgeInsets
public let font: Font
```

### Initializer

```swift
public init(backgroundColor: Color = .clear, textColor: Color = .primary, accentColor: Color = .blue, cornerRadius: CGFloat = 12, padding: EdgeInsets = EdgeInsets(), font: Font = .body)
```

## WidgetSettings

Settings for widget behavior.

### Properties

```swift
public let refreshInterval: TimeInterval
public let enableAnimations: Bool
public let enableHaptics: Bool
public let enableSound: Bool
```

### Initializer

```swift
public init(refreshInterval: TimeInterval = 30.0, enableAnimations: Bool = true, enableHaptics: Bool = true, enableSound: Bool = false)
```

## WidgetData

Data structure for widget content.

### Properties

```swift
public let id: String
public let type: WidgetType
public let content: [String: Any]
public let timestamp: Date
```

### Initializer

```swift
public init(id: String, type: WidgetType, content: [String: Any], timestamp: Date = Date())
```

## WidgetType

Enumeration of supported widget types.

```swift
public enum WidgetType: String, CaseIterable {
    case weather = "weather"
    case calendar = "calendar"
    case fitness = "fitness"
    case news = "news"
    case social = "social"
    case productivity = "productivity"
    case entertainment = "entertainment"
    case finance = "finance"
    case health = "health"
    case travel = "travel"
}
```

## LiveDataIntegration

Framework for real-time data integration.

### Methods

#### registerDataSource(_:dataSource:)
Registers a data source for live updates.

```swift
public func registerDataSource(_ identifier: String, dataSource: WidgetDataSource)
```

#### connectWebSocket(identifier:url:headers:)
Connects to WebSocket for real-time data.

```swift
public func connectWebSocket(identifier: String, url: URL, headers: [String: String] = [:])
```

#### disconnectWebSocket(identifier:)
Disconnects WebSocket.

```swift
public func disconnectWebSocket(identifier: String)
```

#### getDataPublisher(for:)
Gets data publisher for specific source.

```swift
public func getDataPublisher(for identifier: String) -> AnyPublisher<WidgetData, Never>?
```

#### sendData(to:data:)
Sends data to specific widget.

```swift
public func sendData(to widgetId: String, data: WidgetData)
```

#### configureDataSource(_:settings:)
Configures data source settings.

```swift
public func configureDataSource(_ identifier: String, settings: DataSourceSettings)
```

#### getConnectionStatus(for:)
Gets connection status.

```swift
public func getConnectionStatus(for identifier: String) -> ConnectionStatus
```

## WidgetDataSource

Protocol for data sources.

### Properties

```swift
var identifier: String { get }
var dataPublisher: AnyPublisher<WidgetData, Never> { get }
```

### Methods

#### refresh()
Refreshes data source.

```swift
func refresh()
```

#### configure(_:)
Configures data source settings.

```swift
func configure(_ settings: DataSourceSettings)
```

## DataSourceSettings

Settings for data sources.

### Properties

```swift
public let refreshInterval: TimeInterval
public let enableCaching: Bool
public let maxRetries: Int
public let timeout: TimeInterval
```

### Initializer

```swift
public init(refreshInterval: TimeInterval = 30.0, enableCaching: Bool = true, maxRetries: Int = 3, timeout: TimeInterval = 10.0)
```

## ConnectionStatus

Enumeration of connection statuses.

```swift
public enum ConnectionStatus {
    case connected
    case connecting
    case disconnected
    case unknown
}
```

## WidgetAnalyticsService

Service for analytics and performance tracking.

### Methods

#### getAnalytics()
Returns analytics data.

```swift
public func getAnalytics() -> WidgetAnalytics
```

#### configure(_:)
Configures analytics service.

```swift
public func configure(_ config: AnalyticsConfiguration)
```

#### exportAnalytics()
Exports analytics data.

```swift
public func exportAnalytics() -> Data?
```

#### clearAnalytics()
Clears analytics data.

```swift
public func clearAnalytics()
```

## WidgetAnalytics

Analytics data structure.

### Properties

```swift
public var totalWidgetUpdates: Int
public var widgetUpdates: [String: Int]
public var templateRegistrations: Int
public var dataSourceRegistrations: Int
public var webSocketConnections: Int
public var webSocketDisconnections: Int
public var dataSentCount: Int
public var dataSourceUpdates: Int
public var dataSourceConfigurations: Int
public var connectionsEstablished: Int
public var connectionFailures: Int
public var connectionsCancelled: Int
public var connectionRetries: Int
public var reconnectionAttempts: Int
public var dataReceiveErrors: Int
public var dataDecodeErrors: Int
public var networkUnavailableEvents: Int
public var memoryCleanups: Int
public var batteryOptimizations: Int
public var errors: Int
public var engineInitializations: Int
public var sessionStartTime: Date
public var lastUpdateTime: Date
```

## AnalyticsConfiguration

Configuration for analytics service.

### Properties

```swift
public let enableExternalAnalytics: Bool
public let maxEventLogSize: Int
public let enablePerformanceTracking: Bool
public let enableErrorTracking: Bool
```

### Initializer

```swift
public init(enableExternalAnalytics: Bool = false, maxEventLogSize: Int = 1000, enablePerformanceTracking: Bool = true, enableErrorTracking: Bool = true)
```

## WidgetPerformanceMetrics

Performance metrics for widgets.

### Properties

```swift
@Published public var memoryUsage: UInt64
@Published public var batteryLevel: Float
@Published public var refreshCount: Int
@Published public var errorCount: Int
@Published public var settings: WidgetPerformanceSettings
```

### Methods

#### update(_:)
Updates metrics with new data.

```swift
public func update(_ metrics: WidgetPerformanceMetrics)
```

#### updateMemoryUsage(_:)
Updates memory usage.

```swift
public func updateMemoryUsage(_ usage: UInt64)
```

#### updateBatteryLevel(_:)
Updates battery level.

```swift
public func updateBatteryLevel(_ level: Float)
```

#### updateSettings(_:)
Updates performance settings.

```swift
public func updateSettings(_ settings: WidgetPerformanceSettings)
```

#### updateBackgroundRefresh()
Updates background refresh count.

```swift
public func updateBackgroundRefresh()
```

## WidgetPerformanceSettings

Settings for performance optimization.

### Properties

```swift
public let maxMemoryUsage: UInt64
public let refreshInterval: TimeInterval
public let enableBatteryOptimization: Bool
```

### Initializer

```swift
public init(maxMemoryUsage: UInt64 = 100 * 1024 * 1024, refreshInterval: TimeInterval = 30.0, enableBatteryOptimization: Bool = true)
```

## WidgetError

Error types for widgets.

```swift
public enum WidgetError: Error, LocalizedError {
    case templateNotFound(String)
    case dataSourceNotFound(String)
    case connectionFailed(String)
    case dataDecodeFailed(String)
    case networkUnavailable
    case unknown
}
```

## Notification Names

```swift
extension Notification.Name {
    static let widgetDidUpdate = Notification.Name("widgetDidUpdate")
    static let widgetErrorOccurred = Notification.Name("widgetErrorOccurred")
    static let widgetDataReceived = Notification.Name("widgetDataReceived")
    static let dataSourceUpdated = Notification.Name("dataSourceUpdated")
}
``` 