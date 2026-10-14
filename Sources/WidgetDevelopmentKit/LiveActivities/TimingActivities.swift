// Live Activity attributes and views. ActivityKit exists only on iOS.

#if canImport(ActivityKit) && os(iOS)
import ActivityKit
import SwiftUI
import WidgetKit

// MARK: - Timer Activity

/// General purpose timer Live Activity
public struct TimerAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var endTime: Date
        public var isPaused: Bool
        public var pausedTimeRemaining: TimeInterval?

        public init(endTime: Date, isPaused: Bool = false, pausedTimeRemaining: TimeInterval? = nil) {
            self.endTime = endTime
            self.isPaused = isPaused
            self.pausedTimeRemaining = pausedTimeRemaining
        }
    }

    public let timerName: String
    public let category: String
    public let accentColor: String

    public init(timerName: String, category: String = "Timer", accentColor: String = "blue") {
        self.timerName = timerName
        self.category = category
        self.accentColor = accentColor
    }
}

public struct TimerActivityView: View {
    let context: ActivityViewContext<TimerAttributes>

    public init(context: ActivityViewContext<TimerAttributes>) {
        self.context = context
    }

    var color: Color {
        switch context.attributes.accentColor {
        case "red": return .red
        case "green": return .green
        case "orange": return .orange
        case "purple": return .purple
        default: return .blue
        }
    }

    public var body: some View {
        VStack(spacing: 12) {
            HStack {
                Label(context.attributes.category, systemImage: "timer")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                if context.state.isPaused {
                    Text("PAUSED")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(.orange)
                }
            }

            Text(context.state.endTime, style: .timer)
                .font(.system(size: 48, weight: .thin, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(color)

            Text(context.attributes.timerName)
                .font(.headline)
        }
        .padding()
    }

    public var compactLeading: some View {
        Image(systemName: "timer")
            .foregroundStyle(color)
    }

    public var compactTrailing: some View {
        Text(context.state.endTime, style: .timer)
            .font(.caption)
            .monospacedDigit()
    }

    public var minimal: some View {
        Text(context.state.endTime, style: .timer)
            .font(.caption2)
            .monospacedDigit()
    }
}

// MARK: - Workout Activity

/// Fitness workout tracking
public struct WorkoutAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var elapsedTime: TimeInterval
        public var calories: Int
        public var heartRate: Int
        public var distance: Double
        public var pace: String
        public var isActive: Bool

        public init(elapsedTime: TimeInterval, calories: Int, heartRate: Int, distance: Double, pace: String, isActive: Bool) {
            self.elapsedTime = elapsedTime
            self.calories = calories
            self.heartRate = heartRate
            self.distance = distance
            self.pace = pace
            self.isActive = isActive
        }
    }

    public enum WorkoutType: String, Codable {
        case running = "Running"
        case cycling = "Cycling"
        case swimming = "Swimming"
        case walking = "Walking"
        case hiit = "HIIT"

        public var icon: String {
            switch self {
            case .running: return "figure.run"
            case .cycling: return "figure.outdoor.cycle"
            case .swimming: return "figure.pool.swim"
            case .walking: return "figure.walk"
            case .hiit: return "figure.highintensity.intervaltraining"
            }
        }
    }

    public let workoutType: WorkoutType
    public let goalType: String
    public let goalValue: Double

    public init(workoutType: WorkoutType, goalType: String = "Distance", goalValue: Double = 5.0) {
        self.workoutType = workoutType
        self.goalType = goalType
        self.goalValue = goalValue
    }
}

public struct WorkoutActivityView: View {
    let context: ActivityViewContext<WorkoutAttributes>

    public init(context: ActivityViewContext<WorkoutAttributes>) {
        self.context = context
    }

    private func formatTime(_ interval: TimeInterval) -> String {
        WidgetFormat.playbackTime(interval)
    }

    public var body: some View {
        VStack(spacing: 12) {
            HStack {
                Label(context.attributes.workoutType.rawValue, systemImage: context.attributes.workoutType.icon)
                    .font(.headline)

                Spacer()

                if context.state.isActive {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(.green)
                            .frame(width: 8, height: 8)
                        Text("Active")
                            .font(.caption)
                            .foregroundStyle(.green)
                    }
                }
            }

            HStack(spacing: 20) {
                MetricView(value: formatTime(context.state.elapsedTime), label: "Time", icon: "clock")
                MetricView(value: String(format: "%.2f", context.state.distance), label: "km", icon: "location")
                MetricView(value: "\(context.state.calories)", label: "Cal", icon: "flame.fill")
                MetricView(value: "\(context.state.heartRate)", label: "BPM", icon: "heart.fill")
            }

            HStack {
                Text("Pace: \(context.state.pace)")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                Text("Goal: \(String(format: "%.1f", context.attributes.goalValue)) km")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }

    public var compactLeading: some View {
        Image(systemName: context.attributes.workoutType.icon)
            .foregroundStyle(.green)
    }

    public var compactTrailing: some View {
        Text(formatTime(context.state.elapsedTime))
            .font(.caption)
            .monospacedDigit()
    }

    struct MetricView: View {
        let value: String
        let label: String
        let icon: String

        var body: some View {
            VStack(spacing: 2) {
                Image(systemName: icon)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.caption)
                    .fontWeight(.semibold)
                Text(label)
                    .font(.system(size: 9))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - Parking Timer Activity

/// Parking meter countdown
public struct ParkingAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var expiresAt: Date
        public var isExpired: Bool
        public var remainingTime: TimeInterval

        public init(expiresAt: Date, isExpired: Bool = false, remainingTime: TimeInterval) {
            self.expiresAt = expiresAt
            self.isExpired = isExpired
            self.remainingTime = remainingTime
        }
    }

    public let location: String
    public let spotNumber: String
    public let rate: String

    public init(location: String, spotNumber: String, rate: String) {
        self.location = location
        self.spotNumber = spotNumber
        self.rate = rate
    }
}

public struct ParkingActivityView: View {
    let context: ActivityViewContext<ParkingAttributes>

    public init(context: ActivityViewContext<ParkingAttributes>) {
        self.context = context
    }

    var urgencyColor: Color {
        let remaining = context.state.remainingTime
        if remaining <= 0 || context.state.isExpired { return .red }
        if remaining < 600 { return .orange } // Less than 10 min
        return .green
    }

    public var body: some View {
        VStack(spacing: 12) {
            HStack {
                Label(context.attributes.location, systemImage: "car.fill")
                    .font(.headline)

                Spacer()

                Text("Spot \(context.attributes.spotNumber)")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.secondary.opacity(0.2))
                    .clipShape(Capsule())
            }

            if context.state.isExpired {
                Text("EXPIRED")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.red)
            } else {
                Text(context.state.expiresAt, style: .timer)
                    .font(.system(size: 36, weight: .thin, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(urgencyColor)
            }

            HStack {
                Text(context.attributes.rate)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                if !context.state.isExpired {
                    Text("Expires at \(context.state.expiresAt, format: .dateTime.hour().minute())")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
    }

    public var compactLeading: some View {
        Image(systemName: "car.fill")
            .foregroundStyle(urgencyColor)
    }

    public var compactTrailing: some View {
        Text(context.state.expiresAt, style: .timer)
            .font(.caption2)
            .monospacedDigit()
    }
}
#endif
