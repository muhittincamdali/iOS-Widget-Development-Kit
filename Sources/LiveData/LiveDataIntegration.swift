import Foundation
import Combine
import Network

/// Live Data Integration Framework
/// Provides real-time data updates for widgets with WebSocket support
@available(iOS 16.0, *)
public class LiveDataIntegration: ObservableObject {
    
    // MARK: - Properties
    
    /// Shared instance for singleton access
    public static let shared = LiveDataIntegration()
    
    /// Active data sources
    private var dataSources: [String: WidgetDataSource] = [:]
    
    /// WebSocket connections
    private var webSocketConnections: [String: NWConnection] = [:]
    
    /// Data publishers
    private var dataPublishers: [String: PassthroughSubject<WidgetData, Never>] = [:]
    
    /// Combine cancellables
    private var cancellables = Set<AnyCancellable>()
    
    /// Network monitor
    private let networkMonitor = NWPathMonitor()
    
    /// Connection queue
    private let connectionQueue = DispatchQueue(label: "com.widgetkit.connection")
    
    /// Analytics service
    private let analyticsService = WidgetAnalyticsService()
    
    // MARK: - Initialization
    
    private init() {
        setupNetworkMonitoring()
        setupDataSources()
    }
    
    // MARK: - Public Methods
    
    /// Register a data source for live updates
    /// - Parameters:
    ///   - identifier: Data source identifier
    ///   - dataSource: Data source implementation
    public func registerDataSource(_ identifier: String, dataSource: WidgetDataSource) {
        dataSources[identifier] = dataSource
        dataPublishers[identifier] = PassthroughSubject<WidgetData, Never>()
        
        setupDataSourceUpdates(for: identifier, dataSource: dataSource)
        analyticsService.logDataSourceRegistration(identifier)
    }
    
    /// Connect to WebSocket for real-time data
    /// - Parameters:
    ///   - identifier: Connection identifier
    ///   - url: WebSocket URL
    ///   - headers: Optional headers
    public func connectWebSocket(identifier: String, url: URL, headers: [String: String] = [:]) {
        let endpoint = NWEndpoint.url(url)
        let connection = NWConnection(to: endpoint, using: .ws)
        
        connection.stateUpdateHandler = { [weak self] state in
            self?.handleConnectionStateChange(identifier: identifier, state: state)
        }
        
        webSocketConnections[identifier] = connection
        connection.start(queue: connectionQueue)
        
        analyticsService.logWebSocketConnection(identifier: identifier, url: url.absoluteString)
    }
    
    /// Disconnect WebSocket
    /// - Parameter identifier: Connection identifier
    public func disconnectWebSocket(identifier: String) {
        webSocketConnections[identifier]?.cancel()
        webSocketConnections.removeValue(forKey: identifier)
        
        analyticsService.logWebSocketDisconnection(identifier: identifier)
    }
    
    /// Get data publisher for specific source
    /// - Parameter identifier: Data source identifier
    /// - Returns: Publisher for data updates
    public func getDataPublisher(for identifier: String) -> AnyPublisher<WidgetData, Never>? {
        return dataPublishers[identifier]?.eraseToAnyPublisher()
    }
    
    /// Send data to specific widget
    /// - Parameters:
    ///   - widgetId: Widget identifier
    ///   - data: Data to send
    public func sendData(to widgetId: String, data: WidgetData) {
        NotificationCenter.default.post(
            name: .widgetDataReceived,
            object: nil,
            userInfo: ["widgetId": widgetId, "data": data]
        )
        
        analyticsService.logDataSent(widgetId: widgetId, dataType: data.type.rawValue)
    }
    
    /// Configure data source settings
    /// - Parameters:
    ///   - identifier: Data source identifier
    ///   - settings: Data source settings
    public func configureDataSource(_ identifier: String, settings: DataSourceSettings) {
        dataSources[identifier]?.configure(settings)
        analyticsService.logDataSourceConfiguration(identifier: identifier)
    }
    
    /// Get connection status
    /// - Parameter identifier: Connection identifier
    /// - Returns: Connection status
    public func getConnectionStatus(for identifier: String) -> ConnectionStatus {
        guard let connection = webSocketConnections[identifier] else {
            return .disconnected
        }
        
        switch connection.state {
        case .ready:
            return .connected
        case .failed, .cancelled:
            return .disconnected
        case .preparing, .setup:
            return .connecting
        default:
            return .unknown
        }
    }
    
