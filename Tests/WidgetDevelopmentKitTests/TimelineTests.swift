import Foundation
import Testing
import WidgetKit
@testable import WidgetDevelopmentKit

private struct SampleEntry: TimelineEntry, Equatable {
    let date: Date
    let value: Int
}

@Suite("WidgetUpdatePolicy")
struct WidgetUpdatePolicyTests {
    let calendar = TestCalendar.gregorian()
    let now = TestCalendar.date(2026, 10, 14, 9, 41, 30)

    @Test func nextHourIsStartOfFollowingHour() {
        #expect(WidgetUpdatePolicy.nextHour.nextUpdateDate(from: now, calendar: calendar)
            == TestCalendar.date(2026, 10, 14, 10))
    }

    @Test func nextHourRollsOverMidnight() {
        let lateNight = TestCalendar.date(2026, 12, 31, 23, 15)
        #expect(WidgetUpdatePolicy.nextHour.nextUpdateDate(from: lateNight, calendar: calendar)
            == TestCalendar.date(2027, 1, 1))
    }

    @Test func startOfNextDayUsesCalendarDays() {
        let newYork = TestCalendar.gregorian(timeZone: "America/New_York")
        // 1 November 2026 is the US fall-back day and has 25 hours.
        let evening = TestCalendar.date(2026, 10, 31, 22, calendar: newYork)
        let expected = TestCalendar.date(2026, 11, 1, calendar: newYork)
        #expect(WidgetUpdatePolicy.startOfNextDay.nextUpdateDate(from: evening, calendar: newYork) == expected)

        let fallBackDay = TestCalendar.date(2026, 11, 1, 12, calendar: newYork)
        let nextMidnight = TestCalendar.date(2026, 11, 2, calendar: newYork)
        #expect(WidgetUpdatePolicy.startOfNextDay.nextUpdateDate(from: fallBackDay, calendar: newYork) == nextMidnight)
    }

    @Test func intervalAndMinutePolicies() {
        #expect(WidgetUpdatePolicy.afterInterval(90).nextUpdateDate(from: now) == now.addingTimeInterval(90))
        #expect(WidgetUpdatePolicy.afterInterval(-5).nextUpdateDate(from: now) == now)
        #expect(WidgetUpdatePolicy.every(minutes: 15).nextUpdateDate(from: now, calendar: calendar)
            == now.addingTimeInterval(15 * 60))
        // Zero or negative minutes would reload in a tight loop; one minute is the floor.
        #expect(WidgetUpdatePolicy.every(minutes: 0).nextUpdateDate(from: now, calendar: calendar)
            == now.addingTimeInterval(60))
    }

    @Test func fixedCustomAndNever() {
        let target = TestCalendar.date(2027, 1, 1)
        #expect(WidgetUpdatePolicy.atDate(target).nextUpdateDate(from: now) == target)
        #expect(WidgetUpdatePolicy.custom { $0.addingTimeInterval(5) }.nextUpdateDate(from: now) == now.addingTimeInterval(5))
        #expect(WidgetUpdatePolicy.never.nextUpdateDate(from: now) == nil)
    }

    @Test func convertsToReloadPolicy() {
        #expect(WidgetUpdatePolicy.never.reloadPolicy(from: now) == .never)
        #expect(WidgetUpdatePolicy.afterInterval(60).reloadPolicy(from: now) == .after(now.addingTimeInterval(60)))
    }
}

@Suite("TimelineBuilder")
struct TimelineBuilderTests {
    let start = TestCalendar.date(2026, 10, 14, 9)

    @Test func sortsEntriesChronologically() {
        let entries = [2, 0, 1].map { SampleEntry(date: start.addingTimeInterval(Double($0) * 60), value: $0) }
        let timeline = TimelineBuilder<SampleEntry>().adding(entries).build()
        #expect(timeline.entries.map(\.value) == [0, 1, 2])
        #expect(timeline.policy == .atEnd)
    }

    @Test func isAValueType() {
        let base = TimelineBuilder<SampleEntry>().adding(SampleEntry(date: start, value: 1))
        let extended = base.adding(SampleEntry(date: start, value: 2))
        #expect(base.entries.count == 1)
        #expect(extended.entries.count == 2)
    }

    @Test func appliesUpdatePolicy() {
        let calendar = TestCalendar.gregorian()
        let timeline = TimelineBuilder<SampleEntry>()
            .adding(SampleEntry(date: start, value: 0))
            .reloading(.nextHour, from: start.addingTimeInterval(120), calendar: calendar)
            .build()
        #expect(timeline.policy == .after(TestCalendar.date(2026, 10, 14, 10)))
    }

    @Test func singleEntryTimeline() {
        let timeline = Timeline.single(SampleEntry(date: start, value: 7), policy: .never)
        #expect(timeline.entries == [SampleEntry(date: start, value: 7)])
        #expect(timeline.policy == .never)
    }
}

@Suite("TimelineSchedule")
struct TimelineScheduleTests {
    let calendar = TestCalendar.gregorian()

    @Test func evenlySpacedDates() {
        let start = TestCalendar.date(2026, 10, 14, 9)
        let dates = TimelineSchedule.dates(from: start, every: 900, count: 3)
        #expect(dates == [start, start.addingTimeInterval(900), start.addingTimeInterval(1_800)])
        #expect(TimelineSchedule.dates(from: start, every: 900, count: 0).isEmpty)
        #expect(TimelineSchedule.dates(from: start, every: 0, count: 3).isEmpty)
    }

    @Test func alignedDatesStartNowThenSnapToBoundaries() {
        let start = TestCalendar.date(2026, 10, 14, 9, 7, 30)
        let end = TestCalendar.date(2026, 10, 14, 10)
        let dates = TimelineSchedule.alignedDates(from: start, until: end, everyMinutes: 15, calendar: calendar)
        #expect(dates == [
            start,
            TestCalendar.date(2026, 10, 14, 9, 15),
            TestCalendar.date(2026, 10, 14, 9, 30),
            TestCalendar.date(2026, 10, 14, 9, 45)
        ])
    }

    @Test func alignedDatesWhenStartIsOnBoundary() {
        let start = TestCalendar.date(2026, 10, 14, 9, 30)
        let end = TestCalendar.date(2026, 10, 14, 10, 1)
        let dates = TimelineSchedule.alignedDates(from: start, until: end, everyMinutes: 30, calendar: calendar)
        #expect(dates == [start, TestCalendar.date(2026, 10, 14, 10)])
    }

    @Test func alignedDatesRejectInvalidInput() {
        let start = TestCalendar.date(2026, 10, 14, 9)
        #expect(TimelineSchedule.alignedDates(from: start, until: start, everyMinutes: 15, calendar: calendar).isEmpty)
        #expect(TimelineSchedule.alignedDates(from: start, until: start.addingTimeInterval(3_600), everyMinutes: 0, calendar: calendar).isEmpty)
    }
}
