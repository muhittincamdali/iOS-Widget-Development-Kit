import Foundation
import Testing
@testable import WidgetDevelopmentKit

@Suite("WidgetStateStore")
struct WidgetStateStoreTests {
    private let suiteName = "WidgetStateStoreTests.\(UUID().uuidString)"

    private func withStore(_ body: (WidgetStateStore, UserDefaults) throws -> Void) rethrows {
        let defaults = UserDefaults(suiteName: suiteName)!
        defer { defaults.removePersistentDomain(forName: suiteName) }
        try body(WidgetStateStore(defaults: defaults), defaults)
    }

    @Test func flagsDefaultToOffAndPersist() {
        withStore { store, _ in
            #expect(store.isOn("lamp") == false)
            store.setOn(true, for: "lamp")
            #expect(store.isOn("lamp"))
            #expect(store.isOn("other") == false)
        }
    }

    @Test func incrementRespectsMinimum() {
        withStore { store, _ in
            #expect(store.increment("water", by: 250) == 250)
            #expect(store.increment("water", by: 250) == 500)
            #expect(store.increment("water", by: -1_000, minimum: 0) == 0)
            #expect(store.value("water") == 0)
        }
    }

    @Test func incrementSaturatesInsteadOfOverflowing() {
        withStore { store, _ in
            store.setValue(.max - 1, for: "big")
            #expect(store.increment("big", by: 10) == .max)
            store.setValue(.min + 1, for: "small")
            #expect(store.increment("small", by: -10) == .min)
        }
    }

    @Test func pendingActionsAreFIFOAndDrained() {
        withStore { store, _ in
            store.enqueueAction("timer.start.tea")
            store.enqueueAction("timer.stop.tea")
            #expect(store.drainPendingActions() == ["timer.start.tea", "timer.stop.tea"])
            #expect(store.pendingActions().isEmpty)
        }
    }

    @Test func pendingActionsKeepMostRecentFifty() {
        withStore { store, _ in
            for index in 0..<60 { store.enqueueAction("action.\(index)") }
            let actions = store.pendingActions()
            #expect(actions.count == 50)
            #expect(actions.first == "action.10")
            #expect(actions.last == "action.59")
        }
    }

    @Test func keysAreNamespaced() {
        withStore { store, defaults in
            store.setValue(3, for: "rating")
            #expect(defaults.integer(forKey: "widget.state.value.rating") == 3)
            #expect(defaults.object(forKey: "rating") == nil)
        }
    }
}
