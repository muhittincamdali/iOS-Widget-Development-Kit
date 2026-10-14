import AppIntents
import SwiftUI
import WidgetKit

// MARK: - Interactive Button Styles

public struct InteractiveWidgetButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let foregroundColor: Color
    let cornerRadius: CGFloat

    public init(
        backgroundColor: Color = .blue,
        foregroundColor: Color = .white,
        cornerRadius: CGFloat = 8
    ) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.cornerRadius = cornerRadius
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(backgroundColor.opacity(configuration.isPressed ? 0.8 : 1))
            .foregroundStyle(foregroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Interactive Toggle Widget

/// Interactive toggle widget template
public struct InteractiveToggleWidget: View {
    let title: String
    let itemId: String
    let isOn: Bool
    let onIcon: String
    let offIcon: String
    let onColor: Color
    let offColor: Color

    public init(
        title: String,
        itemId: String,
        isOn: Bool,
        onIcon: String = "checkmark.circle.fill",
        offIcon: String = "circle",
        onColor: Color = .green,
        offColor: Color = .gray
    ) {
        self.title = title
        self.itemId = itemId
        self.isOn = isOn
        self.onIcon = onIcon
        self.offIcon = offIcon
        self.onColor = onColor
        self.offColor = offColor
    }

    public var body: some View {
        Button(intent: ToggleIntent(itemId: itemId, newState: !isOn)) {
            HStack {
                Image(systemName: isOn ? onIcon : offIcon)
                    .font(.title2)
                    .foregroundStyle(isOn ? onColor : offColor)

                Text(title)
                    .font(.caption)
                    .lineLimit(1)

                Spacer()
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Interactive Counter Widget

/// Interactive counter widget template
public struct InteractiveCounterWidget: View {
    let title: String
    let counterId: String
    let currentValue: Int
    let accentColor: Color

    public init(
        title: String,
        counterId: String,
        currentValue: Int,
        accentColor: Color = .blue
    ) {
        self.title = title
        self.counterId = counterId
        self.currentValue = currentValue
        self.accentColor = accentColor
    }

    public var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text("\(currentValue)")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(accentColor)

            HStack(spacing: 16) {
                Button(intent: IncrementIntent(counterId: counterId, amount: -1)) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title)
                        .foregroundStyle(.red)
                }
                .buttonStyle(.plain)

                Button(intent: IncrementIntent(counterId: counterId, amount: 1)) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundStyle(.green)
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - Interactive Task List Widget

/// Interactive task list widget with completion toggles
public struct InteractiveTaskListWidget: View {
    public struct Task: Identifiable {
        public let id: String
        public let title: String
        public var isCompleted: Bool
        public let priority: Priority

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

        public init(id: String, title: String, isCompleted: Bool, priority: Priority = .medium) {
            self.id = id
            self.title = title
            self.isCompleted = isCompleted
            self.priority = priority
        }
    }

    let tasks: [Task]
    let listTitle: String

    public init(tasks: [Task], listTitle: String = "Tasks") {
        self.tasks = tasks
        self.listTitle = listTitle
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(listTitle)
                    .font(.headline)

                Spacer()

                let completed = tasks.filter { $0.isCompleted }.count
                Text("\(completed)/\(tasks.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ForEach(tasks.prefix(4)) { task in
                Button(intent: ToggleIntent(itemId: task.id, newState: !task.isCompleted)) {
                    HStack(spacing: 10) {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(task.isCompleted ? .green : task.priority.color)
                            .font(.body)

                        Text(task.title)
                            .font(.caption)
                            .strikethrough(task.isCompleted)
                            .foregroundStyle(task.isCompleted ? .secondary : .primary)
                            .lineLimit(1)

                        Spacer()
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}
