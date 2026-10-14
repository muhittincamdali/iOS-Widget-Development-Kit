import Foundation

/// Stores `Codable` values with an expiry date in `UserDefaults`.
///
/// The usual setup is an App Group suite shared by the app and its widget
/// extension: the app writes fresh data, and the timeline provider reads it
/// without a network call.
///
/// ```swift
/// let store = WidgetSnapshotStore(defaults: UserDefaults(suiteName: "group.com.example.app")!)
/// try store.save(weather, forKey: "weather", lifetime: 15 * 60)
/// let cached: Weather? = store.value(Weather.self, forKey: "weather")
/// ```
public struct WidgetSnapshotStore: Sendable {
    private struct Envelope<Value: Codable>: Codable {
        let value: Value
        let expiresAt: Date
    }

    // UserDefaults is documented as thread-safe but is not marked Sendable in the SDK.
    nonisolated(unsafe) private let defaults: UserDefaults
    private let keyPrefix: String
    private let now: @Sendable () -> Date

    /// - Parameters:
    ///   - defaults: Usually `UserDefaults(suiteName:)` for your App Group.
    ///   - keyPrefix: Namespace for keys written by this store.
    ///   - now: Clock used for expiry checks; injectable for tests.
    public init(
        defaults: UserDefaults,
        keyPrefix: String = "widget.snapshot.",
        now: @escaping @Sendable () -> Date = { Date() }
    ) {
        self.defaults = defaults
        self.keyPrefix = keyPrefix
        self.now = now
    }

    /// Encodes and stores `value` until `lifetime` seconds from now.
    public func save<Value: Codable>(_ value: Value, forKey key: String, lifetime: TimeInterval) throws {
        let envelope = Envelope(value: value, expiresAt: now().addingTimeInterval(lifetime))
        let data = try JSONEncoder().encode(envelope)
        defaults.set(data, forKey: keyPrefix + key)
    }

    /// The stored value if present, decodable as `Value`, and not expired.
    /// Expired entries are removed.
    public func value<Value: Codable>(_ type: Value.Type, forKey key: String) -> Value? {
        guard let envelope = envelope(type, forKey: key) else { return nil }
        guard envelope.expiresAt > now() else {
            removeValue(forKey: key)
            return nil
        }
        return envelope.value
    }

    /// The stored value even if it has expired, for showing stale data while a refresh runs.
    public func staleValue<Value: Codable>(_ type: Value.Type, forKey key: String) -> Value? {
        envelope(type, forKey: key)?.value
    }

    public func removeValue(forKey key: String) {
        defaults.removeObject(forKey: keyPrefix + key)
    }

    private func envelope<Value: Codable>(_ type: Value.Type, forKey key: String) -> Envelope<Value>? {
        guard let data = defaults.data(forKey: keyPrefix + key) else { return nil }
        return try? JSONDecoder().decode(Envelope<Value>.self, from: data)
    }
}
