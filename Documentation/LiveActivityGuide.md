# Live Activity Guide

## Introduction

This guide provides comprehensive instructions for creating and implementing Live Activities in iOS applications using the iOS Widget Development Kit. Live Activities provide users with real-time, engaging experiences that integrate with the Dynamic Island and Lock Screen.

## Prerequisites

- iOS 16.0+ SDK
- Xcode 15.0+
- Swift 5.9+
- Basic knowledge of SwiftUI and ActivityKit

## Getting Started

### 1. Project Setup

First, ensure your project is properly configured for Live Activities:

```swift
// Add to your app's Info.plist
<key>NSSupportsLiveActivities</key>
<true/>
<key>NSSupportsLiveActivitiesFrequentUpdates</key>
<true/>
<key>NSSupportsLiveActivitiesBackgroundProcessing</key>
<true/>
```

### 2. Import the Framework

```swift
import WidgetDevelopmentKit
```

### 3. Initialize Activity Manager

```swift
let activityManager = LiveActivityManager.shared
activityManager.configure { config in
    config.enableDynamicIsland = true
    config.enableLockScreen = true
    config.enableBackgroundUpdates = true
}
```

## Creating Your First Live Activity

### Step 1: Define Activity Configuration

```swift
let activityConfig = LiveActivityConfiguration()
activityConfig.enableDynamicIsland = true
activityConfig.enableLockScreen = true
activityConfig.enableNotifications = true
activityConfig.updateInterval = 30 // 30 seconds
activityConfig.maxDuration = 3600 // 1 hour
```

### Step 2: Create Activity Instance

```swift
let liveActivity = LiveActivity(
    activityType: "com.yourcompany.app.delivery",
    configuration: activityConfig
)
```

### Step 3: Define Activity Content

```swift
liveActivity.setContent { context in
    VStack(spacing: 12) {
        HStack {
            Image(systemName: "shippingbox.fill")
                .foregroundColor(.blue)
            
            VStack(alignment: .leading) {
                Text("Order #12345")
                    .font(.headline)
                
                Text("Out for delivery")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("2:30 PM")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        
        ProgressView(value: 0.8)
            .progressViewStyle(.linear)
            .tint(.blue)
    }
    .padding()
    .background(Color(.systemBackground))
}
```

### Step 4: Start Activity

```swift
activityManager.start(liveActivity) { result in
    switch result {
    case .success(let activity):
        print("✅ Live Activity started successfully")
        print("Activity ID: \(activity.id)")
    case .failure(let error):
        print("❌ Activity start failed: \(error)")
    }
}
```

## Activity Types and Use Cases

### Delivery Tracking

```swift
// Delivery activity configuration
let deliveryConfig = LiveActivityConfiguration()
deliveryConfig.enableDynamicIsland = true
deliveryConfig.enableLockScreen = true
deliveryConfig.updateInterval = 60 // 1 minute

let deliveryActivity = LiveActivity(
    activityType: "com.yourcompany.app.delivery",
    configuration: deliveryConfig
)

deliveryActivity.setContent { context in
    VStack(spacing: 8) {
        HStack {
            Image(systemName: "shippingbox.fill")
                .foregroundColor(.blue)
            
            VStack(alignment: .leading) {
                Text("Package Delivery")
                    .font(.headline)
                Text("Estimated arrival: 3:00 PM")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        
        ProgressView(value: 0.7)
            .progressViewStyle(.linear)
    }
    .padding()
}
```

### Ride Sharing

```swift
// Ride sharing activity
let rideConfig = LiveActivityConfiguration()
rideConfig.enableDynamicIsland = true
rideConfig.enableInteractions = true

let rideActivity = LiveActivity(
    activityType: "com.yourcompany.app.ride",
    configuration: rideConfig
)

rideActivity.setContent { context in
    VStack(spacing: 12) {
        HStack {
            Image(systemName: "car.fill")
                .foregroundColor(.green)
            
            VStack(alignment: .leading) {
                Text("Your ride is arriving")
                    .font(.headline)
                Text("Driver: John Doe")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("2 min")
                .font(.caption2)
                .foregroundColor(.green)
        }
        
        HStack(spacing: 16) {
            Button("Call Driver") {
                // Call driver action
            }
            .buttonStyle(.bordered)
            
            Button("Cancel Ride") {
                // Cancel ride action
            }
            .buttonStyle(.bordered)
        }
    }
    .padding()
}
```

### Music Playback

```swift
// Music activity
let musicConfig = LiveActivityConfiguration()
musicConfig.enableDynamicIsland = true
musicConfig.enableInteractions = true

let musicActivity = LiveActivity(
    activityType: "com.yourcompany.app.music",
    configuration: musicConfig
)

musicActivity.setContent { context in
    VStack(spacing: 12) {
        HStack {
            Image(systemName: "music.note")
                .foregroundColor(.purple)
            
            VStack(alignment: .leading) {
                Text("Now Playing")
                    .font(.headline)
                Text("Song Title - Artist")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button("Play/Pause") {
                // Play/pause action
            }
            .buttonStyle(.bordered)
        }
        
        ProgressView(value: 0.6)
            .progressViewStyle(.linear)
    }
    .padding()
}
```

