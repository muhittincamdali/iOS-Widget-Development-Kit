# WidgetDevelopmentKit

[![CI](https://github.com/muhittincamdali/iOS-Widget-Development-Kit/actions/workflows/ci.yml/badge.svg)](https://github.com/muhittincamdali/iOS-Widget-Development-Kit/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/github/license/muhittincamdali/iOS-Widget-Development-Kit)](LICENSE)

A Swift package of SwiftUI views and helpers for WidgetKit: Home Screen, Lock Screen and
StandBy widget views, Swift Charts views sized for widgets, timeline and data helpers,
App Intents for interactive widgets, and ActivityKit templates for Live Activities.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/images/home-screen-dark.png">
  <img src="docs/images/home-screen-light.png" alt="Weather, water, fitness, countdown, quote and habit widgets rendered from the package" width="404">
</picture>
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/images/charts-dark.png">
  <img src="docs/images/charts-light.png" alt="Stats sparkline, progress ring, line chart and bar chart views" width="404">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/images/lock-screen-dark.png">
  <img src="docs/images/lock-screen-light.png" alt="Lock Screen battery, activity rings, countdown, weather and stats widgets" width="304">
</picture>

The images are rendered from the package's views with `ImageRenderer` by
[`scripts/render-screenshots.sh`](scripts/render-screenshots.sh). They are drawn outside
WidgetKit, so the widget frame, Lock Screen vibrancy and StandBy night mode are
approximated rather than produced by the system.

## What is in the package

| Area                  | Contents                                                                                                                                                                                                            | Platforms                |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| Home Screen templates | 20 views: weather, stats, finance, social stats, gradient card, calendar, countdown, clock, notes, quote, music, photo frame, podcast, news, fitness rings, habit tracker, to-do, water tracker, battery, shortcuts | iOS, macOS               |
| Charts                | 9 Swift Charts views: line, sparkline, multi-line, stats + sparkline, bar, horizontal bar, pie/donut, progress ring, activity heat map                                                                              | iOS, macOS               |
| Lock Screen           | 15 accessory views (circular, rectangular, inline; five adapt to the widget family)                                                                                                                                 | iOS                      |
| StandBy               | 7 views (clock, photo, weather, calendar, fitness, music, countdown) and a StandBy modifier                                                                                                                         | iOS, macOS               |
| Interactive widgets   | 5 App Intents (toggle, increment, set value, record action, refresh), a shared `WidgetStateStore`, and 8 views that use them                                                                                        | iOS, macOS               |
| Live Activities       | 10 `ActivityAttributes` types with Lock Screen and compact Dynamic Island views, `LiveActivities` helpers, and `LiveActivityStateMachine`                                                                           | iOS (state machine: all) |
| Timelines and data    | `WidgetUpdatePolicy`, `TimelineBuilder`, `TimelineSchedule`, `WidgetSnapshotStore` (Codable values with expiry in App Group defaults)                                                                               | iOS, macOS               |
| Networking            | `WidgetDataLoader` (retries only transient errors, injectable transport), `Endpoint` request builder                                                                                                                | iOS, macOS               |
| Configuration         | `WidgetDeepLink`, `HexColor`, `RefreshIntervalOption` and `AccentColorOption` App Entities                                                                                                                          | iOS, macOS               |
| Debugging             | `WidgetTimelineScrubber`, a view for stepping through timeline entries                                                                                                                                              | iOS, macOS               |

The package has no third-party dependencies.

## Requirements

- A Swift 6 toolchain: the manifest uses `swift-tools-version: 6.0` and the package builds
  in the Swift 6 language mode. It has been built and tested only with Xcode 27 (Swift 6.4);
  CI runs on GitHub's `macos-26` image. Older Xcode versions have not been tried.
- iOS 17 or later. The macOS 14 target exists so that the platform-independent code and
  the unit tests can run with `swift test`; Lock Screen views and Live Activities are iOS only.

## Installation

Swift Package Manager, in Xcode: **File > Add Package Dependencies**, enter
`https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git`, and add the
`WidgetDevelopmentKit` library to your widget extension (and to the app if it writes
shared data). In `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git", branch: "main")
],
targets: [
    .target(name: "MyWidgets", dependencies: [
        .product(name: "WidgetDevelopmentKit", package: "iOS-Widget-Development-Kit")
    ])
]
```

The `v1.0.0` tag predates the current code and does not build; use `main` until the next
tagged release.

## Usage

The examples below are copied from
[`Tests/WidgetDevelopmentKitTests/ReadmeExamplesTests.swift`](Tests/WidgetDevelopmentKitTests/ReadmeExamplesTests.swift),
so they are compiled on every test run.

### Timeline provider

`TimelineSchedule` produces entry dates, `TimelineBuilder` sorts the entries and turns a
`WidgetUpdatePolicy` into WidgetKit's reload policy, and `WidgetSnapshotStore` reads data
the app saved to the shared App Group.

```swift
struct StepsEntry: TimelineEntry {
    let date: Date
    let steps: Int
}

struct StepsProvider: TimelineProvider {
    let store = WidgetSnapshotStore(defaults: UserDefaults(suiteName: "group.com.example.steps") ?? .standard)

    func placeholder(in context: Context) -> StepsEntry {
        StepsEntry(date: .now, steps: 6_000)
    }

    func getSnapshot(in context: Context, completion: @escaping (StepsEntry) -> Void) {
        completion(placeholder(in: context))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<StepsEntry>) -> Void) {
        completion(makeTimeline(now: .now))
    }

    func makeTimeline(now: Date) -> Timeline<StepsEntry> {
        // Written by the app; stale data is better than an empty widget.
        let steps = store.staleValue(Int.self, forKey: "steps") ?? 0
        let entries = TimelineSchedule
            .dates(from: now, every: 15 * 60, count: 4)
            .map { StepsEntry(date: $0, steps: steps) }
        return TimelineBuilder(entries: entries)
            .reloading(.every(minutes: 60), from: now)
            .build()
    }
}
```

In the app, save the value and ask WidgetKit to reload:

```swift
try store.save(steps, forKey: "steps", lifetime: 30 * 60)
WidgetCenter.shared.reloadTimelines(ofKind: "steps")
```

### Widget view

```swift
struct StepsWidgetView: View {
    let entry: StepsEntry

    var body: some View {
        WidgetProgressRing(progress: Double(entry.steps), total: 10_000, colors: [.green, .mint])
            .padding()
            .containerBackground(.fill.tertiary, for: .widget)
            .widgetURL(WidgetDeepLink(scheme: "steps", host: "today"))
    }
}

struct StepsWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "steps", provider: StepsProvider()) { entry in
            StepsWidgetView(entry: entry)
        }
        .configurationDisplayName("Steps")
        .supportedFamilies([.systemSmall])
    }
}
```

Views that show time-dependent values (`CountdownWidget`, `StandByCountdownWidget`,
`LockScreenCountdownWidget`) take a `referenceDate`; pass `entry.date` so each entry
renders its own moment.

### Interactive button

```swift
struct WaterButton: View {
    var body: some View {
        Button(intent: IncrementIntent(counterId: "water", amount: 250)) {
            Label("+250 ml", systemImage: "drop.fill")
        }
    }
}
```

The intents run in the widget extension and write to `WidgetStateStore.shared`, which
uses the App Group named by the `WidgetDevelopmentKitAppGroup` key in Info.plist. Add the
key to both the app and the extension, and list `WidgetDevelopmentKitIntents` in your
`AppIntentsPackage` so the intents are registered. The DocC article
_Interactive Widgets_ covers the setup.

### Networking

```swift
struct RandomQuote: Decodable {
    let text: String
}

func loadQuote() async throws -> RandomQuote {
    let endpoint = Endpoint(base: URL(string: "https://api.example.com")!)
        .appendingPath("v1/quotes/random")
        .adding(query: "lang", "en")
    guard let request = endpoint.request else { throw URLError(.badURL) }
    return try await WidgetDataLoader().load(RandomQuote.self, from: request)
}
```

`WidgetDataLoader` uses an ephemeral session with short timeouts that does not wait for
connectivity, and retries 5xx, 408, timeouts and offline errors (one retry by default, configurable with `RetryPolicy`) but
not 4xx or decoding errors.

## Architecture

```
Sources/WidgetDevelopmentKit/
├── Core/            Pure helpers: clamping, formatting, month grid, countdown math
├── Timeline/        Update policy, timeline builder and schedule, snapshot store
├── Networking/      Data loader with retry policy, endpoint builder
├── Configuration/   Deep links, hex colors, App Intents entities
├── Interactive/     App Intents, shared state store, interactive views
├── Templates/       Home Screen views
├── Charts/          Swift Charts views
├── LockScreen/      Accessory family views (iOS)
├── StandBy/         StandBy views
├── LiveActivities/  ActivityKit attributes and views (iOS), state machine
├── UI/              Timeline scrubber
└── WidgetDevelopmentKit.docc/
```

Views stay thin: arithmetic that can go wrong with real data (zero goals, `NaN`, reversed
date ranges, daylight-saving days) lives in `Core` and `Timeline` as pure functions with
unit tests. Types that touch storage or the network take their dependencies
(`UserDefaults`, clock, transport, sleep) as parameters so they can be tested without
an App Group or a server.

## Testing

```sh
swift test                         # macOS: 74 tests
xcodebuild test -scheme WidgetDevelopmentKit \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'   # iOS simulator
scripts/render-screenshots.sh      # regenerate docs/images
```

Tests use Swift Testing and cover the helper logic (including edge cases such as `NaN`,
zero totals, Monday-first calendars, leap months and DST transitions), the timeline and
snapshot types, the deep link and color parsers, the retry behavior of the data loader,
the state store, the state machine and the README examples. SwiftUI view bodies are not
snapshot-tested.

## Documentation

The package includes a DocC catalog with a getting-started article and an
interactive-widgets article. Build it with **Product > Build Documentation** in Xcode,
or:

```sh
xcodebuild docbuild -scheme WidgetDevelopmentKit -destination 'generic/platform=iOS'
```

## Project history

The manifest at the `v1.0.0` tag does not load. After a mid-June 2026 rework the library
target built, but it held only about 240 lines in six files; the rest of the Swift code in
`Sources/` was not part of any target, and the test target did not compile because its
Quick/Nimble tests used packages the manifest never declared. In October 2026 the code was
restored from history, reworked where it was broken, and covered by tests; parts that
could not work as written (for example, singletons tied to hard-coded App Group names and
an intent that posted notifications from the widget extension) were removed. See
[CHANGELOG.md](CHANGELOG.md) for details.

## Contributing

Issues and pull requests are welcome. Please run `swift test` and the iOS simulator tests
before opening a pull request, and add tests for new logic. See
[CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT. See [LICENSE](LICENSE).
