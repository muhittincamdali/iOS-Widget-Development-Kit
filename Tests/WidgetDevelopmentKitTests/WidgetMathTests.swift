import Foundation
import Testing
@testable import WidgetDevelopmentKit

@Suite("WidgetMath")
struct WidgetMathTests {
    @Test(arguments: [
        (-0.5, 0.0), (0.0, 0.0), (0.42, 0.42), (1.0, 1.0), (7.0, 1.0),
        (Double.nan, 0.0), (Double.infinity, 0.0), (-Double.infinity, 0.0)
    ])
    func clampedFraction(input: Double, expected: Double) {
        #expect(WidgetMath.clampedFraction(input) == expected)
    }

    @Test func fractionGuardsAgainstZeroAndNegativeTotals() {
        #expect(WidgetMath.fraction(250, of: 500) == 0.5)
        #expect(WidgetMath.fraction(900, of: 500) == 1)
        #expect(WidgetMath.fraction(10, of: 0) == 0)
        #expect(WidgetMath.fraction(10, of: -5) == 0)
        #expect(WidgetMath.fraction(10, of: .infinity) == 0)
    }

    @Test func percentRoundsDownAndClamps() {
        #expect(WidgetMath.percent(0.999) == 99)
        #expect(WidgetMath.percent(1.5) == 100)
        #expect(WidgetMath.percentString(0.42) == "42%")
        #expect(WidgetMath.percentString(-1) == "0%")
    }

    @Test(arguments: [
        (0.05, "battery.0"), (0.1, "battery.25"), (0.3, "battery.50"),
        (0.6, "battery.75"), (0.75, "battery.100"), (2.0, "battery.100"), (-1.0, "battery.0")
    ])
    func batterySymbol(level: Double, expected: String) {
        #expect(WidgetMath.batterySymbolName(level: level, isCharging: false) == expected)
    }

    @Test func chargingAlwaysUsesBoltSymbol() {
        #expect(WidgetMath.batterySymbolName(level: 0.05, isCharging: true) == "battery.100.bolt")
    }

    @Test func timerIntervalNeverReversesBounds() {
        let start = TestCalendar.date(2026, 3, 1, 12)
        let earlier = start.addingTimeInterval(-60)
        let later = start.addingTimeInterval(60)

        #expect(WidgetMath.timerInterval(start: start, end: later) == start...later)
        #expect(WidgetMath.timerInterval(start: start, end: earlier) == start...start)
    }

    @Test func daysRemainingCountsCalendarDays() {
        let calendar = TestCalendar.gregorian()
        let lateEvening = TestCalendar.date(2026, 3, 1, 23, 30)
        let nextMorning = TestCalendar.date(2026, 3, 2, 8)
        let nextWeek = TestCalendar.date(2026, 3, 8, 0, 1)

        // Less than 24 hours away, but on the next calendar day.
        #expect(WidgetMath.daysRemaining(until: nextMorning, from: lateEvening, calendar: calendar) == 1)
        #expect(WidgetMath.daysRemaining(until: nextWeek, from: lateEvening, calendar: calendar) == 7)
        #expect(WidgetMath.daysRemaining(until: lateEvening, from: nextMorning, calendar: calendar) == 0)
    }

    @Test func daysRemainingIsStableAcrossDaylightSavingChange() {
        let calendar = TestCalendar.gregorian(timeZone: "America/New_York")
        // US clocks spring forward on 8 March 2026, so that day has 23 hours.
        let before = TestCalendar.date(2026, 3, 7, 12, calendar: calendar)
        let after = TestCalendar.date(2026, 3, 9, 12, calendar: calendar)
        #expect(WidgetMath.daysRemaining(until: after, from: before, calendar: calendar) == 2)
    }

    @Test func intensityLevels() {
        #expect(WidgetMath.intensityLevel(0, maximum: 10, levels: 5) == 0)
        #expect(WidgetMath.intensityLevel(-3, maximum: 10, levels: 5) == 0)
        #expect(WidgetMath.intensityLevel(0.1, maximum: 10, levels: 5) == 1)
        #expect(WidgetMath.intensityLevel(5, maximum: 10, levels: 5) == 2)
        #expect(WidgetMath.intensityLevel(10, maximum: 10, levels: 5) == 4)
        #expect(WidgetMath.intensityLevel(25, maximum: 10, levels: 5) == 4)
        #expect(WidgetMath.intensityLevel(5, maximum: 0, levels: 5) == 0)
        #expect(WidgetMath.intensityLevel(5, maximum: 10, levels: 1) == 0)
    }
}

@Suite("WidgetFormat")
struct WidgetFormatTests {
    @Test(arguments: [
        (0, "0"), (999, "999"), (1_000, "1.0K"), (12_345, "12.3K"),
        (1_500_000, "1.5M"), (-2_500, "-2.5K"), (-42, "-42")
    ])
    func compactNumber(input: Int, expected: String) {
        #expect(WidgetFormat.compactNumber(input) == expected)
    }

    @Test(arguments: [
        (0.0, "0:00"), (7.9, "0:07"), (187, "3:07"), (3_725, "1:02:05"),
        (-10, "0:00"), (Double.nan, "0:00"), (Double.infinity, "0:00")
    ])
    func playbackTime(input: Double, expected: String) {
        #expect(WidgetFormat.playbackTime(input) == expected)
    }
}
