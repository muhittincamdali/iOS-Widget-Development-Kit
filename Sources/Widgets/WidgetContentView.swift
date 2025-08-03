import SwiftUI

// MARK: - Weather Widget Views

@available(iOS 16.0, *)
public struct WeatherLoadingView: View {
    public var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading weather...")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

@available(iOS 16.0, *)
public struct WeatherContentView: View {
    let weatherData: WeatherData
    let customization: WidgetCustomization
    
    public var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(weatherData.temperature)°")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(customization.textColor)
                    
                    Text(weatherData.condition.capitalized)
                        .font(.caption)
                        .foregroundColor(customization.textColor.opacity(0.8))
                }
                
                Spacer()
                
                Image(systemName: weatherIcon)
                    .font(.title2)
                    .foregroundColor(customization.accentColor)
            }
            
            HStack {
                WeatherDetailView(title: "Humidity", value: "\(weatherData.humidity)%")
                Spacer()
                WeatherDetailView(title: "Wind", value: "\(weatherData.windSpeed) km/h")
            }
        }
        .padding(customization.padding)
        .background(customization.backgroundColor)
        .cornerRadius(customization.cornerRadius)
    }
    
    private var weatherIcon: String {
        switch weatherData.condition.lowercased() {
        case "sunny": return "sun.max.fill"
        case "cloudy": return "cloud.fill"
        case "rainy": return "cloud.rain.fill"
        case "snowy": return "cloud.snow.fill"
        default: return "cloud.fill"
        }
    }
}

@available(iOS 16.0, *)
public struct WeatherDetailView: View {
    let title: String
    let value: String
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
        }
    }
}

@available(iOS 16.0, *)
public struct WeatherErrorView: View {
    public var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.title2)
                .foregroundColor(.orange)
            Text("Weather unavailable")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Calendar Widget Views

@available(iOS 16.0, *)
public struct CalendarLoadingView: View {
    public var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading calendar...")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

@available(iOS 16.0, *)
public struct CalendarContentView: View {
    let events: [CalendarEvent]
    let customization: WidgetCustomization
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(customization.accentColor)
                Text("Today's Events")
                    .font(.headline)
                    .foregroundColor(customization.textColor)
                Spacer()
            }
            
            ForEach(events.prefix(3), id: \.title) { event in
                CalendarEventRow(event: event, customization: customization)
            }
        }
        .padding(customization.padding)
        .background(customization.backgroundColor)
        .cornerRadius(customization.cornerRadius)
    }
}

@available(iOS 16.0, *)
public struct CalendarEventRow: View {
    let event: CalendarEvent
    let customization: WidgetCustomization
    
    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(event.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(customization.textColor)
                    .lineLimit(1)
                
                Text(event.time)
                    .font(.caption2)
                    .foregroundColor(customization.textColor.opacity(0.7))
            }
            
            Spacer()
            
            Text(event.location)
                .font(.caption2)
                .foregroundColor(customization.accentColor)
                .lineLimit(1)
        }
    }
}

@available(iOS 16.0, *)
public struct CalendarEmptyView: View {
    public var body: some View {
        VStack {
            Image(systemName: "calendar.badge.plus")
                .font(.title2)
                .foregroundColor(.green)
            Text("No events today")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Fitness Widget Views

@available(iOS 16.0, *)
public struct FitnessLoadingView: View {
    public var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading fitness data...")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

@available(iOS 16.0, *)
public struct FitnessContentView: View {
    let fitnessData: FitnessData
    let customization: WidgetCustomization
    
    public var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(fitnessData.steps)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(customization.textColor)
                    Text("Steps")
                        .font(.caption)
                        .foregroundColor(customization.textColor.opacity(0.8))
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("\(fitnessData.calories)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(customization.accentColor)
                    Text("Calories")
                        .font(.caption)
                        .foregroundColor(customization.accentColor.opacity(0.8))
                }
            }
            
            HStack {
                FitnessMetricView(title: "Active", value: "\(fitnessData.activeMinutes)m")
                Spacer()
                FitnessMetricView(title: "Workouts", value: "\(fitnessData.workouts)")
            }
        }
        .padding(customization.padding)
        .background(customization.backgroundColor)
        .cornerRadius(customization.cornerRadius)
    }
}

@available(iOS 16.0, *)
public struct FitnessMetricView: View {
    let title: String
    let value: String
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
        }
    }
}

@available(iOS 16.0, *)
public struct FitnessErrorView: View {
    public var body: some View {
        VStack {
            Image(systemName: "heart.slash")
                .font(.title2)
                .foregroundColor(.red)
            Text("Fitness data unavailable")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - News Widget Views

@available(iOS 16.0, *)
public struct NewsLoadingView: View {
    public var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading news...")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

@available(iOS 16.0, *)
public struct NewsContentView: View {
    let newsItems: [NewsItem]
    let customization: WidgetCustomization
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "newspaper")
                    .foregroundColor(customization.accentColor)
                Text("Latest News")
                    .font(.headline)
                    .foregroundColor(customization.textColor)
                Spacer()
            }
            
            ForEach(newsItems.prefix(2), id: \.title) { item in
                NewsItemRow(item: item, customization: customization)
            }
        }
        .padding(customization.padding)
        .background(customization.backgroundColor)
        .cornerRadius(customization.cornerRadius)
    }
}

