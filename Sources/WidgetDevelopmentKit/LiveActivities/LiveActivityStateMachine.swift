import Foundation

/// iOS-Widget-Development-Kit: Live Activity State-Machine.
/// 
/// Manages complex state transitions for Live Activities using a 
/// strictly-typed, high-integrity state machine.
public actor LiveActivityStateMachine<State: Sendable & Hashable> {
    private var currentState: State
    private let transitions: [State: [State]]
    
    public init(initialState: State, transitions: [State: [State]]) {
        self.currentState = initialState
        self.transitions = transitions
    }
    
    /// Attempts to transition to a new state. 
    /// Validates the transition against the defined graph.
    public func transition(to newState: State) throws {
        guard let allowed = transitions[currentState], allowed.contains(newState) else {
            throw StateMachineError.invalidTransition
        }
        
        currentState = newState
        print("⚡ [WidgetKit] Live Activity Transitioned to: \\(newState)")
    }
    
    public func getCurrentState() -> State {
        return currentState
    }
}

public enum StateMachineError: Error {
    case invalidTransition
}
