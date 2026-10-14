// Lock Screen (accessory family) widget views.
// Accessory widget families do not exist on macOS, so this file is iOS/watchOS only.

#if os(iOS) || os(watchOS)
import SwiftUI
import WidgetKit

// MARK: - Battery Widget (All Families)

/// Battery level widget supporting all Lock Screen families
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
        WidgetMath.batterySymbolName(level: level, isCharging: isCharging)
    }

    public var body: some View {
        switch family {
        case .accessoryCircular:
            Gauge(value: WidgetMath.clampedFraction(level), in: 0...1) {
                Image(systemName: batteryIcon)
            } currentValueLabel: {
                Text("\(WidgetMath.percent(level))")
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

                    Text(WidgetMath.percentString(level))
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
            Label(WidgetMath.percentString(level), systemImage: batteryIcon)

        default:
            EmptyView()
        }
    }
}

// MARK: - Timer Widget (All Families)

/// Countdown timer widget supporting all accessory families.
///
/// The system animates the timer text and progress between `startTime` and
/// `endTime`, so the widget does not need extra timeline entries to tick.
public struct LockScreenTimerWidget: View {
    let interval: ClosedRange<Date>
    let title: String?
    let family: WidgetFamily

    public init(
        startTime: Date,
        endTime: Date,
        title: String? = nil,
        family: WidgetFamily = .accessoryCircular
    ) {
        self.interval = WidgetMath.timerInterval(start: startTime, end: endTime)
        self.title = title
        self.family = family
    }

    private var endTime: Date { interval.upperBound }

    public var body: some View {
        switch family {
        case .accessoryCircular:
            ProgressView(timerInterval: interval) {
                Image(systemName: "timer")
            }
            .progressViewStyle(.circular)

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

                ProgressView(timerInterval: interval, countsDown: true) {
                    EmptyView()
                } currentValueLabel: {
                    EmptyView()
                }
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

// MARK: - Fitness Widget (All Families)

/// Fitness activity widget
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
                    .trim(from: 0, to: WidgetMath.clampedFraction(moveProgress))
                    .stroke(Color.red, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .rotationEffect(.degrees(-90))

                // Exercise ring (middle)
                Circle()
                    .stroke(Color.green.opacity(0.3), lineWidth: 4)
                    .padding(5)
                Circle()
                    .trim(from: 0, to: WidgetMath.clampedFraction(exerciseProgress))
                    .stroke(Color.green, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .padding(5)

                // Stand ring (inner)
                Circle()
                    .stroke(Color.cyan.opacity(0.3), lineWidth: 4)
                    .padding(10)
                Circle()
                    .trim(from: 0, to: WidgetMath.clampedFraction(standProgress))
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
            Label("\(WidgetMath.percentString(moveProgress)) · \(WidgetMath.percentString(exerciseProgress)) · \(WidgetMath.percentString(standProgress))", systemImage: "figure.walk")

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

                Gauge(value: WidgetMath.clampedFraction(progress), in: 0...1) {
                    EmptyView()
                }
                .gaugeStyle(.linearCapacity)
                .tint(color)

                Text(WidgetMath.percentString(progress))
                    .font(.system(size: 9))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - Countdown Widget (All Families)

/// Event countdown widget
public struct LockScreenCountdownWidget: View {
    let targetDate: Date
    let eventName: String
    let referenceDate: Date
    let family: WidgetFamily

    /// - Parameters:
    ///   - targetDate: The day being counted down to.
    ///   - eventName: Shown in the rectangular and inline families.
    ///   - referenceDate: The timeline entry date; pass `entry.date` from your provider.
    ///   - family: The accessory family to lay out for.
    public init(
        targetDate: Date,
        eventName: String,
        referenceDate: Date = Date(),
        family: WidgetFamily = .accessoryCircular
    ) {
        self.targetDate = targetDate
        self.eventName = eventName
        self.referenceDate = referenceDate
        self.family = family
    }

    private var daysRemaining: Int {
        WidgetMath.daysRemaining(until: targetDate, from: referenceDate)
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
                    Text(daysRemaining == 1 ? "day remaining" : "days remaining")
                        .font(.caption)
                }

                Text(targetDate, format: .dateTime.month().day().year())
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

        case .accessoryInline:
            Text("\(daysRemaining) \(daysRemaining == 1 ? "day" : "days") until \(eventName)")

        default:
            EmptyView()
        }
    }
}

// MARK: - Quick Action Widget

/// Quick action shortcut widget
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
#endif
