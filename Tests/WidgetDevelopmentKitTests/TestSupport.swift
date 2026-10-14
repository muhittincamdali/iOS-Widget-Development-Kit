import Foundation

/// Deterministic calendar and dates so tests do not depend on the machine's locale or time zone.
enum TestCalendar {
    static func gregorian(firstWeekday: Int = 1, timeZone: String = "UTC") -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.timeZone = TimeZone(identifier: timeZone)!
        calendar.firstWeekday = firstWeekday
        return calendar
    }

    static func date(
        _ year: Int, _ month: Int, _ day: Int,
        _ hour: Int = 0, _ minute: Int = 0, _ second: Int = 0,
        calendar: Calendar = gregorian()
    ) -> Date {
        let components = DateComponents(
            year: year, month: month, day: day,
            hour: hour, minute: minute, second: second
        )
        return calendar.date(from: components)!
    }
}
