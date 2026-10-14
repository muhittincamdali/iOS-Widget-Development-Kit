<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/banner-light.svg" alt="iOS Widget Development Kit: SwiftUI views and timeline helpers for WidgetKit widgets and Live Activities."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/actions/workflows/ci.yml/badge.svg" alt="CI status"></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-platforms-light.svg" alt="Supported platforms: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-language-light.svg" alt="Language version: Swift 6.0+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-license-light.svg" alt="License: MIT"></picture></a>
</p>

<p align="center">
<a href="#quick-start"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-start-en-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-start-en-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-start-en-light.svg" alt="Get started"></picture></a>
<a href="https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-docs-en-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-docs-en-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-docs-en-light.svg" alt="Documentation"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-examples-en-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-examples-en-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-examples-en-light.svg" alt="Examples"></picture></a>
</p>

<!-- brand:end -->

WidgetDevelopmentKit is a Swift package for developers who build widgets for their iOS apps.
It contains ready-made SwiftUI views for Home Screen, Lock Screen and StandBy widgets, chart
views sized for widgets, helpers for timelines and for the data the app shares with its
widget, App Intents for widget buttons, and ActivityKit attributes and views for Live
Activities. You still write the widget extension; the package saves you the views and the
date, storage and retry logic that every widget needs.

## Highlights

- **20 Home Screen templates** — weather, stats, finance, calendar, countdown, clock, notes,
  quote, music, podcast, news, fitness rings, habit tracker, to-do, water, battery and more.
- **Lock Screen and StandBy** — 15 accessory views (circular, rectangular, inline) and 7
  StandBy views.
- **Timeline helpers** — entry dates, reload policies and a snapshot store with expiry, so
  the widget reads what the app saved through an App Group.
- **Interactive widgets** — 5 App Intents and 8 views with buttons that run them.
- **Live Activities** — 10 `ActivityAttributes` types with Lock Screen and compact Dynamic
  Island views, and a state machine that rejects out-of-order updates.
- **Tested logic** — the date, number and retry code is covered by Swift Testing tests,
  including edge cases such as `NaN`, zero goals and daylight-saving days.

## Quick start

**1. Add the package**

Your app needs a widget extension. If it has none yet, choose **File › New › Target…** in
Xcode and pick **Widget Extension**. Then choose **File › Add Package Dependencies…**, paste
this URL into the search field at the top right and choose **Add Package**:

```text
https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git
```

In the next dialog, set **Add to Target** for `WidgetDevelopmentKit` to your widget
extension and choose **Add Package**.

**2. Import the module**

At the top of a Swift file in the widget extension:

```swift
import WidgetDevelopmentKit
```

**3. Use it**

Add this widget to the extension. It counts down to a date with the package's
`CountdownWidget` view. Then list `LaunchCountdownWidget()` in the extension's
`WidgetBundle`, the type marked `@main`.

```swift
struct LaunchEntry: TimelineEntry {
    let date: Date
}

struct LaunchProvider: TimelineProvider {
    func placeholder(in context: Context) -> LaunchEntry {
        LaunchEntry(date: .now)
    }

    func getSnapshot(in context: Context, completion: @escaping (LaunchEntry) -> Void) {
        completion(LaunchEntry(date: .now))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<LaunchEntry>) -> Void) {
        // One entry per hour for the next six hours, then WidgetKit asks again.
        let entries = TimelineSchedule.dates(from: .now, every: 60 * 60, count: 6).map(LaunchEntry.init)
        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

struct LaunchCountdownWidget: Widget {
    let launchDay = DateComponents(calendar: .current, year: 2027, month: 1, day: 1).date ?? .now

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "launch", provider: LaunchProvider()) { entry in
            CountdownWidget(title: "Launch", targetDate: launchDay, referenceDate: entry.date)
        }
        .configurationDisplayName("Countdown")
        .supportedFamilies([.systemSmall])
    }
}
```

Run the app on an iPhone simulator. On the Home Screen, touch and hold an empty area, tap
**Edit › Add Widget**, find your app and add **Countdown**. The same code is in
[`Examples/WidgetKitExample`](Examples/WidgetKitExample/Widgets/LaunchCountdownWidget.swift).

## Installation

### Swift Package Manager

In Xcode, choose **File › Add Package Dependencies…** and enter the repository URL:

```text
https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git
```

