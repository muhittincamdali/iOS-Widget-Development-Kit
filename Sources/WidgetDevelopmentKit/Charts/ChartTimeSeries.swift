import SwiftUI
import Charts

// MARK: - Chart Data Types

/// Generic data point for charts
public struct ChartDataPoint: Identifiable, Hashable, Sendable {
    public let id = UUID()
    public let label: String
    public let value: Double
    public let date: Date?
    public let category: String?

    public init(label: String, value: Double, date: Date? = nil, category: String? = nil) {
        self.label = label
        self.value = value
        self.date = date
        self.category = category
    }
}

/// Time series data point
public struct TimeSeriesDataPoint: Identifiable, Hashable, Sendable {
    public let id = UUID()
    public let date: Date
    public let value: Double
    public let series: String?

    public init(date: Date, value: Double, series: String? = nil) {
        self.date = date
        self.value = value
        self.series = series
    }
}

// MARK: - Widget Line Chart

/// Compact line chart for widgets
public struct WidgetLineChart: View {
    let data: [TimeSeriesDataPoint]
    let accentColor: Color
    let showArea: Bool
    let showPoints: Bool
    let showXAxis: Bool

    public init(
        data: [TimeSeriesDataPoint],
        accentColor: Color = .blue,
        showArea: Bool = true,
        showPoints: Bool = false,
        showXAxis: Bool = false
    ) {
        self.data = data
        self.accentColor = accentColor
        self.showArea = showArea
        self.showPoints = showPoints
        self.showXAxis = showXAxis
    }

    public var body: some View {
        Chart(data) { point in
            LineMark(
                x: .value("Date", point.date),
                y: .value("Value", point.value)
            )
            .foregroundStyle(accentColor)
            .interpolationMethod(.catmullRom)

            if showArea {
                AreaMark(
                    x: .value("Date", point.date),
                    y: .value("Value", point.value)
                )
                .foregroundStyle(accentColor.opacity(0.2).gradient)
                .interpolationMethod(.catmullRom)
            }

            if showPoints {
                PointMark(
                    x: .value("Date", point.date),
                    y: .value("Value", point.value)
                )
                .foregroundStyle(accentColor)
            }
        }
        .chartXAxis(showXAxis ? .automatic : .hidden)
        .chartYAxis(.hidden)
    }
}

// MARK: - Widget Sparkline

/// Minimal sparkline chart for widgets
public struct WidgetSparkline: View {
    let values: [Double]
    let color: Color
    let lineWidth: CGFloat
    let showGradient: Bool

    public init(
        values: [Double],
        color: Color = .blue,
        lineWidth: CGFloat = 2,
        showGradient: Bool = true
    ) {
        self.values = values
        self.color = color
        self.lineWidth = lineWidth
        self.showGradient = showGradient
    }

    public var body: some View {
        Chart(Array(values.enumerated()), id: \.offset) { index, value in
            LineMark(
                x: .value("Index", index),
                y: .value("Value", value)
            )
            .foregroundStyle(color)
            .lineStyle(StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            .interpolationMethod(.catmullRom)

            if showGradient {
                AreaMark(
                    x: .value("Index", index),
                    y: .value("Value", value)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [color.opacity(0.3), color.opacity(0)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)
            }
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
    }
}

// MARK: - Multi-Line Chart

/// Line chart with multiple series
public struct WidgetMultiLineChart: View {
    let series: [String: [TimeSeriesDataPoint]]
    let colors: [String: Color]
    let showLegend: Bool

    public init(
        series: [String: [TimeSeriesDataPoint]],
        colors: [String: Color],
        showLegend: Bool = true
    ) {
        self.series = series
        self.colors = colors
        self.showLegend = showLegend
    }

    private var seriesNames: [String] { series.keys.sorted() }

    private var allDataPoints: [TimeSeriesDataPoint] {
        seriesNames.flatMap { seriesName in
            (series[seriesName] ?? []).map { point in
                TimeSeriesDataPoint(date: point.date, value: point.value, series: seriesName)
            }
        }
    }

    public var body: some View {
        Chart(allDataPoints) { point in
            LineMark(
                x: .value("Date", point.date),
                y: .value("Value", point.value)
            )
            .foregroundStyle(by: .value("Series", point.series ?? ""))
            .interpolationMethod(.catmullRom)
        }
        .chartForegroundStyleScale(domain: seriesNames, range: seriesNames.map { colors[$0] ?? .gray })
        .chartLegend(showLegend ? .visible : .hidden)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
    }
}

// MARK: - Stats Chart Widget

/// Combined stats with chart
public struct WidgetStatsChart: View {
    let title: String
    let value: String
    let change: Double
    let sparklineData: [Double]
    let accentColor: Color

    public init(
        title: String,
        value: String,
        change: Double,
        sparklineData: [Double],
        accentColor: Color = .blue
    ) {
        self.title = title
        self.value = value
        self.change = change
        self.sparklineData = sparklineData
        self.accentColor = accentColor
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(alignment: .firstTextBaseline) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)

                HStack(spacing: 2) {
                    Image(systemName: change >= 0 ? "arrow.up.right" : "arrow.down.right")
                    Text(String(format: "%.1f%%", abs(change)))
                }
                .font(.caption)
                .foregroundStyle(change >= 0 ? .green : .red)
            }

            WidgetSparkline(values: sparklineData, color: accentColor)
                .frame(height: 40)
        }
    }
}
