import AppIntents
import WidgetKit

/// Sets a boolean flag in ``WidgetStateStore/shared`` and reloads widget timelines.
public struct ToggleIntent: AppIntent {
    public static let title: LocalizedStringResource = "Toggle"
    public static let description = IntentDescription("Turns a widget item on or off.")
    public static let isDiscoverable = false

    @Parameter(title: "Item ID") public var itemId: String
    @Parameter(title: "New State") public var newState: Bool

    public init() {}

    public init(itemId: String, newState: Bool) {
        self.itemId = itemId
        self.newState = newState
    }

    public func perform() async throws -> some IntentResult {
        WidgetStateStore.shared.setOn(newState, for: itemId)
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}

/// Adds `amount` (which may be negative) to a counter, never going below zero.
public struct IncrementIntent: AppIntent {
    public static let title: LocalizedStringResource = "Increment"
    public static let description = IntentDescription("Changes a widget counter.")
    public static let isDiscoverable = false

    @Parameter(title: "Counter ID") public var counterId: String
    @Parameter(title: "Amount") public var amount: Int

    public init() {}

    public init(counterId: String, amount: Int = 1) {
        self.counterId = counterId
        self.amount = amount
    }

    public func perform() async throws -> some IntentResult {
        WidgetStateStore.shared.increment(counterId, by: amount, minimum: 0)
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}

/// Stores an integer, e.g. a star rating.
public struct SetValueIntent: AppIntent {
    public static let title: LocalizedStringResource = "Set Value"
    public static let description = IntentDescription("Stores a value chosen in a widget.")
    public static let isDiscoverable = false

    @Parameter(title: "Key") public var key: String
    @Parameter(title: "Value") public var value: Int

    public init() {}

    public init(key: String, value: Int) {
        self.key = key
        self.value = value
    }

    public func perform() async throws -> some IntentResult {
        WidgetStateStore.shared.setValue(value, for: key)
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}

/// Queues an action identifier for the app to process later with
/// ``WidgetStateStore/drainPendingActions()``. Use it for work the extension
/// cannot do itself, such as starting a timer owned by the app.
public struct RecordActionIntent: AppIntent {
    public static let title: LocalizedStringResource = "Record Action"
    public static let description = IntentDescription("Queues a widget action for the app.")
    public static let isDiscoverable = false

    @Parameter(title: "Action") public var action: String

    public init() {}

    public init(action: String) {
        self.action = action
    }

    public func perform() async throws -> some IntentResult {
        WidgetStateStore.shared.enqueueAction(action)
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}

/// Reloads one widget kind, or all widgets when `kind` is empty.
public struct RefreshWidgetIntent: AppIntent {
    public static let title: LocalizedStringResource = "Refresh Widget"
    public static let description = IntentDescription("Reloads widget data.")
    public static let isDiscoverable = false

    @Parameter(title: "Widget Kind") public var kind: String?

    public init() {}

    public init(kind: String? = nil) {
        self.kind = kind
    }

    public func perform() async throws -> some IntentResult {
        if let kind, !kind.isEmpty {
            WidgetCenter.shared.reloadTimelines(ofKind: kind)
        } else {
            WidgetCenter.shared.reloadAllTimelines()
        }
        return .result()
    }
}
