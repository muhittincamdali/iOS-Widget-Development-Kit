import Foundation
import WidgetKit

/// Describes when a widget's timeline should be reloaded, and converts that into
/// a WidgetKit `TimelineReloadPolicy`.
///
/// Calendar-based cases (`.nextHour`, `.startOfNextDay`) use calendar arithmetic, so
/// they stay correct across daylight-saving changes where adding 3600 or 86400
/// seconds would not.
public enum WidgetUpdatePolicy: Sendable {
    /// Reload at a fixed date.
    case atDate(Date)
    /// Reload after a time interval in seconds.
    case afterInterval(TimeInterval)
    /// Reload at the start of the next clock hour.
    case nextHour
    /// Reload at midnight of the following day.
    case startOfNextDay
    /// Reload every `minutes` minutes.
    case every(minutes: Int)
    /// Never reload automatically; the app calls `WidgetCenter` itself.
    case never
    /// Compute the date yourself.
    case custom(@Sendable (Date) -> Date?)

    /// The next reload date after `date`, or `nil` for `.never`.
    public func nextUpdateDate(from date: Date, calendar: Calendar = .current) -> Date? {
        switch self {
        case .atDate(let target):
            return target
        case .afterInterval(let interval):
            return date.addingTimeInterval(max(interval, 0))
        case .nextHour:
            guard let hour = calendar.dateInterval(of: .hour, for: date) else { return nil }
            return hour.end
        case .startOfNextDay:
            let startOfDay = calendar.startOfDay(for: date)
            return calendar.date(byAdding: .day, value: 1, to: startOfDay)
        case .every(let minutes):
            return calendar.date(byAdding: .minute, value: max(minutes, 1), to: date)
        case .never:
            return nil
        case .custom(let compute):
            return compute(date)
        }
    }

    /// The WidgetKit reload policy for a timeline generated at `date`.
    public func reloadPolicy(from date: Date, calendar: Calendar = .current) -> TimelineReloadPolicy {
        guard let next = nextUpdateDate(from: date, calendar: calendar) else { return .never }
        return .after(next)
    }
}
