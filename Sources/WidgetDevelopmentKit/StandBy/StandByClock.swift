import SwiftUI
import WidgetKit

// MARK: - StandBy View Modifier

/// View modifier for StandBy mode optimizations
public struct StandByOptimizedModifier: ViewModifier {
    @Environment(\.showsWidgetContainerBackground) var showsBackground
    @Environment(\.widgetRenderingMode) var renderingMode

    let nightModeColor: Color

    public init(nightModeColor: Color = .red) {
        self.nightModeColor = nightModeColor
    }

    public func body(content: Content) -> some View {
        content
            .foregroundStyle(renderingMode == .fullColor ? .primary : nightModeColor)
            .containerBackground(for: .widget) {
                if showsBackground {
                    Color.clear
                }
            }
    }
}

extension View {
    public func standByOptimized(nightModeColor: Color = .red) -> some View {
        modifier(StandByOptimizedModifier(nightModeColor: nightModeColor))
    }
}

// MARK: - StandBy Clock Widget

/// Large clock widget optimized for StandBy mode
public struct StandByClockWidget: View {
    let date: Date
    let style: ClockStyle
    let showDate: Bool
    let accentColor: Color

    public enum ClockStyle {
        case digital
        case analog
        case flipClock
        case minimal
    }

    public init(
        date: Date = Date(),
        style: ClockStyle = .digital,
        showDate: Bool = true,
        accentColor: Color = .white
    ) {
        self.date = date
        self.style = style
        self.showDate = showDate
        self.accentColor = accentColor
    }

    public var body: some View {
        VStack(spacing: 16) {
            switch style {
            case .digital:
                DigitalClockView(date: date, accentColor: accentColor)
            case .analog:
                AnalogClockView(date: date, accentColor: accentColor)
            case .flipClock:
                FlipClockView(date: date, accentColor: accentColor)
            case .minimal:
                MinimalClockView(date: date, accentColor: accentColor)
            }

            if showDate {
                Text(date, format: .dateTime.weekday(.wide).month().day())
                    .font(.title3)
                    .foregroundStyle(accentColor.opacity(0.8))
            }
        }
        .containerBackground(.black.gradient, for: .widget)
    }

    struct DigitalClockView: View {
        let date: Date
        let accentColor: Color

        var body: some View {
            Text(date, format: .dateTime.hour().minute())
                .font(.system(size: 96, weight: .thin, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(accentColor)
        }
    }

    struct AnalogClockView: View {
        let date: Date
        let accentColor: Color

        var hourAngle: Double {
            let hour = Calendar.current.component(.hour, from: date) % 12
            let minute = Calendar.current.component(.minute, from: date)
            return Double(hour) * 30 + Double(minute) * 0.5
        }

        var minuteAngle: Double {
            let minute = Calendar.current.component(.minute, from: date)
            return Double(minute) * 6
        }

        var body: some View {
            GeometryReader { geo in
                let size = min(geo.size.width, geo.size.height)

                ZStack {
                    // Clock face
                    Circle()
                        .stroke(accentColor.opacity(0.3), lineWidth: 3)

                    // Hour markers
                    ForEach(0..<12) { hour in
                        Rectangle()
                            .fill(accentColor)
                            .frame(width: hour % 3 == 0 ? 3 : 1, height: hour % 3 == 0 ? 15 : 8)
                            .offset(y: -size/2 + 20)
                            .rotationEffect(.degrees(Double(hour) * 30))
                    }

                    // Hour hand
                    RoundedRectangle(cornerRadius: 3)
                        .fill(accentColor)
                        .frame(width: 6, height: size * 0.25)
                        .offset(y: -size * 0.125)
                        .rotationEffect(.degrees(hourAngle))

                    // Minute hand
                    RoundedRectangle(cornerRadius: 2)
                        .fill(accentColor)
                        .frame(width: 4, height: size * 0.35)
                        .offset(y: -size * 0.175)
                        .rotationEffect(.degrees(minuteAngle))

                    // Center dot
                    Circle()
                        .fill(accentColor)
                        .frame(width: 12, height: 12)
                }
                .frame(width: size, height: size)
                .position(x: geo.size.width / 2, y: geo.size.height / 2)
            }
            .aspectRatio(1, contentMode: .fit)
        }
    }

    struct FlipClockView: View {
        let date: Date
        let accentColor: Color

        var hour: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH"
            return formatter.string(from: date)
        }

        var minute: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "mm"
            return formatter.string(from: date)
        }

        var body: some View {
            HStack(spacing: 8) {
                FlipDigitView(digit: hour, accentColor: accentColor)

                VStack(spacing: 12) {
                    Circle()
                        .fill(accentColor)
                        .frame(width: 10, height: 10)
                    Circle()
                        .fill(accentColor)
                        .frame(width: 10, height: 10)
                }

                FlipDigitView(digit: minute, accentColor: accentColor)
            }
        }
    }

    struct FlipDigitView: View {
        let digit: String
        let accentColor: Color

        var body: some View {
            Text(digit)
                .font(.system(size: 80, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(accentColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(accentColor.opacity(0.15))
                )
        }
    }

    struct MinimalClockView: View {
        let date: Date
        let accentColor: Color

        var body: some View {
            Text(date, format: .dateTime.hour().minute())
                .font(.system(size: 120, weight: .ultraLight, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(accentColor)
        }
    }
}
