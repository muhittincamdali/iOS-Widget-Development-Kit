// LockScreenWidgets.swift
// iOS-Widget-Development-Kit
//
// iOS 16+ Lock Screen Widget Templates
// Created by Muhittin Camdali

import SwiftUI
import WidgetKit

// MARK: - Lock Screen Widget Families

/// Supported Lock Screen widget families
@available(iOS 16.0, *)
public enum LockScreenWidgetFamily: CaseIterable {
    case accessoryCircular
    case accessoryRectangular
    case accessoryInline
    
    public var widgetFamily: WidgetFamily {
        switch self {
        case .accessoryCircular:
            return .accessoryCircular
        case .accessoryRectangular:
            return .accessoryRectangular
        case .accessoryInline:
            return .accessoryInline
        }
    }
}

// MARK: - Lock Screen Widget Protocol

/// Protocol for Lock Screen widgets
@available(iOS 16.0, *)
public protocol LockScreenWidgetProtocol {
    associatedtype CircularView: View
    associatedtype RectangularView: View
    associatedtype InlineView: View
    
    @ViewBuilder func makeCircular() -> CircularView
    @ViewBuilder func makeRectangular() -> RectangularView
    @ViewBuilder func makeInline() -> InlineView
}

// MARK: - 1. Circular Progress Widget

/// Circular progress indicator widget
@available(iOS 16.0, *)
public struct CircularProgressWidget: View {
    let progress: Double
    let icon: String
    let title: String
    let accentColor: Color
    
    public init(
        progress: Double,
        icon: String = "star.fill",
        title: String = "",
        accentColor: Color = .blue
    ) {
        self.progress = progress
        self.icon = icon
        self.title = title
        self.accentColor = accentColor
    }
    
    public var body: some View {
        Gauge(value: progress, in: 0...1) {
            Image(systemName: icon)
        } currentValueLabel: {
            Text("\(Int(progress * 100))%")
                .font(.system(size: 12, weight: .semibold))
        }
        .gaugeStyle(.accessoryCircularCapacity)
        .tint(accentColor)
    }
}

// MARK: - 2. Circular Icon Widget

/// Simple icon display widget
@available(iOS 16.0, *)
public struct CircularIconWidget: View {
    let icon: String
    let value: String?
    let backgroundColor: Color
    
    public init(
        icon: String,
        value: String? = nil,
        backgroundColor: Color = .blue
    ) {
        self.icon = icon
        self.value = value
        self.backgroundColor = backgroundColor
    }
    
    public var body: some View {
        ZStack {
            AccessoryWidgetBackground()
            
            VStack(spacing: 2) {
                Image(systemName: icon)
                    .font(.title3)
                
                if let value = value {
                    Text(value)
                        .font(.system(size: 10, weight: .semibold))
                }
            }
        }
    }
}

// MARK: - 3. Circular Ring Widget

/// Activity ring style widget
@available(iOS 16.0, *)
public struct CircularRingWidget: View {
    let innerProgress: Double
    let outerProgress: Double
    let innerColor: Color
    let outerColor: Color
    let centerIcon: String
    
    public init(
        innerProgress: Double,
        outerProgress: Double,
        innerColor: Color = .cyan,
        outerColor: Color = .green,
        centerIcon: String = "figure.walk"
    ) {
        self.innerProgress = innerProgress
        self.outerProgress = outerProgress
        self.innerColor = innerColor
        self.outerColor = outerColor
        self.centerIcon = centerIcon
    }
    
