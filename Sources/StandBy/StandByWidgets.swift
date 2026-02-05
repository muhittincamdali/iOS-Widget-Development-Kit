// StandByWidgets.swift
// iOS-Widget-Development-Kit
//
// iOS 17+ StandBy Mode Widget Support
// Created by Muhittin Camdali

import SwiftUI
import WidgetKit

// MARK: - StandBy Mode Configuration

/// Configuration for StandBy mode widgets
@available(iOS 17.0, *)
public struct StandByConfiguration {
    public let supportsStandBy: Bool
    public let fullColorMode: Bool
    public let nightModeColor: Color
    public let alwaysOnDisplay: Bool
    
    public init(
        supportsStandBy: Bool = true,
        fullColorMode: Bool = true,
        nightModeColor: Color = .red,
        alwaysOnDisplay: Bool = true
    ) {
        self.supportsStandBy = supportsStandBy
        self.fullColorMode = fullColorMode
        self.nightModeColor = nightModeColor
        self.alwaysOnDisplay = alwaysOnDisplay
    }
}

// MARK: - StandBy View Modifier

/// View modifier for StandBy mode optimizations
@available(iOS 17.0, *)
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

@available(iOS 17.0, *)
extension View {
    public func standByOptimized(nightModeColor: Color = .red) -> some View {
        modifier(StandByOptimizedModifier(nightModeColor: nightModeColor))
    }
}

// MARK: - StandBy Clock Widget

/// Large clock widget optimized for StandBy mode
@available(iOS 17.0, *)
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

// MARK: - StandBy Photo Widget

/// Photo display widget for StandBy mode
@available(iOS 17.0, *)
public struct StandByPhotoWidget: View {
    let caption: String?
    let date: Date?
    let style: PhotoStyle
    
    public enum PhotoStyle {
        case full
        case polaroid
        case rounded
        case minimal
    }
    
    public init(
        caption: String? = nil,
        date: Date? = nil,
        style: PhotoStyle = .full
    ) {
        self.caption = caption
        self.date = date
        self.style = style
    }
    
