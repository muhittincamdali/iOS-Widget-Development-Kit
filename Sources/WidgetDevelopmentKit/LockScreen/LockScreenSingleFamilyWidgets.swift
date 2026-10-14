// Lock Screen (accessory family) widget views.
// Accessory widget families do not exist on macOS, so this file is iOS/watchOS only.

#if os(iOS) || os(watchOS)
import SwiftUI
import WidgetKit

// MARK: - Lock Screen Widget Families

/// Supported Lock Screen widget families
public enum LockScreenWidgetFamily: CaseIterable, Sendable {
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

// MARK: - Circular Progress Widget

/// Circular progress indicator widget
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
        Gauge(value: WidgetMath.clampedFraction(progress), in: 0...1) {
            Image(systemName: icon)
        } currentValueLabel: {
            Text(WidgetMath.percentString(progress))
                .font(.system(size: 12, weight: .semibold))
        }
        .gaugeStyle(.accessoryCircularCapacity)
        .tint(accentColor)
    }
}

// MARK: - Circular Icon Widget

/// Simple icon display widget
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

// MARK: - Circular Ring Widget

/// Activity ring style widget
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
                .trim(from: 0, to: WidgetMath.clampedFraction(outerProgress))
                .stroke(outerColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))

            // Inner ring
            Circle()
                .stroke(innerColor.opacity(0.3), lineWidth: 4)
                .padding(6)
            Circle()
                .trim(from: 0, to: WidgetMath.clampedFraction(innerProgress))
                .stroke(innerColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .padding(6)

            // Center icon
            Image(systemName: centerIcon)
                .font(.body)
        }
    }
}

// MARK: - Rectangular Text Widget

/// Multi-line text widget
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

// MARK: - Rectangular Stats Widget

/// Statistics display widget
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
                ForEach(Array(stats.prefix(3).enumerated()), id: \.offset) { _, stat in
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

// MARK: - Rectangular Progress Widget

/// Progress bar widget
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

            Gauge(value: WidgetMath.clampedFraction(progress)) {
                EmptyView()
            }
            .gaugeStyle(.accessoryLinearCapacity)
        }
    }
}

// MARK: - Rectangular Calendar Widget

/// Upcoming events widget
public struct RectangularCalendarWidget: View {
    let events: [(String, Date)]

    public init(events: [(String, Date)]) {
        self.events = events
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(Array(events.prefix(2).enumerated()), id: \.offset) { _, event in
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

// MARK: - Rectangular Weather Widget

/// Weather conditions widget
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

// MARK: - Inline Text Widget

/// Simple inline text widget
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

// MARK: - Inline Stats Widget

/// Inline statistics widget
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
#endif
