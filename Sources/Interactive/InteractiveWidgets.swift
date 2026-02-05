// InteractiveWidgets.swift
// iOS-Widget-Development-Kit
//
// iOS 17+ Interactive Widget support with App Intents
// Created by Muhittin Camdali

import SwiftUI
import WidgetKit
import AppIntents

// MARK: - Interactive Widget Protocol

/// Protocol for interactive widget configurations
@available(iOS 17.0, *)
public protocol InteractiveWidgetProtocol {
    associatedtype IntentType: AppIntent
    var supportedFamilies: [WidgetFamily] { get }
}

// MARK: - Base Intent Protocol

/// Base protocol for widget intents
@available(iOS 17.0, *)
public protocol WidgetIntentProtocol: AppIntent {
    static var intentIdentifier: String { get }
}

// MARK: - Toggle Intent

/// Generic toggle intent for widgets
@available(iOS 17.0, *)
public struct ToggleIntent: AppIntent {
    public static var title: LocalizedStringResource = "Toggle"
    public static var description = IntentDescription("Toggle a boolean value")
    
    @Parameter(title: "Item ID")
    public var itemId: String
    
    @Parameter(title: "New State")
    public var newState: Bool
    
    public init() {}
    
    public init(itemId: String, newState: Bool) {
        self.itemId = itemId
        self.newState = newState
    }
    
    public func perform() async throws -> some IntentResult {
        // Store the state change
        UserDefaults(suiteName: "group.widget.interactive")?.set(newState, forKey: "toggle_\(itemId)")
        
        // Reload widgets
        WidgetCenter.shared.reloadAllTimelines()
        
        return .result()
    }
}

// MARK: - Increment Intent

/// Intent to increment a counter
@available(iOS 17.0, *)
public struct IncrementIntent: AppIntent {
    public static var title: LocalizedStringResource = "Increment"
    public static var description = IntentDescription("Increment a counter value")
    
    @Parameter(title: "Counter ID")
    public var counterId: String
    
    @Parameter(title: "Amount")
    public var amount: Int
    
    public init() {}
    
    public init(counterId: String, amount: Int = 1) {
        self.counterId = counterId
        self.amount = amount
    }
    
    public func perform() async throws -> some IntentResult {
        let defaults = UserDefaults(suiteName: "group.widget.interactive")
        let currentValue = defaults?.integer(forKey: "counter_\(counterId)") ?? 0
        defaults?.set(currentValue + amount, forKey: "counter_\(counterId)")
        
        WidgetCenter.shared.reloadAllTimelines()
        
        return .result()
    }
}

// MARK: - Refresh Intent

/// Intent to manually refresh widget data
@available(iOS 17.0, *)
public struct RefreshWidgetIntent: AppIntent {
    public static var title: LocalizedStringResource = "Refresh Widget"
    public static var description = IntentDescription("Manually refresh widget data")
    
    @Parameter(title: "Widget ID")
    public var widgetId: String?
    
    public init() {}
    
    public init(widgetId: String? = nil) {
        self.widgetId = widgetId
    }
    
    public func perform() async throws -> some IntentResult {
        if let widgetId = widgetId {
            WidgetCenter.shared.reloadTimelines(ofKind: widgetId)
        } else {
            WidgetCenter.shared.reloadAllTimelines()
        }
        
        return .result()
    }
}

// MARK: - Action Intent

/// Generic action intent for custom actions
@available(iOS 17.0, *)
public struct ActionIntent: AppIntent {
    public static var title: LocalizedStringResource = "Perform Action"
    public static var description = IntentDescription("Perform a custom widget action")
    
    @Parameter(title: "Action Type")
    public var actionType: String
    
    @Parameter(title: "Parameters")
    public var parameters: String?
    
    public init() {}
    
    public init(actionType: String, parameters: String? = nil) {
        self.actionType = actionType
        self.parameters = parameters
    }
    
    public func perform() async throws -> some IntentResult {
        // Post notification for app to handle
        NotificationCenter.default.post(
            name: Notification.Name("WidgetAction"),
            object: nil,
            userInfo: ["actionType": actionType, "parameters": parameters as Any]
        )
        
        return .result()
    }
}

// MARK: - Interactive Button Styles

@available(iOS 17.0, *)
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
@available(iOS 17.0, *)
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
@available(iOS 17.0, *)
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
@available(iOS 17.0, *)
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

// MARK: - Interactive Quick Actions Widget

/// Quick action buttons widget
@available(iOS 17.0, *)
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
                    Button(intent: ActionIntent(actionType: action.id)) {
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
@available(iOS 17.0, *)
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
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
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
                Button(intent: ActionIntent(actionType: "timer_reset", parameters: timerId)) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.title3)
                        .foregroundStyle(.orange)
                }
                .buttonStyle(.plain)
                
                Button(intent: ActionIntent(actionType: isRunning ? "timer_pause" : "timer_start", parameters: timerId)) {
                    Image(systemName: isRunning ? "pause.circle.fill" : "play.circle.fill")
                        .font(.title)
                        .foregroundStyle(isRunning ? .yellow : .green)
                }
                .buttonStyle(.plain)
                
                Button(intent: ActionIntent(actionType: "timer_stop", parameters: timerId)) {
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
@available(iOS 17.0, *)
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
@available(iOS 17.0, *)
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
                ForEach(1...maxRating, id: \.self) { star in
                    Button(intent: ActionIntent(actionType: "rate", parameters: "\(ratingId):\(star)")) {
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
@available(iOS 17.0, *)
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
        self.currentIntake = currentIntake
        self.dailyGoal = dailyGoal
        self.glassSize = glassSize
    }
    
    var progress: Double {
        min(currentIntake / dailyGoal, 1.0)
    }
    
    var glasses: Int {
        Int(currentIntake / glassSize)
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
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("/ \(Int(dailyGoal))ml")
                        .font(.system(size: 9))
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 70, height: 70)
            
            Button(intent: ActionIntent(actionType: "add_water", parameters: "\(trackerId):\(Int(glassSize))")) {
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
