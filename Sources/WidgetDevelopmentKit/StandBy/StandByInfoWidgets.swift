import SwiftUI
import WidgetKit

// MARK: - StandBy Photo Widget

/// Photo display widget for StandBy mode
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

    private var grid: MonthGrid { MonthGrid(month: date, calendar: calendar) }

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
                ForEach(Array(grid.weekdaySymbols.enumerated()), id: \.offset) { _, day in
                    Text(day)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.5))
                        .frame(maxWidth: .infinity)
                }
            }

            // Calendar grid
            let weeks = grid.weeks
            VStack(spacing: 8) {
                ForEach(weeks.indices, id: \.self) { weekIndex in
                    HStack {
                        ForEach(0..<7, id: \.self) { dayIndex in
                            if let day = weeks[weekIndex][dayIndex] {
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