    // MARK: - Private Methods
    
    private func setupNetworkMonitoring() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            self?.handleNetworkPathUpdate(path)
        }
        networkMonitor.start(queue: DispatchQueue.global())
    }
    
    private func setupDataSources() {
        // Register default data sources
        registerDefaultDataSources()
    }
    
    private func registerDefaultDataSources() {
        let defaultSources: [WidgetDataSource] = [
            WeatherDataSource(),
            CalendarDataSource(),
            FitnessDataSource(),
            NewsDataSource(),
            SocialMediaDataSource(),
            ProductivityDataSource(),
            EntertainmentDataSource(),
            FinanceDataSource(),
            HealthDataSource(),
            TravelDataSource()
        ]
        
        defaultSources.forEach { dataSource in
            registerDataSource(dataSource.identifier, dataSource: dataSource)
        }
    }
    
    private func setupDataSourceUpdates(for identifier: String, dataSource: WidgetDataSource) {
        dataSource.dataPublisher
            .sink { [weak self] data in
                self?.handleDataSourceUpdate(identifier: identifier, data: data)
            }
            .store(in: &cancellables)
    }
    
    private func handleDataSourceUpdate(identifier: String, data: WidgetData) {
        dataPublishers[identifier]?.send(data)
        
        // Notify widgets using this data source
        NotificationCenter.default.post(
            name: .dataSourceUpdated,
            object: nil,
            userInfo: ["identifier": identifier, "data": data]
        )
        
        analyticsService.logDataSourceUpdate(identifier: identifier, dataType: data.type.rawValue)
    }
    
    private func handleConnectionStateChange(identifier: String, state: NWConnection.State) {
        DispatchQueue.main.async { [weak self] in
            switch state {
            case .ready:
                self?.analyticsService.logConnectionEstablished(identifier: identifier)
                self?.startReceivingData(for: identifier)
            case .failed(let error):
                self?.analyticsService.logConnectionFailed(identifier: identifier, error: error)
                self?.handleConnectionFailure(identifier: identifier, error: error)
            case .cancelled:
                self?.analyticsService.logConnectionCancelled(identifier: identifier)
            default:
                break
            }
        }
    }
    
    private func handleNetworkPathUpdate(_ path: NWPath) {
        if path.status == .satisfied {
            // Network is available, reconnect if needed
            reconnectIfNeeded()
        } else {
            // Network is unavailable
            analyticsService.logNetworkUnavailable()
        }
    }
    
    private func startReceivingData(for identifier: String) {
        guard let connection = webSocketConnections[identifier] else { return }
        
        connection.receiveMessage { [weak self] content, context, isComplete, error in
            if let error = error {
                self?.analyticsService.logDataReceiveError(identifier: identifier, error: error)
                return
            }
            
            if let content = content {
                self?.handleReceivedData(identifier: identifier, data: content)
            }
            
            // Continue receiving
            if !isComplete {
                self?.startReceivingData(for: identifier)
            }
        }
    }
    
    private func handleReceivedData(identifier: String, data: Data) {
        do {
            let widgetData = try JSONDecoder().decode(WidgetData.self, from: data)
            handleDataSourceUpdate(identifier: identifier, data: widgetData)
        } catch {
            analyticsService.logDataDecodeError(identifier: identifier, error: error)
        }
    }
    
    private func handleConnectionFailure(identifier: String, error: NWError) {
        // Implement retry logic
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            self?.retryConnection(identifier: identifier)
        }
    }
    
    private func retryConnection(identifier: String) {
        // Implement retry logic for failed connections
        analyticsService.logConnectionRetry(identifier: identifier)
    }
    
    private func reconnectIfNeeded() {
        // Reconnect any disconnected WebSocket connections
        for (identifier, connection) in webSocketConnections {
            if connection.state == .failed || connection.state == .cancelled {
                // Reconnect logic
                analyticsService.logReconnectionAttempt(identifier: identifier)
            }
        }
    }
}

// MARK: - Supporting Types

/// Data source protocol
@available(iOS 16.0, *)
public protocol WidgetDataSource {
    var identifier: String { get }
    var dataPublisher: AnyPublisher<WidgetData, Never> { get }
    
    func refresh()
    func configure(_ settings: DataSourceSettings)
}