@available(iOS 16.0, *)
public struct NewsItemRow: View {
    let item: NewsItem
    let customization: WidgetCustomization
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(customization.textColor)
                .lineLimit(2)
            
            HStack {
                Text(item.category)
                    .font(.caption2)
                    .foregroundColor(customization.accentColor)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(customization.accentColor.opacity(0.1))
                    .cornerRadius(4)
                
                Spacer()
            }
        }
    }
}

@available(iOS 16.0, *)
public struct NewsEmptyView: View {
    public var body: some View {
        VStack {
            Image(systemName: "newspaper")
                .font(.title2)
                .foregroundColor(.blue)
            Text("No news available")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Social Media Widget Views

@available(iOS 16.0, *)
public struct SocialLoadingView: View {
    public var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading social updates...")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

@available(iOS 16.0, *)
public struct SocialContentView: View {
    let socialUpdates: [SocialUpdate]
    let customization: WidgetCustomization
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "bubble.left.and.bubble.right")
                    .foregroundColor(customization.accentColor)
                Text("Social Updates")
                    .font(.headline)
                    .foregroundColor(customization.textColor)
                Spacer()
            }
            
            ForEach(socialUpdates.prefix(2), id: \.content) { update in
                SocialUpdateRow(update: update, customization: customization)
            }
        }
        .padding(customization.padding)
        .background(customization.backgroundColor)
        .cornerRadius(customization.cornerRadius)
    }
}

@available(iOS 16.0, *)
public struct SocialUpdateRow: View {
    let update: SocialUpdate
    let customization: WidgetCustomization
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(update.platform)
                    .font(.caption2)
                    .foregroundColor(customization.accentColor)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(customization.accentColor.opacity(0.1))
                    .cornerRadius(4)
                
                Spacer()
                
                Text("\(update.likes) likes")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Text(update.content)
                .font(.caption)
                .foregroundColor(customization.textColor)
                .lineLimit(2)
        }
    }
}

@available(iOS 16.0, *)
public struct SocialEmptyView: View {
    public var body: some View {
        VStack {
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.title2)
                .foregroundColor(.pink)
            Text("No social updates")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Productivity Widget Views

@available(iOS 16.0, *)
public struct ProductivityLoadingView: View {
    public var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading productivity data...")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

@available(iOS 16.0, *)
public struct ProductivityContentView: View {
    let productivityData: ProductivityData
    let customization: WidgetCustomization
    
    public var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(productivityData.tasksCompleted)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(customization.textColor)
                    Text("Completed")
                        .font(.caption)
                        .foregroundColor(customization.textColor.opacity(0.8))
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("\(productivityData.productivityScore)%")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(customization.accentColor)
                    Text("Score")
                        .font(.caption)
                        .foregroundColor(customization.accentColor.opacity(0.8))
                }
            }
            
            HStack {
                ProductivityMetricView(title: "Remaining", value: "\(productivityData.tasksRemaining)")
                Spacer()
                ProductivityMetricView(title: "Focus Time", value: "\(productivityData.focusTime)m")
            }
        }
        .padding(customization.padding)
        .background(customization.backgroundColor)
        .cornerRadius(customization.cornerRadius)
    }
}

@available(iOS 16.0, *)
public struct ProductivityMetricView: View {
    let title: String
    let value: String
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
        }
    }
}

@available(iOS 16.0, *)
public struct ProductivityErrorView: View {
    public var body: some View {
        VStack {
            Image(systemName: "chart.line.downtrend.xyaxis")
                .font(.title2)
                .foregroundColor(.orange)
            Text("Productivity data unavailable")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Entertainment Widget Views

@available(iOS 16.0, *)
public struct EntertainmentLoadingView: View {
    public var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading entertainment...")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

@available(iOS 16.0, *)
public struct EntertainmentContentView: View {
    let entertainmentItems: [EntertainmentItem]
    let customization: WidgetCustomization
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "play.circle")
                    .foregroundColor(customization.accentColor)
                Text("Entertainment")
                    .font(.headline)
                    .foregroundColor(customization.textColor)
                Spacer()
            }
            
            ForEach(entertainmentItems.prefix(2), id: \.title) { item in
                EntertainmentItemRow(item: item, customization: customization)
            }
        }
        .padding(customization.padding)
        .background(customization.backgroundColor)
        .cornerRadius(customization.cornerRadius)
    }
}

@available(iOS 16.0, *)
public struct EntertainmentItemRow: View {
    let item: EntertainmentItem
    let customization: WidgetCustomization
    
    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(customization.textColor)
                    .lineLimit(1)
                