## Dynamic Island Integration

### Compact View

```swift
// Configure Dynamic Island
let islandConfig = DynamicIslandConfiguration()
islandConfig.enableCompactView = true
islandConfig.enableExpandedView = true
islandConfig.enableMinimalView = true

let islandActivity = DynamicIslandActivity(
    activityType: "com.yourcompany.app.music",
    configuration: islandConfig
)

// Set compact view
islandActivity.setCompactView { context in
    HStack {
        Image(systemName: "music.note")
            .foregroundColor(.purple)
        Text("Now Playing")
            .font(.caption)
    }
}
```

### Expanded View

```swift
// Set expanded view
islandActivity.setExpandedView { context in
    VStack(spacing: 12) {
        HStack {
            Image(systemName: "music.note")
                .foregroundColor(.purple)
            
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
```

### Minimal View

```swift
// Set minimal view
islandActivity.setMinimalView { context in
    Image(systemName: "music.note")
        .foregroundColor(.purple)
}
```

## Data Integration

### Real-Time Updates

```swift
// Create data source
let dataSource = ActivityDataSource(
    type: .api,
    endpoint: "https://api.yourcompany.com/activity-data",
    cachePolicy: .cacheFirst
)

// Configure real-time updates
let realTimeManager = RealTimeUpdateManager()
realTimeManager.configure { config in
    config.enableWebSocket = true
    config.enablePushNotifications = true
    config.enableBackgroundUpdates = true
}

// Setup real-time connection
realTimeManager.connect { result in
    switch result {
    case .success:
        print("✅ Real-time connection established")
        
        // Listen for updates
        realTimeManager.onDataUpdate { data in
            print("📱 Real-time data received: \(data)")
            
            // Update activity with real-time data
            liveActivity.update(with: data) { result in
                switch result {
                case .success:
                    print("✅ Activity updated with real-time data")
                case .failure(let error):
                    print("❌ Real-time update failed: \(error)")
                }
            }
        }
    case .failure(let error):
        print("❌ Real-time connection failed: \(error)")
    }
}
```

### Background Updates

