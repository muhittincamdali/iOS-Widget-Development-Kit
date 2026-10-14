import SwiftUI
import Testing
@testable import WidgetDevelopmentKit

@Suite("Template logic")
struct TemplateLogicTests {
    @Test(arguments: [
        ([true, true, false, true, true, true], 3),
        ([true, true, true], 3),
        ([true, false], 0),
        ([Bool](), 0)
    ])
    func habitStreakCountsTrailingCompletedDays(days: [Bool], expected: Int) {
        let habit = HabitTrackerWidget.Habit(name: "Read", icon: "book", color: .blue, completedDays: days)
        #expect(habit.streak == expected)
    }

    @Test func waterTrackerCountsGlassesAndGoal() {
        let widget = WaterTrackerWidget(currentIntake: 1_100, dailyGoal: 2_000, glassSize: 250)
        #expect(widget.glasses == 4)
        #expect(widget.glassGoal == 8)
        #expect(widget.progress == 0.55)
    }

    @Test func waterTrackerHandlesInvalidSizes() {
        let zeroGlass = WaterTrackerWidget(currentIntake: 500, dailyGoal: 2_000, glassSize: 0)
        #expect(zeroGlass.glasses == 0)
        #expect(zeroGlass.glassGoal == 0)

        let zeroGoal = WaterTrackerWidget(currentIntake: 500, dailyGoal: 0, glassSize: 250)
        #expect(zeroGoal.progress == 0)
        #expect(zeroGoal.glassGoal == 0)
    }

    @Test func waterTrackerCapsGlassIcons() {
        let widget = WaterTrackerWidget(currentIntake: 0, dailyGoal: 10_000, glassSize: 100)
        #expect(widget.glassGoal == 12)
    }
}