                Text(item.type)
                    .font(.caption2)
                    .foregroundColor(customization.textColor.opacity(0.7))
            }
            
            Spacer()
            
            HStack(spacing: 2) {
                Image(systemName: "star.fill")
                    .font(.caption2)
                    .foregroundColor(.yellow)
                Text(String(format: "%.1f", item.rating))
                    .font(.caption2)
                    .foregroundColor(customization.accentColor)
            }
        }
    }
}

@available(iOS 16.0, *)
public struct EntertainmentEmptyView: View {
    public var body: some View {
        VStack {
            Image(systemName: "play.circle")
                .font(.title2)
                .foregroundColor(.red)
            Text("No entertainment available")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Finance Widget Views

@available(iOS 16.0, *)
public struct FinanceLoadingView: View {
    public var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading finance data...")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

@available(iOS 16.0, *)
public struct FinanceContentView: View {
    let financeData: FinanceData
    let customization: WidgetCustomization
    
    public var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text("$\(Int(financeData.portfolioValue))")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(customization.textColor)
                    Text("Portfolio")
                        .font(.caption)
                        .foregroundColor(customization.textColor.opacity(0.8))
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("$\(Int(financeData.dailyChange))")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(financeData.dailyChange >= 0 ? .green : .red)
                    Text("Today")
                        .font(.caption)
                        .foregroundColor(customization.textColor.opacity(0.8))
                }
            }
            
            HStack {
                FinanceMetricView(title: "Top Stock", value: financeData.topStock)
                Spacer()
                FinanceMetricView(title: "Trend", value: financeData.marketTrend)
            }
        }
        .padding(customization.padding)
        .background(customization.backgroundColor)
        .cornerRadius(customization.cornerRadius)
    }
}

@available(iOS 16.0, *)
public struct FinanceMetricView: View {
    let title: String
    let value: String
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
        }
    }
}

@available(iOS 16.0, *)
public struct FinanceErrorView: View {
    public var body: some View {
        VStack {
            Image(systemName: "chart.line.downtrend.xyaxis")
                .font(.title2)
                .foregroundColor(.red)
            Text("Finance data unavailable")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Health Widget Views

@available(iOS 16.0, *)
public struct HealthLoadingView: View {
    public var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading health data...")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

@available(iOS 16.0, *)
public struct HealthContentView: View {
    let healthData: HealthData
    let customization: WidgetCustomization
    
    public var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(healthData.heartRate)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(customization.textColor)
                    Text("BPM")
                        .font(.caption)
                        .foregroundColor(customization.textColor.opacity(0.8))
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("\(healthData.sleepHours, specifier: "%.1f")h")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(customization.accentColor)
                    Text("Sleep")
                        .font(.caption)
                        .foregroundColor(customization.accentColor.opacity(0.8))
                }
            }
            
            HStack {
                HealthMetricView(title: "Water", value: "\(healthData.waterIntake) cups")
                Spacer()
                HealthMetricView(title: "Mood", value: healthData.mood)
            }
        }
        .padding(customization.padding)
        .background(customization.backgroundColor)
        .cornerRadius(customization.cornerRadius)
    }
}

@available(iOS 16.0, *)
public struct HealthMetricView: View {
    let title: String
    let value: String
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
        }
    }
}

@available(iOS 16.0, *)
public struct HealthErrorView: View {
    public var body: some View {
        VStack {
            Image(systemName: "heart.slash")
                .font(.title2)
                .foregroundColor(.red)
            Text("Health data unavailable")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Travel Widget Views

@available(iOS 16.0, *)
public struct TravelLoadingView: View {
    public var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading travel info...")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

@available(iOS 16.0, *)
public struct TravelContentView: View {
    let travelData: TravelData
    let customization: WidgetCustomization
    
    public var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text(travelData.destination)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(customization.textColor)
                    Text("Destination")
                        .font(.caption)
                        .foregroundColor(customization.textColor.opacity(0.8))
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(travelData.departureTime)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(customization.accentColor)
                    Text("Departure")
                        .font(.caption)
                        .foregroundColor(customization.accentColor.opacity(0.8))
                }
            }
            
            HStack {
                TravelMetricView(title: "Flight", value: travelData.flightNumber)
                Spacer()
                TravelMetricView(title: "Weather", value: travelData.weather)
            }
        }
        .padding(customization.padding)
        .background(customization.backgroundColor)
        .cornerRadius(customization.cornerRadius)
    }
}

@available(iOS 16.0, *)
public struct TravelMetricView: View {
    let title: String
    let value: String
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
        }
    }
}

@available(iOS 16.0, *)
public struct TravelErrorView: View {
    public var body: some View {
        VStack {
            Image(systemName: "airplane")
                .font(.title2)
                .foregroundColor(.blue)
            Text("Travel data unavailable")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
} 