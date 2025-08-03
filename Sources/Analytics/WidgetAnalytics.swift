import Foundation
import Combine

/// Widget Analytics Service
/// Provides comprehensive analytics and performance tracking for widgets
@available(iOS 16.0, *)
public class WidgetAnalyticsService: ObservableObject {
    
    // MARK: - Properties
    
    /// Analytics data storage
    private var analyticsData = WidgetAnalytics()
    
    /// Performance metrics
    private let performanceSubject = PassthroughSubject<WidgetPerformanceMetrics, Never>()
    public var performancePublisher: AnyPublisher<WidgetPerformanceMetrics, Never> {
        return performanceSubject.eraseToAnyPublisher()
    }
    
    /// Event tracking
    private var eventLog: [AnalyticsEvent] = []
    
    /// Performance monitoring
    private var performanceMetrics = WidgetPerformanceMetrics()
    
    /// Combine cancellables
    private var cancellables = Set<AnyCancellable>()
    
    /// Analytics configuration
    private var configuration = AnalyticsConfiguration()
    
    // MARK: - Initialization
    
    public init() {
        setupAnalytics()
    }
    
    // MARK: - Public Methods
    
    /// Get current analytics data
    /// - Returns: Analytics data
    public func getAnalytics() -> WidgetAnalytics {
        return analyticsData
    }
    
    /// Log widget update
    /// - Parameter widgetId: Widget identifier
    public func logWidgetUpdate(widgetId: String) {
        let event = AnalyticsEvent(
            type: .widgetUpdate,
            widgetId: widgetId,
            timestamp: Date(),
            metadata: ["widgetId": widgetId]
        )
        
        logEvent(event)
        updateWidgetMetrics(widgetId: widgetId)
    }
    
    /// Log template registration
    /// - Parameter templateId: Template identifier
    public func logTemplateRegistration(_ templateId: String) {
        let event = AnalyticsEvent(
            type: .templateRegistration,
            widgetId: nil,
            timestamp: Date(),
            metadata: ["templateId": templateId]
        )
        
        logEvent(event)
        analyticsData.templateRegistrations += 1
    }
    
    /// Log data source registration
    /// - Parameter identifier: Data source identifier
    public func logDataSourceRegistration(_ identifier: String) {
        let event = AnalyticsEvent(
            type: .dataSourceRegistration,
            widgetId: nil,
            timestamp: Date(),
            metadata: ["dataSourceId": identifier]
        )
        
        logEvent(event)
        analyticsData.dataSourceRegistrations += 1
    }
    
    /// Log WebSocket connection
    /// - Parameters:
    ///   - identifier: Connection identifier
    ///   - url: Connection URL
    public func logWebSocketConnection(identifier: String, url: String) {
        let event = AnalyticsEvent(
            type: .webSocketConnection,
            widgetId: nil,
            timestamp: Date(),
            metadata: ["identifier": identifier, "url": url]
        )
        
        logEvent(event)
        analyticsData.webSocketConnections += 1
    }
    
    /// Log WebSocket disconnection
    /// - Parameter identifier: Connection identifier
    public func logWebSocketDisconnection(identifier: String) {
        let event = AnalyticsEvent(
            type: .webSocketDisconnection,
            widgetId: nil,
            timestamp: Date(),
            metadata: ["identifier": identifier]
        )
        
        logEvent(event)
        analyticsData.webSocketDisconnections += 1
    }
    
    /// Log data sent
    /// - Parameters:
    ///   - widgetId: Widget identifier
    ///   - dataType: Data type
    public func logDataSent(widgetId: String, dataType: String) {
        let event = AnalyticsEvent(
            type: .dataSent,
            widgetId: widgetId,
            timestamp: Date(),
            metadata: ["widgetId": widgetId, "dataType": dataType]
        )
        
        logEvent(event)
        analyticsData.dataSentCount += 1
    }
    
    /// Log data source update
    /// - Parameters:
    ///   - identifier: Data source identifier
    ///   - dataType: Data type
    public func logDataSourceUpdate(identifier: String, dataType: String) {
        let event = AnalyticsEvent(
            type: .dataSourceUpdate,
            widgetId: nil,
            timestamp: Date(),
            metadata: ["identifier": identifier, "dataType": dataType]
        )
        
        logEvent(event)
        analyticsData.dataSourceUpdates += 1
    }
    
    /// Log data source configuration
    /// - Parameter identifier: Data source identifier
    public func logDataSourceConfiguration(identifier: String) {
        let event = AnalyticsEvent(
            type: .dataSourceConfiguration,
            widgetId: nil,
            timestamp: Date(),
            metadata: ["identifier": identifier]
        )
        
        logEvent(event)
        analyticsData.dataSourceConfigurations += 1
    }
    
    /// Log connection established
    /// - Parameter identifier: Connection identifier
    public func logConnectionEstablished(identifier: String) {
        let event = AnalyticsEvent(
            type: .connectionEstablished,
            widgetId: nil,
            timestamp: Date(),
            metadata: ["identifier": identifier]
        )
        
        logEvent(event)
        analyticsData.connectionsEstablished += 1
    }
    
