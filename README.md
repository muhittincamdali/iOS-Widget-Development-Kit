# iOS Widget Development Kit

<p align="center">
  <img src="Assets/banner.png" alt="iOS Widget Development Kit" width="800">
</p>

<p align="center">
  <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-5.9+-F05138?style=flat&logo=swift&logoColor=white" alt="Swift"></a>
  <a href="https://developer.apple.com/ios/"><img src="https://img.shields.io/badge/iOS-16.0+-000000?style=flat&logo=apple&logoColor=white" alt="iOS"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License"></a>
  <a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/actions"><img src="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
</p>

<p align="center">
  <b>Build beautiful widgets for iOS with WidgetKit, Live Activities, and Dynamic Island.</b>
</p>

---

## Preview

<p align="center">
  <img src="Assets/widgets-preview.png" alt="Widget Preview" width="700">
</p>

## Features

- **Home Screen Widgets** — Small, medium, and large widget sizes
- **Lock Screen Widgets** — iOS 16+ lock screen integration
- **Live Activities** — Real-time updates on lock screen and Dynamic Island
- **StandBy Mode** — iOS 17+ StandBy widget support
- **Interactive Widgets** — Button actions and app intents (iOS 17+)
- **Timeline Provider** — Efficient widget refresh management

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git", from: "1.0.0")
]
```

## Quick Start

### 1. Create a Widget

```swift
import WidgetKit
import SwiftUI
import iOSWidgetKit

struct MyWidget: Widget {
    let kind: String = "MyWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MyProvider()) { entry in
            MyWidgetView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("Shows important information.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
```

### 2. Define Timeline Provider

```swift
struct MyProvider: TimelineProvider {
    func placeholder(in context: Context) -> MyEntry {
        MyEntry(date: Date(), title: "Loading...")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (MyEntry) -> Void) {
        let entry = MyEntry(date: Date(), title: "Snapshot")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<MyEntry>) -> Void) {
        let entry = MyEntry(date: Date(), title: "Current Data")
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(3600)))
        completion(timeline)
    }
}
```

### 3. Build Widget View

```swift
struct MyWidgetView: View {
    var entry: MyEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(entry.title)
                .font(.headline)
            
            Text(entry.date, style: .time)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}
```

## Live Activities

```swift
import ActivityKit

// Define Activity Attributes
struct DeliveryAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var status: String
        var estimatedTime: Date
    }
    
    var orderNumber: String
}

// Start Live Activity
func startDeliveryActivity(orderNumber: String) throws -> Activity<DeliveryAttributes> {
    let attributes = DeliveryAttributes(orderNumber: orderNumber)
    let state = DeliveryAttributes.ContentState(
        status: "Preparing",
        estimatedTime: Date().addingTimeInterval(1800)
    )
    
    return try Activity.request(
        attributes: attributes,
        content: .init(state: state, staleDate: nil)
    )
}

// Update Activity
func updateActivity(_ activity: Activity<DeliveryAttributes>, status: String) async {
    let state = DeliveryAttributes.ContentState(
        status: status,
        estimatedTime: Date().addingTimeInterval(900)
    )
    await activity.update(.init(state: state, staleDate: nil))
}
```

## Interactive Widgets (iOS 17+)

```swift
import AppIntents

struct RefreshIntent: AppIntent {
    static var title: LocalizedStringResource = "Refresh Widget"
    
    func perform() async throws -> some IntentResult {
        // Refresh data
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}

struct InteractiveWidgetView: View {
    var body: some View {
        Button(intent: RefreshIntent()) {
            Label("Refresh", systemImage: "arrow.clockwise")
        }
        .buttonStyle(.bordered)
    }
}
```

## Project Structure

```
iOS-Widget-Development-Kit/
├── Sources/
│   ├── Core/              # Core widget utilities
│   ├── Widgets/           # Widget implementations
│   ├── LiveData/          # Live Activity support
│   ├── Integration/       # App integration helpers
│   ├── Analytics/         # Widget analytics
│   └── Performance/       # Performance optimization
├── Examples/              # Sample widget projects
├── Tests/                 # Unit tests
└── Documentation/         # Guides
```

## Widget Types

| Type | iOS Version | Description |
|------|-------------|-------------|
| Home Screen | 14.0+ | Standard home screen widgets |
| Lock Screen | 16.0+ | Circular and rectangular lock screen widgets |
| Live Activity | 16.1+ | Real-time updates with Dynamic Island |
| StandBy | 17.0+ | Full-screen StandBy widgets |
| Interactive | 17.0+ | Buttons and toggles in widgets |

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

## Documentation

See the [Documentation](Documentation/) folder for detailed guides:

- [Widget Design Guide](Documentation/WidgetDesign.md)
- [Timeline Management](Documentation/TimelineManagement.md)
- [Live Activities Guide](Documentation/LiveActivities.md)
- [Best Practices](Documentation/BestPractices.md)

## Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT License. See [LICENSE](LICENSE).

## Author

**Muhittin Camdali** — [@muhittincamdali](https://github.com/muhittincamdali)

---

<p align="center">
  <sub>Built for iOS developers who love widgets ❤️</sub>
</p>
