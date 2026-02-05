// WidgetCharts.swift
// iOS-Widget-Development-Kit
//
// SwiftUI Charts Support for Widgets
// Created by Muhittin Camdali

import SwiftUI
import Charts

// MARK: - Chart Data Types

/// Generic data point for charts
public struct ChartDataPoint: Identifiable {
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
public struct TimeSeriesDataPoint: Identifiable {
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

// MARK: - Widget Bar Chart

/// Compact bar chart for widgets
@available(iOS 16.0, *)
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

// MARK: - Widget Line Chart

/// Compact line chart for widgets
@available(iOS 16.0, *)
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
@available(iOS 16.0, *)
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
    
    private var dataPoints: [TimeSeriesDataPoint] {
        values.enumerated().map { index, value in
            TimeSeriesDataPoint(
                date: Date().addingTimeInterval(Double(index) * 3600),
                value: value
            )
        }
    }
    
    public var body: some View {
        Chart(dataPoints) { point in
            LineMark(
                x: .value("Index", point.date),
                y: .value("Value", point.value)
            )
            .foregroundStyle(color)
            .lineStyle(StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            .interpolationMethod(.catmullRom)
            
            if showGradient {
                AreaMark(
                    x: .value("Index", point.date),
                    y: .value("Value", point.value)
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

// MARK: - Widget Pie Chart

/// Compact pie chart for widgets
@available(iOS 16.0, *)
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
        self.colors = colors ?? [.blue, .green, .orange, .red, .purple, .pink, .cyan, .yellow]
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
        .chartForegroundStyleScale(domain: data.map { $0.label }, range: colors)
    }
}

// MARK: - Widget Progress Ring Chart

/// Circular progress chart
@available(iOS 16.0, *)
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
        self.colors = colors
        self.lineWidth = lineWidth
        self.showValue = showValue
        self.valueFormat = valueFormat
    }
    
    private var normalizedProgress: Double {
        min(max(progress / total, 0), 1)
    }
    
    private var gradient: AngularGradient {
        AngularGradient(
            colors: colors + [colors.first!],
            center: .center,
            startAngle: .degrees(-90),
            endAngle: .degrees(270)
        )
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .stroke(colors.first!.opacity(0.2), lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0, to: normalizedProgress)
                .stroke(
                    colors.count == 1 ? AnyShapeStyle(colors.first!) : AnyShapeStyle(gradient),
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

// MARK: - Multi-Line Chart

/// Line chart with multiple series
@available(iOS 16.0, *)
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
    
    private var allDataPoints: [TimeSeriesDataPoint] {
        series.flatMap { seriesName, points in
            points.map { point in
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
        .chartForegroundStyleScale(domain: Array(colors.keys), range: Array(colors.values))
        .chartLegend(showLegend ? .visible : .hidden)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
    }
}

// MARK: - Stats Chart Widget

/// Combined stats with chart
@available(iOS 16.0, *)
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

// MARK: - Horizontal Bar Chart

/// Horizontal bar chart for comparisons
@available(iOS 16.0, *)
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
        maxValue ?? (data.map { $0.value }.max() ?? 1)
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
                                .frame(width: geo.size.width * (point.value / normalizedMax))
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

/// Activity/contribution chart (like GitHub)
@available(iOS 16.0, *)
public struct WidgetActivityChart: View {
    let activities: [[Double]] // Weeks x Days
    let colorRange: [Color]
    let cellSize: CGFloat
    let spacing: CGFloat
    
    public init(
        activities: [[Double]],
        colorRange: [Color] = [Color.gray.opacity(0.2), .green],
        cellSize: CGFloat = 10,
        spacing: CGFloat = 2
    ) {
        self.activities = activities
        self.colorRange = colorRange
        self.cellSize = cellSize
        self.spacing = spacing
    }
    
    private func colorForValue(_ value: Double) -> Color {
        if value <= 0 { return colorRange.first! }
        let maxValue = activities.flatMap { $0 }.max() ?? 1
        let normalized = min(value / maxValue, 1)
        
        // Interpolate between colors
        let index = normalized * Double(colorRange.count - 1)
        let lowerIndex = Int(index)
        let upperIndex = min(lowerIndex + 1, colorRange.count - 1)
        let fraction = index - Double(lowerIndex)
        
        // Simple color interpolation
        return colorRange[upperIndex].opacity(0.3 + normalized * 0.7)
    }
    
    public var body: some View {
        HStack(spacing: spacing) {
            ForEach(activities.indices, id: \.self) { weekIndex in
                VStack(spacing: spacing) {
                    ForEach(activities[weekIndex].indices, id: \.self) { dayIndex in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(colorForValue(activities[weekIndex][dayIndex]))
                            .frame(width: cellSize, height: cellSize)
                    }
                }
            }
        }
    }
}
