import Foundation

/// A month laid out as rows of seven cells, respecting the calendar's first weekday.
public struct MonthGrid: Equatable, Sendable {
    /// Each row has exactly seven entries; `nil` marks a cell outside the month.
    public let weeks: [[Int?]]
    /// Very short weekday symbols ordered to match the grid columns.
    public let weekdaySymbols: [String]

    public init(month date: Date, calendar: Calendar = .current) {
        let daysPerWeek = 7
        let symbols = calendar.veryShortWeekdaySymbols
        let firstIndex = calendar.firstWeekday - 1
        weekdaySymbols = Array(symbols[firstIndex...] + symbols[..<firstIndex])

        guard
            let startOfMonth = calendar.dateInterval(of: .month, for: date)?.start,
            let dayRange = calendar.range(of: .day, in: .month, for: startOfMonth)
        else {
            weeks = []
            return
        }

        let weekdayOfFirst = calendar.component(.weekday, from: startOfMonth)
        let leadingBlanks = (weekdayOfFirst - calendar.firstWeekday + daysPerWeek) % daysPerWeek
        var cells: [Int?] = Array(repeating: nil, count: leadingBlanks) + dayRange.map { Optional($0) }
        let trailingBlanks = (daysPerWeek - cells.count % daysPerWeek) % daysPerWeek
        cells += Array(repeating: nil, count: trailingBlanks)

        weeks = stride(from: 0, to: cells.count, by: daysPerWeek).map {
            Array(cells[$0..<$0 + daysPerWeek])
        }
    }
}

/// Whole days, hours and minutes left until a target date.
public struct CountdownComponents: Equatable, Sendable {
    public let days: Int
    public let hours: Int
    public let minutes: Int

    /// All components are `0` once `target` is at or before `date`.
    /// Seconds are dropped, because a widget snapshot cannot tick every second.
    public init(from date: Date, to target: Date) {
        let secondsPerMinute = 60
        let secondsPerHour = 3_600
        let secondsPerDay = 86_400
        let remaining = max(0, Int(target.timeIntervalSince(date)))
        days = remaining / secondsPerDay
        hours = remaining % secondsPerDay / secondsPerHour
        minutes = remaining % secondsPerHour / secondsPerMinute
    }
}