    public var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                // Photo placeholder
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.gray.opacity(0.3), .gray.opacity(0.5)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay {
                        Image(systemName: "photo.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    .frame(maxHeight: style == .polaroid ? geo.size.height * 0.8 : .infinity)
                
                if style == .polaroid {
                    VStack(spacing: 4) {
                        if let caption = caption {
                            Text(caption)
                                .font(.caption)
                                .foregroundStyle(.black)
                        }
                        if let date = date {
                            Text(date, format: .dateTime.month().day().year())
                                .font(.caption2)
                                .foregroundStyle(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(.white)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: style == .rounded ? 20 : (style == .minimal ? 0 : 8)))
            .shadow(radius: style == .polaroid ? 10 : 0)
        }
        .containerBackground(.black, for: .widget)
    }
}

// MARK: - StandBy Weather Widget

/// Weather widget optimized for StandBy mode
@available(iOS 17.0, *)
public struct StandByWeatherWidget: View {
    let temperature: Int
    let condition: WeatherCondition
    let location: String
    let high: Int
    let low: Int
    let hourlyForecast: [HourlyForecast]
    
    public enum WeatherCondition: String {
        case sunny = "sun.max.fill"
        case cloudy = "cloud.fill"
        case rainy = "cloud.rain.fill"
        case stormy = "cloud.bolt.rain.fill"
        case snowy = "cloud.snow.fill"
        case partlyCloudy = "cloud.sun.fill"
        
        var color: Color {
            switch self {
            case .sunny: return .yellow
            case .cloudy: return .gray
            case .rainy: return .blue
            case .stormy: return .purple
            case .snowy: return .cyan
            case .partlyCloudy: return .orange
            }
        }
    }
    
    public struct HourlyForecast: Identifiable {
        public let id = UUID()
        public let hour: String
        public let temp: Int
        public let condition: WeatherCondition
        
        public init(hour: String, temp: Int, condition: WeatherCondition) {
            self.hour = hour
            self.temp = temp
            self.condition = condition
        }
    }
    
    public init(
        temperature: Int,
        condition: WeatherCondition,
        location: String,
        high: Int,
        low: Int,
        hourlyForecast: [HourlyForecast] = []
    ) {
        self.temperature = temperature
        self.condition = condition
        self.location = location
        self.high = high
        self.low = low
        self.hourlyForecast = hourlyForecast
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            // Location
            Text(location)
                .font(.title3)
                .foregroundStyle(.white.opacity(0.8))
            
            // Main temperature
            HStack(alignment: .top, spacing: 16) {
                Image(systemName: condition.rawValue)
                    .font(.system(size: 64))
                    .foregroundStyle(condition.color)
                
                VStack(alignment: .leading) {
                    Text("\(temperature)°")
                        .font(.system(size: 72, weight: .thin))
                        .foregroundStyle(.white)
                    
                    HStack {
                        Text("H:\(high)°")
                        Text("L:\(low)°")
                    }
                    .font(.title3)
                    .foregroundStyle(.white.opacity(0.7))
                }
            }
            
            // Hourly forecast
            if !hourlyForecast.isEmpty {
                HStack(spacing: 16) {
                    ForEach(hourlyForecast.prefix(5)) { forecast in
                        VStack(spacing: 8) {
                            Text(forecast.hour)
                                .font(.caption)
                            Image(systemName: forecast.condition.rawValue)
                                .font(.title3)
                                .foregroundStyle(forecast.condition.color)
                            Text("\(forecast.temp)°")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .foregroundStyle(.white.opacity(0.8))
                    }
                }
            }
        }
        .padding()
        .containerBackground(.black.gradient, for: .widget)
    }
}

// MARK: - StandBy Calendar Widget

/// Calendar widget for StandBy mode
@available(iOS 17.0, *)
public struct StandByCalendarWidget: View {
    let date: Date
    let events: [CalendarEvent]
    let accentColor: Color
    
    public struct CalendarEvent: Identifiable {
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
    
    public init(
        date: Date = Date(),
        events: [CalendarEvent] = [],
        accentColor: Color = .blue
    ) {
        self.date = date
        self.events = events
        self.accentColor = accentColor
    }
    
    private var calendar: Calendar { Calendar.current }
    
    private var monthDays: [[Int?]] {
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        
        var days: [[Int?]] = []
        var week: [Int?] = []
        
        // Leading empty days
        for _ in 1..<firstWeekday {
            week.append(nil)
        }
        
        // Days of month
        for day in range {
            week.append(day)
            if week.count == 7 {
                days.append(week)
                week = []
            }
        }
        
        // Trailing empty days
        if !week.isEmpty {
            while week.count < 7 {
                week.append(nil)
            }
            days.append(week)
        }
        
        return days
    }
    
    private var currentDay: Int {
        calendar.component(.day, from: date)
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            // Month header
            Text(date, format: .dateTime.month(.wide).year())
                .font(.title2)
                .fontWeight(.medium)
                .foregroundStyle(.white)
            
            // Weekday headers
            HStack {
                ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.5))
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Calendar grid
            VStack(spacing: 8) {
                ForEach(monthDays.indices, id: \.self) { weekIndex in
                    HStack {
                        ForEach(0..<7, id: \.self) { dayIndex in
                            if let day = monthDays[weekIndex][dayIndex] {
                                Text("\(day)")
                                    .font(.caption)
                                    .fontWeight(day == currentDay ? .bold : .regular)
                                    .foregroundStyle(day == currentDay ? .white : .white.opacity(0.8))
                                    .frame(maxWidth: .infinity)
                                    .padding(4)
                                    .background(
                                        day == currentDay ?
                                        Circle().fill(accentColor) :
                                        Circle().fill(Color.clear)
                                    )
                            } else {
                                Text("")
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
            }
            
            // Upcoming events
            if !events.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(events.prefix(2)) { event in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(event.color)
                                .frame(width: 6, height: 6)
                            
                            Text(event.title)
                                .font(.caption)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Text(event.time, format: .dateTime.hour().minute())
                                .font(.caption2)
                                .foregroundStyle(.white.opacity(0.6))
                        }
                        .foregroundStyle(.white)
                    }
                }
            }
        }
        .padding()
        .containerBackground(.black.gradient, for: .widget)
    }
}

// MARK: - StandBy Fitness Widget

/// Fitness activity rings for StandBy mode
@available(iOS 17.0, *)
public struct StandByFitnessWidget: View {
    let calories: Double
    let caloriesGoal: Double
    let exercise: Double
    let exerciseGoal: Double
    let standing: Double
    let standingGoal: Double
    
    public init(
        calories: Double,
        caloriesGoal: Double = 500,
        exercise: Double,
        exerciseGoal: Double = 30,
        standing: Double,
        standingGoal: Double = 12
    ) {
        self.calories = calories
        self.caloriesGoal = caloriesGoal
        self.exercise = exercise
        self.exerciseGoal = exerciseGoal
        self.standing = standing
        self.standingGoal = standingGoal
    }
    
    public var body: some View {
        HStack(spacing: 40) {
            // Activity rings
            ZStack {
                ActivityRing(progress: calories / caloriesGoal, color: .red, lineWidth: 16)
                    .frame(width: 140, height: 140)
                
                ActivityRing(progress: exercise / exerciseGoal, color: .green, lineWidth: 14)
                    .frame(width: 108, height: 108)
                
                ActivityRing(progress: standing / standingGoal, color: .cyan, lineWidth: 12)
                    .frame(width: 80, height: 80)
            }
            
            // Stats
            VStack(alignment: .leading, spacing: 20) {
                StatRow(label: "Move", value: "\(Int(calories))", unit: "CAL", color: .red, progress: calories / caloriesGoal)
                StatRow(label: "Exercise", value: "\(Int(exercise))", unit: "MIN", color: .green, progress: exercise / exerciseGoal)
                StatRow(label: "Stand", value: "\(Int(standing))", unit: "HRS", color: .cyan, progress: standing / standingGoal)
            }
        }
        .padding()
        .containerBackground(.black.gradient, for: .widget)
    }
    
    struct ActivityRing: View {
        let progress: Double
        let color: Color
        let lineWidth: CGFloat
        
        var body: some View {
            Circle()
                .stroke(color.opacity(0.3), lineWidth: lineWidth)
                .overlay {
                    Circle()
                        .trim(from: 0, to: min(progress, 1))
                        .stroke(
                            color,
                            style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                }
        }
    }
    
    struct StatRow: View {
        let label: String
        let value: String
        let unit: String
        let color: Color
        let progress: Double
        
        var body: some View {
            HStack(spacing: 8) {
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(label)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                    
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(value)
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(unit)
                            .font(.caption)
                    }
                    .foregroundStyle(.white)
                }
            }
        }
    }
}

// MARK: - StandBy Music Widget

/// Now playing widget for StandBy mode
@available(iOS 17.0, *)
public struct StandByMusicWidget: View {
    let trackName: String
    let artistName: String
    let albumName: String
    let isPlaying: Bool
    let progress: Double
    let accentColor: Color
    
