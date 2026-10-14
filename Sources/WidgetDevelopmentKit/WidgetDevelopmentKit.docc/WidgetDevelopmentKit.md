# ``WidgetDevelopmentKit``

SwiftUI views and helpers for building WidgetKit widgets, interactive widgets and Live Activities.

## Overview

WidgetDevelopmentKit is a source library for a widget extension. It provides:

- Ready-made SwiftUI views for Home Screen, Lock Screen and StandBy widgets, and chart views built on Swift Charts.
- Timeline helpers: reload policies based on calendar arithmetic, a value-type timeline builder, and evenly spaced or boundary-aligned entry dates.
- A `Codable` snapshot store with expiry, so the app can hand data to the widget through an App Group.
- App Intents for interactive widget buttons and a shared state store they write to.
- A JSON loader that retries only transient network errors, sized for a widget extension's short runtime.
- ActivityKit attributes and views for ten common Live Activity scenarios (iOS only).

Lock Screen views and Live Activities compile only on iOS, where accessory widget families and ActivityKit exist. Everything else also builds on macOS, which is where the unit tests run.

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:InteractiveWidgets>

### Timelines and data

- ``TimelineBuilder``
- ``TimelineSchedule``
- ``WidgetUpdatePolicy``
- ``WidgetSnapshotStore``
- ``WidgetDataLoader``
- ``Endpoint``
- ``RetryPolicy``
- ``WidgetNetworkError``

### Interactive widgets

- ``WidgetStateStore``
- ``ToggleIntent``
- ``IncrementIntent``
- ``SetValueIntent``
- ``RecordActionIntent``
- ``RefreshWidgetIntent``
- ``InteractiveToggleWidget``
- ``InteractiveCounterWidget``
- ``InteractiveTaskListWidget``
- ``InteractiveQuickActionsWidget``
- ``InteractiveTimerWidget``
- ``InteractiveHabitWidget``
- ``InteractiveRatingWidget``
- ``InteractiveWaterWidget``
- ``InteractiveWidgetButtonStyle``

### Configuration and deep links

- ``WidgetDeepLink``
- ``HexColor``
- ``RefreshIntervalOption``
- ``AccentColorOption``
- ``WidgetDevelopmentKitIntents``

### Charts

- ``WidgetLineChart``
- ``WidgetSparkline``
- ``WidgetMultiLineChart``
- ``WidgetStatsChart``
- ``WidgetBarChart``
- ``WidgetHorizontalBarChart``
- ``WidgetPieChart``
- ``WidgetProgressRing``
- ``WidgetActivityChart``
- ``ChartDataPoint``
- ``TimeSeriesDataPoint``

### Home Screen templates

- ``GradientCardWidget``
- ``StatsWidget``
- ``WeatherWidget``
- ``FinanceWidget``
- ``SocialStatsWidget``
- ``CalendarWidget``
- ``CountdownWidget``
- ``ClockWidget``
- ``NotesWidget``
- ``QuoteWidget``
- ``MusicWidget``
- ``PhotoFrameWidget``
- ``PodcastWidget``
- ``NewsWidget``
- ``FitnessWidget``
- ``HabitTrackerWidget``
- ``TodoWidget``
- ``WaterTrackerWidget``
- ``BatteryWidget``
- ``ShortcutsWidget``

### StandBy

- ``StandByClockWidget``
- ``StandByPhotoWidget``
- ``StandByWeatherWidget``
- ``StandByCalendarWidget``
- ``StandByFitnessWidget``
- ``StandByMusicWidget``
- ``StandByCountdownWidget``
- ``StandByOptimizedModifier``

### Live Activities

- ``LiveActivityStateMachine``
- ``StateMachineError``

### Utilities

- ``WidgetMath``
- ``WidgetFormat``
- ``MonthGrid``
- ``CountdownComponents``
- ``WidgetTimelineScrubber``