    public var body: some View {
        ZStack {
            // Outer ring
            Circle()
                .stroke(outerColor.opacity(0.3), lineWidth: 4)
            Circle()
                .trim(from: 0, to: outerProgress)
                .stroke(outerColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
            // Inner ring
            Circle()
                .stroke(innerColor.opacity(0.3), lineWidth: 4)
                .padding(6)
            Circle()
                .trim(from: 0, to: innerProgress)
                .stroke(innerColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .padding(6)
            
            // Center icon
            Image(systemName: centerIcon)
                .font(.body)
        }
    }
}

// MARK: - 4. Rectangular Text Widget

/// Multi-line text widget
@available(iOS 16.0, *)
public struct RectangularTextWidget: View {
    let title: String
    let subtitle: String
    let detail: String?
    let icon: String
    
    public init(
        title: String,
        subtitle: String,
        detail: String? = nil,
        icon: String = "star"
    ) {
        self.title = title
        self.subtitle = subtitle
        self.detail = detail
        self.icon = icon
    }
    
    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .widgetAccentable()
                
                Text(subtitle)
                    .font(.caption)
                
                if let detail = detail {
                    Text(detail)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            Image(systemName: icon)
                .font(.title2)
                .widgetAccentable()
        }
    }
}

// MARK: - 5. Rectangular Stats Widget

/// Statistics display widget
@available(iOS 16.0, *)
public struct RectangularStatsWidget: View {
    let stats: [(String, String)]
    let title: String?
    