```swift
// Configure background updates
let backgroundConfig = BackgroundUpdateConfiguration()
backgroundConfig.enableBackgroundProcessing = true
backgroundConfig.updateInterval = 60 // 1 minute
backgroundConfig.maxBackgroundTime = 1800 // 30 minutes

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

## Interactive Elements

### Action Buttons

```swift
// Add action buttons to activity
liveActivity.setContent { context in
    VStack(spacing: 12) {
        HStack {
            Image(systemName: "shippingbox.fill")
                .foregroundColor(.blue)
            
            VStack(alignment: .leading) {
                Text("Package Delivery")
                    .font(.headline)
                Text("Out for delivery")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        
        ProgressView(value: 0.8)
            .progressViewStyle(.linear)
        
        HStack(spacing: 16) {
            Button("Track Package") {
                // Track package action
            }
            .buttonStyle(.bordered)
            
            Button("Contact Driver") {
                // Contact driver action
            }
            .buttonStyle(.bordered)
        }
    }
    .padding()
}
```

### Gesture Recognition

```swift
// Add gesture recognition
liveActivity.onTap { context in
    print("Activity tapped!")
    // Handle tap gesture
}

liveActivity.onLongPress { context in
    print("Activity long pressed!")
    // Handle long press gesture
}

liveActivity.onSwipe { direction in
    print("Activity swiped: \(direction)")
    // Handle swipe gesture
}
```

## Styling and Theming

### Custom Styling

```swift
// Create custom activity style
let customStyle = ActivityStyle(
    backgroundColor: .systemBlue,
    cornerRadius: 12,
    shadow: ActivityShadow(
        color: .black.opacity(0.1),
        radius: 8,
        offset: CGSize(width: 0, height: 2)
    )
)

// Apply custom styling
let stylingManager = ActivityStylingManager()
stylingManager.applyStyle(customStyle, to: liveActivity)
```

### Dynamic Theming

```swift
// Create dynamic theme
let dynamicTheme = DynamicActivityTheme(
    lightMode: ActivityTheme(
        backgroundColor: .white,
        textColor: .black,
        accentColor: .blue
    ),
    darkMode: ActivityTheme(
        backgroundColor: .black,
        textColor: .white,
        accentColor: .cyan
    )
)

// Apply dynamic theme
let themeManager = DynamicActivityThemeManager()
themeManager.applyTheme(dynamicTheme)
```

## Performance Optimization

### Best Practices

1. **Efficient Updates**: Only update when necessary
2. **Background Processing**: Use background processing wisely
3. **Memory Management**: Properly manage activity resources
4. **Battery Optimization**: Minimize battery impact

### Performance Monitoring

```swift
// Configure performance monitoring
let performanceMonitor = ActivityPerformanceMonitor()
performanceMonitor.enableMonitoring = true
performanceMonitor.monitorUpdates = true
performanceMonitor.monitorMemory = true

// Monitor activity performance
performanceMonitor.startMonitoring(liveActivity) { metrics in
    print("Activity performance metrics: \(metrics)")
}
```

## Error Handling

### Common Errors and Solutions

1. **Activity Start Failed**
   - Check activity configuration
   - Verify permissions
   - Ensure proper setup

2. **Update Failed**
   - Check data source connectivity
   - Verify data format
   - Handle network errors

3. **Performance Issues**
   - Optimize data fetching
   - Reduce update frequency
   - Monitor memory usage

### Error Handling Implementation

```swift
// Comprehensive error handling
func handleActivityError(_ error: ActivityError) {
    switch error {
    case .startFailed(let message):
        print("Activity start failed: \(message)")
        // Retry start or show user message
        
    case .stopFailed(let message):
        print("Activity stop failed: \(message)")
        // Handle stop error
        
    case .updateFailed(let message):
        print("Activity update failed: \(message)")
        // Retry update or use cached data
        
    case .configurationError(let message):
        print("Configuration error: \(message)")
        // Fix configuration and retry
        
    case .dataError(let message):
        print("Data error: \(message)")
        // Handle data issues
        
    case .networkError(let message):
        print("Network error: \(message)")
        // Handle network issues
        
    case .permissionError(let message):
        print("Permission error: \(message)")
        // Request permissions or show guidance
        
    case .timeoutError(let message):
        print("Timeout error: \(message)")
        // Handle timeout issues
    }
}
```

## Testing

### Unit Testing

```swift
import XCTest

class LiveActivityTests: XCTestCase {
    var liveActivity: LiveActivity!
    
    override func setUp() {
        super.setUp()
        let config = LiveActivityConfiguration()
        liveActivity = LiveActivity(activityType: "test.activity", configuration: config)
    }
    
    func testActivityStart() {
        let expectation = XCTestExpectation(description: "Activity start")
        
        let manager = LiveActivityManager.shared
        manager.start(liveActivity) { result in
            switch result {
            case .success(let activity):
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Activity start failed: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testActivityUpdate() {
        let expectation = XCTestExpectation(description: "Activity update")
        
        let testData = ActivityData(content: "Test content")
        liveActivity.update(with: testData) { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Update failed: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
```

### UI Testing

```swift
import XCTest

class LiveActivityUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }
    
    func testActivityAppearance() {
        // Test activity appears on lock screen
        let activity = app.otherElements["liveActivity"]
        XCTAssertTrue(activity.exists)
    }
    
    func testActivityInteraction() {
        // Test activity interactions
        let activity = app.otherElements["liveActivity"]
        activity.tap()
        
        // Verify interaction handled
        XCTAssertTrue(app.isActive)
    }
}
```

## Deployment

### App Store Guidelines

1. **Privacy**: Respect user privacy
2. **Performance**: Ensure good performance
3. **Battery**: Minimize battery impact
4. **Accessibility**: Ensure accessibility compliance

### Production Checklist

- [ ] Activity tested on multiple devices
- [ ] Background updates working correctly
- [ ] Error handling implemented
- [ ] Performance optimized
- [ ] Privacy compliance verified
- [ ] Accessibility requirements met

## Troubleshooting

### Common Issues

1. **Activity Not Starting**
   - Check activity configuration
   - Verify permissions
   - Test on physical device

2. **Updates Not Working**
   - Check data source
   - Verify network connectivity
   - Monitor background processing

3. **Performance Issues**
   - Optimize data fetching
   - Reduce update frequency
   - Monitor memory usage

### Debug Tools

```swift
// Enable debug logging
let debugLogger = ActivityDebugLogger()
debugLogger.enableLogging = true
debugLogger.logLevel = .verbose

// Monitor activity lifecycle
debugLogger.onActivityStarted = { activity in
    print("Activity started: \(activity.activityType)")
}

debugLogger.onActivityUpdated = { activity in
    print("Activity updated: \(activity.activityType)")
}

debugLogger.onActivityStopped = { activity in
    print("Activity stopped: \(activity.activityType)")
}

debugLogger.onActivityError = { error in
    print("Activity error: \(error)")
}
```

## Conclusion

This guide provides a comprehensive overview of creating Live Activities using the iOS Widget Development Kit. By following these guidelines, you can create engaging, real-time experiences that enhance the user experience of your iOS applications.

For more advanced features and detailed API documentation, refer to the [Live Activity API](LiveActivityAPI.md) documentation.
