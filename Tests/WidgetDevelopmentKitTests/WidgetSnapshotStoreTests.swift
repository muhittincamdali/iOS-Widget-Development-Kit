import Foundation
import Testing
@testable import WidgetDevelopmentKit

private struct Weather: Codable, Equatable {
    let city: String
    let temperature: Int
}

/// A clock the test can move forward.
private final class TestClock: @unchecked Sendable {
    private let lock = NSLock()
    private var current: Date
    init(_ date: Date) { current = date }
    func now() -> Date { lock.withLock { current } }
    func advance(by seconds: TimeInterval) { lock.withLock { current += seconds } }
}

@Suite("WidgetSnapshotStore")
struct WidgetSnapshotStoreTests {
    private let suiteName = "WidgetSnapshotStoreTests.\(UUID().uuidString)"
    private let clock = TestClock(Date(timeIntervalSince1970: 1_800_000_000))

    private func makeStore() -> (WidgetSnapshotStore, UserDefaults) {
        let defaults = UserDefaults(suiteName: suiteName)!
        let clock = clock
        return (WidgetSnapshotStore(defaults: defaults, now: { clock.now() }), defaults)
    }

    @Test func roundTripsBeforeExpiry() throws {
        let (store, defaults) = makeStore()
        defer { defaults.removePersistentDomain(forName: suiteName) }

        try store.save(Weather(city: "Istanbul", temperature: 21), forKey: "weather", lifetime: 600)
        clock.advance(by: 599)
        #expect(store.value(Weather.self, forKey: "weather") == Weather(city: "Istanbul", temperature: 21))
    }

    @Test func expiredValueIsRemovedButStaleReadWorksBeforeThat() throws {
        let (store, defaults) = makeStore()
        defer { defaults.removePersistentDomain(forName: suiteName) }

        try store.save(Weather(city: "Ankara", temperature: 12), forKey: "weather", lifetime: 60)
        clock.advance(by: 61)
        #expect(store.staleValue(Weather.self, forKey: "weather")?.city == "Ankara")
        #expect(store.value(Weather.self, forKey: "weather") == nil)
        #expect(store.staleValue(Weather.self, forKey: "weather") == nil)
    }

    @Test func wrongTypeAndMissingKeyReturnNil() throws {
        let (store, defaults) = makeStore()
        defer { defaults.removePersistentDomain(forName: suiteName) }

        try store.save(42, forKey: "count", lifetime: 60)
        #expect(store.value(Weather.self, forKey: "count") == nil)
        #expect(store.value(Int.self, forKey: "count") == 42)
        #expect(store.value(Int.self, forKey: "missing") == nil)
    }

    @Test func keysAreNamespaced() throws {
        let (store, defaults) = makeStore()
        defer { defaults.removePersistentDomain(forName: suiteName) }

        try store.save("hello", forKey: "greeting", lifetime: 60)
        #expect(defaults.data(forKey: "widget.snapshot.greeting") != nil)
        #expect(defaults.data(forKey: "greeting") == nil)

        store.removeValue(forKey: "greeting")
        #expect(store.value(String.self, forKey: "greeting") == nil)
    }
}
