#if canImport(ActivityKit) && os(iOS)
import Foundation
import Testing
@testable import WidgetDevelopmentKit

@Suite("Timer activity state")
struct TimerActivityStateTests {
    @Test func runningTimerHasNoPausedLabel() {
        let state = TimerAttributes.ContentState(endTime: .now, pausedTimeRemaining: 90)
        #expect(state.pausedLabel == nil)
    }

    @Test func pausedTimerShowsRemainingTime() {
        let state = TimerAttributes.ContentState(endTime: .now, isPaused: true, pausedTimeRemaining: 125)
        #expect(state.pausedLabel == "2:05")
    }

    @Test func pausedTimerWithoutRemainingTimeReadsZero() {
        let state = TimerAttributes.ContentState(endTime: .now, isPaused: true)
        #expect(state.pausedLabel == "0:00")
    }
}
#endif