    public init(stats: [(String, String)], title: String? = nil) {
        self.stats = stats
        self.title = title
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let title = title {
                Text(title)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                ForEach(stats.prefix(3), id: \.0) { stat in
                    VStack(spacing: 2) {
                        Text(stat.1)
                            .font(.headline)
                            .widgetAccentable()
                        Text(stat.0)
                            .font(.system(size: 8))
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

// MARK: - 6. Rectangular Progress Widget

/// Progress bar widget
@available(iOS 16.0, *)
public struct RectangularProgressWidget: View {
    let title: String
    let progress: Double
    let currentValue: String
    let maxValue: String
    let icon: String
    
    public init(
        title: String,
        progress: Double,
        currentValue: String,
        maxValue: String,
        icon: String = "chart.bar.fill"
    ) {
        self.title = title
        self.progress = progress
        self.currentValue = currentValue
        self.maxValue = maxValue
        self.icon = icon
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: icon)
                    .widgetAccentable()
                
                Text(title)
                    .font(.caption)
                
                Spacer()
                
                Text("\(currentValue)/\(maxValue)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            
            ProgressView(value: progress, total: 1.0)
                .tint(.primary)
        }
    }
}

// MARK: - 7. Rectangular Calendar Widget

/// Upcoming events widget
@available(iOS 16.0, *)
public struct RectangularCalendarWidget: View {
    let events: [(String, Date)]
    
    public init(events: [(String, Date)]) {
        self.events = events
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(events.prefix(2), id: \.0) { event in
                HStack {
                    Circle()
                        .fill(Color.primary)
                        .frame(width: 6, height: 6)
                    
                    Text(event.0)
                        .font(.caption)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text(event.1, style: .time)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

// MARK: - 8. Rectangular Weather Widget

/// Weather conditions widget
@available(iOS 16.0, *)
public struct RectangularWeatherWidget: View {
    let temperature: Int
    let high: Int
    let low: Int
    let condition: String
    let location: String
    
    public init(
        temperature: Int,
        high: Int,
        low: Int,
        condition: String = "sun.max.fill",
        location: String
    ) {
        self.temperature = temperature
        self.high = high
        self.low = low
        self.condition = condition
        self.location = location
    }
    
    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(location)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                
                Text("\(temperature)°")
                    .font(.title)
                    .fontWeight(.medium)
                    .widgetAccentable()
                
                HStack(spacing: 4) {
                    Text("H:\(high)°")
                    Text("L:\(low)°")
                }
                .font(.caption2)
                .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: condition)
                .font(.largeTitle)
                .widgetAccentable()
        }
    }
}

// MARK: - 9. Inline Text Widget

/// Simple inline text widget
@available(iOS 16.0, *)
public struct InlineTextWidget: View {
    let icon: String?
    let text: String
    
    public init(icon: String? = nil, text: String) {
        self.icon = icon
        self.text = text
    }
    
    public var body: some View {
        if let icon = icon {
            Label(text, systemImage: icon)
        } else {
            Text(text)
        }
    }
}

// MARK: - 10. Inline Stats Widget

/// Inline statistics widget
@available(iOS 16.0, *)
public struct InlineStatsWidget: View {
    let label: String
    let value: String
    let icon: String
    
    public init(label: String, value: String, icon: String) {
        self.label = label
        self.value = value
        self.icon = icon
    }
    
    public var body: some View {
        Label {
            Text("\(label): \(value)")
        } icon: {
            Image(systemName: icon)
        }
    }
}

// MARK: - 11. Battery Widget (All Families)

/// Battery level widget supporting all Lock Screen families
@available(iOS 16.0, *)
public struct LockScreenBatteryWidget: View {
    let level: Double
    let isCharging: Bool
    let deviceName: String?
    let family: WidgetFamily
    
    public init(
        level: Double,
        isCharging: Bool = false,
        deviceName: String? = nil,
        family: WidgetFamily = .accessoryCircular
    ) {
        self.level = level
        self.isCharging = isCharging
        self.deviceName = deviceName
        self.family = family
    }
    
    private var batteryIcon: String {
        if isCharging { return "battery.100.bolt" }
        if level < 0.1 { return "battery.0" }
        if level < 0.25 { return "battery.25" }
        if level < 0.5 { return "battery.50" }
        if level < 0.75 { return "battery.75" }
        return "battery.100"
    }
    
    public var body: some View {
        switch family {
        case .accessoryCircular:
            Gauge(value: level, in: 0...1) {
                Image(systemName: batteryIcon)
            } currentValueLabel: {
                Text("\(Int(level * 100))")
                    .font(.system(size: 14, weight: .semibold))
            }
            .gaugeStyle(.accessoryCircularCapacity)
            .tint(level < 0.2 ? .red : (level < 0.5 ? .orange : .green))
            
        case .accessoryRectangular:
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    if let name = deviceName {
                        Text(name)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    
                    Text("\(Int(level * 100))%")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .widgetAccentable()
                    
                    if isCharging {
                        Label("Charging", systemImage: "bolt.fill")
                            .font(.caption2)
                            .foregroundStyle(.green)
                    }
                }
                
                Spacer()
                
                Image(systemName: batteryIcon)
                    .font(.title)
                    .widgetAccentable()
            }
            
        case .accessoryInline:
            Label("\(Int(level * 100))%\(isCharging ? " ⚡" : "")", systemImage: batteryIcon)
            
        default:
            EmptyView()
        }
    }
}

// MARK: - 12. Timer Widget (All Families)

/// Countdown timer widget supporting all families
@available(iOS 16.0, *)
public struct LockScreenTimerWidget: View {
    let endTime: Date
    let title: String?
    let family: WidgetFamily
    
    public init(
        endTime: Date,
        title: String? = nil,
        family: WidgetFamily = .accessoryCircular
    ) {
        self.endTime = endTime
        self.title = title
        self.family = family
    }
    
    private var progress: Double {
        // Calculate progress (assuming 1 hour max for visualization)
        let remaining = endTime.timeIntervalSince(Date())
        return max(0, min(1, remaining / 3600))
    }
    
    public var body: some View {
        switch family {
        case .accessoryCircular:
            ZStack {
                ProgressView(timerInterval: Date()...endTime) {
                    Image(systemName: "timer")
                }
                .progressViewStyle(.circular)
            }
            
        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 2) {
                if let title = title {
                    Text(title)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                Text(endTime, style: .timer)
                    .font(.title)
                    .fontWeight(.medium)
                    .monospacedDigit()
                    .widgetAccentable()
                
                ProgressView(value: progress)
                    .tint(.primary)
            }
            
        case .accessoryInline:
            Label {
                Text(endTime, style: .timer)
            } icon: {
                Image(systemName: "timer")
            }
            
        default:
            EmptyView()
        }
    }
}

// MARK: - 13. Fitness Widget (All Families)

/// Fitness activity widget
@available(iOS 16.0, *)
public struct LockScreenFitnessWidget: View {
    let moveProgress: Double
    let exerciseProgress: Double
    let standProgress: Double
    let family: WidgetFamily
    
    public init(
        moveProgress: Double,
        exerciseProgress: Double,
        standProgress: Double,
        family: WidgetFamily = .accessoryCircular
    ) {
        self.moveProgress = moveProgress
        self.exerciseProgress = exerciseProgress
        self.standProgress = standProgress
        self.family = family
    }
    
    public var body: some View {
        switch family {
        case .accessoryCircular:
            ZStack {
                // Move ring (outer)
                Circle()
                    .stroke(Color.red.opacity(0.3), lineWidth: 4)
                Circle()
                    .trim(from: 0, to: min(moveProgress, 1))
                    .stroke(Color.red, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                
                // Exercise ring (middle)
                Circle()
                    .stroke(Color.green.opacity(0.3), lineWidth: 4)
                    .padding(5)
                Circle()
                    .trim(from: 0, to: min(exerciseProgress, 1))
                    .stroke(Color.green, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .padding(5)
                
                // Stand ring (inner)
                Circle()
                    .stroke(Color.cyan.opacity(0.3), lineWidth: 4)
                    .padding(10)
                Circle()
                    .trim(from: 0, to: min(standProgress, 1))
                    .stroke(Color.cyan, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .padding(10)
            }
            
        case .accessoryRectangular:
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    FitnessRow(label: "Move", progress: moveProgress, color: .red)
                    FitnessRow(label: "Exercise", progress: exerciseProgress, color: .green)
                    FitnessRow(label: "Stand", progress: standProgress, color: .cyan)
                }
            }
            
        case .accessoryInline:
            Label("\(Int(moveProgress * 100))% · \(Int(exerciseProgress * 100))% · \(Int(standProgress * 100))%", systemImage: "figure.walk")
            
        default:
            EmptyView()
        }
    }
    
    struct FitnessRow: View {
        let label: String
        let progress: Double
        let color: Color
        
        var body: some View {
            HStack(spacing: 4) {
                Circle()
                    .fill(color)
                    .frame(width: 6, height: 6)
                
                Text(label)
                    .font(.system(size: 9))
                
                Gauge(value: progress, in: 0...1) {
                    EmptyView()
                }
                .gaugeStyle(.linearCapacity)
                .tint(color)
                
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 9))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - 14. Countdown Widget (All Families)

/// Event countdown widget
@available(iOS 16.0, *)
public struct LockScreenCountdownWidget: View {
    let targetDate: Date
    let eventName: String
    let family: WidgetFamily
    
    public init(
        targetDate: Date,
        eventName: String,
        family: WidgetFamily = .accessoryCircular
    ) {
        self.targetDate = targetDate
        self.eventName = eventName
        self.family = family
    }
    
    private var daysRemaining: Int {
        let interval = targetDate.timeIntervalSince(Date())
        return max(0, Int(interval / 86400))
    }
    
    public var body: some View {
        switch family {
        case .accessoryCircular:
            VStack(spacing: 2) {
                Text("\(daysRemaining)")
                    .font(.system(size: 24, weight: .bold))
                Text("DAYS")
                    .font(.system(size: 8, weight: .medium))
            }
            .background(AccessoryWidgetBackground())
            
        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 2) {
                Text(eventName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(daysRemaining)")
                        .font(.title)
                        .fontWeight(.bold)
                        .widgetAccentable()
                    Text("days remaining")
                        .font(.caption)
                }
                
                Text(targetDate, format: .dateTime.month().day().year())
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            
        case .accessoryInline:
            Text("\(daysRemaining) days until \(eventName)")
            
        default:
            EmptyView()
        }
    }
}

// MARK: - 15. Quick Action Widget

/// Quick action shortcut widget
@available(iOS 16.0, *)
public struct LockScreenQuickActionWidget: View {
    let icon: String
    let label: String
    let family: WidgetFamily
    
    public init(
        icon: String,
        label: String,
        family: WidgetFamily = .accessoryCircular
    ) {
        self.icon = icon
        self.label = label
        self.family = family
    }
    
    public var body: some View {
        switch family {
        case .accessoryCircular:
            ZStack {
                AccessoryWidgetBackground()
                
                Image(systemName: icon)
                    .font(.title2)
            }
            
        case .accessoryRectangular:
            HStack {
                Image(systemName: icon)
                    .font(.title)
                    .widgetAccentable()
                
                Text(label)
                    .font(.headline)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
        case .accessoryInline:
            Label(label, systemImage: icon)
            
        default:
            EmptyView()
        }
    }
}
