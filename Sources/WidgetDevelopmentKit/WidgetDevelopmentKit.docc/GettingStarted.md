# Getting Started

Add the package to a widget extension and build a timeline-driven widget.

## Overview

A widget has three parts: a timeline entry, a provider that produces a timeline of
entries, and a SwiftUI view that renders one entry. WidgetDevelopmentKit helps with
the provider (scheduling and reload policy), the data it reads, and the view.

The `Examples/WidgetKitExample` project in the repository contains the code from this
article as a running app with a widget extension.

### Add a widget extension

Widgets live in a widget extension, not in the app target. If your app does not have one
yet, choose **File > New > Target…** in Xcode, pick **Widget Extension**, and give it a
name. Xcode adds the extension and embeds it in the app.

### Add the package

1. In Xcode, choose **File > Add Package Dependencies…**.
2. Paste `https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git` into the search
   field at the top right and choose **Add Package**.
3. In the **Add to Target** column, choose your widget extension for the
   `WidgetDevelopmentKit` library, then choose **Add Package**. Add the library to the app
   target as well (**General > Frameworks, Libraries, and Embedded Content**) if the app
   writes data for the widget.

In a `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git", from: "2.0.0")
]
```

### Share data from the app

The app and the extension run in separate processes. Add the **App Groups** capability to
both targets with the same group identifier, then write data from the app with
``WidgetSnapshotStore``:

```swift
let store = WidgetSnapshotStore(defaults: UserDefaults(suiteName: "group.com.example.widgets") ?? .standard)
try store.save(steps, forKey: "steps", lifetime: 30 * 60)
WidgetCenter.shared.reloadTimelines(ofKind: "steps")
```

The store keeps values in `UserDefaults`, which is not encrypted. Do not put credentials
or other secrets in ``WidgetSnapshotStore`` or ``WidgetStateStore``.

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
debug screen in the app. The example app uses it to show the steps timeline:

```swift
WidgetTimelineScrubber(entries: timeline.entries) { entry in
    StepsWidgetView(entry: entry)
}
```
