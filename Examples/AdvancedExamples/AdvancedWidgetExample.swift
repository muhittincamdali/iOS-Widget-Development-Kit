import SwiftUI
import WidgetKit
import WidgetTemplates
import LiveDataIntegration
import WidgetAnalytics

@available(iOS 16.0, *)
struct AdvancedWidgetExample: View {
    @StateObject private var widgetEngine = WidgetEngine.shared
    @State private var selectedWidgets: [WidgetConfiguration] = []
    @State private var isLiveDataEnabled = false
    @State private var analyticsData: WidgetAnalytics?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Live Data Integration Section
                    LiveDataSection(isEnabled: $isLiveDataEnabled)
                    
                    // Widget Gallery
                    WidgetGallerySection(selectedWidgets: $selectedWidgets)
                    
                    // Analytics Dashboard
                    AnalyticsSection(analyticsData: $analyticsData)
                    
                    // Performance Monitoring
                    PerformanceSection()
                }
                .padding()
            }
            .navigationTitle("Advanced Widget Builder")
            .onAppear {
                setupLiveDataIntegration()
                loadAnalytics()
            }
        }
    }
    
    private func setupLiveDataIntegration() {
        // Register data sources
        let weatherDataSource = WeatherDataSource()
        let calendarDataSource = CalendarDataSource()
        let fitnessDataSource = FitnessDataSource()
        
        LiveDataIntegration.shared.registerDataSource("weather_api", dataSource: weatherDataSource)
        LiveDataIntegration.shared.registerDataSource("calendar_events", dataSource: calendarDataSource)
        LiveDataIntegration.shared.registerDataSource("health_kit", dataSource: fitnessDataSource)
        
        // Configure data source settings
        let settings = DataSourceSettings(
            refreshInterval: 30.0,
            enableCaching: true,
            maxRetries: 3,
            timeout: 10.0
        )
        
        LiveDataIntegration.shared.configureDataSource("weather_api", settings: settings)
        LiveDataIntegration.shared.configureDataSource("calendar_events", settings: settings)
        LiveDataIntegration.shared.configureDataSource("health_kit", settings: settings)
    }
    
    private func loadAnalytics() {
        analyticsData = widgetEngine.getAnalytics()
    }
}

@available(iOS 16.0, *)
struct LiveDataSection: View {
    @Binding var isEnabled: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Live Data Integration")
                .font(.headline)
            
            Toggle("Enable Real-time Updates", isOn: $isEnabled)
                .onChange(of: isEnabled) { newValue in
                    if newValue {
                        enableLiveData()
                    } else {
                        disableLiveData()
                    }
                }
            
            if isEnabled {
                LiveDataStatusView()
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func enableLiveData() {
        // Connect to WebSocket for real-time updates
        let weatherURL = URL(string: "ws://api.weatherapi.com/v1/current.json")!
        LiveDataIntegration.shared.connectWebSocket(identifier: "weather_ws", url: weatherURL)
        
        let calendarURL = URL(string: "ws://api.calendar.com/events")!
        LiveDataIntegration.shared.connectWebSocket(identifier: "calendar_ws", url: calendarURL)
    }
    
    private func disableLiveData() {
        LiveDataIntegration.shared.disconnectWebSocket(identifier: "weather_ws")
        LiveDataIntegration.shared.disconnectWebSocket(identifier: "calendar_ws")
    }
}

@available(iOS 16.0, *)
struct LiveDataStatusView: View {
    @State private var weatherStatus: ConnectionStatus = .connecting
    @State private var calendarStatus: ConnectionStatus = .connecting
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Weather API")
                Spacer()
                ConnectionStatusIndicator(status: weatherStatus)
            }
            
            HStack {
                Text("Calendar API")
                Spacer()
                ConnectionStatusIndicator(status: calendarStatus)
            }
        }
        .onAppear {
            updateConnectionStatus()
        }
    }
    
    private func updateConnectionStatus() {
        weatherStatus = LiveDataIntegration.shared.getConnectionStatus(for: "weather_ws")
        calendarStatus = LiveDataIntegration.shared.getConnectionStatus(for: "calendar_ws")
    }
}

@available(iOS 16.0, *)
struct ConnectionStatusIndicator: View {
    let status: ConnectionStatus
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
            
            Text(statusText)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    private var statusColor: Color {
        switch status {
        case .connected: return .green
        case .connecting: return .orange
        case .disconnected: return .red
        case .unknown: return .gray
        }
    }
    
