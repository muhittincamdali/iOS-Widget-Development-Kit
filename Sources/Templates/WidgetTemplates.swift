// WidgetTemplates.swift
// iOS-Widget-Development-Kit
//
// Complete collection of 25+ production-ready widget templates
// Created by Muhittin Camdali

import SwiftUI
import WidgetKit

// MARK: - Template Protocol

/// Protocol defining requirements for all widget templates
public protocol WidgetTemplateProtocol {
    associatedtype Content: View
    var templateName: String { get }
    var supportedFamilies: [WidgetFamily] { get }
    @ViewBuilder func makeBody(configuration: WidgetTemplateConfiguration) -> Content
}

/// Configuration passed to widget templates
public struct WidgetTemplateConfiguration {
    public let family: WidgetFamily
    public let isPlaceholder: Bool
    public let colorScheme: ColorScheme
    
    public init(family: WidgetFamily, isPlaceholder: Bool = false, colorScheme: ColorScheme = .light) {
        self.family = family
        self.isPlaceholder = isPlaceholder
        self.colorScheme = colorScheme
    }
}

// MARK: - 1. Gradient Card Widget

/// Beautiful gradient card widget with customizable colors
public struct GradientCardWidget<Content: View>: View {
    let title: String
    let subtitle: String
    let gradient: LinearGradient
    let icon: String
    let content: () -> Content
    
    public init(
        title: String,
        subtitle: String,
        gradient: LinearGradient = LinearGradient(
            colors: [.blue, .purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        icon: String = "star.fill",
        @ViewBuilder content: @escaping () -> Content = { EmptyView() }
    ) {
        self.title = title
        self.subtitle = subtitle
        self.gradient = gradient
        self.icon = icon
        self.content = content
    }
    
    public var body: some View {
        ZStack {
            gradient
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundStyle(.white.opacity(0.9))
                    Spacer()
                }
                
                Spacer()
                
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
                
                content()
            }
            .padding()
        }
    }
}

// MARK: - 2. Stats Widget

/// Statistics widget with progress indicators
public struct StatsWidget: View {
    public struct StatItem: Identifiable {
        public let id = UUID()
        public let title: String
        public let value: String
        public let progress: Double
        public let color: Color
        
        public init(title: String, value: String, progress: Double, color: Color = .blue) {
            self.title = title
            self.value = value
            self.progress = progress
            self.color = color
        }
    }
    
    let title: String
    let stats: [StatItem]
    
    public init(title: String, stats: [StatItem]) {
        self.title = title
        self.stats = stats
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)
            
            ForEach(stats) { stat in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(stat.title)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(stat.value)
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(stat.color.opacity(0.2))
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(stat.color)
                                .frame(width: geo.size.width * stat.progress)
                        }
                    }
                    .frame(height: 6)
                }
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - 3. Calendar Widget

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

// MARK: - 4. Weather Widget

/// Beautiful weather widget with conditions
public struct WeatherWidget: View {
    public enum Condition: String, CaseIterable {
        case sunny = "sun.max.fill"
        case cloudy = "cloud.fill"
        case rainy = "cloud.rain.fill"
        case stormy = "cloud.bolt.rain.fill"
        case snowy = "cloud.snow.fill"
        case partlyCloudy = "cloud.sun.fill"
        case foggy = "cloud.fog.fill"
        case windy = "wind"
        
        var color: Color {
            switch self {
            case .sunny: return .yellow
            case .cloudy: return .gray
            case .rainy: return .blue
            case .stormy: return .purple
            case .snowy: return .cyan
            case .partlyCloudy: return .orange
            case .foggy: return .gray
            case .windy: return .teal
            }
        }
    }
    
    let temperature: Int
    let condition: Condition
    let location: String
    let high: Int
    let low: Int
    
    public init(
        temperature: Int,
        condition: Condition,
        location: String,
        high: Int,
        low: Int
    ) {
        self.temperature = temperature
        self.condition = condition
        self.location = location
        self.high = high
        self.low = low
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(location)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Image(systemName: condition.rawValue)
                    .font(.title)
                    .foregroundStyle(condition.color)
            }
            
            Spacer()
            
            Text("\(temperature)°")
                .font(.system(size: 48, weight: .thin))
            
