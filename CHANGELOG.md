# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.0] - 2026-10-14

This is the first release in which the whole package builds and its tests run. The
manifest at the `v1.0.0` tag does not load. After a mid-June 2026 rework the library
target built, but it held only about 240 lines in six files under
`Sources/WidgetDevelopmentKit`; the rest of the Swift code was outside every target, the
manifest depended on a package no source file used, and the test target did not compile
because its Quick/Nimble tests in `Tests/Unit` used packages the manifest never declared.
The changes below restore the code from history, rework the parts that were broken, and
remove the parts that could not work. Because the public API changes substantially, this
release is a new major version.

### Added

- Unit tests with Swift Testing for the helper logic, timelines, snapshot store, deep links,
  hex colors, configuration entities, data loader and retry policy, state store, Live
  Activity state machine and the README examples; the iOS simulator run adds Live Activity
  state tests.
- `ReadmeSyncTests`, which fail when a Swift block in README.md no longer matches the code
  in `Examples/` or `ReadmeExamplesTests.swift`.
- `WidgetMath`, `WidgetFormat`, `MonthGrid` and `CountdownComponents`: pure helpers for
  progress clamping, compact numbers, playback times, month grids and countdowns.
- `WidgetUpdatePolicy`, `TimelineBuilder`, `TimelineSchedule` and `WidgetSnapshotStore`,
  reworked from the removed `TimelineManager`.
- `WidgetDataLoader`, `RetryPolicy` and `Endpoint`, reworked from `NetworkDataProvider`.
- `WidgetDeepLink`, `HexColor`, `RefreshIntervalOption`, `AccentColorOption` and
  `WidgetDevelopmentKitIntents`, reworked from `WidgetConfiguration.swift`.
- `WidgetStateStore` and `SetValueIntent` / `RecordActionIntent` for interactive widgets.
- DocC catalog with getting-started and interactive-widgets articles, which `docs.yml` builds
  and deploys to GitHub Pages.
- `Examples/WidgetKitExample`: an iOS app with a widget extension (countdown, steps and
  interactive water widgets) that builds against the package in the same commit.
- README translations in Turkish, Simplified Chinese, Japanese, Korean, Spanish, German,
  French, Brazilian Portuguese and Russian, with a banner, badges and buttons served from
  the repository.
- `scripts/render-screenshots.sh` and an opt-in test suite that renders the README images.
- CI through the shared workflows in `muhittincamdali/.github`: `swift build` and
  `swift test` on macOS, `xcodebuild` builds for iOS and macOS, tests on an iOS simulator,
  DocC to GitHub Pages, link check, wording scan and README translation check. Separate
  workflows build the example app and run SwiftLint.

### Changed

- Manifest uses Swift 6 tools and language mode, iOS 17 and macOS 14, and has no
  dependencies.
- Restored the chart, Lock Screen, StandBy, Home Screen template, interactive and Live
  Activity views into the `WidgetDevelopmentKit` target, split into files by theme.
- Countdown views take a `referenceDate` (the timeline entry date) instead of reading
  `Date()` while rendering; the StandBy countdown no longer shows a seconds column that a
  static snapshot cannot update.
- `LockScreenTimerWidget` takes a start and end time and animates with the system timer.
- `LiveActivityManager` became the `LiveActivities` namespace without a singleton, with
  optional stale dates.
- `LiveActivityStateMachine` uses typed throws, reports the rejected transition and offers
  `canTransition(to:)` and `allowedNextStates()`.

### Fixed

- A string literal in `QuoteWidget` that did not compile.
- The habit tracker header read "7 Day Streak" regardless of the streaks; it now reads
  "Last 7 days", which is what the dots show.
- Division by zero and `NaN` progress in fitness, water, podcast, horizontal bar and progress
  ring views; force-unwrapped colors and URLs in the progress ring and shortcuts views.
- A trap in timer views when the end date was before the start date.
- `.swiftlint.yml` did not parse (an unquoted `*` started a YAML alias), so SwiftLint ran
  with its default rules.
- Day counts that truncated intervals instead of counting calendar days, and month grids
  that ignored the calendar's first weekday.
- Duplicate `ForEach` identifiers in weekday headers and Lock Screen stats and events.
- Network requests that were retried on 4xx responses and waited for connectivity inside the
  widget extension.
- `TimerActivityView` kept counting down while `isPaused` was set; a paused timer now shows
  `pausedTimeRemaining` as a fixed value.

### Removed

- About 10,500 lines in `Sources/Enterprise`, `Sources/Integration`, `Sources/Analytics`,
  `Sources/Widgets` and `Sources/LiveData`, plus about 6,000 lines of Quick/Nimble tests,
  demo app and examples, and the `Documentation/` folder that described them. The sources,
  demo app and examples were not compiled by any target, the Quick/Nimble tests belonged
  to a test target that could not compile, and much of the code referenced types that did
  not exist.
- `WidgetConfiguration` (it shadowed SwiftUI's protocol), the no-op `WidgetDevelopmentKit`
  singleton, `TimelinePrewarmer`, `WidgetGallery`, `SmartTimelineProvider` (it force-cast
  `nil` to the data type), the Timer-based reload manager, and storage, migration and
  metrics singletons tied to hard-coded App Group names.
- `ActionIntent`, which posted a notification inside the widget extension that the app
  could never receive.
- The CocoaPods podspec, the Turkish README stub and ten CI workflows that did not build
  the package.
- The repository's own code of conduct, security policy, issue forms, pull request template
  and funding file; the shared files in `muhittincamdali/.github` apply instead.
- Earlier entries in this file, which listed 2.x and 3.x versions that were never tagged
  and are unrelated to this release.

## [1.0.0] - 2026-02-02

Tagged release. The manifest at this tag fails to load (`invalid custom path` for the test
target), so this version cannot be built.

[Unreleased]: https://github.com/muhittincamdali/iOS-Widget-Development-Kit/compare/v2.0.0...HEAD
[2.0.0]: https://github.com/muhittincamdali/iOS-Widget-Development-Kit/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/muhittincamdali/iOS-Widget-Development-Kit/releases/tag/v1.0.0
