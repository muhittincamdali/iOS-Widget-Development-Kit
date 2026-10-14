import Foundation
import WidgetKit

/// Assembles a WidgetKit `Timeline` from entries and a reload policy.
///
/// Entries are sorted by date when the timeline is built, since WidgetKit expects
/// them in chronological order.
///
/// ```swift
/// let timeline = TimelineBuilder<SimpleEntry>()
///     .adding(entries)
///     .reloading(.every(minutes: 30), from: now)
///     .build()
/// ```
public struct TimelineBuilder<Entry: TimelineEntry> {
    public private(set) var entries: [Entry]
    public private(set) var policy: TimelineReloadPolicy

    public init(entries: [Entry] = [], policy: TimelineReloadPolicy = .atEnd) {
        self.entries = entries
        self.policy = policy
    }

    /// Returns a copy with `entry` appended.
    public func adding(_ entry: Entry) -> Self {
        var copy = self
        copy.entries.append(entry)
        return copy
    }

    /// Returns a copy with `newEntries` appended.
    public func adding(_ newEntries: [Entry]) -> Self {
        var copy = self
        copy.entries.append(contentsOf: newEntries)
        return copy
    }

    /// Returns a copy using a WidgetKit reload policy.
    public func reloading(_ policy: TimelineReloadPolicy) -> Self {
        var copy = self
        copy.policy = policy
        return copy
    }

    /// Returns a copy whose reload policy is derived from a `WidgetUpdatePolicy`.
    public func reloading(
        _ policy: WidgetUpdatePolicy,
        from date: Date,
        calendar: Calendar = .current
    ) -> Self {
        reloading(policy.reloadPolicy(from: date, calendar: calendar))
    }

    /// The timeline with entries in chronological order.
    public func build() -> Timeline<Entry> {
        Timeline(entries: entries.sorted { $0.date < $1.date }, policy: policy)
    }
}

/// Generates evenly spaced dates for timeline entries.
public enum TimelineSchedule {
    /// `count` dates starting at `start`, `interval` seconds apart.
    /// Returns an empty array when `count` is not positive or `interval` is not positive.
    public static func dates(from start: Date, every interval: TimeInterval, count: Int) -> [Date] {
        guard count > 0, interval > 0 else { return [] }
        return (0..<count).map { start.addingTimeInterval(Double($0) * interval) }
    }

    /// Dates from `start` up to (but excluding) `end`, aligned to whole multiples of
    /// `minutes` past the hour. Useful for clock-like widgets that should tick on the
    /// quarter hour rather than at arbitrary offsets.
    public static func alignedDates(
        from start: Date,
        until end: Date,
        everyMinutes minutes: Int,
        calendar: Calendar = .current
    ) -> [Date] {
        guard minutes > 0, start < end else { return [] }
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: start)
        let minute = components.minute ?? 0
        components.minute = minute - minute % minutes
        guard var current = calendar.date(from: components) else { return [] }

        var dates: [Date] = []
        while current < end {
            if current >= start || dates.isEmpty {
                dates.append(max(current, start))
            }
            guard let next = calendar.date(byAdding: .minute, value: minutes, to: current) else { break }
            current = next
        }
        return dates
    }
}

extension Timeline {
    /// A timeline with one entry.
    public static func single(_ entry: EntryType, policy: TimelineReloadPolicy = .atEnd) -> Timeline<EntryType> {
        Timeline(entries: [entry], policy: policy)
    }
}
