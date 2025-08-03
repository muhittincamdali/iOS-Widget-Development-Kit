import Foundation
import Combine

/// Widget Error Handler
/// Provides comprehensive error handling and reporting for widgets
@available(iOS 16.0, *)
public class WidgetErrorHandler: ObservableObject {
    
    // MARK: - Properties
    
    /// Error publisher
    private let errorSubject = PassthroughSubject<WidgetError, Never>()
    public var errorPublisher: AnyPublisher<WidgetError, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
    
    /// Error log
    private var errorLog: [ErrorLogEntry] = []
    
    /// Error configuration
    private var configuration = ErrorHandlerConfiguration()
    
    /// Combine cancellables
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    public init() {
        setupErrorHandling()
    }
    
    // MARK: - Public Methods
    
    /// Handle widget error
    /// - Parameter error: Widget error
    public func handleError(_ error: WidgetError) {
        let logEntry = ErrorLogEntry(
            error: error,
            timestamp: Date(),
            context: getCurrentContext()
        )
        
        errorLog.append(logEntry)
        
        // Limit error log size
        if errorLog.count > configuration.maxErrorLogSize {
            errorLog.removeFirst(errorLog.count - configuration.maxErrorLogSize)
        }
        
        // Send error to publisher
        errorSubject.send(error)
        
        // Log error if enabled
        if configuration.enableErrorLogging {
            logError(logEntry)
        }
        
        // Send to external error reporting if enabled
        if configuration.enableExternalErrorReporting {
            sendToExternalErrorReporting(logEntry)
        }
    }
    
    /// Get error log
    /// - Returns: Array of error log entries
    public func getErrorLog() -> [ErrorLogEntry] {
        return errorLog
    }
    
    /// Clear error log
    public func clearErrorLog() {
        errorLog.removeAll()
    }
    
    /// Configure error handler
    /// - Parameter config: Error handler configuration
    public func configure(_ config: ErrorHandlerConfiguration) {
        configuration = config
    }
    
    /// Get error statistics
    /// - Returns: Error statistics
    public func getErrorStatistics() -> ErrorStatistics {
        var statistics = ErrorStatistics()
        
        for entry in errorLog {
            statistics.totalErrors += 1
            
            switch entry.error {
            case .templateNotFound:
                statistics.templateNotFoundErrors += 1
            case .dataSourceNotFound:
                statistics.dataSourceNotFoundErrors += 1
            case .connectionFailed:
                statistics.connectionFailedErrors += 1
            case .dataDecodeFailed:
                statistics.dataDecodeFailedErrors += 1
            case .networkUnavailable:
                statistics.networkUnavailableErrors += 1
            case .unknown:
                statistics.unknownErrors += 1
            }
        }
        
        return statistics
    }
    
    // MARK: - Private Methods
    
    private func setupErrorHandling() {
        // Setup error monitoring
        Timer.publish(every: 300.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.cleanupOldErrors()
            }
            .store(in: &cancellables)
    }
    
    private func getCurrentContext() -> [String: Any] {
        return [
            "timestamp": Date(),
            "memoryUsage": getCurrentMemoryUsage(),
            "batteryLevel": getCurrentBatteryLevel()
        ]
    }
    
    private func getCurrentMemoryUsage() -> UInt64 {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        return kerr == KERN_SUCCESS ? info.resident_size : 0
    }
    
    private func getCurrentBatteryLevel() -> Float {
        UIDevice.current.isBatteryMonitoringEnabled = true
        return UIDevice.current.batteryLevel
    }
    
    private func logError(_ entry: ErrorLogEntry) {
        // Implementation for local error logging
        print("Widget Error: \(entry.error.localizedDescription) at \(entry.timestamp)")
    }
    
    private func sendToExternalErrorReporting(_ entry: ErrorLogEntry) {
        // Implementation for external error reporting
        // This could send data to Crashlytics, Sentry, etc.
    }
    
    private func cleanupOldErrors() {
        let cutoffDate = Date().addingTimeInterval(-configuration.errorRetentionPeriod)
        errorLog.removeAll { entry in
            entry.timestamp < cutoffDate
        }
    }
}

// MARK: - Supporting Types

/// Error log entry
public struct ErrorLogEntry {
    public let error: WidgetError
    public let timestamp: Date
    public let context: [String: Any]
    
    public init(error: WidgetError, timestamp: Date, context: [String: Any]) {
        self.error = error
        self.timestamp = timestamp
        self.context = context
    }
}

/// Error statistics
public struct ErrorStatistics {
    public var totalErrors: Int = 0
    public var templateNotFoundErrors: Int = 0
    public var dataSourceNotFoundErrors: Int = 0
    public var connectionFailedErrors: Int = 0
    public var dataDecodeFailedErrors: Int = 0
    public var networkUnavailableErrors: Int = 0
    public var unknownErrors: Int = 0
    
    public init() {}
}

/// Error handler configuration
public struct ErrorHandlerConfiguration {
    public let enableErrorLogging: Bool
    public let enableExternalErrorReporting: Bool
    public let maxErrorLogSize: Int
    public let errorRetentionPeriod: TimeInterval
    
    public init(enableErrorLogging: Bool = true, enableExternalErrorReporting: Bool = false, maxErrorLogSize: Int = 100, errorRetentionPeriod: TimeInterval = 86400) {
        self.enableErrorLogging = enableErrorLogging
        self.enableExternalErrorReporting = enableExternalErrorReporting
        self.maxErrorLogSize = maxErrorLogSize
        self.errorRetentionPeriod = errorRetentionPeriod
    }
} 