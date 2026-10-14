import Foundation

/// Locale-independent formatting helpers for small widget labels.
public enum WidgetFormat {
    /// Short count such as `"950"`, `"12.3K"` or `"4.5M"`. Negative values keep their sign.
    public static func compactNumber(_ number: Int) -> String {
        let magnitude = number.magnitude
        let sign = number < 0 ? "-" : ""
        switch magnitude {
        case 1_000_000...:
            return sign + String(format: "%.1fM", Double(magnitude) / 1_000_000)
        case 1_000...:
            return sign + String(format: "%.1fK", Double(magnitude) / 1_000)
        default:
            return "\(number)"
        }
    }

    /// Playback position such as `"3:07"` or `"1:02:05"`. Invalid or negative input reads `"0:00"`.
    public static func playbackTime(_ interval: TimeInterval) -> String {
        guard interval.isFinite, interval > 0 else { return "0:00" }
        let totalSeconds = Int(interval)
        let hours = totalSeconds / 3_600
        let minutes = totalSeconds % 3_600 / 60
        let seconds = totalSeconds % 60
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%d:%02d", minutes, seconds)
    }
}
