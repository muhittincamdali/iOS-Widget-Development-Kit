# Getting Started

Add the package to a widget extension and build a timeline-driven widget.

## Overview

A widget has three parts: a timeline entry, a provider that produces a timeline of
entries, and a SwiftUI view that renders one entry. WidgetDevelopmentKit helps with
the provider (scheduling and reload policy), the data it reads, and the view.

### Add the package

In Xcode choose **File > Add Package Dependencies** and enter
`https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git`, then add the
`WidgetDevelopmentKit` library to your widget extension target (and to the app target
if the app writes shared data). In a `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git", branch: "main")
]
```

### Share data from the app

Create an App Group shared by the app and the extension, then write data from the app
with ``WidgetSnapshotStore``:

```swift
let store = WidgetSnapshotStore(defaults: UserDefaults(suiteName: "group.com.example.steps")!)
try store.save(steps, forKey: "steps", lifetime: 30 * 60)
WidgetCenter.shared.reloadTimelines(ofKind: "steps")
```

### Build the timeline

``TimelineSchedule`` produces entry dates and ``TimelineBuilder`` assembles the timeline,
sorting entries and converting a ``WidgetUpdatePolicy`` into WidgetKit's reload policy:

```swift
func makeTimeline(now: Date) -> Timeline<StepsEntry> {
    let steps = store.staleValue(Int.self, forKey: "steps") ?? 0
    let entries = TimelineSchedule
        .dates(from: now, every: 15 * 60, count: 4)
        .map { StepsEntry(date: $0, steps: steps) }
    return TimelineBuilder(entries: entries)
        .reloading(.every(minutes: 60), from: now)
        .build()
}
```

`staleValue(_:forKey:)` returns expired data too, which is usually better than an empty
widget; use `value(_:forKey:)` when expired data must not be shown.

### Render the entry

Use one of the template views, or compose your own from the chart views:

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

Views that show time-dependent values, such as ``CountdownWidget`` and
``StandByCountdownWidget``, take a `referenceDate`. Pass the entry's date so each entry
renders the value for its own moment rather than the time the timeline was generated.

### Preview a timeline

``WidgetTimelineScrubber`` steps through a timeline's entries in a SwiftUI preview or a
debug screen in the app.
