# Usage Guide

<!-- TOC START -->
## Table of Contents
- [Usage Guide](#usage-guide)
- [Quick Start](#quick-start)
  - [Creating Your First Widget](#creating-your-first-widget)
  - [Customizing Widgets](#customizing-widgets)
- [Live Data Integration](#live-data-integration)
  - [Setting Up Data Sources](#setting-up-data-sources)
  - [Custom Data Sources](#custom-data-sources)
- [Analytics and Monitoring](#analytics-and-monitoring)
  - [Performance Tracking](#performance-tracking)
  - [Error Handling](#error-handling)
- [Advanced Features](#advanced-features)
  - [Performance Optimization](#performance-optimization)
  - [Widget Lifecycle Management](#widget-lifecycle-management)
- [Best Practices](#best-practices)
  - [Memory Management](#memory-management)
  - [Battery Optimization](#battery-optimization)
  - [Error Handling](#error-handling)
  - [Performance](#performance)
- [Examples](#examples)
<!-- TOC END -->


## Quick Start

### Creating Your First Widget

```swift
import WidgetKit
import WidgetTemplates

// 1. Get a template
let weatherTemplate = WeatherWidgetTemplate()

// 2. Get default configuration
let configuration = weatherTemplate.getDefaultConfiguration()

// 3. Create the widget
let widget = WidgetEngine.shared.createWidget(with: configuration)
```

### Customizing Widgets

```swift
// Create custom configuration
let customization = WidgetCustomization(
    backgroundColor: .blue.opacity(0.1),
    textColor: .primary,
    accentColor: .blue,
    cornerRadius: 16,
    padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16),
    font: .title2
)

let widgetDefinition = WidgetDefinition(
    id: "my_weather_widget",
    type: .weather,
    dataSourceIdentifier: "weather_api",
    customization: customization
)

let configuration = WidgetConfiguration(
    id: "my_config",
    templateIdentifier: "weather_widget",
    widgets: [widgetDefinition],
    settings: WidgetSettings(
        refreshInterval: 300.0,
        enableAnimations: true,
        enableHaptics: true,
        enableSound: false
    )
)
```

## Live Data Integration

### Setting Up Data Sources

```swift
import LiveDataIntegration

// Register a data source
let weatherDataSource = WeatherDataSource()
LiveDataIntegration.shared.registerDataSource("weather_api", dataSource: weatherDataSource)

// Connect to WebSocket for real-time updates
let url = URL(string: "ws://your-api.com/weather")!
LiveDataIntegration.shared.connectWebSocket(identifier: "weather_ws", url: url)

// Get data publisher
let publisher = LiveDataIntegration.shared.getDataPublisher(for: "weather_api")
publisher?.sink { data in
    print("Received weather data: \(data)")
}
.store(in: &cancellables)
```

### Custom Data Sources

```swift
class CustomDataSource: WidgetDataSource {
    let identifier = "custom_data"
    private let dataSubject = PassthroughSubject<WidgetData, Never>()
    
    var dataPublisher: AnyPublisher<WidgetData, Never> {
        return dataSubject.eraseToAnyPublisher()
    }
    
    func refresh() {
        // Fetch data from your API
        let data = WidgetData(
            id: "custom_data",
            type: .weather,
            content: ["temperature": 22, "condition": "sunny"]
        )
        dataSubject.send(data)
    }
    
    func configure(_ settings: DataSourceSettings) {
        // Configure data source settings
    }
}
```

## Analytics and Monitoring

### Performance Tracking

```swift
import WidgetAnalytics

// Get analytics data
let analytics = WidgetEngine.shared.getAnalytics()
print("Total widget updates: \(analytics.totalWidgetUpdates)")
print("Memory usage: \(analytics.memoryUsage)")
print("Battery level: \(analytics.batteryLevel)")

// Configure analytics
let config = AnalyticsConfiguration(
    enableExternalAnalytics: true,
    maxEventLogSize: 1000,
    enablePerformanceTracking: true,
    enableErrorTracking: true
)
WidgetAnalyticsService.shared.configure(config)
```

### Error Handling

```swift
// Listen for errors
NotificationCenter.default.addObserver(
    forName: .widgetErrorOccurred,
    object: nil,
    queue: .main
) { notification in
    if let error = notification.userInfo?["error"] as? WidgetError {
        print("Widget error: \(error.localizedDescription)")
    }
}

// Handle specific error types
switch error {
case .templateNotFound(let templateId):
    print("Template not found: \(templateId)")
case .dataSourceNotFound(let dataSourceId):
    print("Data source not found: \(dataSourceId)")
case .connectionFailed(let reason):
    print("Connection failed: \(reason)")
default:
    print("Unknown error")
}
```

## Advanced Features

### Performance Optimization

```swift
// Configure performance settings
let settings = WidgetPerformanceSettings(
    maxMemoryUsage: 50 * 1024 * 1024, // 50MB
    refreshInterval: 60.0, // 60 seconds
    enableBatteryOptimization: true
)

WidgetEngine.shared.configurePerformance(settings)

// Monitor performance
let metrics = WidgetEngine.shared.performanceMetrics
print("Memory usage: \(metrics.memoryUsage)")
print("Battery level: \(metrics.batteryLevel)")
print("Refresh count: \(metrics.refreshCount)")
```

### Widget Lifecycle Management

```swift
// Register templates
let templates = [
    WeatherWidgetTemplate(),
    CalendarWidgetTemplate(),
    FitnessWidgetTemplate()
]

templates.forEach { template in
    WidgetEngine.shared.registerTemplate(template)
}

// Update widgets
let data = WidgetData(
    id: "widget_1",
    type: .weather,
    content: ["temperature": 25]
)

WidgetEngine.shared.updateWidget("widget_1", with: data)
```

## Best Practices

### Memory Management

- Use weak references in closures
- Properly dispose of Combine cancellables
- Monitor memory usage with analytics

### Battery Optimization

- Enable battery optimization in settings
- Use appropriate refresh intervals
- Minimize network requests

### Error Handling

- Always handle potential errors
- Provide fallback data
- Log errors for debugging

### Performance

- Use lazy loading for large datasets
- Implement proper caching
- Monitor performance metrics

## Examples

See the [Examples](Examples/) directory for complete working examples of:

- Basic widget creation
- Custom data sources
- Live data integration
- Analytics implementation
- Error handling
- Performance optimization 