            HStack {
                Text("H:\(high)°")
                Text("L:\(low)°")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - 5. Countdown Widget

/// Countdown timer widget for events
public struct CountdownWidget: View {
    let title: String
    let targetDate: Date
    let icon: String
    let accentColor: Color
    
    public init(
        title: String,
        targetDate: Date,
        icon: String = "clock.fill",
        accentColor: Color = .orange
    ) {
        self.title = title
        self.targetDate = targetDate
        self.icon = icon
        self.accentColor = accentColor
    }
    
    private var timeRemaining: (days: Int, hours: Int, minutes: Int) {
        let interval = targetDate.timeIntervalSince(Date())
        guard interval > 0 else { return (0, 0, 0) }
        
        let days = Int(interval) / 86400
        let hours = (Int(interval) % 86400) / 3600
        let minutes = (Int(interval) % 3600) / 60
        return (days, hours, minutes)
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

// MARK: - 6. Quote Widget

/// Inspirational quote widget
public struct QuoteWidget: View {
    let quote: String
    let author: String
    let category: String?
    
    public init(quote: String, author: String, category: String? = nil) {
        self.quote = quote
        self.author = author
        self.category = category
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let category = category {
                Text(category.uppercased())
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
            
            Text(""\(quote)"")
                .font(.system(.body, design: .serif))
                .italic()
                .lineLimit(4)
            
            Spacer()
            
            HStack {
                Text("— \(author)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Image(systemName: "quote.closing")
                    .foregroundStyle(.tertiary)
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - 7. Music Widget

/// Music player widget with album art placeholder
public struct MusicWidget: View {
    let trackName: String
    let artistName: String
    let albumName: String
    let isPlaying: Bool
    let progress: Double
    
    public init(
        trackName: String,
        artistName: String,
        albumName: String,
        isPlaying: Bool = true,
        progress: Double = 0.5
    ) {
        self.trackName = trackName
        self.artistName = artistName
        self.albumName = albumName
        self.isPlaying = isPlaying
        self.progress = progress
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            // Album art placeholder
            RoundedRectangle(cornerRadius: 8)
                .fill(LinearGradient(
                    colors: [.purple, .blue],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: 60, height: 60)
                .overlay {
                    Image(systemName: "music.note")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(trackName)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(artistName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.secondary.opacity(0.3))
                        
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.purple)
                            .frame(width: geo.size.width * progress)
                    }
                }
                .frame(height: 4)
                
                HStack {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    Spacer()
                    Image(systemName: "forward.fill")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - 8. Fitness Widget

/// Fitness tracking widget with activity rings
public struct FitnessWidget: View {
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
        HStack {
            ZStack {
                ActivityRing(progress: calories / caloriesGoal, color: .red, lineWidth: 12)
                    .frame(width: 80, height: 80)
                
                ActivityRing(progress: exercise / exerciseGoal, color: .green, lineWidth: 10)
                    .frame(width: 60, height: 60)
                
                ActivityRing(progress: standing / standingGoal, color: .cyan, lineWidth: 8)
                    .frame(width: 44, height: 44)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ActivityStat(label: "Move", value: "\(Int(calories))/\(Int(caloriesGoal))", unit: "CAL", color: .red)
                ActivityStat(label: "Exercise", value: "\(Int(exercise))/\(Int(exerciseGoal))", unit: "MIN", color: .green)
                ActivityStat(label: "Stand", value: "\(Int(standing))/\(Int(standingGoal))", unit: "HRS", color: .cyan)
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
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
                        .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                }
        }
    }
    
    struct ActivityStat: View {
        let label: String
        let value: String
        let unit: String
        let color: Color
        
        var body: some View {
            HStack(spacing: 4) {
                Circle()
                    .fill(color)
                    .frame(width: 6, height: 6)
                
                Text(label)
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(value)
                    .font(.system(size: 10, weight: .semibold))
                
                Text(unit)
                    .font(.system(size: 8))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - 9. Habit Tracker Widget

/// Habit tracking widget with streak display
public struct HabitTrackerWidget: View {
    public struct Habit: Identifiable {
        public let id = UUID()
        public let name: String
        public let icon: String
        public let color: Color
        public let completedDays: [Bool] // Last 7 days
        
        public init(name: String, icon: String, color: Color, completedDays: [Bool]) {
            self.name = name
            self.icon = icon
            self.color = color
            self.completedDays = completedDays
        }
        
        public var streak: Int {
            var count = 0
            for completed in completedDays.reversed() {
                if completed { count += 1 } else { break }
            }
            return count
        }
    }
    
    let habits: [Habit]
    
    public init(habits: [Habit]) {
        self.habits = habits
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Habits")
                    .font(.headline)
                Spacer()
                Text("7 Day Streak")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            ForEach(habits.prefix(3)) { habit in
                HStack(spacing: 8) {
                    Image(systemName: habit.icon)
                        .font(.caption)
                        .foregroundStyle(habit.color)
                        .frame(width: 20)
                    
                    Text(habit.name)
                        .font(.caption)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    HStack(spacing: 2) {
                        ForEach(0..<7, id: \.self) { day in
                            Circle()
                                .fill(habit.completedDays.indices.contains(day) && habit.completedDays[day] 
                                    ? habit.color 
                                    : Color.secondary.opacity(0.3))
                                .frame(width: 8, height: 8)
                        }
                    }
                    
                    Text("🔥\(habit.streak)")
                        .font(.system(size: 10))
                }
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - 10. Finance Widget

/// Financial overview widget
public struct FinanceWidget: View {
    public struct Account: Identifiable {
        public let id = UUID()
        public let name: String
        public let balance: Double
        public let change: Double
        public let icon: String
        
        public init(name: String, balance: Double, change: Double, icon: String = "creditcard") {
            self.name = name
            self.balance = balance
            self.change = change
            self.icon = icon
        }
    }
    
    let totalBalance: Double
    let accounts: [Account]
    let currency: String
    
    public init(totalBalance: Double, accounts: [Account], currency: String = "$") {
        self.totalBalance = totalBalance
        self.accounts = accounts
        self.currency = currency
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Total Balance")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text("\(currency)\(totalBalance, specifier: "%.2f")")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            Divider()
            
            ForEach(accounts.prefix(2)) { account in
                HStack {
                    Image(systemName: account.icon)
                        .font(.caption)
                        .foregroundStyle(.blue)
                        .frame(width: 24, height: 24)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    
                    VStack(alignment: .leading) {
                        Text(account.name)
                            .font(.caption)
                        Text("\(currency)\(account.balance, specifier: "%.2f")")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Text("\(account.change >= 0 ? "+" : "")\(account.change, specifier: "%.1f")%")
                        .font(.caption)
                        .foregroundStyle(account.change >= 0 ? .green : .red)
                }
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - 11. Photo Widget

/// Photo frame widget with customizable styling
public struct PhotoFrameWidget: View {
    let imageName: String?
    let caption: String?
    let date: Date?
    let style: FrameStyle
    
    public enum FrameStyle {
        case minimal
        case polaroid
        case modern
        case vintage
    }
    
    public init(
        imageName: String? = nil,
        caption: String? = nil,
        date: Date? = nil,
        style: FrameStyle = .modern
    ) {
        self.imageName = imageName
        self.caption = caption
        self.date = date
        self.style = style
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Image placeholder
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.gray.opacity(0.3), .gray.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay {
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                }
            
            if style == .polaroid, let caption = caption {
                VStack(spacing: 4) {
                    Text(caption)
                        .font(.caption)
                        .lineLimit(1)
                    
                    if let date = date {
                        Text(date, style: .date)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(.white)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: style == .minimal ? 0 : 12))
        .shadow(radius: style == .modern ? 8 : 0)
        .containerBackground(.clear, for: .widget)
    }
}

// MARK: - 12. Notes Widget

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

// MARK: - 13. Battery Widget

/// Device battery status widget
public struct BatteryWidget: View {
    public struct Device: Identifiable {
        public let id = UUID()
        public let name: String
        public let icon: String
        public let batteryLevel: Double
        public let isCharging: Bool
        
        public init(name: String, icon: String, batteryLevel: Double, isCharging: Bool = false) {
            self.name = name
            self.icon = icon
            self.batteryLevel = batteryLevel
            self.isCharging = isCharging
        }
        
        var batteryColor: Color {
            if isCharging { return .green }
            if batteryLevel < 0.2 { return .red }
            if batteryLevel < 0.5 { return .orange }
            return .green
        }
    }
    
    let devices: [Device]
    
    public init(devices: [Device]) {
        self.devices = devices
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            ForEach(devices.prefix(3)) { device in
                HStack(spacing: 12) {
                    Image(systemName: device.icon)
                        .font(.title2)
                        .frame(width: 30)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(device.name)
                            .font(.caption)
                            .lineLimit(1)
                        
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color.secondary.opacity(0.2))
                                
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(device.batteryColor)
                                    .frame(width: geo.size.width * device.batteryLevel)
                            }
                        }
                        .frame(height: 8)
                    }
                    
                    HStack(spacing: 2) {
                        if device.isCharging {
                            Image(systemName: "bolt.fill")
                                .font(.system(size: 10))
                                .foregroundStyle(.green)
                        }
                        Text("\(Int(device.batteryLevel * 100))%")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .frame(width: 45, alignment: .trailing)
                }
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - 14. Shortcuts Widget

/// Quick shortcuts grid widget
public struct ShortcutsWidget: View {
    public struct Shortcut: Identifiable {
        public let id = UUID()
        public let name: String
        public let icon: String
        public let color: Color
        public let url: URL?
        
        public init(name: String, icon: String, color: Color, url: URL? = nil) {
            self.name = name
            self.icon = icon
            self.color = color
            self.url = url
        }
    }
    
    let shortcuts: [Shortcut]
    
    public init(shortcuts: [Shortcut]) {
        self.shortcuts = shortcuts
    }
    
    public var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
            ForEach(shortcuts.prefix(4)) { shortcut in
                Link(destination: shortcut.url ?? URL(string: "app://")!) {
                    VStack(spacing: 6) {
                        Image(systemName: shortcut.icon)
                            .font(.title2)
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(shortcut.color)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Text(shortcut.name)
                            .font(.caption2)
                            .foregroundStyle(.primary)
                            .lineLimit(1)
                    }
                }
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - 15. Social Stats Widget

/// Social media statistics widget
public struct SocialStatsWidget: View {
    let platform: String
    let platformIcon: String
    let platformColor: Color
    let followers: Int
    let following: Int
    let posts: Int
    let engagement: Double
    
    public init(
        platform: String,
        platformIcon: String,
        platformColor: Color,
        followers: Int,
        following: Int,
        posts: Int,
        engagement: Double
    ) {
        self.platform = platform
        self.platformIcon = platformIcon
        self.platformColor = platformColor
        self.followers = followers
        self.following = following
        self.posts = posts
        self.engagement = engagement
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: platformIcon)
                    .foregroundStyle(platformColor)
                Text(platform)
                    .font(.headline)
            }
            
            HStack(spacing: 16) {
                StatBox(value: formatNumber(followers), label: "Followers")
                StatBox(value: formatNumber(following), label: "Following")
                StatBox(value: formatNumber(posts), label: "Posts")
            }
            
            HStack {
                Text("Engagement")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(engagement, specifier: "%.1f")%")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
    
    private func formatNumber(_ num: Int) -> String {
        if num >= 1_000_000 {
            return String(format: "%.1fM", Double(num) / 1_000_000)
        } else if num >= 1_000 {
            return String(format: "%.1fK", Double(num) / 1_000)
        }
        return "\(num)"
    }
    
    struct StatBox: View {
        let value: String
        let label: String
        
        var body: some View {
            VStack(spacing: 2) {
                Text(value)
                    .font(.headline)
                Text(label)
                    .font(.system(size: 9))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - 16. Clock Widget

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

// MARK: - 17. To-Do Widget

/// Task list widget
public struct TodoWidget: View {
    public struct Task: Identifiable {
        public let id = UUID()
        public let title: String
        public let isCompleted: Bool
        public let priority: Priority
        public let dueDate: Date?
        
        public enum Priority {
            case low, medium, high
            
            var color: Color {
                switch self {
                case .low: return .blue
                case .medium: return .orange
                case .high: return .red
                }
            }
        }
        
        public init(title: String, isCompleted: Bool = false, priority: Priority = .medium, dueDate: Date? = nil) {
            self.title = title
            self.isCompleted = isCompleted
            self.priority = priority
            self.dueDate = dueDate
        }
    }
    
    let tasks: [Task]
    let listName: String
    
    public init(tasks: [Task], listName: String = "Tasks") {
        self.tasks = tasks
        self.listName = listName
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(listName)
                    .font(.headline)
                Spacer()
                let completed = tasks.filter { $0.isCompleted }.count
                Text("\(completed)/\(tasks.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            ForEach(tasks.prefix(4)) { task in
                HStack(spacing: 8) {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(task.isCompleted ? .green : task.priority.color)
                        .font(.body)
                    
                    Text(task.title)
                        .font(.caption)
                        .strikethrough(task.isCompleted)
                        .foregroundStyle(task.isCompleted ? .secondary : .primary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if let dueDate = task.dueDate {
                        Text(dueDate, style: .relative)
                            .font(.system(size: 9))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            if tasks.count > 4 {
                Text("+\(tasks.count - 4) more tasks")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - 18. Podcast Widget

/// Podcast player widget
public struct PodcastWidget: View {
    let podcastName: String
    let episodeTitle: String
    let currentTime: TimeInterval
    let duration: TimeInterval
    let isPlaying: Bool
    
    public init(
        podcastName: String,
        episodeTitle: String,
        currentTime: TimeInterval,
        duration: TimeInterval,
        isPlaying: Bool = false
    ) {
        self.podcastName = podcastName
        self.episodeTitle = episodeTitle
        self.currentTime = currentTime
        self.duration = duration
        self.isPlaying = isPlaying
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(LinearGradient(colors: [.orange, .pink], startPoint: .top, endPoint: .bottom))
                .frame(width: 50, height: 50)
                .overlay {
                    Image(systemName: "mic.fill")
                        .foregroundStyle(.white)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(podcastName)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                
                Text(episodeTitle)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(2)
                
                HStack {
                    Text(formatTime(currentTime))
                    
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.secondary.opacity(0.3))
                            
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.orange)
                                .frame(width: geo.size.width * (currentTime / duration))
                        }
                    }
                    .frame(height: 3)
                    
                    Text(formatTime(duration))
                }
                .font(.system(size: 9))
                .foregroundStyle(.secondary)
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
    
    private func formatTime(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - 19. News Headlines Widget

/// News headlines widget
public struct NewsWidget: View {
    public struct Article: Identifiable {
        public let id = UUID()
        public let headline: String
        public let source: String
        public let timeAgo: String
        public let category: String
        
        public init(headline: String, source: String, timeAgo: String, category: String) {
            self.headline = headline
            self.source = source
            self.timeAgo = timeAgo
            self.category = category
        }
    }
    
    let articles: [Article]
    let category: String
    
    public init(articles: [Article], category: String = "Top Stories") {
        self.articles = articles
        self.category = category
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(category)
                    .font(.headline)
                Spacer()
                Image(systemName: "newspaper.fill")
                    .foregroundStyle(.red)
            }
            
            ForEach(articles.prefix(3)) { article in
                VStack(alignment: .leading, spacing: 4) {
                    Text(article.headline)
                        .font(.caption)
                        .fontWeight(.medium)
                        .lineLimit(2)
                    
                    HStack {
                        Text(article.source)
                        Text("•")
                        Text(article.timeAgo)
                    }
                    .font(.system(size: 9))
                    .foregroundStyle(.secondary)
                }
                
                if article.id != articles.prefix(3).last?.id {
                    Divider()
                }
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - 20. Water Tracker Widget

/// Water intake tracking widget
public struct WaterTrackerWidget: View {
    let currentIntake: Double // in ml
    let dailyGoal: Double
    let glassSize: Double
    
    public init(currentIntake: Double, dailyGoal: Double = 2000, glassSize: Double = 250) {
        self.currentIntake = currentIntake
        self.dailyGoal = dailyGoal
        self.glassSize = glassSize
    }
    
    var progress: Double {
        min(currentIntake / dailyGoal, 1.0)
    }
    
    var glasses: Int {
        Int(currentIntake / glassSize)
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "drop.fill")
                    .foregroundStyle(.cyan)
                Text("Water")
                    .font(.headline)
                Spacer()
            }
            
            ZStack {
                Circle()
                    .stroke(Color.cyan.opacity(0.2), lineWidth: 8)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        LinearGradient(colors: [.cyan, .blue], startPoint: .topLeading, endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: 2) {
                    Text("\(Int(currentIntake))")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("/ \(Int(dailyGoal)) ml")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 80, height: 80)
            
            HStack {
                ForEach(0..<8, id: \.self) { index in
                    Image(systemName: index < glasses ? "drop.fill" : "drop")
                        .font(.system(size: 10))
                        .foregroundStyle(index < glasses ? .cyan : .secondary.opacity(0.3))
                }
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}