    public init(
        trackName: String,
        artistName: String,
        albumName: String,
        isPlaying: Bool = true,
        progress: Double = 0.5,
        accentColor: Color = .purple
    ) {
        self.trackName = trackName
        self.artistName = artistName
        self.albumName = albumName
        self.isPlaying = isPlaying
        self.progress = progress
        self.accentColor = accentColor
    }
    
    public var body: some View {
        HStack(spacing: 24) {
            // Album art placeholder
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [accentColor, accentColor.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 140, height: 140)
                .overlay {
                    Image(systemName: "music.note")
                        .font(.system(size: 48))
                        .foregroundStyle(.white.opacity(0.5))
                }
                .shadow(color: accentColor.opacity(0.5), radius: 20)
            
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(trackName)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    
                    Text(artistName)
                        .font(.title3)
                        .foregroundStyle(.white.opacity(0.7))
                        .lineLimit(1)
                    
                    Text(albumName)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.5))
                        .lineLimit(1)
                }
                .foregroundStyle(.white)
                
                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.white.opacity(0.3))
                        
                        RoundedRectangle(cornerRadius: 2)
                            .fill(accentColor)
                            .frame(width: geo.size.width * progress)
                    }
                }
                .frame(height: 4)
                
                // Controls
                HStack(spacing: 32) {
                    Image(systemName: "backward.fill")
                        .font(.title2)
                    
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 36))
                    
                    Image(systemName: "forward.fill")
                        .font(.title2)
                }
                .foregroundStyle(.white)
            }
        }
        .padding()
        .containerBackground(.black.gradient, for: .widget)
    }
}

// MARK: - StandBy Countdown Widget

/// Event countdown for StandBy mode
@available(iOS 17.0, *)
public struct StandByCountdownWidget: View {
    let eventName: String
    let targetDate: Date
    let accentColor: Color
    
    public init(
        eventName: String,
        targetDate: Date,
        accentColor: Color = .orange
    ) {
        self.eventName = eventName
        self.targetDate = targetDate
        self.accentColor = accentColor
    }
    
    private var timeComponents: (days: Int, hours: Int, minutes: Int, seconds: Int) {
        let interval = targetDate.timeIntervalSince(Date())
        guard interval > 0 else { return (0, 0, 0, 0) }
        
        let days = Int(interval) / 86400
        let hours = (Int(interval) % 86400) / 3600
        let minutes = (Int(interval) % 3600) / 60
        let seconds = Int(interval) % 60
        return (days, hours, minutes, seconds)
    }
    
    public var body: some View {
        VStack(spacing: 24) {
            Text(eventName)
                .font(.title2)
                .foregroundStyle(.white.opacity(0.8))
            
            HStack(spacing: 16) {
                CountdownUnit(value: timeComponents.days, label: "DAYS", color: accentColor)
                CountdownUnit(value: timeComponents.hours, label: "HOURS", color: accentColor)
                CountdownUnit(value: timeComponents.minutes, label: "MIN", color: accentColor)
                CountdownUnit(value: timeComponents.seconds, label: "SEC", color: accentColor)
            }
            
            Text(targetDate, format: .dateTime.month().day().year())
                .font(.caption)
                .foregroundStyle(.white.opacity(0.5))
        }
        .padding()
        .containerBackground(.black.gradient, for: .widget)
    }
    
    struct CountdownUnit: View {
        let value: Int
        let label: String
        let color: Color
        
        var body: some View {
            VStack(spacing: 8) {
                Text(String(format: "%02d", value))
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(color)
                
                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
    }
}
