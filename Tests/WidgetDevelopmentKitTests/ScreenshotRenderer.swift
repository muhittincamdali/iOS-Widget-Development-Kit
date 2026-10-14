#if os(iOS)
import Foundation
import SwiftUI
import Testing
import UIKit
import WidgetKit
@testable import WidgetDevelopmentKit

/// Renders the README screenshots with `ImageRenderer`.
///
/// Disabled unless `WDK_SCREENSHOT_DIR` is set; run `scripts/render-screenshots.sh`.
/// The views are rendered outside WidgetKit, so the system widget chrome
/// (container background, Lock Screen vibrancy, StandBy night mode) is
/// approximated by the frames drawn here.
@MainActor
@Suite("README screenshots", .enabled(if: ProcessInfo.processInfo.environment["WDK_SCREENSHOT_DIR"] != nil))
struct ScreenshotRenderer {
    private static let reference = TestCalendar.date(2026, 10, 14, 9, 41)
    private let outputDirectory = URL(
        fileURLWithPath: ProcessInfo.processInfo.environment["WDK_SCREENSHOT_DIR"] ?? NSTemporaryDirectory()
    )

    @Test(arguments: [ColorScheme.light, .dark])
    func homeScreenTemplates(scheme: ColorScheme) throws {
        try render(name: "home-screen", scheme: scheme) {
            Gallery(scheme: scheme) {
                HStack(spacing: 16) {
                    SystemWidget(.small, scheme) {
                        WeatherWidget(temperature: 21, condition: .partlyCloudy, location: "Istanbul", high: 24, low: 15)
                    }
                    SystemWidget(.small, scheme) {
                        WaterTrackerWidget(currentIntake: 1_250)
                    }
                }
                SystemWidget(.medium, scheme) {
                    FitnessWidget(calories: 420, exercise: 24, standing: 9)
                }
                HStack(spacing: 16) {
                    SystemWidget(.small, scheme) {
                        CountdownWidget(
                            title: "Launch",
                            targetDate: Self.reference.addingTimeInterval(3 * 86_400 + 5 * 3_600 + 12 * 60),
                            referenceDate: Self.reference
                        )
                    }
                    SystemWidget(.small, scheme) {
                        QuoteWidget(quote: "Simplicity is prerequisite for reliability.", author: "Edsger W. Dijkstra")
                    }
                }
                SystemWidget(.medium, scheme) {
                    HabitTrackerWidget(habits: [
                        .init(name: "Read", icon: "book.fill", color: .orange,
                              completedDays: [true, true, false, true, true, true, true]),
                        .init(name: "Run", icon: "figure.run", color: .green,
                              completedDays: [false, true, true, false, true, false, true]),
                        .init(name: "Meditate", icon: "brain.head.profile", color: .purple,
                              completedDays: [true, true, true, true, false, true, false])
                    ])
                }
            }
        }
    }

