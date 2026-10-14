import Testing
@testable import WidgetDevelopmentKit

@Suite("LiveActivityStateMachine")
struct LiveActivityStateMachineTests {
    enum Phase: Hashable, Sendable {
        case preparing, onTheWay, delivered, cancelled
    }

    private func makeMachine() -> LiveActivityStateMachine<Phase> {
        LiveActivityStateMachine(
            initialState: .preparing,
            transitions: [
                .preparing: [.onTheWay, .cancelled],
                .onTheWay: [.delivered, .cancelled]
            ]
        )
    }

    @Test func followsAllowedTransitions() async throws {
        let machine = makeMachine()
        try await machine.transition(to: .onTheWay)
        try await machine.transition(to: .delivered)
        #expect(await machine.currentState == .delivered)
    }

    @Test func rejectsTransitionAndKeepsState() async {
        let machine = makeMachine()
        await #expect(throws: StateMachineError.invalidTransition(from: Phase.preparing, to: .delivered)) {
            try await machine.transition(to: .delivered)
        }
        #expect(await machine.currentState == .preparing)
    }

    @Test func terminalStateHasNoNextStates() async throws {
        let machine = makeMachine()
        try await machine.transition(to: .cancelled)
        #expect(await machine.allowedNextStates().isEmpty)
        #expect(await machine.canTransition(to: .preparing) == false)
    }

    @Test func reportsAllowedNextStates() async {
        let machine = makeMachine()
        #expect(await machine.allowedNextStates() == [.onTheWay, .cancelled])
        #expect(await machine.canTransition(to: .onTheWay))
    }
}
