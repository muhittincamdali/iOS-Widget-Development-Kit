# Interactive Widgets

Handle widget button taps with App Intents and share the resulting state with the app.

## Overview

Since iOS 17, `Button` and `Toggle` in a widget can run an `AppIntent`. The intent runs in
the widget extension's process, not in the app, so any state it changes must be stored
where both processes can read it.

### Configure the App Group

The intents in this package write to ``WidgetStateStore/shared``. It reads the App Group
identifier from the `WidgetDevelopmentKitAppGroup` key in the running bundle's Info.plist.
Add the key, with the same App Group identifier, to both the app's and the widget
extension's Info.plist. Without the key the store falls back to standard user defaults,
which the app cannot see.

### Register the package's intents

The App Intents metadata processor only finds intents and entities in packages that are
listed in an `AppIntentsPackage`:

```swift
struct AppIntentsRoot: AppIntentsPackage {
    static var includedPackages: [any AppIntentsPackage.Type] {
        [WidgetDevelopmentKitIntents.self]
    }
}
```

### Add buttons

```swift
Button(intent: IncrementIntent(counterId: "water", amount: 250)) {
    Label("+250 ml", systemImage: "drop.fill")
}
```

| Intent                | Effect                                  |
| --------------------- | --------------------------------------- |
| ``ToggleIntent``        | Sets a boolean flag.                    |
| ``IncrementIntent``     | Adds to a counter, never below zero.    |
| ``SetValueIntent``      | Stores an integer, such as a rating.    |
| ``RecordActionIntent``  | Queues an action string for the app.    |
| ``RefreshWidgetIntent`` | Reloads one widget kind or all widgets. |

Each intent except ``RefreshWidgetIntent`` reloads all widget timelines after writing, so
the provider can read the new value from the store.

### Read state in the provider and the app

```swift
let intake = WidgetStateStore.shared.value("water")
```

Work the extension cannot do itself, such as starting a timer the app owns, goes through
``RecordActionIntent``. The app processes the queue when it becomes active:

```swift
for action in WidgetStateStore.shared.drainPendingActions() {
    handle(action)
}
```

The queue keeps the 50 most recent actions.