    private var statusText: String {
        switch status {
        case .connected: return "Connected"
        case .connecting: return "Connecting"
        case .disconnected: return "Disconnected"
        case .unknown: return "Unknown"
        }
    }
}

@available(iOS 16.0, *)
struct WidgetGallerySection: View {
    @Binding var selectedWidgets: [WidgetConfiguration]
    
    let availableTemplates: [WidgetTemplate] = [
        WeatherWidgetTemplate(),
        CalendarWidgetTemplate(),
        FitnessWidgetTemplate(),
        NewsWidgetTemplate(),
        SocialMediaWidgetTemplate(),
        ProductivityWidgetTemplate(),
        EntertainmentWidgetTemplate(),
        FinanceWidgetTemplate(),
        HealthWidgetTemplate(),
        TravelWidgetTemplate()
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Widget Gallery")
                .font(.headline)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                ForEach(availableTemplates, id: \.identifier) { template in
                    WidgetTemplateCard(template: template) {
                        addWidget(template: template)
                    }
                }
            }
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func addWidget(template: WidgetTemplate) {
        let configuration = template.getDefaultConfiguration()
        selectedWidgets.append(configuration)
    }
}

@available(iOS 16.0, *)
struct WidgetTemplateCard: View {
    let template: WidgetTemplate
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: iconName)
                .font(.title2)
                .foregroundColor(.blue)
            
            Text(template.displayName)
                .font(.caption)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            Text(template.description)
                .font(.caption2)
                .foregroundColor(.secondary)
                .lineLimit(3)
        }
        .frame(height: 100)
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
        .onTapGesture {
            onTap()
        }
    }
    
    private var iconName: String {
        switch template.identifier {
        case "weather_widget": return "cloud.sun.fill"
        case "calendar_widget": return "calendar"
        case "fitness_widget": return "figure.walk"
        case "news_widget": return "newspaper"
        case "social_media_widget": return "bubble.left.and.bubble.right"
        case "productivity_widget": return "chart.line.uptrend.xyaxis"
        case "entertainment_widget": return "play.circle"
        case "finance_widget": return "dollarsign.circle"
        case "health_widget": return "heart.fill"
        case "travel_widget": return "airplane"
        default: return "square.fill"
        }
    }
}

@available(iOS 16.0, *)
struct AnalyticsSection: View {
    @Binding var analyticsData: WidgetAnalytics?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Analytics Dashboard")
                .font(.headline)
            
            if let analytics = analyticsData {
                AnalyticsGridView(analytics: analytics)
            } else {
                ProgressView("Loading analytics...")
            }
        }
        .padding()
        .background(Color.purple.opacity(0.1))
        .cornerRadius(12)
    }
}

@available(iOS 16.0, *)
struct AnalyticsGridView: View {
    let analytics: WidgetAnalytics
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
            AnalyticsCard(title: "Total Updates", value: "\(analytics.totalWidgetUpdates)")
            AnalyticsCard(title: "Memory Usage", value: "\(analytics.memoryUsage / 1024 / 1024) MB")
            AnalyticsCard(title: "Connections", value: "\(analytics.connectionsEstablished)")
            AnalyticsCard(title: "Errors", value: "\(analytics.errors)")
        }
    }
}

@available(iOS 16.0, *)
struct AnalyticsCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.caption)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(Color.white)
        .cornerRadius(6)
    }
}

@available(iOS 16.0, *)
struct PerformanceSection: View {
    @StateObject private var performanceMetrics = WidgetEngine.shared.performanceMetrics
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Performance Monitoring")
                .font(.headline)
            
            VStack(spacing: 10) {
                PerformanceMetricRow(title: "Memory Usage", value: "\(performanceMetrics.memoryUsage / 1024 / 1024) MB")
                PerformanceMetricRow(title: "Battery Level", value: "\(Int(performanceMetrics.batteryLevel * 100))%")
                PerformanceMetricRow(title: "Refresh Count", value: "\(performanceMetrics.refreshCount)")
                PerformanceMetricRow(title: "Error Count", value: "\(performanceMetrics.errorCount)")
            }
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
    }
}

@available(iOS 16.0, *)
struct PerformanceMetricRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.caption)
            Spacer()
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
        }
    }
}

@available(iOS 16.0, *)
struct AdvancedWidgetExample_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedWidgetExample()
    }
} 