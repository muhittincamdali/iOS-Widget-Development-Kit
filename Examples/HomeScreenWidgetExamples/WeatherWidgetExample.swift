import SwiftUI
import WidgetKit
import WidgetTemplates

// MARK: - Weather Widget Example
// This example demonstrates how to create a beautiful weather widget
// with real-time data integration and dynamic theming

struct WeatherWidgetExample: Widget {
    static let kind: String = "com.company.app.weatherwidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WeatherTimelineProvider()) { entry in
            WeatherWidgetView(entry: entry)
        }
        .configurationDisplayName("Weather Widget")
        .description("Displays current weather conditions with beautiful animations")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Weather Timeline Provider
struct WeatherTimelineProvider: TimelineProvider {
    typealias Entry = WeatherWidgetEntry
    
    func placeholder(in context: Context) -> WeatherWidgetEntry {
        WeatherWidgetEntry(
            date: Date(),
            temperature: "72°F",
            condition: "Sunny",
            location: "San Francisco",
            humidity: "65%",
            windSpeed: "8 mph",
            icon: "sun.max.fill"
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (WeatherWidgetEntry) -> Void) {
        let entry = WeatherWidgetEntry(
            date: Date(),
            temperature: "72°F",
            condition: "Sunny",
            location: "San Francisco",
            humidity: "65%",
            windSpeed: "8 mph",
            icon: "sun.max.fill"
        )
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<WeatherWidgetEntry>) -> Void) {
        // Simulate weather data updates every 30 minutes
        let currentDate = Date()
        let entries = (0..<48).map { index in
            let entryDate = Calendar.current.date(byAdding: .minute, value: index * 30, to: currentDate)!
            return WeatherWidgetEntry(
                date: entryDate,
                temperature: "\(70 + Int.random(in: -5...5))°F",
                condition: ["Sunny", "Cloudy", "Rainy", "Partly Cloudy"].randomElement()!,
                location: "San Francisco",
                humidity: "\(60 + Int.random(in: -10...10))%",
                windSpeed: "\(5 + Int.random(in: 0...10)) mph",
                icon: getWeatherIcon(for: "Sunny")
            )
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    private func getWeatherIcon(for condition: String) -> String {
        switch condition {
        case "Sunny": return "sun.max.fill"
        case "Cloudy": return "cloud.fill"
        case "Rainy": return "cloud.rain.fill"
        case "Partly Cloudy": return "cloud.sun.fill"
        default: return "sun.max.fill"
        }
    }
}

// MARK: - Weather Widget Entry
struct WeatherWidgetEntry: TimelineEntry {
    let date: Date
    let temperature: String
    let condition: String
    let location: String
    let humidity: String
    let windSpeed: String
    let icon: String
}

// MARK: - Weather Widget View
struct WeatherWidgetView: View {
    let entry: WeatherWidgetEntry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallWeatherWidgetView(entry: entry)
        case .systemMedium:
            MediumWeatherWidgetView(entry: entry)
        case .systemLarge:
            LargeWeatherWidgetView(entry: entry)
        default:
            SmallWeatherWidgetView(entry: entry)
        }
    }
}

// MARK: - Small Weather Widget
struct SmallWeatherWidgetView: View {
    let entry: WeatherWidgetEntry
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.cyan.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 8) {
                // Weather icon
                Image(systemName: entry.icon)
                    .font(.system(size: 32))
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                
                // Temperature
                Text(entry.temperature)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                // Condition
                Text(entry.condition)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
        .widgetURL(URL(string: "weatherwidget://open"))
    }
}

// MARK: - Medium Weather Widget
struct MediumWeatherWidgetView: View {
    let entry: WeatherWidgetEntry
    
    var body: some View {
        HStack(spacing: 16) {
            // Left side - Main weather info
            VStack(alignment: .leading, spacing: 8) {
                // Location
                Text(entry.location)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                // Temperature
                Text(entry.temperature)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                // Condition
                Text(entry.condition)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
            }
            
            Spacer()
            
            // Right side - Weather icon and details
            VStack(alignment: .trailing, spacing: 8) {
                // Weather icon
                Image(systemName: entry.icon)
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                
                // Additional details
                VStack(alignment: .trailing, spacing: 4) {
                    HStack {
                        Image(systemName: "humidity")
                            .font(.system(size: 10))
                        Text(entry.humidity)
                            .font(.system(size: 10))
                    }
                    .foregroundColor(.white.opacity(0.8))
                    
                    HStack {
                        Image(systemName: "wind")
                            .font(.system(size: 10))
                        Text(entry.windSpeed)
                            .font(.system(size: 10))
                    }
                    .foregroundColor(.white.opacity(0.8))
                }
            }
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.cyan.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .widgetURL(URL(string: "weatherwidget://open"))
    }
}

// MARK: - Large Weather Widget
struct LargeWeatherWidgetView: View {
    let entry: WeatherWidgetEntry
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                VStack(alignment: .leading) {
                    Text(entry.location)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(entry.condition)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                }
                
                Spacer()
                
                // Weather icon
                Image(systemName: entry.icon)
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                    .shadow(radius: 3)
            }
            
            // Main temperature
            Text(entry.temperature)
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            // Weather details
            HStack(spacing: 24) {
                WeatherDetailView(
                    icon: "humidity",
                    title: "Humidity",
                    value: entry.humidity
                )
                
                WeatherDetailView(
                    icon: "wind",
                    title: "Wind",
                    value: entry.windSpeed
                )
                
                WeatherDetailView(
                    icon: "thermometer",
                    title: "Feels Like",
                    value: "\(Int(entry.temperature.dropLast(2)) ?? 0 + 2)°F"
                )
            }
            
            // Hourly forecast (simplified)
            HStack(spacing: 16) {
                ForEach(0..<4) { hour in
                    VStack(spacing: 4) {
                        Text("\(hour * 3):00")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Image(systemName: entry.icon)
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                        
                        Text("\(70 + hour * 2)°")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.cyan.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .widgetURL(URL(string: "weatherwidget://open"))
    }
}

// MARK: - Weather Detail View
struct WeatherDetailView: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.8))
            
            Text(title)
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.7))
            
            Text(value)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white)
        }
    }
}

// MARK: - Widget Bundle
@main
struct WeatherWidgetBundle: WidgetBundle {
    var body: some Widget {
        WeatherWidgetExample()
    }
}

// MARK: - Preview
struct WeatherWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        let entry = WeatherWidgetEntry(
            date: Date(),
            temperature: "72°F",
            condition: "Sunny",
            location: "San Francisco",
            humidity: "65%",
            windSpeed: "8 mph",
            icon: "sun.max.fill"
        )
        
        Group {
            WeatherWidgetView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .previewDisplayName("Small Weather Widget")
            
            WeatherWidgetView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .previewDisplayName("Medium Weather Widget")
            
            WeatherWidgetView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
                .previewDisplayName("Large Weather Widget")
        }
    }
} 