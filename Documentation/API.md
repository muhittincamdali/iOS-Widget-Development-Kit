# API Reference

## Table of Contents

- [Overview](#overview)
- [WidgetKit Integration](#widgetkit-integration)
- [Timeline Providers](#timeline-providers)
- [Widget Views](#widget-views)
- [Data Services](#data-services)
- [Configuration](#configuration)
- [Utilities](#utilities)

---

## Overview

iOS Widget Development Kit provides a comprehensive set of tools for building beautiful, performant widgets for iOS 14+.

### Module Import

```swift
import iOSWidgetDevelopmentKit
```

---

## WidgetKit Integration

### WidgetBuilder

A fluent API for constructing widgets with minimal boilerplate.

```swift
public struct WidgetBuilder<Content: View> {
    public init(@ViewBuilder content: @escaping () -> Content)
    public func supportedFamilies(_ families: [WidgetFamily]) -> Self
    public func configurationDisplayName(_ name: String) -> Self
    public func description(_ description: String) -> Self
}
```

**Example:**

```swift
WidgetBuilder {
    MyWidgetView()
}
.supportedFamilies([.systemSmall, .systemMedium])
.configurationDisplayName("My Widget")
.description("Displays important information")
```

---

## Timeline Providers

### SimpleTimelineProvider

A simplified timeline provider with automatic refresh management.

```swift
public protocol SimpleTimelineProvider: TimelineProvider {
    associatedtype DataType
    
    func fetchData() async throws -> DataType
    var refreshInterval: TimeInterval { get }
}
```

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `refreshInterval` | `TimeInterval` | Time between updates (default: 3600) |

**Example:**

```swift
struct WeatherProvider: SimpleTimelineProvider {
    typealias DataType = WeatherData
    
    var refreshInterval: TimeInterval { 1800 } // 30 minutes
    
    func fetchData() async throws -> WeatherData {
        try await WeatherService.shared.getCurrentWeather()
    }
}
```

### IntentTimelineProvider

For configurable widgets with user intents.

```swift
public struct IntentWidgetConfiguration<Intent: WidgetConfigurationIntent> {
    public let provider: IntentTimelineProvider<Intent>
    public let content: (Entry) -> WidgetView
}
```

---

## Widget Views

### WidgetContainerView

A container that handles all widget families with appropriate layouts.

```swift
public struct WidgetContainerView<Content: View>: View {
    public init(
        @ViewBuilder small: @escaping () -> Content,
        @ViewBuilder medium: @escaping () -> Content,
        @ViewBuilder large: @escaping () -> Content
    )
}
```

### GradientBackground

Pre-built gradient backgrounds for widgets.

```swift
public enum GradientBackground {
    case sunrise
    case sunset
    case ocean
    case forest
    case custom(colors: [Color], startPoint: UnitPoint, endPoint: UnitPoint)
    
    public var gradient: LinearGradient { get }
}
```

### WidgetText

Optimized text component for widgets.

```swift
public struct WidgetText: View {
    public init(_ text: String, style: TextStyle = .body)
    
    public enum TextStyle {
        case title
        case headline
        case body
        case caption
        case value
    }
}
```

---

## Data Services

### WidgetDataService

Protocol for widget data fetching.

```swift
public protocol WidgetDataService {
    associatedtype DataType: Codable
    
    func fetch() async throws -> DataType
    func getCached() -> DataType?
    func invalidateCache()
}
```

### SharedDataContainer

For sharing data between app and widget.

```swift
public final class SharedDataContainer {
    public static func configure(appGroupIdentifier: String)
    
    public static func save<T: Encodable>(_ value: T, forKey key: String) throws
    public static func load<T: Decodable>(_ type: T.Type, forKey key: String) throws -> T?
    public static func remove(forKey key: String)
}
```

**Example:**

```swift
// In main app
SharedDataContainer.configure(appGroupIdentifier: "group.com.yourapp")
try SharedDataContainer.save(userData, forKey: "userData")

// In widget
let userData = try SharedDataContainer.load(UserData.self, forKey: "userData")
```

---

## Configuration

### WidgetConfiguration

Global widget configuration options.

```swift
public struct WidgetConfiguration {
    public static var shared: WidgetConfiguration
    
    public var defaultRefreshInterval: TimeInterval
    public var cacheExpirationInterval: TimeInterval
    public var maxCacheSize: Int
    public var enableDebugMode: Bool
}
```

### WidgetPreferences

User preferences storage for widgets.

```swift
public final class WidgetPreferences {
    public static let shared: WidgetPreferences
    
    public subscript<T>(key: String) -> T? { get set }
    public func register(defaults: [String: Any])
}
```

---

## Utilities

### WidgetCenter Extensions

```swift
extension WidgetCenter {
    /// Reloads specific widget timeline
    public func reload(kind: String)
    
    /// Reloads all widget timelines
    public func reloadAll()
    
    /// Gets current widget configurations
    public func getConfigurations() async -> [WidgetInfo]
}
```

### DateFormatting

Widget-optimized date formatters.

```swift
public enum WidgetDateFormatter {
    case relative      // "2 hours ago"
    case compact       // "2h"
    case time          // "3:45 PM"
    case date          // "Jan 15"
    case full          // "January 15, 2024"
    
    public func string(from date: Date) -> String
}
```

### DeepLinking

Handle widget tap actions.

```swift
public struct WidgetDeepLink {
    public static func url(for action: String, parameters: [String: String] = [:]) -> URL
    
    public static func parse(_ url: URL) -> (action: String, parameters: [String: String])?
}
```

**Example:**

```swift
// In widget view
Link(destination: WidgetDeepLink.url(for: "showDetails", parameters: ["id": "123"])) {
    WidgetContent()
}

// In main app
func application(_ app: UIApplication, open url: URL) -> Bool {
    if let (action, params) = WidgetDeepLink.parse(url) {
        handleWidgetAction(action, parameters: params)
        return true
    }
    return false
}
```

---

## Error Handling

### WidgetError

```swift
public enum WidgetError: LocalizedError {
    case dataFetchFailed(underlying: Error)
    case cacheMiss
    case invalidConfiguration
    case networkUnavailable
    
    public var errorDescription: String? { get }
    public var recoverySuggestion: String? { get }
}
```

---

## Best Practices

1. **Keep widgets lightweight** - Minimize memory usage
2. **Cache aggressively** - Network calls are expensive
3. **Handle errors gracefully** - Always show useful content
4. **Use appropriate refresh intervals** - Balance freshness vs battery
5. **Test all widget families** - Each size has different requirements

---

## Version History

| Version | Changes |
|---------|---------|
| 2.0.0 | iOS 17 support, Interactive widgets |
| 1.5.0 | Live Activities support |
| 1.0.0 | Initial release |
