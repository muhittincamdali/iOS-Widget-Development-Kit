import SwiftUI
import WidgetKit

// MARK: - Fitness Widget

/// Fitness tracking widget with activity rings
public struct FitnessWidget: View {
    let calories: Double
    let caloriesGoal: Double
    let exercise: Double
    let exerciseGoal: Double
    let standing: Double
    let standingGoal: Double

    public init(
        calories: Double,
        caloriesGoal: Double = 500,
        exercise: Double,
        exerciseGoal: Double = 30,
        standing: Double,
        standingGoal: Double = 12
    ) {
        self.calories = calories
        self.caloriesGoal = caloriesGoal
        self.exercise = exercise
        self.exerciseGoal = exerciseGoal
        self.standing = standing
        self.standingGoal = standingGoal
    }

    public var body: some View {
        HStack {
            ZStack {
                ActivityRing(progress: WidgetMath.fraction(calories, of: caloriesGoal), color: .red, lineWidth: 12)
                    .frame(width: 80, height: 80)

                ActivityRing(progress: WidgetMath.fraction(exercise, of: exerciseGoal), color: .green, lineWidth: 10)
                    .frame(width: 60, height: 60)

                ActivityRing(progress: WidgetMath.fraction(standing, of: standingGoal), color: .cyan, lineWidth: 8)
                    .frame(width: 44, height: 44)
            }

            VStack(alignment: .leading, spacing: 8) {
                ActivityStat(label: "Move", value: "\(Int(calories))/\(Int(caloriesGoal))", unit: "CAL", color: .red)
                ActivityStat(label: "Exercise", value: "\(Int(exercise))/\(Int(exerciseGoal))", unit: "MIN", color: .green)
                ActivityStat(label: "Stand", value: "\(Int(standing))/\(Int(standingGoal))", unit: "HRS", color: .cyan)
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }

    struct ActivityRing: View {
        let progress: Double
        let color: Color
        let lineWidth: CGFloat

        var body: some View {
            Circle()
                .stroke(color.opacity(0.3), lineWidth: lineWidth)
                .overlay {
                    Circle()
                        .trim(from: 0, to: WidgetMath.clampedFraction(progress))
                        .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                }
        }
    }

    struct ActivityStat: View {
        let label: String
        let value: String
        let unit: String
        let color: Color

        var body: some View {
            HStack(spacing: 4) {
                Circle()
                    .fill(color)
                    .frame(width: 6, height: 6)

                Text(label)
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)

                Spacer()

                Text(value)
                    .font(.system(size: 10, weight: .semibold))

                Text(unit)
                    .font(.system(size: 8))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - Habit Tracker Widget

/// Habit tracking widget with streak display
public struct HabitTrackerWidget: View {
    public struct Habit: Identifiable {
        public let id = UUID()
        public let name: String
        public let icon: String
        public let color: Color
        public let completedDays: [Bool] // Last 7 days

        public init(name: String, icon: String, color: Color, completedDays: [Bool]) {
            self.name = name
            self.icon = icon
            self.color = color
            self.completedDays = completedDays
        }

        public var streak: Int {
            var count = 0
            for completed in completedDays.reversed() {
                if completed { count += 1 } else { break }
            }
            return count
        }
    }

    let habits: [Habit]

    public init(habits: [Habit]) {
        self.habits = habits
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Habits")
                    .font(.headline)
                Spacer()
                Text("7 Day Streak")
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

                    HStack(spacing: 2) {
                        ForEach(0..<7, id: \.self) { day in
                            Circle()
                                .fill(habit.completedDays.indices.contains(day) && habit.completedDays[day]
                                    ? habit.color
                                    : Color.secondary.opacity(0.3))
                                .frame(width: 8, height: 8)
                        }
                    }

                    Text("🔥\(habit.streak)")
                        .font(.system(size: 10))
                }
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - To-Do Widget

/// Task list widget
public struct TodoWidget: View {
    public struct Task: Identifiable {
        public let id = UUID()
        public let title: String
        public let isCompleted: Bool
        public let priority: Priority
        public let dueDate: Date?

        public enum Priority {
            case low, medium, high

            var color: Color {
                switch self {
                case .low: return .blue
                case .medium: return .orange
                case .high: return .red
                }
            }
        }

        public init(title: String, isCompleted: Bool = false, priority: Priority = .medium, dueDate: Date? = nil) {
            self.title = title
            self.isCompleted = isCompleted
            self.priority = priority
            self.dueDate = dueDate
        }
    }

    let tasks: [Task]
    let listName: String

    public init(tasks: [Task], listName: String = "Tasks") {
        self.tasks = tasks
        self.listName = listName
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(listName)
                    .font(.headline)
                Spacer()
                let completed = tasks.filter { $0.isCompleted }.count
                Text("\(completed)/\(tasks.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ForEach(tasks.prefix(4)) { task in
                HStack(spacing: 8) {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(task.isCompleted ? .green : task.priority.color)
                        .font(.body)

                    Text(task.title)
                        .font(.caption)
                        .strikethrough(task.isCompleted)
                        .foregroundStyle(task.isCompleted ? .secondary : .primary)
                        .lineLimit(1)

                    Spacer()

                    if let dueDate = task.dueDate {
                        Text(dueDate, style: .relative)
                            .font(.system(size: 9))
                            .foregroundStyle(.secondary)
                    }
                }
            }

            if tasks.count > 4 {
                Text("+\(tasks.count - 4) more tasks")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - Water Tracker Widget

/// Water intake tracking widget
public struct WaterTrackerWidget: View {
    let currentIntake: Double // in ml
    let dailyGoal: Double
    let glassSize: Double

    public init(currentIntake: Double, dailyGoal: Double = 2000, glassSize: Double = 250) {
        self.currentIntake = currentIntake
        self.dailyGoal = dailyGoal
        self.glassSize = glassSize
    }

    private static let maximumGlassIcons = 12

    var progress: Double {
        WidgetMath.fraction(currentIntake, of: dailyGoal)
    }

    /// Number of full glasses drunk so far.
    var glasses: Int {
        guard glassSize > 0, currentIntake.isFinite, currentIntake > 0 else { return 0 }
        return Int(currentIntake / glassSize)
    }

    /// Number of glasses needed to reach the daily goal, capped so the row fits.
    var glassGoal: Int {
        guard glassSize > 0, dailyGoal.isFinite, dailyGoal > 0 else { return 0 }
        return min(Int((dailyGoal / glassSize).rounded(.up)), Self.maximumGlassIcons)
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
                    .trim(from: 0, to: progress)
                    .stroke(
                        LinearGradient(colors: [.cyan, .blue], startPoint: .topLeading, endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 2) {
                    Text("\(Int(currentIntake))")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("/ \(Int(dailyGoal)) ml")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 80, height: 80)

            HStack {
                ForEach(0..<glassGoal, id: \.self) { index in
                    Image(systemName: index < glasses ? "drop.fill" : "drop")
                        .font(.system(size: 10))
                        .foregroundStyle(index < glasses ? .cyan : .secondary.opacity(0.3))
                }
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}
