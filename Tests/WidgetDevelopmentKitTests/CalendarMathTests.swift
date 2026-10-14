import Foundation
import Testing
@testable import WidgetDevelopmentKit

@Suite("MonthGrid")
struct MonthGridTests {
    @Test func sundayFirstCalendar() {
        // 1 October 2026 is a Thursday.
        let calendar = TestCalendar.gregorian(firstWeekday: 1)
        let grid = MonthGrid(month: TestCalendar.date(2026, 10, 14), calendar: calendar)

        #expect(grid.weekdaySymbols == ["S", "M", "T", "W", "T", "F", "S"])
        #expect(grid.weeks.count == 5)
        #expect(grid.weeks[0] == [nil, nil, nil, nil, 1, 2, 3])
        #expect(grid.weeks[4] == [25, 26, 27, 28, 29, 30, 31])
    }

    @Test func mondayFirstCalendarShiftsColumns() {
        let calendar = TestCalendar.gregorian(firstWeekday: 2)
        let grid = MonthGrid(month: TestCalendar.date(2026, 10, 1), calendar: calendar)

        #expect(grid.weekdaySymbols == ["M", "T", "W", "T", "F", "S", "S"])
        #expect(grid.weeks[0] == [nil, nil, nil, 1, 2, 3, 4])
        #expect(grid.weeks.last == [26, 27, 28, 29, 30, 31, nil])
    }

    @Test func everyRowHasSevenCellsAndEveryDayAppearsOnce() {
        let calendar = TestCalendar.gregorian(firstWeekday: 2)
        // February 2028 is a leap month.
        let grid = MonthGrid(month: TestCalendar.date(2028, 2, 10), calendar: calendar)

        #expect(grid.weeks.allSatisfy { $0.count == 7 })
        #expect(grid.weeks.flatMap { $0 }.compactMap { $0 } == Array(1...29))
    }

    @Test func monthStartingOnFirstWeekdayHasNoLeadingBlanks() {
        // 1 February 2026 is a Sunday.
        let grid = MonthGrid(month: TestCalendar.date(2026, 2, 1), calendar: TestCalendar.gregorian())
        #expect(grid.weeks.count == 4)
        #expect(grid.weeks[0].first == 1)
    }
}

@Suite("CountdownComponents")
struct CountdownComponentsTests {
    @Test func splitsRemainingTime() {
        let now = TestCalendar.date(2026, 1, 1)
        let target = now.addingTimeInterval(2 * 86_400 + 3 * 3_600 + 4 * 60 + 59)
        let countdown = CountdownComponents(from: now, to: target)

        #expect(countdown == CountdownComponents(from: now, to: target))
        #expect(countdown.days == 2)
        #expect(countdown.hours == 3)
        #expect(countdown.minutes == 4)
    }

    @Test func pastTargetIsAllZero() {
        let now = TestCalendar.date(2026, 1, 1)
        let countdown = CountdownComponents(from: now, to: now.addingTimeInterval(-500))
        #expect(countdown.days == 0 && countdown.hours == 0 && countdown.minutes == 0)
    }
}