    /// Log connection failed
    /// - Parameters:
    ///   - identifier: Connection identifier
    ///   - error: Error details
    public func logConnectionFailed(identifier: String, error: Error) {
        let event = AnalyticsEvent(
            type: .connectionFailed,
            widgetId: nil,
            timestamp: Date(),
            metadata: ["identifier": identifier, "error": error.localizedDescription]
        )
        
        logEvent(event)
        analyticsData.connectionFailures += 1
    }
    
    /// Log connection cancelled
    /// - Parameter identifier: Connection identifier
    public func logConnectionCancelled(identifier: String) {
        let event = AnalyticsEvent(
            type: .connectionCancelled,
            widgetId: nil,
            timestamp: Date(),
            metadata: ["identifier": identifier]
        )
        
        logEvent(event)
        analyticsData.connectionsCancelled += 1
    }
    
    /// Log connection retry
    /// - Parameter identifier: Connection identifier
    public func logConnectionRetry(identifier: String) {
        let event = AnalyticsEvent(
            type: .connectionRetry,
            widgetId: nil,
            timestamp: Date(),
            metadata: ["identifier": identifier]
        )
        
        logEvent(event)
        analyticsData.connectionRetries += 1
    }
    
    /// Log reconnection attempt
    /// - Parameter identifier: Connection identifier
    public func logReconnectionAttempt(identifier: String) {
        let event = AnalyticsEvent(
            type: .reconnectionAttempt,
            widgetId: nil,
            timestamp: Date(),
            metadata: ["identifier": identifier]
        )
        
        logEvent(event)
        analyticsData.reconnectionAttempts += 1
    }
    
    /// Log data receive error
    /// - Parameters:
    ///   - identifier: Connection identifier
    ///   - error: Error details
    public func logDataReceiveError(identifier: String, error: Error) {
        let event = AnalyticsEvent(
            type: .dataReceiveError,
            widgetId: nil,
            timestamp: Date(),
            metadata: ["identifier": identifier, "error": error.localizedDescription]
        )
        
        logEvent(event)
        analyticsData.dataReceiveErrors += 1
    }
    
    /// Log data decode error
    /// - Parameters:
    ///   - identifier: Connection identifier
    ///   - error: Error details
    public func logDataDecodeError(identifier: String, error: Error) {
        let event = AnalyticsEvent(
            type: .dataDecodeError,
            widgetId: nil,
            timestamp: Date(),
            metadata: ["identifier": identifier, "error": error.localizedDescription]
        )
        
        logEvent(event)
        analyticsData.dataDecodeErrors += 1
    }
    
    /// Log network unavailable
    public func logNetworkUnavailable() {
        let event = AnalyticsEvent(
            type: .networkUnavailable,
            widgetId: nil,
            timestamp: Date(),
            metadata: [:]
        )
        
        logEvent(event)
        analyticsData.networkUnavailableEvents += 1
    }
    
    /// Log memory cleanup
    /// - Parameter removedEntries: Number of removed cache entries
    public func logMemoryCleanup(removedEntries: Int) {
        let event = AnalyticsEvent(
            type: .memoryCleanup,
            widgetId: nil,
            timestamp: Date(),
            metadata: ["removedEntries": removedEntries]
        )
        
        logEvent(event)
        analyticsData.memoryCleanups += 1
    }
    
    /// Log battery optimization
    /// - Parameter newInterval: New refresh interval
    public func logBatteryOptimization(newInterval: TimeInterval) {
        let event = AnalyticsEvent(
            type: .batteryOptimization,
            widgetId: nil,
            timestamp: Date(),
            metadata: ["newInterval": newInterval]
        )
        
        logEvent(event)
        analyticsData.batteryOptimizations += 1
    }
    
    /// Log error
    /// - Parameter error: Widget error
    public func logError(_ error: WidgetError) {
        let event = AnalyticsEvent(
            type: .error,
            widgetId: nil,
            timestamp: Date(),
            metadata: ["error": error.localizedDescription]
        )
        
        logEvent(event)
        analyticsData.errors += 1
    }
    
    /// Log engine initialization
    public func logEngineInitialization() {
        let event = AnalyticsEvent(
            type: .engineInitialization,
            widgetId: nil,
            timestamp: Date(),
            metadata: [:]
        )
        
        logEvent(event)
        analyticsData.engineInitializations += 1
    }
    
    /// Configure analytics
    /// - Parameter config: Analytics configuration
    public func configure(_ config: AnalyticsConfiguration) {
        configuration = config
    }
    
