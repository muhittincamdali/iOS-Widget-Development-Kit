import AppIntents
import SwiftUI
import WidgetKit

// MARK: - Interactive Quick Actions Widget

/// Quick action buttons widget
public struct InteractiveQuickActionsWidget: View {
    public struct QuickAction: Identifiable {
        public let id: String
        public let title: String
        public let icon: String
        public let color: Color
        public let url: URL?

        public init(id: String, title: String, icon: String, color: Color, url: URL? = nil) {
            self.id = id
            self.title = title
            self.icon = icon
            self.color = color
            self.url = url
        }
    }

    let actions: [QuickAction]
    let columns: Int

    public init(actions: [QuickAction], columns: Int = 2) {
        self.actions = actions
        self.columns = columns
    }

    public var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columns), spacing: 8) {
            ForEach(actions.prefix(4)) { action in
                if let url = action.url {
                    Link(destination: url) {
                        ActionButtonView(action: action)
                    }
                } else {
                    Button(intent: RecordActionIntent(action: action.id)) {
                        ActionButtonView(action: action)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }

    struct ActionButtonView: View {
        let action: QuickAction

        var body: some View {
            VStack(spacing: 6) {
                Image(systemName: action.icon)
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(action.color)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                Text(action.title)
                    .font(.caption2)
                    .lineLimit(1)
            }
        }
    }
}

// MARK: - Interactive Timer Control Widget

/// Timer control widget with start/pause/reset
public struct InteractiveTimerWidget: View {
    let timerId: String
    let timeRemaining: TimeInterval
    let isRunning: Bool
    let title: String

    public init(
        timerId: String,
        timeRemaining: TimeInterval,
        isRunning: Bool,
        title: String = "Timer"
    ) {
        self.timerId = timerId
        self.timeRemaining = timeRemaining
        self.isRunning = isRunning
        self.title = title
    }

    private func formatTime(_ interval: TimeInterval) -> String {
        WidgetFormat.playbackTime(interval)
    }

    public var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(formatTime(timeRemaining))
                .font(.system(size: 36, weight: .thin, design: .rounded))
                .monospacedDigit()

            HStack(spacing: 20) {
                Button(intent: RecordActionIntent(action: "timer.reset.\(timerId)")) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.title3)
                        .foregroundStyle(.orange)
                }
                .buttonStyle(.plain)

                Button(intent: RecordActionIntent(action: "timer.\(isRunning ? "pause" : "start").\(timerId)")) {
                    Image(systemName: isRunning ? "pause.circle.fill" : "play.circle.fill")
                        .font(.title)
                        .foregroundStyle(isRunning ? .yellow : .green)
                }
                .buttonStyle(.plain)

                Button(intent: RecordActionIntent(action: "timer.stop.\(timerId)")) {
                    Image(systemName: "stop.circle")
                        .font(.title3)
                        .foregroundStyle(.red)
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - Interactive Habit Tracker Widget

/// Habit tracker with interactive checkmarks
public struct InteractiveHabitWidget: View {
    public struct Habit: Identifiable {
        public let id: String
        public let name: String
        public let icon: String
        public let color: Color
        public var weekProgress: [Bool] // 7 days

        public init(id: String, name: String, icon: String, color: Color, weekProgress: [Bool]) {
            self.id = id
            self.name = name
            self.icon = icon
            self.color = color
            self.weekProgress = weekProgress
        }
    }

    let habits: [Habit]
    let todayIndex: Int

    public init(habits: [Habit], todayIndex: Int = 6) {
        self.habits = habits
        self.todayIndex = todayIndex
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Habits")
                    .font(.headline)
                Spacer()
                Text("Today")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ForEach(habits.prefix(3)) { habit in
                HStack(spacing: 8) {
                    Image(systemName: habit.icon)
                        .font(.caption)
                        .foregroundStyle(habit.color)
                        .frame(width: 20)

                    Text(habit.name)
                        .font(.caption)
                        .lineLimit(1)

                    Spacer()

                    // Week progress (non-interactive)
                    HStack(spacing: 2) {
                        ForEach(0..<6, id: \.self) { day in
                            Circle()
                                .fill(habit.weekProgress.indices.contains(day) && habit.weekProgress[day]
                                    ? habit.color
                                    : Color.secondary.opacity(0.3))
                                .frame(width: 6, height: 6)
                        }
                    }

                    // Today's checkbox (interactive)
                    Button(intent: ToggleIntent(
                        itemId: "\(habit.id)_\(todayIndex)",
                        newState: !(habit.weekProgress.indices.contains(todayIndex) && habit.weekProgress[todayIndex])
                    )) {
                        Image(systemName: habit.weekProgress.indices.contains(todayIndex) && habit.weekProgress[todayIndex]
                            ? "checkmark.circle.fill"
                            : "circle")
                            .font(.body)
                            .foregroundStyle(habit.weekProgress.indices.contains(todayIndex) && habit.weekProgress[todayIndex]
                                ? habit.color
                                : Color.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - Interactive Rating Widget

/// Star rating widget
public struct InteractiveRatingWidget: View {
    let ratingId: String
    let currentRating: Int
    let maxRating: Int
    let title: String
    let subtitle: String?

    public init(
        ratingId: String,
        currentRating: Int,
        maxRating: Int = 5,
        title: String,
        subtitle: String? = nil
    ) {
        self.ratingId = ratingId
        self.currentRating = currentRating
        self.maxRating = maxRating
        self.title = title
        self.subtitle = subtitle
    }

    public var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.headline)

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 8) {
                ForEach(1...max(maxRating, 1), id: \.self) { star in
                    Button(intent: SetValueIntent(key: ratingId, value: star)) {
                        Image(systemName: star <= currentRating ? "star.fill" : "star")
                            .font(.title2)
                            .foregroundStyle(star <= currentRating ? .yellow : .secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - Interactive Water Tracker Widget

/// Water intake tracker with increment buttons
public struct InteractiveWaterWidget: View {
    let trackerId: String
    let currentIntake: Double // in ml
    let dailyGoal: Double
    let glassSize: Double

    public init(
        trackerId: String,
        currentIntake: Double,
        dailyGoal: Double = 2000,
        glassSize: Double = 250
    ) {
        self.trackerId = trackerId
        self.currentIntake = currentIntake.isFinite ? max(currentIntake, 0) : 0
        self.dailyGoal = dailyGoal
        // The button converts the glass size to whole millilitres, so keep it finite.
        self.glassSize = glassSize.isFinite ? min(max(glassSize, 0), 10_000) : 0
    }

    var progress: Double {
        WidgetMath.fraction(currentIntake, of: dailyGoal)
    }

    public var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "drop.fill")
                    .foregroundStyle(.cyan)
                Text("Water")
                    .font(.headline)
                Spacer()
            }

            ZStack {
                Circle()
                    .stroke(Color.cyan.opacity(0.2), lineWidth: 8)

                Circle()
                    .trim(from: 0, to: WidgetMath.clampedFraction(progress))
                    .stroke(
                        LinearGradient(colors: [.cyan, .blue], startPoint: .topLeading, endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 2) {
                    Text("\(Int(currentIntake))")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("/ \(dailyGoal, format: .number.precision(.fractionLength(0)))ml")
                        .font(.system(size: 9))
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 70, height: 70)

            Button(intent: IncrementIntent(counterId: trackerId, amount: Int(glassSize))) {
                Label("+\(Int(glassSize))ml", systemImage: "plus.circle.fill")
                    .font(.caption)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.cyan)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}