/// Data source settings
public struct DataSourceSettings {
    public let refreshInterval: TimeInterval
    public let enableCaching: Bool
    public let maxRetries: Int
    public let timeout: TimeInterval
    
    public init(refreshInterval: TimeInterval = 30.0, enableCaching: Bool = true, maxRetries: Int = 3, timeout: TimeInterval = 10.0) {
        self.refreshInterval = refreshInterval
        self.enableCaching = enableCaching
        self.maxRetries = maxRetries
        self.timeout = timeout
    }
}

/// Connection status
public enum ConnectionStatus {
    case connected
    case connecting
    case disconnected
    case unknown
}

// MARK: - Default Data Sources

@available(iOS 16.0, *)
public class WeatherDataSource: WidgetDataSource {
    public let identifier = "weather_api"
    private let dataSubject = PassthroughSubject<WidgetData, Never>()
    public var dataPublisher: AnyPublisher<WidgetData, Never> {
        return dataSubject.eraseToAnyPublisher()
    }
    
    public func refresh() {
        // Simulate weather API call
        let weatherData = WidgetData(
            id: "weather_current",
            type: .weather,
            content: [
                "temperature": 22,
                "condition": "sunny",
                "humidity": 65,
                "windSpeed": 12
            ]
        )
        dataSubject.send(weatherData)
    }
    
    public func configure(_ settings: DataSourceSettings) {
        // Configure data source settings
    }
}

@available(iOS 16.0, *)
public class CalendarDataSource: WidgetDataSource {
    public let identifier = "calendar_events"
    private let dataSubject = PassthroughSubject<WidgetData, Never>()
    public var dataPublisher: AnyPublisher<WidgetData, Never> {
        return dataSubject.eraseToAnyPublisher()
    }
    
    public func refresh() {
        // Simulate calendar API call
        let calendarData = WidgetData(
            id: "calendar_events",
            type: .calendar,
            content: [
                "events": [
                    ["title": "Team Meeting", "time": "10:00 AM", "location": "Conference Room"],
                    ["title": "Lunch", "time": "12:30 PM", "location": "Cafeteria"]
                ]
            ]
        )
        dataSubject.send(calendarData)
    }
    
    public func configure(_ settings: DataSourceSettings) {
        // Configure data source settings
    }
}

@available(iOS 16.0, *)
public class FitnessDataSource: WidgetDataSource {
    public let identifier = "health_kit"
    private let dataSubject = PassthroughSubject<WidgetData, Never>()
    public var dataPublisher: AnyPublisher<WidgetData, Never> {
        return dataSubject.eraseToAnyPublisher()
    }
    
    public func refresh() {
        // Simulate HealthKit data
        let fitnessData = WidgetData(
            id: "fitness_current",
            type: .fitness,
            content: [
                "steps": 8420,
                "calories": 320,
                "activeMinutes": 45,
                "workouts": 2
            ]
        )
        dataSubject.send(fitnessData)
    }
    
    public func configure(_ settings: DataSourceSettings) {
        // Configure data source settings
    }
}

@available(iOS 16.0, *)
public class NewsDataSource: WidgetDataSource {
    public let identifier = "news_api"
    private let dataSubject = PassthroughSubject<WidgetData, Never>()
    public var dataPublisher: AnyPublisher<WidgetData, Never> {
        return dataSubject.eraseToAnyPublisher()
    }
    
    public func refresh() {
        // Simulate news API call
        let newsData = WidgetData(
            id: "news_latest",
            type: .news,
            content: [
                "articles": [
                    ["title": "Tech Innovation", "summary": "Latest developments in AI technology", "category": "Technology"],
                    ["title": "Market Update", "summary": "Stock market trends and analysis", "category": "Finance"]
                ]
            ]
        )
        dataSubject.send(newsData)
    }
    
    public func configure(_ settings: DataSourceSettings) {
        // Configure data source settings
    }
}

@available(iOS 16.0, *)
public class SocialMediaDataSource: WidgetDataSource {
    public let identifier = "social_api"
    private let dataSubject = PassthroughSubject<WidgetData, Never>()
    public var dataPublisher: AnyPublisher<WidgetData, Never> {
        return dataSubject.eraseToAnyPublisher()
    }
    