    @Test(arguments: [ColorScheme.light, .dark])
    func charts(scheme: ColorScheme) throws {
        let start = Self.reference
        let series = [12.0, 18, 15, 22, 19, 27, 24, 31, 29, 35]
        try render(name: "charts", scheme: scheme) {
            Gallery(scheme: scheme) {
                HStack(spacing: 16) {
                    SystemWidget(.small, scheme) {
                        WidgetStatsChart(title: "Revenue", value: "$12.4K", change: 8.3, sparklineData: series, accentColor: .green)
                            .padding()
                    }
                    SystemWidget(.small, scheme) {
                        WidgetProgressRing(progress: 0.68, colors: [.blue, .purple])
                            .padding(24)
                    }
                }
                SystemWidget(.medium, scheme) {
                    WidgetLineChart(
                        data: series.enumerated().map {
                            TimeSeriesDataPoint(date: start.addingTimeInterval(Double($0.offset) * 3_600), value: $0.element)
                        },
                        accentColor: .orange
                    )
                    .padding()
                }
                SystemWidget(.medium, scheme) {
                    WidgetBarChart(
                        data: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"].enumerated().map {
                            ChartDataPoint(label: $0.element, value: [6, 9, 4, 11, 8, 3, 7][$0.offset])
                        },
                        accentColor: .indigo
                    )
                    .padding()
                }
            }
        }
    }

    @Test(arguments: [ColorScheme.light, .dark])
    func lockScreen(scheme: ColorScheme) throws {
        try render(name: "lock-screen", scheme: scheme) {
            Gallery(scheme: scheme, background: scheme == .dark ? Color(white: 0.08) : Color(white: 0.35)) {
                HStack(spacing: 20) {
                    AccessoryWidget(.circular) {
                        LockScreenBatteryWidget(level: 0.72, family: .accessoryCircular)
                    }
                    AccessoryWidget(.circular) {
                        LockScreenFitnessWidget(moveProgress: 0.8, exerciseProgress: 0.55, standProgress: 0.9)
                    }
                    AccessoryWidget(.circular) {
                        LockScreenCountdownWidget(
                            targetDate: Self.reference.addingTimeInterval(12 * 86_400),
                            eventName: "Trip",
                            referenceDate: Self.reference
                        )
                    }
                }
                AccessoryWidget(.rectangular) {
                    RectangularWeatherWidget(temperature: 21, high: 24, low: 15, condition: "cloud.sun.fill", location: "Istanbul")
                }
                AccessoryWidget(.rectangular) {
                    // Linear gauges and progress views render as placeholders in ImageRenderer,
                    // so the README shows a text-only rectangular widget here.
                    RectangularStatsWidget(stats: [("Steps", "8.2K"), ("km", "6.1"), ("kcal", "420")], title: "Today")
                }
            }
        }
    }

    // MARK: - Rendering

    private func render<Content: View>(name: String, scheme: ColorScheme, @ViewBuilder content: () -> Content) throws {
        let view = content()
            .environment(\.colorScheme, scheme)
            .environment(\.locale, Locale(identifier: "en_US"))
            .environment(\.timeZone, TimeZone(identifier: "UTC")!)
        let renderer = ImageRenderer(content: view)
        renderer.scale = 2
        let image = try #require(renderer.uiImage)
        let data = try #require(image.pngData())
        try FileManager.default.createDirectory(at: outputDirectory, withIntermediateDirectories: true)
        let suffix = scheme == .dark ? "dark" : "light"
        try data.write(to: outputDirectory.appendingPathComponent("\(name)-\(suffix).png"))
    }
}

/// Lays out a column of widgets on a plain background.
private struct Gallery<Content: View>: View {
    let scheme: ColorScheme
    var background: Color?
    @ViewBuilder let content: Content

    var body: some View {
        VStack(spacing: 16) { content }
            .padding(24)
            .background(background ?? (scheme == .dark ? Color.black : Color(white: 0.93)))
    }
}

/// Approximates a Home Screen widget: fixed size, rounded corners, system background.
private struct SystemWidget<Content: View>: View {
    enum Size {
        case small, medium
        var frame: CGSize {
            switch self {
            case .small: CGSize(width: 170, height: 170)
            case .medium: CGSize(width: 356, height: 170)
            }
        }
    }

    let size: Size
    let scheme: ColorScheme
    let content: Content

    init(_ size: Size, _ scheme: ColorScheme, @ViewBuilder content: () -> Content) {
        self.size = size
        self.scheme = scheme
        self.content = content()
    }

    var body: some View {
        content
            .frame(width: size.frame.width, height: size.frame.height)
            .background(scheme == .dark ? Color(white: 0.11) : .white)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}

/// Approximates a Lock Screen accessory widget: white content on a translucent backing.
private struct AccessoryWidget<Content: View>: View {
    enum Shape {
        case circular, rectangular
        var frame: CGSize {
            switch self {
            case .circular: CGSize(width: 72, height: 72)
            case .rectangular: CGSize(width: 172, height: 76)
            }
        }
    }

    let shape: Shape
    let content: Content

    init(_ shape: Shape, @ViewBuilder content: () -> Content) {
        self.shape = shape
        self.content = content()
    }

    var body: some View {
        content
            .foregroundStyle(.white)
            .tint(.white)
            .padding(shape == .rectangular ? 8 : 0)
            .frame(width: shape.frame.width, height: shape.frame.height)
            .background(.white.opacity(0.15), in: RoundedRectangle(cornerRadius: shape == .circular ? 36 : 12))
            .environment(\.colorScheme, .dark)
    }
}
#endif
