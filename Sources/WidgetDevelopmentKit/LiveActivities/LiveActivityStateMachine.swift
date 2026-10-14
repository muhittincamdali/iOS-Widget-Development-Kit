import Foundation

/// A small state machine for driving Live Activity content through allowed phases.
///
/// Live Activity updates often arrive out of order (push, background refresh, app
/// launch). Declaring the allowed transitions up front lets the app reject an update
/// that would move an activity backwards, for example from `.delivered` to `.preparing`.
///
/// ```swift
/// enum Phase: Hashable, Sendable { case preparing, onTheWay, delivered }
///
/// let machine = LiveActivityStateMachine(
///     initialState: Phase.preparing,
///     transitions: [.preparing: [.onTheWay], .onTheWay: [.delivered]]
/// )
/// try await machine.transition(to: .onTheWay)
/// ```
public actor LiveActivityStateMachine<State: Sendable & Hashable> {
    public private(set) var currentState: State
    private let transitions: [State: Set<State>]

    public init(initialState: State, transitions: [State: Set<State>]) {
        self.currentState = initialState
        self.transitions = transitions
    }

    /// Whether moving from the current state to `newState` is allowed.
    public func canTransition(to newState: State) -> Bool {
        transitions[currentState]?.contains(newState) ?? false
    }

    /// Moves to `newState`, or throws without changing state if the transition is not allowed.
    public func transition(to newState: State) throws(StateMachineError<State>) {
        guard canTransition(to: newState) else {
            throw .invalidTransition(from: currentState, to: newState)
        }
        currentState = newState
    }

    /// States reachable in one step from the current state.
    public func allowedNextStates() -> Set<State> {
        transitions[currentState] ?? []
    }
}

public enum StateMachineError<State: Sendable & Hashable>: Error, Equatable {
    case invalidTransition(from: State, to: State)
}
