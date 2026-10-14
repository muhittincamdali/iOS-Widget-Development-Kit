import Foundation

/// Small key-value state shared by interactive widget intents and the host app.
///
/// Interactive widget buttons run their `AppIntent` in the widget extension
/// process, so any state they change must live somewhere the app can also read:
/// usually `UserDefaults` for a shared App Group.
///
/// The intents in this package use ``shared``, which reads the App Group from
/// the `WidgetDevelopmentKitAppGroup` key in the running bundle's Info.plist.
/// Add that key with the same value to both the app and the widget extension.
public struct WidgetStateStore: Sendable {
    /// Info.plist key holding the App Group identifier used by ``shared``.
    public static let appGroupInfoKey = "WidgetDevelopmentKitAppGroup"

    private static let pendingActionsKey = "actions.pending"
    private static let maximumPendingActions = 50

    // UserDefaults is documented as thread-safe but is not marked Sendable in the SDK.
    nonisolated(unsafe) private let defaults: UserDefaults
    private let keyPrefix: String

    public init(defaults: UserDefaults, keyPrefix: String = "widget.state.") {
        self.defaults = defaults
        self.keyPrefix = keyPrefix
    }

    /// The store for the App Group named in Info.plist, or standard defaults if the key
    /// is missing (state then stays inside the current process's container).
    public static var shared: WidgetStateStore {
        let group = Bundle.main.object(forInfoDictionaryKey: appGroupInfoKey) as? String
        let defaults = group.flatMap { UserDefaults(suiteName: $0) } ?? .standard
        return WidgetStateStore(defaults: defaults)
    }

    // MARK: Flags

    public func isOn(_ id: String) -> Bool {
        defaults.bool(forKey: key("flag", id))
    }

    public func setOn(_ isOn: Bool, for id: String) {
        defaults.set(isOn, forKey: key("flag", id))
    }

    // MARK: Integers

    public func value(_ id: String) -> Int {
        defaults.integer(forKey: key("value", id))
    }

    public func setValue(_ value: Int, for id: String) {
        defaults.set(value, forKey: key("value", id))
    }

    /// Adds `amount` and returns the new value. Saturates instead of overflowing.
    @discardableResult
    public func increment(_ id: String, by amount: Int = 1, minimum: Int? = nil) -> Int {
        let (sum, overflow) = value(id).addingReportingOverflow(amount)
        var newValue = overflow ? (amount > 0 ? Int.max : Int.min) : sum
        if let minimum { newValue = max(newValue, minimum) }
        setValue(newValue, for: id)
        return newValue
    }

    // MARK: Pending actions

    /// Queues an action for the app to handle on its next launch or foreground.
    /// The queue keeps the most recent 50 actions.
    public func enqueueAction(_ action: String) {
        var actions = pendingActions()
        actions.append(action)
        defaults.set(Array(actions.suffix(Self.maximumPendingActions)), forKey: keyPrefix + Self.pendingActionsKey)
    }

    public func pendingActions() -> [String] {
        defaults.stringArray(forKey: keyPrefix + Self.pendingActionsKey) ?? []
    }

    /// Returns queued actions in order and clears the queue.
    public func drainPendingActions() -> [String] {
        let actions = pendingActions()
        defaults.removeObject(forKey: keyPrefix + Self.pendingActionsKey)
        return actions
    }

    private func key(_ kind: String, _ id: String) -> String {
        "\(keyPrefix)\(kind).\(id)"
    }
}
