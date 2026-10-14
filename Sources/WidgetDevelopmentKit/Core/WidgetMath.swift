import Foundation

/// Pure helpers shared by the widget views.
///
/// Widget views receive values straight from app data, so progress values can be
/// negative, larger than one, `NaN`, or come with a zero total. Keeping the
/// arithmetic here makes those cases testable on every platform.
public enum WidgetMath {
    /// Clamps a progress value into `0...1`. `NaN` and infinities map to `0`.
    public static func clampedFraction(_ value: Double) -> Double {
        guard value.isFinite else { return 0 }
        return min(max(value, 0), 1)
    }

    /// Returns `value / total` clamped into `0...1`, or `0` when `total` is not positive.
    public static func fraction(_ value: Double, of total: Double) -> Double {
        guard total > 0, total.isFinite else { return 0 }
        return clampedFraction(value / total)
    }

    /// Whole-number percentage (`0...100`) of a fraction, rounded down.
    public static func percent(_ fraction: Double) -> Int {
        Int(clampedFraction(fraction) * 100)
    }

    /// Percentage string such as `"42%"`.
    public static func percentString(_ fraction: Double) -> String {
        "\(percent(fraction))%"
    }

    /// SF Symbol name for a battery level in `0...1`.
    public static func batterySymbolName(level: Double, isCharging: Bool) -> String {
        if isCharging { return "battery.100.bolt" }
        switch clampedFraction(level) {
        case ..<0.1: return "battery.0"
        case ..<0.25: return "battery.25"
        case ..<0.5: return "battery.50"
        case ..<0.75: return "battery.75"
        default: return "battery.100"
        }
    }

    /// Builds a date range for timer views. `ClosedRange` traps when the bounds are
    /// reversed, so an `end` earlier than `start` collapses to an empty interval.
    public static func timerInterval(start: Date, end: Date) -> ClosedRange<Date> {
        start...max(start, end)
    }

    /// Number of calendar days from `date` until `target`; `0` once the target has passed.
    public static func daysRemaining(
        until target: Date,
        from date: Date,
        calendar: Calendar = .current
    ) -> Int {
        let start = calendar.startOfDay(for: date)
        let end = calendar.startOfDay(for: target)
        let days = calendar.dateComponents([.day], from: start, to: end).day ?? 0
        return max(0, days)
    }

    /// Discrete intensity level (`0..<levels`) for a heat-map cell, GitHub style.
    /// Zero or negative values are level `0`; the maximum value is the top level.
    public static func intensityLevel(_ value: Double, maximum: Double, levels: Int) -> Int {
        guard levels > 1, value > 0, maximum > 0, value.isFinite else { return 0 }
        let fraction = min(value / maximum, 1)
        let level = Int((fraction * Double(levels - 1)).rounded(.up))
        return min(max(level, 1), levels - 1)
    }
}
