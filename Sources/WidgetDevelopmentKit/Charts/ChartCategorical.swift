import SwiftUI
import Charts

// MARK: - Widget Bar Chart

/// Compact bar chart for widgets
public struct WidgetBarChart: View {
    let data: [ChartDataPoint]
    let accentColor: Color
    let showLabels: Bool
    let showValues: Bool

    public init(
        data: [ChartDataPoint],
        accentColor: Color = .blue,
        showLabels: Bool = true,
        showValues: Bool = false
    ) {
        self.data = data
        self.accentColor = accentColor
        self.showLabels = showLabels
        self.showValues = showValues
    }

    public var body: some View {
        Chart(data) { point in
            BarMark(
                x: .value("Category", point.label),
                y: .value("Value", point.value)
            )
            .foregroundStyle(accentColor.gradient)
            .cornerRadius(4)

            if showValues {
                RuleMark(y: .value("Value", point.value))
                    .lineStyle(StrokeStyle(lineWidth: 0))
                    .annotation(position: .top) {
                        Text("\(Int(point.value))")
                            .font(.system(size: 8))
                            .foregroundStyle(.secondary)
                    }
            }
        }
        .chartXAxis(showLabels ? .automatic : .hidden)
        .chartYAxis(.hidden)
    }
}

// MARK: - Widget Pie Chart

/// Compact pie chart for widgets
public struct WidgetPieChart: View {
    let data: [ChartDataPoint]
    let colors: [Color]
    let showLabels: Bool
    let innerRadiusRatio: Double

    public init(
        data: [ChartDataPoint],
        colors: [Color]? = nil,
        showLabels: Bool = false,
        innerRadiusRatio: Double = 0
    ) {
        self.data = data
        let palette: [Color] = [.blue, .green, .orange, .red, .purple, .pink, .cyan, .yellow]
        self.colors = (colors?.isEmpty == false ? colors : nil) ?? palette
        self.showLabels = showLabels
        self.innerRadiusRatio = innerRadiusRatio
    }

    public var body: some View {
        Chart(data) { point in
            SectorMark(
                angle: .value("Value", point.value),
                innerRadius: .ratio(innerRadiusRatio),
                angularInset: 1
            )
            .foregroundStyle(by: .value("Category", point.label))
            .cornerRadius(4)
        }
        .chartLegend(showLabels ? .visible : .hidden)
        .chartForegroundStyleScale(domain: data.map(\.label), range: colors)
    }
}

// MARK: - Widget Progress Ring Chart

/// Circular progress chart
public struct WidgetProgressRing: View {
    let progress: Double
    let total: Double
    let colors: [Color]
    let lineWidth: CGFloat
    let showValue: Bool
    let valueFormat: String

    public init(
        progress: Double,
        total: Double = 1.0,
        colors: [Color] = [.blue],
        lineWidth: CGFloat = 12,
        showValue: Bool = true,
        valueFormat: String = "%.0f%%"
    ) {
        self.progress = progress
        self.total = total
        self.colors = colors.isEmpty ? [.blue] : colors
        self.lineWidth = lineWidth
        self.showValue = showValue
        self.valueFormat = valueFormat
    }

    private var normalizedProgress: Double {
        WidgetMath.fraction(progress, of: total)
    }

    private var baseColor: Color { colors[0] }

    private var gradient: AngularGradient {
        AngularGradient(
            colors: colors + [baseColor],
            center: .center,
            startAngle: .degrees(-90),
            endAngle: .degrees(270)
        )
    }

    public var body: some View {
        ZStack {
            Circle()
                .stroke(baseColor.opacity(0.2), lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: normalizedProgress)
                .stroke(
                    colors.count == 1 ? AnyShapeStyle(baseColor) : AnyShapeStyle(gradient),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            if showValue {
                Text(String(format: valueFormat, normalizedProgress * 100))
                    .font(.system(size: lineWidth * 1.5, weight: .bold, design: .rounded))
            }
        }
    }
}

// MARK: - Horizontal Bar Chart

/// Horizontal bar chart for comparisons
public struct WidgetHorizontalBarChart: View {
    let data: [ChartDataPoint]
    let accentColor: Color
    let showValues: Bool
    let maxValue: Double?

    public init(
        data: [ChartDataPoint],
        accentColor: Color = .blue,
        showValues: Bool = true,
        maxValue: Double? = nil
    ) {
        self.data = data
        self.accentColor = accentColor
        self.showValues = showValues
        self.maxValue = maxValue
    }

    private var normalizedMax: Double {
        maxValue ?? data.map(\.value).max() ?? 1
    }

    public var body: some View {
        VStack(spacing: 8) {
            ForEach(data) { point in
                HStack(spacing: 8) {
                    Text(point.label)
                        .font(.caption)
                        .frame(width: 60, alignment: .leading)
                        .lineLimit(1)

                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(accentColor.opacity(0.2))

                            RoundedRectangle(cornerRadius: 4)
                                .fill(accentColor.gradient)
                                .frame(width: geo.size.width * WidgetMath.fraction(point.value, of: normalizedMax))
                        }
                    }
                    .frame(height: 16)

                    if showValues {
                        Text("\(Int(point.value))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .frame(width: 30, alignment: .trailing)
                    }
                }
            }
        }
    }
}

// MARK: - Activity Chart

/// Contribution-style heat map (weeks as columns, days as rows).
public struct WidgetActivityChart: View {
    let activities: [[Double]]
    let color: Color
    let levels: Int
    let cellSize: CGFloat
    let spacing: CGFloat

    /// - Parameters:
    ///   - activities: One array per week, each holding the values for its days.
    ///   - color: Color of the most active cells; lower levels use lower opacity.
    ///   - levels: Number of discrete intensity steps, including the empty level.
    public init(
        activities: [[Double]],
        color: Color = .green,
        levels: Int = 5,
        cellSize: CGFloat = 10,
        spacing: CGFloat = 2
    ) {
        self.activities = activities
        self.color = color
        self.levels = max(levels, 2)
        self.cellSize = cellSize
        self.spacing = spacing
    }

    public var body: some View {
        let maximum = activities.flatMap { $0 }.max() ?? 0
        HStack(spacing: spacing) {
            ForEach(activities.indices, id: \.self) { weekIndex in
                VStack(spacing: spacing) {
                    ForEach(activities[weekIndex].indices, id: \.self) { dayIndex in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(cellColor(activities[weekIndex][dayIndex], maximum: maximum))
                            .frame(width: cellSize, height: cellSize)
                    }
                }
            }
        }
    }

    private func cellColor(_ value: Double, maximum: Double) -> Color {
        let level = WidgetMath.intensityLevel(value, maximum: maximum, levels: levels)
        guard level > 0 else { return Color.gray.opacity(0.2) }
        return color.opacity(Double(level) / Double(levels - 1))
    }
}