    public func refresh() {
        // Simulate social media API call
        let socialData = WidgetData(
            id: "social_updates",
            type: .social,
            content: [
                "updates": [
                    ["platform": "Twitter", "content": "New product launch!", "likes": 150],
                    ["platform": "Instagram", "content": "Beautiful sunset", "likes": 89]
                ]
            ]
        )
        dataSubject.send(socialData)
    }
    
    public func configure(_ settings: DataSourceSettings) {
        // Configure data source settings
    }
}

@available(iOS 16.0, *)
public class ProductivityDataSource: WidgetDataSource {
    public let identifier = "productivity_data"
    private let dataSubject = PassthroughSubject<WidgetData, Never>()
    public var dataPublisher: AnyPublisher<WidgetData, Never> {
        return dataSubject.eraseToAnyPublisher()
    }
    
    public func refresh() {
        // Simulate productivity data
        let productivityData = WidgetData(
            id: "productivity_current",
            type: .productivity,
            content: [
                "tasksCompleted": 8,
                "tasksRemaining": 3,
                "focusTime": 240,
                "productivityScore": 85
            ]
        )
        dataSubject.send(productivityData)
    }
    
    public func configure(_ settings: DataSourceSettings) {
        // Configure data source settings
    }
}

@available(iOS 16.0, *)
public class EntertainmentDataSource: WidgetDataSource {
    public let identifier = "entertainment_api"
    private let dataSubject = PassthroughSubject<WidgetData, Never>()
    public var dataPublisher: AnyPublisher<WidgetData, Never> {
        return dataSubject.eraseToAnyPublisher()
    }
    
    public func refresh() {
        // Simulate entertainment API call
        let entertainmentData = WidgetData(
            id: "entertainment_latest",
            type: .entertainment,
            content: [
                "items": [
                    ["title": "New Movie", "type": "Movie", "rating": 4.5],
                    ["title": "Popular Series", "type": "TV Show", "rating": 4.8]
                ]
            ]
        )
        dataSubject.send(entertainmentData)
    }
    
    public func configure(_ settings: DataSourceSettings) {
        // Configure data source settings
    }
}

@available(iOS 16.0, *)
public class FinanceDataSource: WidgetDataSource {
    public let identifier = "finance_api"
    private let dataSubject = PassthroughSubject<WidgetData, Never>()
    public var dataPublisher: AnyPublisher<WidgetData, Never> {
        return dataSubject.eraseToAnyPublisher()
    }
    
    public func refresh() {
        // Simulate finance API call
        let financeData = WidgetData(
            id: "finance_current",
            type: .finance,
            content: [
                "portfolioValue": 125000,
                "dailyChange": 1250,
                "topStock": "AAPL",
                "marketTrend": "Bullish"
            ]
        )
        dataSubject.send(financeData)
    }
    
    public func configure(_ settings: DataSourceSettings) {
        // Configure data source settings
    }
}

@available(iOS 16.0, *)
public class HealthDataSource: WidgetDataSource {
    public let identifier = "health_kit"
    private let dataSubject = PassthroughSubject<WidgetData, Never>()
    public var dataPublisher: AnyPublisher<WidgetData, Never> {
        return dataSubject.eraseToAnyPublisher()
    }
    
    public func refresh() {
        // Simulate health data
        let healthData = WidgetData(
            id: "health_current",
            type: .health,
            content: [
                "heartRate": 72,
                "sleepHours": 7.5,
                "waterIntake": 8,
                "mood": "Good"
            ]
        )
        dataSubject.send(healthData)
    }
    
    public func configure(_ settings: DataSourceSettings) {
        // Configure data source settings
    }
}

@available(iOS 16.0, *)
public class TravelDataSource: WidgetDataSource {
    public let identifier = "travel_api"
    private let dataSubject = PassthroughSubject<WidgetData, Never>()
    public var dataPublisher: AnyPublisher<WidgetData, Never> {
        return dataSubject.eraseToAnyPublisher()
    }
    
    public func refresh() {
        // Simulate travel API call
        let travelData = WidgetData(
            id: "travel_current",
            type: .travel,
            content: [
                "destination": "Paris",
                "departureTime": "10:30 AM",
                "flightNumber": "AF123",
                "weather": "Sunny"
            ]
        )
        dataSubject.send(travelData)
    }
    
    public func configure(_ settings: DataSourceSettings) {
        // Configure data source settings
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let widgetDataReceived = Notification.Name("widgetDataReceived")
    static let dataSourceUpdated = Notification.Name("dataSourceUpdated")
} 