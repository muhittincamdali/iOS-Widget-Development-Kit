import SwiftUI
import WidgetKit

// MARK: - Calendar Widget

/// Calendar widget showing upcoming events
public struct CalendarWidget: View {
    public struct Event: Identifiable {
        public let id = UUID()
        public let title: String
        public let time: Date
        public let color: Color

        public init(title: String, time: Date, color: Color = .blue) {
            self.title = title
            self.time = time
            self.color = color
        }
    }

    let date: Date
    let events: [Event]

    public init(date: Date = Date(), events: [Event]) {
        self.date = date
        self.events = events
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text(date.formatted(.dateTime.weekday(.wide)))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(date.formatted(.dateTime.day().month()))
                        .font(.title2)
                        .fontWeight(.bold)
                }
                Spacer()
                Image(systemName: "calendar")
                    .font(.title2)
                    .foregroundStyle(.blue)
            }

            Divider()

            ForEach(events.prefix(3)) { event in
                HStack(spacing: 8) {
                    Circle()
                        .fill(event.color)
                        .frame(width: 8, height: 8)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(event.title)
                            .font(.caption)
                            .lineLimit(1)
                        Text(event.time, style: .time)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            if events.count > 3 {
                Text("+\(events.count - 3) more events")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - Countdown Widget

/// Countdown timer widget for events
public struct CountdownWidget: View {
    let title: String
    let targetDate: Date
    let referenceDate: Date
    let icon: String
    let accentColor: Color

    /// - Parameter referenceDate: The timeline entry date; pass `entry.date` from your provider.
    public init(
        title: String,
        targetDate: Date,
        referenceDate: Date = Date(),
        icon: String = "clock.fill",
        accentColor: Color = .orange
    ) {
        self.title = title
        self.targetDate = targetDate
        self.referenceDate = referenceDate
        self.icon = icon
        self.accentColor = accentColor
    }

    private var timeRemaining: CountdownComponents {
        CountdownComponents(from: referenceDate, to: targetDate)
    }

    public var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(accentColor)
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 16) {
                TimeUnitView(value: timeRemaining.days, unit: "DAYS", color: accentColor)
                TimeUnitView(value: timeRemaining.hours, unit: "HRS", color: accentColor)
                TimeUnitView(value: timeRemaining.minutes, unit: "MIN", color: accentColor)
            }

            Text(targetDate, style: .date)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }

    struct TimeUnitView: View {
        let value: Int
        let unit: String
        let color: Color

        var body: some View {
            VStack(spacing: 2) {
                Text("\(value)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(color)
                Text(unit)
                    .font(.system(size: 8, weight: .medium))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - Clock Widget

/// Analog/Digital clock widget
public struct ClockWidget: View {
    let date: Date
    let style: ClockStyle
    let showSeconds: Bool

    public enum ClockStyle {
        case analog
        case digital
        case minimal
    }

    public init(date: Date = Date(), style: ClockStyle = .digital, showSeconds: Bool = false) {
        self.date = date
        self.style = style
        self.showSeconds = showSeconds
    }

    public var body: some View {
        VStack {
            switch style {
            case .analog:
                AnalogClockView(date: date)
            case .digital:
                DigitalClockView(date: date, showSeconds: showSeconds)
            case .minimal:
                MinimalClockView(date: date)
            }
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }

    struct AnalogClockView: View {
        let date: Date

        var body: some View {
            GeometryReader { geo in
                let size = min(geo.size.width, geo.size.height) - 20

                ZStack {
                    Circle()
                        .stroke(Color.secondary.opacity(0.3), lineWidth: 2)

                    // Hour markers
                    ForEach(0..<12) { hour in
                        Rectangle()
                            .fill(Color.primary)
                            .frame(width: 2, height: hour % 3 == 0 ? 10 : 5)
                            .offset(y: -size/2 + 15)
                            .rotationEffect(.degrees(Double(hour) * 30))
                    }

                    // Hour hand
                    ClockHand(length: size * 0.25, width: 4)
                        .rotationEffect(.degrees(hourAngle))

                    // Minute hand
                    ClockHand(length: size * 0.35, width: 3)
                        .rotationEffect(.degrees(minuteAngle))

                    Circle()
                        .fill(Color.primary)
                        .frame(width: 8, height: 8)
                }
                .frame(width: size, height: size)
                .position(x: geo.size.width / 2, y: geo.size.height / 2)
            }
            .padding()
        }

        var hourAngle: Double {
            let hour = Calendar.current.component(.hour, from: date) % 12
            let minute = Calendar.current.component(.minute, from: date)
            return Double(hour) * 30 + Double(minute) * 0.5
        }

        var minuteAngle: Double {
            let minute = Calendar.current.component(.minute, from: date)
            return Double(minute) * 6
        }
    }

    struct ClockHand: View {
        let length: CGFloat
        let width: CGFloat

        var body: some View {
            RoundedRectangle(cornerRadius: width / 2)
                .fill(Color.primary)
                .frame(width: width, height: length)
                .offset(y: -length / 2)
        }
    }

    struct DigitalClockView: View {
        let date: Date
        let showSeconds: Bool

        var body: some View {
            VStack(spacing: 4) {
                Text(date, format: showSeconds ? .dateTime.hour().minute().second() : .dateTime.hour().minute())
                    .font(.system(size: 36, weight: .thin, design: .rounded))
                    .monospacedDigit()

                Text(date, format: .dateTime.weekday(.wide).month().day())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
    }

    struct MinimalClockView: View {
        let date: Date

        var body: some View {
            Text(date, format: .dateTime.hour().minute())
                .font(.system(size: 48, weight: .ultraLight, design: .rounded))
                .monospacedDigit()
                .padding()
        }
    }
}

// MARK: - Notes Widget

/// Quick notes widget with rich formatting
public struct NotesWidget: View {
    public struct Note: Identifiable {
        public let id = UUID()
        public let title: String
        public let preview: String
        public let date: Date
        public let color: Color

        public init(title: String, preview: String, date: Date = Date(), color: Color = .yellow) {
            self.title = title
            self.preview = preview
            self.date = date
            self.color = color
        }
    }

    let notes: [Note]

    public init(notes: [Note]) {
        self.notes = notes
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "note.text")
                    .foregroundStyle(.yellow)
                Text("Notes")
                    .font(.headline)
                Spacer()
                Text("\(notes.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ForEach(notes.prefix(3)) { note in
                HStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(note.color)
                        .frame(width: 3)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(note.title)
                            .font(.caption)
                            .fontWeight(.medium)
                            .lineLimit(1)

                        Text(note.preview)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }

                    Spacer()

                    Text(note.date, style: .relative)
                        .font(.system(size: 9))
                        .foregroundStyle(.tertiary)
                }
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}