Or add it to the `dependencies` in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git", from: "2.0.0")
],
targets: [
    .target(name: "YourApp", dependencies: [
        .product(name: "WidgetDevelopmentKit", package: "iOS-Widget-Development-Kit")
    ])
]
```

Releases start at 2.0.0; the earlier `v1.0.0` tag predates the current code and does not
build. The package has no third-party dependencies.

## Usage

Every Swift example in this section is taken from
[`Examples/WidgetKitExample`](Examples/WidgetKitExample), which CI builds, or from
[`ReadmeExamplesTests.swift`](Tests/WidgetDevelopmentKitTests/ReadmeExamplesTests.swift),
which is compiled with the tests. A test fails if a block here no longer matches that code.

### Read shared data in a timeline provider

`TimelineSchedule` produces the entry dates, `TimelineBuilder` sorts the entries and turns a
`WidgetUpdatePolicy` into WidgetKit's reload policy, and `WidgetSnapshotStore` reads what the
app saved to the shared App Group.

```swift
struct StepsProvider: TimelineProvider {
    let store = WidgetSnapshotStore(defaults: UserDefaults(suiteName: "group.com.example.widgets") ?? .standard)

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

### Save data in the app

The app writes the value with a lifetime and asks WidgetKit to reload the widget:

```swift
try store.save(steps, forKey: "steps", lifetime: 30 * 60)
WidgetCenter.shared.reloadTimelines(ofKind: "steps")
```

Add the **App Groups** capability to the app and the extension with the same identifier.
The store uses `UserDefaults`, which is not encrypted, so keep secrets out of it.

### Show an entry

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
```

Views that show time-dependent values (`CountdownWidget`, `StandByCountdownWidget`,
`LockScreenCountdownWidget`) take a `referenceDate`; pass `entry.date` so each entry renders
its own moment.

### Add a button to a widget

```swift
struct WaterButton: View {
    var body: some View {
        Button(intent: IncrementIntent(counterId: "water", amount: 250)) {
            Label("+250 ml", systemImage: "drop.fill")
        }
    }
}
```

The intents run in the widget extension and write to `WidgetStateStore.shared`, which uses
the App Group named by the `WidgetDevelopmentKitAppGroup` key in Info.plist. Add the key to
both the app and the extension, and register the package's intents:

```swift
struct AppIntentsRoot: AppIntentsPackage {
    static var includedPackages: [any AppIntentsPackage.Type] {
        [WidgetDevelopmentKitIntents.self]
    }
}
```

### Load data from a server

```swift
struct RandomQuote: Decodable {
    let text: String
}

func loadQuote() async throws -> RandomQuote {
    guard let base = URL(string: "https://api.example.com") else { throw URLError(.badURL) }
    let endpoint = Endpoint(base: base)
        .appendingPath("v1/quotes/random")
        .adding(query: "lang", "en")
    guard let request = endpoint.request else { throw URLError(.badURL) }
    return try await WidgetDataLoader().load(RandomQuote.self, from: request)
}
```

`WidgetDataLoader` uses an ephemeral session with short timeouts that does not wait for
connectivity. It retries 5xx and 408 responses, timeouts and offline errors (once by
default; set a `RetryPolicy` to change it), but not 4xx responses or decoding errors.

## Demo

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
WidgetKit, so the widget frame, Lock Screen vibrancy and StandBy night mode are approximated
rather than produced by the system.

To try the widgets yourself, open
[`Examples/WidgetKitExample/WidgetKitExample.xcodeproj`](Examples/WidgetKitExample) and run
the **WidgetKitExample** scheme on an iPhone simulator; [`Examples/README.md`](Examples/README.md)
explains the three widgets and how to add them to the Home Screen.

## Documentation

Reference documentation and articles:

- [API reference](https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/)
  on GitHub Pages, built from the DocC comments in the source.
- In Xcode: **Product › Build Documentation**, or
  `xcodebuild docbuild -scheme WidgetDevelopmentKit -destination 'generic/platform=iOS Simulator'`.

## Guides

- [Getting Started](https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/gettingstarted):
  add a widget extension and the package, share data through an App Group, build the
  timeline and render an entry.
- [Interactive Widgets](https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/interactivewidgets):
  configure the App Group, register the intents, add buttons and read their state in the
  provider and the app.

## Requirements

| Platform  | Minimum version |
| --------- | --------------- |
| iOS       | 17.0            |
| macOS     | 14.0            |
| Toolchain | Swift 6.0       |

Lock Screen views and Live Activities are iOS only. The macOS target exists so the
platform-independent code and its tests run with `swift test`. CI builds with the default
Xcode of GitHub's `macos-26` image; local development uses Xcode 27. Older Xcode versions have
not been tried.

## Architecture

```text
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
date ranges, daylight-saving days) lives in `Core` and `Timeline` as pure functions with unit
tests. Types that touch storage or the network take their dependencies (`UserDefaults`,
clock, transport, sleep) as parameters, so they can be tested without an App Group or a
server. SwiftUI view bodies are not snapshot-tested.

Run the tests on macOS and on an iOS simulator:

```sh
swift test
xcodebuild test -scheme WidgetDevelopmentKit -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

Three iOS tests are skipped on purpose: they render the README images and run only through
`scripts/render-screenshots.sh`.

## Roadmap

- Tag a release that matches the current code, so the package can be added by version.
- Snapshot tests for the view bodies.
- An example Live Activity in the example app.

The [CHANGELOG](CHANGELOG.md) records what changed so far, including how the package was
restored in October 2026 after the `v1.0.0` code turned out not to build.

## Contributing

Contributions are welcome. Read the [contributing guide](https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/CONTRIBUTING.md) and the [code of conduct](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md) before opening a pull request. Report security issues privately as described in the [security policy](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md).

## License

Released under the MIT license. See [LICENSE](LICENSE).
