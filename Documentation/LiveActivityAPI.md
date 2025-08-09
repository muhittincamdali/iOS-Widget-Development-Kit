# Live Activity API

<!-- TOC START -->
## Table of Contents
- [Live Activity API](#live-activity-api)
- [Overview](#overview)
- [Core Classes](#core-classes)
  - [LiveActivityManager](#liveactivitymanager)
  - [LiveActivity](#liveactivity)
  - [LiveActivityConfiguration](#liveactivityconfiguration)
- [Activity Types](#activity-types)
  - [Supported Activity Types](#supported-activity-types)
- [Content Types](#content-types)
  - [Basic Activity Content](#basic-activity-content)
  - [Interactive Activity Content](#interactive-activity-content)
- [Usage Examples](#usage-examples)
  - [Creating a Simple Live Activity](#creating-a-simple-live-activity)
  - [Creating an Interactive Live Activity](#creating-an-interactive-live-activity)
- [Dynamic Island Integration](#dynamic-island-integration)
  - [Dynamic Island Views](#dynamic-island-views)
- [Data Integration](#data-integration)
  - [Real-Time Updates](#real-time-updates)
  - [Background Updates](#background-updates)
- [Error Handling](#error-handling)
  - [ActivityError Types](#activityerror-types)
  - [Error Handling Example](#error-handling-example)
- [Best Practices](#best-practices)
  - [Performance Optimization](#performance-optimization)
  - [Design Guidelines](#design-guidelines)
  - [Security Considerations](#security-considerations)
- [API Reference](#api-reference)
  - [Methods](#methods)
  - [Properties](#properties)
- [Migration Guide](#migration-guide)
  - [From iOS 15 to iOS 16+](#from-ios-15-to-ios-16)
- [Troubleshooting](#troubleshooting)
  - [Common Issues](#common-issues)
  - [Debug Tips](#debug-tips)
<!-- TOC END -->


## Overview

The Live Activity API provides comprehensive functionality for creating and managing Live Activities in iOS applications. This API enables developers to create engaging, real-time experiences that integrate with the Dynamic Island and Lock Screen.

## Core Classes

### LiveActivityManager

The main manager class for handling Live Activity operations.

```swift
class LiveActivityManager {
    static let shared = LiveActivityManager()
    
    func start(_ activity: LiveActivity) -> Result<LiveActivity, ActivityError>
    func stop(_ activity: LiveActivity) -> Result<Void, ActivityError>
    func update(_ activity: LiveActivity, with data: ActivityData) -> Result<Void, ActivityError>
    func refresh(_ activity: LiveActivity) -> Result<Void, ActivityError>
}
```

### LiveActivity

The core activity class for Live Activity implementations.

```swift
class LiveActivity {
    let activityType: String
    let configuration: LiveActivityConfiguration
    var content: ActivityContent?
    
    init(activityType: String, configuration: LiveActivityConfiguration)
    func setContent(_ content: @escaping (ActivityContext) -> ActivityContent)
    func update(with data: ActivityData) -> Result<Void, ActivityError>
}
```

### LiveActivityConfiguration

Configuration options for Live Activities.

```swift
struct LiveActivityConfiguration {
    var enableDynamicIsland: Bool
    var enableLockScreen: Bool
    var enableNotifications: Bool
    var updateInterval: TimeInterval
    var enableInteractions: Bool
    var enableBackgroundUpdates: Bool
    var maxDuration: TimeInterval
}
```

## Activity Types

### Supported Activity Types

```swift
enum ActivityType {
    case delivery    // Package delivery tracking
    case ride        // Ride sharing
    case food        // Food delivery
    case workout     // Fitness tracking
    case music       // Music playback
    case timer       // Timer/countdown
    case game        // Game status
    case custom      // Custom activity
}
```

## Content Types

### Basic Activity Content

```swift
struct BasicActivityContent: ActivityContent {
    let title: String
    let subtitle: String?
    let icon: String?
    let progress: Double?
    let backgroundColor: Color
    let textColor: Color
}
```

### Interactive Activity Content

```swift
struct InteractiveActivityContent: ActivityContent {
    let title: String
    let subtitle: String?
    let actions: [ActivityAction]
    let progress: Double?
    let backgroundColor: Color
    let textColor: Color
}
```

## Usage Examples

### Creating a Simple Live Activity

```swift
// Create Live Activity manager
let activityManager = LiveActivityManager.shared

// Configure activity
let config = LiveActivityConfiguration()
config.enableDynamicIsland = true
config.enableLockScreen = true
config.updateInterval = 30 // 30 seconds
config.maxDuration = 3600 // 1 hour

// Create activity
let liveActivity = LiveActivity(
    activityType: "com.company.app.delivery",
    configuration: config
)

// Set activity content
liveActivity.setContent { context in
    BasicActivityContent(
        title: "Package Delivery",
        subtitle: "Out for delivery",
        icon: "shippingbox.fill",
        progress: 0.8,
        backgroundColor: .systemBlue,
        textColor: .white
    )
}

// Start activity
let result = activityManager.start(liveActivity)
switch result {
case .success(let activity):
    print("✅ Live Activity started successfully")
    print("Activity ID: \(activity.id)")
case .failure(let error):
    print("❌ Activity start failed: \(error)")
}
```

### Creating an Interactive Live Activity

```swift
// Create interactive activity
let interactiveConfig = LiveActivityConfiguration()
interactiveConfig.enableDynamicIsland = true
interactiveConfig.enableInteractions = true
interactiveConfig.enableBackgroundUpdates = true

let interactiveActivity = LiveActivity(
    activityType: "com.company.app.music",
    configuration: interactiveConfig
)

// Set interactive content
interactiveActivity.setContent { context in
    InteractiveActivityContent(
        title: "Now Playing",
        subtitle: "Artist Name",
        actions: [
            ActivityAction(title: "Play", icon: "play.fill", action: .play),
            ActivityAction(title: "Pause", icon: "pause.fill", action: .pause),
            ActivityAction(title: "Next", icon: "forward.fill", action: .next)
        ],
        progress: 0.6,
        backgroundColor: .systemBackground,
        textColor: .primary
    )
}

// Start interactive activity
activityManager.start(interactiveActivity)
```

## Dynamic Island Integration

### Dynamic Island Views

```swift
// Configure Dynamic Island
let islandConfig = DynamicIslandConfiguration()
islandConfig.enableCompactView = true
islandConfig.enableExpandedView = true
islandConfig.enableMinimalView = true

// Create Dynamic Island activity
let islandActivity = DynamicIslandActivity(
    activityType: "com.company.app.music",
    configuration: islandConfig
)

// Set Dynamic Island views
islandActivity.setCompactView { context in
    HStack {
        Image(systemName: "music.note")
            .foregroundColor(.blue)
        Text("Now Playing")
            .font(.caption)
    }
}

islandActivity.setExpandedView { context in
    VStack {
        HStack {
            Image(systemName: "music.note")
                .foregroundColor(.blue)
            VStack(alignment: .leading) {
                Text("Song Title")
                    .font(.headline)
                Text("Artist Name")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button("Play") {
                // Play action
            }
            .buttonStyle(.bordered)
        }
        ProgressView(value: 0.6)
            .progressViewStyle(.linear)
    }
    .padding()
}

// Start Dynamic Island activity
activityManager.start(islandActivity)
```

## Data Integration

### Real-Time Updates

```swift
// Create data source
let dataSource = ActivityDataSource(
    type: .api,
    endpoint: "https://api.company.com/activity-data",
    cachePolicy: .cacheFirst
)

// Fetch and update data
dataSource.fetchData { result in
    switch result {
    case .success(let data):
        // Update activity with new data
        liveActivity.update(with: data) { result in
            switch result {
            case .success:
                print("✅ Live Activity updated")
            case .failure(let error):
                print("❌ Update failed: \(error)")
            }
        }
    case .failure(let error):
        print("❌ Data fetch failed: \(error)")
    }
}
```

### Background Updates

```swift
// Configure background updates
let backgroundConfig = BackgroundUpdateConfiguration()
backgroundConfig.enableBackgroundProcessing = true
backgroundConfig.updateInterval = 60 // 1 minute
backgroundConfig.maxBackgroundTime = 300 // 5 minutes

// Setup background updates
activityManager.configureBackgroundUpdates(backgroundConfig) { result in
    switch result {
    case .success:
        print("✅ Background updates configured")
    case .failure(let error):
        print("❌ Background configuration failed: \(error)")
    }
}
```

## Error Handling

### ActivityError Types

```swift
enum ActivityError: Error {
    case startFailed(String)
    case stopFailed(String)
    case updateFailed(String)
    case configurationError(String)
    case dataError(String)
    case networkError(String)
    case permissionError(String)
    case timeoutError(String)
}
```

### Error Handling Example

```swift
func handleActivityError(_ error: ActivityError) {
    switch error {
    case .startFailed(let message):
        print("Activity start failed: \(message)")
        // Handle start error
    case .stopFailed(let message):
        print("Activity stop failed: \(message)")
        // Handle stop error
    case .updateFailed(let message):
        print("Activity update failed: \(message)")
        // Handle update error
    case .configurationError(let message):
        print("Configuration error: \(message)")
        // Handle configuration error
    case .dataError(let message):
        print("Data error: \(message)")
        // Handle data error
    case .networkError(let message):
        print("Network error: \(message)")
        // Handle network error
    case .permissionError(let message):
        print("Permission error: \(message)")
        // Handle permission error
    case .timeoutError(let message):
        print("Timeout error: \(message)")
        // Handle timeout error
    }
}
```

## Best Practices

### Performance Optimization

1. **Efficient Updates**: Only update when necessary
2. **Background Processing**: Use background processing wisely
3. **Memory Management**: Properly manage activity resources
4. **Battery Optimization**: Minimize battery impact

### Design Guidelines

1. **Clear Information**: Display essential information clearly
2. **Consistent Styling**: Maintain consistent visual design
3. **Accessibility**: Ensure activities are accessible
4. **User Privacy**: Respect user privacy settings

### Security Considerations

1. **Data Protection**: Secure sensitive data
2. **Permission Handling**: Request only necessary permissions
3. **Network Security**: Use secure network connections
4. **Error Handling**: Handle errors gracefully

## API Reference

### Methods

| Method | Description | Parameters | Returns |
|--------|-------------|------------|---------|
| `start` | Start a Live Activity | `LiveActivity` | `Result<LiveActivity, ActivityError>` |
| `stop` | Stop a Live Activity | `LiveActivity` | `Result<Void, ActivityError>` |
| `update` | Update activity with new data | `LiveActivity`, `ActivityData` | `Result<Void, ActivityError>` |
| `refresh` | Refresh activity content | `LiveActivity` | `Result<Void, ActivityError>` |

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `activityType` | `String` | Unique activity type identifier |
| `configuration` | `LiveActivityConfiguration` | Activity configuration |
| `content` | `ActivityContent?` | Activity content |
| `isActive` | `Bool` | Activity status |

## Migration Guide

### From iOS 15 to iOS 16+

```swift
// iOS 15 approach (deprecated)
let oldActivity = Activity(kind: "com.app.activity")

// iOS 16+ approach
let newActivity = LiveActivity(
    activityType: "com.app.activity",
    configuration: LiveActivityConfiguration()
)
```

## Troubleshooting

### Common Issues

1. **Activity Not Starting**: Check permissions and configuration
2. **Updates Not Working**: Verify data source and network connectivity
3. **Performance Issues**: Optimize data fetching and background processing
4. **Crash Issues**: Implement proper error handling

### Debug Tips

1. **Enable Logging**: Use debug logging for troubleshooting
2. **Test on Device**: Always test on physical devices
3. **Monitor Performance**: Use performance monitoring tools
4. **Check Permissions**: Verify required permissions are granted