    /// Export analytics data
    /// - Returns: Exported analytics data
    public func exportAnalytics() -> Data? {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            return try encoder.encode(analyticsData)
        } catch {
            return nil
        }
    }
    
    /// Clear analytics data
    public func clearAnalytics() {
        analyticsData = WidgetAnalytics()
        eventLog.removeAll()
    }
    
    // MARK: - Private Methods
    
    private func setupAnalytics() {
        // Setup performance monitoring
        Timer.publish(every: 60.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updatePerformanceMetrics()
            }
            .store(in: &cancellables)
    }
    
    private func logEvent(_ event: AnalyticsEvent) {
        eventLog.append(event)
        
        // Limit event log size
        if eventLog.count > configuration.maxEventLogSize {
            eventLog.removeFirst(eventLog.count - configuration.maxEventLogSize)
        }
        
        // Send to external analytics if configured
        if configuration.enableExternalAnalytics {
            sendToExternalAnalytics(event)
        }
    }
    
    private func updateWidgetMetrics(widgetId: String) {
        analyticsData.widgetUpdates[widgetId, default: 0] += 1
        analyticsData.totalWidgetUpdates += 1
    }
    
    private func updatePerformanceMetrics() {
        performanceSubject.send(performanceMetrics)
    }
    
    private func sendToExternalAnalytics(_ event: AnalyticsEvent) {
        // Implementation for external analytics service
        // This could send data to Firebase, Mixpanel, etc.
    }
}

// MARK: - Supporting Types

/// Analytics data structure
public struct WidgetAnalytics: Codable {
    public var totalWidgetUpdates: Int = 0
    public var widgetUpdates: [String: Int] = [:]
    public var templateRegistrations: Int = 0
    public var dataSourceRegistrations: Int = 0
    public var webSocketConnections: Int = 0
    public var webSocketDisconnections: Int = 0
    public var dataSentCount: Int = 0
    public var dataSourceUpdates: Int = 0
    public var dataSourceConfigurations: Int = 0
    public var connectionsEstablished: Int = 0
    public var connectionFailures: Int = 0
    public var connectionsCancelled: Int = 0
    public var connectionRetries: Int = 0
    public var reconnectionAttempts: Int = 0
    public var dataReceiveErrors: Int = 0
    public var dataDecodeErrors: Int = 0
    public var networkUnavailableEvents: Int = 0
    public var memoryCleanups: Int = 0
    public var batteryOptimizations: Int = 0
    public var errors: Int = 0
    public var engineInitializations: Int = 0
    public var sessionStartTime: Date = Date()
    public var lastUpdateTime: Date = Date()
    
    public init() {}
}

/// Analytics event
public struct AnalyticsEvent {
    public let type: AnalyticsEventType
    public let widgetId: String?
    public let timestamp: Date
    public let metadata: [String: Any]
    
    public init(type: AnalyticsEventType, widgetId: String?, timestamp: Date, metadata: [String: Any]) {
        self.type = type
        self.widgetId = widgetId
        self.timestamp = timestamp
        self.metadata = metadata
    }
}

/// Analytics event types
public enum AnalyticsEventType: String, CaseIterable {
    case widgetUpdate = "widget_update"
    case templateRegistration = "template_registration"
    case dataSourceRegistration = "data_source_registration"
    case webSocketConnection = "websocket_connection"
    case webSocketDisconnection = "websocket_disconnection"
    case dataSent = "data_sent"
    case dataSourceUpdate = "data_source_update"
    case dataSourceConfiguration = "data_source_configuration"
    case connectionEstablished = "connection_established"
    case connectionFailed = "connection_failed"
    case connectionCancelled = "connection_cancelled"
    case connectionRetry = "connection_retry"
    case reconnectionAttempt = "reconnection_attempt"
    case dataReceiveError = "data_receive_error"
    case dataDecodeError = "data_decode_error"
    case networkUnavailable = "network_unavailable"
    case memoryCleanup = "memory_cleanup"
    case batteryOptimization = "battery_optimization"
    case error = "error"
    case engineInitialization = "engine_initialization"
}

/// Analytics configuration
public struct AnalyticsConfiguration {
    public let enableExternalAnalytics: Bool
    public let maxEventLogSize: Int
    public let enablePerformanceTracking: Bool
    public let enableErrorTracking: Bool
    
    public init(enableExternalAnalytics: Bool = false, maxEventLogSize: Int = 1000, enablePerformanceTracking: Bool = true, enableErrorTracking: Bool = true) {
        self.enableExternalAnalytics = enableExternalAnalytics
        self.maxEventLogSize = maxEventLogSize
        self.enablePerformanceTracking = enablePerformanceTracking
        self.enableErrorTracking = enableErrorTracking
    }
}

/// Widget error types
public enum WidgetError: Error, LocalizedError {
    case templateNotFound(String)
    case dataSourceNotFound(String)
    case connectionFailed(String)
    case dataDecodeFailed(String)
    case networkUnavailable
    case unknown
    
    public var errorDescription: String? {
        switch self {
        case .templateNotFound(let templateId):
            return "Template not found: \(templateId)"
        case .dataSourceNotFound(let dataSourceId):
            return "Data source not found: \(dataSourceId)"
        case .connectionFailed(let reason):
            return "Connection failed: \(reason)"
        case .dataDecodeFailed(let reason):
            return "Data decode failed: \(reason)"
        case .networkUnavailable:
            return "Network unavailable"
        case .unknown:
            return "Unknown error occurred"
        }
    }
    
    public var localizedDescription: String {
        return errorDescription ?? "Unknown error"
    }
} 