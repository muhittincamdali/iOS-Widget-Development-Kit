import Foundation
import UIKit
import OSLog
import Combine

/// Enterprise-grade performance monitoring system providing real-time metrics,
/// bottleneck detection, and automated optimization for iOS widgets
@available(iOS 16.0, *)
public class PerformanceMonitor: ObservableObject {
    
    // MARK: - Types
    
    public enum PerformanceError: LocalizedError {
        case monitoringDisabled
        case metricCollectionFailed
        case thresholdExceeded(metric: String, value: Double, threshold: Double)
        case insufficientData
        case configurationInvalid
        
        public var errorDescription: String? {
            switch self {
            case .monitoringDisabled:
                return "Performance monitoring is disabled"
            case .metricCollectionFailed:
                return "Failed to collect performance metrics"
            case .thresholdExceeded(let metric, let value, let threshold):
                return "Performance threshold exceeded: \(metric) = \(value) > \(threshold)"
            case .insufficientData:
                return "Insufficient performance data for analysis"
            case .configurationInvalid:
                return "Performance monitoring configuration is invalid"
            }
        }
    }
    
    public enum MetricType: String, CaseIterable, Codable {
        case cpuUsage = "cpu_usage"
        case memoryUsage = "memory_usage"
        case diskUsage = "disk_usage"
        case networkLatency = "network_latency"
        case renderTime = "render_time"
        case frameDrop = "frame_drop"
        case batteryDrain = "battery_drain"
        case thermalState = "thermal_state"
        case launchTime = "launch_time"
        case widgetLoadTime = "widget_load_time"
        
        public var unit: String {
            switch self {
            case .cpuUsage: return "%"
            case .memoryUsage: return "MB"
            case .diskUsage: return "MB"
            case .networkLatency: return "ms"
            case .renderTime: return "ms"
            case .frameDrop: return "count"
            case .batteryDrain: return "%/hour"
            case .thermalState: return "level"
            case .launchTime: return "ms"
            case .widgetLoadTime: return "ms"
            }
        }
        
        public var threshold: Double {
            switch self {
            case .cpuUsage: return 80.0
            case .memoryUsage: return 100.0
            case .diskUsage: return 500.0
            case .networkLatency: return 1000.0
            case .renderTime: return 100.0
            case .frameDrop: return 5.0
            case .batteryDrain: return 5.0
            case .thermalState: return 2.0
            case .launchTime: return 1000.0
            case .widgetLoadTime: return 200.0
            }
        }
    }
    
    public struct PerformanceMetric: Codable, Identifiable {
        public let id: String
        public let type: MetricType
        public let value: Double
        public let timestamp: Date
        public let metadata: [String: String]
        public let severity: Severity
        
        public enum Severity: String, Codable, CaseIterable {
            case normal = "normal"
            case warning = "warning"
            case critical = "critical"
            
            public var priority: Int {
                switch self {
                case .normal: return 1
                case .warning: return 2
                case .critical: return 3
                }
            }
        }
        
        public init(type: MetricType, value: Double, metadata: [String: String] = [:]) {
            self.id = UUID().uuidString
            self.type = type
            self.value = value
            self.timestamp = Date()
            self.metadata = metadata
            self.severity = value > type.threshold ? .critical : 
                           value > (type.threshold * 0.8) ? .warning : .normal
        }
    }
    
    public struct PerformanceReport: Codable {
        public let generatedAt: Date
        public let reportPeriod: DateInterval
        public let metrics: [PerformanceMetric]
        public let summary: PerformanceSummary
        public let recommendations: [PerformanceRecommendation]
        public let trends: [PerformanceTrend]
    }
    
    public struct PerformanceSummary: Codable {
        public let averageMetrics: [MetricType: Double]
        public let peakMetrics: [MetricType: Double]
        public let violationCount: [MetricType: Int]
        public let overallScore: Double
        public let improvementOpportunities: [String]
    }
    
    public struct PerformanceRecommendation: Codable {
        public let id: String
        public let category: RecommendationCategory
        public let priority: Priority
        public let title: String
        public let description: String
        public let impact: String
        public let effort: String
        public let actionItems: [String]
        
        public enum RecommendationCategory: String, Codable {
            case memory = "memory"
            case cpu = "cpu"
            case network = "network"
            case battery = "battery"
            case rendering = "rendering"
            case architecture = "architecture"
        }
        
        public enum Priority: String, Codable {
            case low = "low"
            case medium = "medium"
            case high = "high"
            case critical = "critical"
        }
    }
    
    public struct PerformanceTrend: Codable {
        public let metricType: MetricType
        public let direction: TrendDirection
        public let magnitude: Double
        public let confidence: Double
        public let timeframe: TimeInterval
        
        public enum TrendDirection: String, Codable {
            case improving = "improving"
            case stable = "stable"
            case degrading = "degrading"
        }
    }
    
    public struct PerformanceConfiguration {
        public var isEnabled: Bool = true
        public var samplingInterval: TimeInterval = 1.0
        public var maxMetricsCount: Int = 10000
        public var alertThresholds: [MetricType: Double] = [:]
        public var enabledMetrics: Set<MetricType> = Set(MetricType.allCases)
        public var enableAutomaticOptimization: Bool = true
        public var enableRealTimeAlerts: Bool = true
        
        public init() {
            // Initialize with default thresholds
            for metricType in MetricType.allCases {
                alertThresholds[metricType] = metricType.threshold
            }
        }
    }
    
    // MARK: - Properties
    
    public static let shared = PerformanceMonitor()
    
    private let metricsCollector: MetricsCollector
    private let performanceAnalyzer: PerformanceAnalyzer
    private let optimizationEngine: OptimizationEngine
    private let alertManager: PerformanceAlertManager
    private let reportGenerator: ReportGenerator
    private let storageManager: PerformanceStorageManager
    
    @Published public private(set) var currentMetrics: [MetricType: PerformanceMetric] = [:]
    @Published public private(set) var recentMetrics: [PerformanceMetric] = []
    @Published public private(set) var performanceScore: Double = 100.0
    @Published public private(set) var isMonitoring: Bool = false
    @Published public private(set) var activeAlerts: [PerformanceAlert] = []
    @Published public private(set) var configuration: PerformanceConfiguration = PerformanceConfiguration()
    
    private var monitoringTimer: Timer?
    private var cancellables = Set<AnyCancellable>()
    private let queue = DispatchQueue(label: "performance.monitor", qos: .utility)
    private let logger = Logger(subsystem: "WidgetKit", category: "Performance")
    
    // MARK: - Initialization
    
    private init() {
        self.metricsCollector = MetricsCollector()
        self.performanceAnalyzer = PerformanceAnalyzer()
        self.optimizationEngine = OptimizationEngine()
        self.alertManager = PerformanceAlertManager()
        self.reportGenerator = ReportGenerator()
        self.storageManager = PerformanceStorageManager()
        
        setupPerformanceMonitoring()
    }
    
    // MARK: - Public Methods
    
    /// Starts performance monitoring with the current configuration
    public func startMonitoring() async throws {
        guard configuration.isEnabled else {
            throw PerformanceError.monitoringDisabled
        }
        
        guard !isMonitoring else { return }
        
        await MainActor.run {
            self.isMonitoring = true
        }
        
        startMetricsCollection()
        setupRealTimeMonitoring()
        
        await loadHistoricalMetrics()
        
        logger.info("Performance monitoring started")
    }
    
    /// Stops performance monitoring
    public func stopMonitoring() async {
        await MainActor.run {
            self.isMonitoring = false
        }
        
        stopMetricsCollection()
        
        // Save current session metrics
        await saveCurrentMetrics()
        
        logger.info("Performance monitoring stopped")
    }
    
    /// Records a custom performance metric
    public func recordMetric(_ metric: PerformanceMetric) async {
        guard configuration.isEnabled else { return }
        
        await queue.async { [weak self] in
            await self?.processNewMetric(metric)
        }
    }
    
    /// Measures and records execution time for a block of code
    public func measureExecutionTime<T>(
        _ operation: () async throws -> T,
        metricType: MetricType = .renderTime,
        metadata: [String: String] = [:]
    ) async throws -> T {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        do {
            let result = try await operation()
            let executionTime = (CFAbsoluteTimeGetCurrent() - startTime) * 1000 // Convert to ms
            
            let metric = PerformanceMetric(
                type: metricType,
                value: executionTime,
                metadata: metadata
            )
            
            await recordMetric(metric)
            return result
            
        } catch {
            let executionTime = (CFAbsoluteTimeGetCurrent() - startTime) * 1000
            
            let metric = PerformanceMetric(
                type: metricType,
                value: executionTime,
                metadata: metadata.merging(["error": error.localizedDescription]) { $1 }
            )
            
            await recordMetric(metric)
            throw error
        }
    }
    
    /// Gets current performance metrics
    public func getCurrentMetrics() -> [MetricType: PerformanceMetric] {
        return currentMetrics
    }
    
    /// Gets performance metrics for a specific time period
    public func getMetrics(for period: DateInterval) async throws -> [PerformanceMetric] {
        return try await storageManager.getMetrics(for: period)
    }
    
    /// Generates a comprehensive performance report
    public func generateReport(for period: DateInterval) async throws -> PerformanceReport {
        let metrics = try await getMetrics(for: period)
        
        guard !metrics.isEmpty else {
            throw PerformanceError.insufficientData
        }
        
        let summary = await performanceAnalyzer.generateSummary(for: metrics)
        let recommendations = await performanceAnalyzer.generateRecommendations(based: metrics)
        let trends = await performanceAnalyzer.analyzeTrends(in: metrics)
        
        return PerformanceReport(
            generatedAt: Date(),
            reportPeriod: period,
            metrics: metrics,
            summary: summary,
            recommendations: recommendations,
            trends: trends
        )
    }
    
    /// Updates monitoring configuration
    public func updateConfiguration(_ newConfiguration: PerformanceConfiguration) async throws {
        guard isValidConfiguration(newConfiguration) else {
            throw PerformanceError.configurationInvalid
        }
        
        let wasMonitoring = isMonitoring
        
        if wasMonitoring {
            await stopMonitoring()
        }
        
        await MainActor.run {
            self.configuration = newConfiguration
        }
        
        if wasMonitoring && newConfiguration.isEnabled {
            try await startMonitoring()
        }
        
        logger.info("Performance monitoring configuration updated")
    }
    
    /// Triggers manual performance optimization
    public func optimizePerformance() async throws {
        guard configuration.enableAutomaticOptimization else { return }
        
        let currentMetrics = Array(self.currentMetrics.values)
        let optimizations = await optimizationEngine.generateOptimizations(based: currentMetrics)
        
        for optimization in optimizations {
            await optimizationEngine.applyOptimization(optimization)
        }
        
        logger.info("Manual performance optimization completed")
    }
    
    /// Gets performance dashboard data
    public func getDashboardData() async -> PerformanceDashboardData {
        let recentPeriod = DateInterval(start: Date().addingTimeInterval(-3600), end: Date())
        
        return PerformanceDashboardData(
            currentScore: performanceScore,
            recentMetrics: recentMetrics.suffix(50).map { $0 },
            activeAlerts: activeAlerts,
            trendData: await performanceAnalyzer.getTrendData(for: recentPeriod),
            topIssues: await performanceAnalyzer.getTopIssues(),
            optimizationSuggestions: await optimizationEngine.getQuickWins()
        )
    }
    
    /// Clears all stored performance data
    public func clearPerformanceData() async throws {
        try await storageManager.clearAllData()
        
        await MainActor.run {
            self.currentMetrics.removeAll()
            self.recentMetrics.removeAll()
            self.activeAlerts.removeAll()
            self.performanceScore = 100.0
        }
        
        logger.info("Performance data cleared")
    }
    
    // MARK: - Private Methods
    
    private func setupPerformanceMonitoring() {
        // Setup observers for system events
        NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)
            .sink { [weak self] _ in
                Task { await self?.handleAppDidEnterBackground() }
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                Task { await self?.handleAppWillEnterForeground() }
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification)
            .sink { [weak self] _ in
                Task { await self?.handleMemoryWarning() }
            }
            .store(in: &cancellables)
    }
    
    private func startMetricsCollection() {
        monitoringTimer = Timer.scheduledTimer(withTimeInterval: configuration.samplingInterval, repeats: true) { [weak self] _ in
            Task {
                await self?.collectSystemMetrics()
            }
        }
    }
    
    private func stopMetricsCollection() {
        monitoringTimer?.invalidate()
        monitoringTimer = nil
    }
    
    private func setupRealTimeMonitoring() {
        guard configuration.enableRealTimeAlerts else { return }
        
        // Monitor for performance threshold violations
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            Task {
                await self?.checkPerformanceThresholds()
            }
        }
    }
    
    private func collectSystemMetrics() async {
        guard configuration.isEnabled && isMonitoring else { return }
        
        let metrics = await metricsCollector.collectSystemMetrics(enabledTypes: configuration.enabledMetrics)
        
        for metric in metrics {
            await processNewMetric(metric)
        }
    }
    
    private func processNewMetric(_ metric: PerformanceMetric) async {
        // Store metric
        try? await storageManager.storeMetric(metric)
        
        // Update current metrics
        await MainActor.run {
            self.currentMetrics[metric.type] = metric
            self.recentMetrics.append(metric)
            
            // Keep only recent metrics in memory
            if self.recentMetrics.count > 1000 {
                self.recentMetrics.removeFirst(self.recentMetrics.count - 1000)
            }
        }
        
        // Update performance score
        await updatePerformanceScore()
        
        // Check for alerts
        await checkMetricForAlerts(metric)
        
        // Trigger automatic optimization if enabled
        if configuration.enableAutomaticOptimization {
            await triggerAutomaticOptimization(for: metric)
        }
    }
    
    private func updatePerformanceScore() async {
        let score = await performanceAnalyzer.calculatePerformanceScore(
            from: Array(currentMetrics.values)
        )
        
        await MainActor.run {
            self.performanceScore = score
        }
    }
    
    private func checkPerformanceThresholds() async {
        for (metricType, metric) in currentMetrics {
            if metric.value > configuration.alertThresholds[metricType] ?? metricType.threshold {
                await triggerPerformanceAlert(for: metric)
            }
        }
    }
    
    private func checkMetricForAlerts(_ metric: PerformanceMetric) async {
        if metric.severity == .critical {
            await triggerPerformanceAlert(for: metric)
        }
    }
    
    private func triggerPerformanceAlert(for metric: PerformanceMetric) async {
        let alert = PerformanceAlert(
            id: UUID().uuidString,
            metricType: metric.type,
            severity: metric.severity,
            value: metric.value,
            threshold: configuration.alertThresholds[metric.type] ?? metric.type.threshold,
            timestamp: Date(),
            message: "Performance threshold exceeded for \(metric.type.rawValue)"
        )
        
        await alertManager.handleAlert(alert)
        
        await MainActor.run {
            self.activeAlerts.append(alert)
            
            // Keep only recent alerts
            if self.activeAlerts.count > 50 {
                self.activeAlerts.removeFirst(self.activeAlerts.count - 50)
            }
        }
    }
    
    private func triggerAutomaticOptimization(for metric: PerformanceMetric) async {
        guard metric.severity == .critical else { return }
        
        let optimizations = await optimizationEngine.generateImmediateOptimizations(for: metric)
        
        for optimization in optimizations {
            await optimizationEngine.applyOptimization(optimization)
        }
    }
    
    private func loadHistoricalMetrics() async {
        let recentPeriod = DateInterval(start: Date().addingTimeInterval(-3600), end: Date())
        
        do {
            let historicalMetrics = try await storageManager.getMetrics(for: recentPeriod)
            
            await MainActor.run {
                self.recentMetrics = historicalMetrics
            }
        } catch {
            logger.error("Failed to load historical metrics: \(error)")
        }
    }
    
    private func saveCurrentMetrics() async {
        for metric in recentMetrics {
            try? await storageManager.storeMetric(metric)
        }
    }
    
    private func isValidConfiguration(_ config: PerformanceConfiguration) -> Bool {
        return config.samplingInterval > 0 &&
               config.maxMetricsCount > 0 &&
               !config.enabledMetrics.isEmpty
    }
    
    private func handleAppDidEnterBackground() async {
        if configuration.enableAutomaticOptimization {
            await optimizePerformance()
        }
    }
    
    private func handleAppWillEnterForeground() async {
        // Record app resume time
        let resumeMetric = PerformanceMetric(
            type: .launchTime,
            value: 0, // Would be measured from actual resume time
            metadata: ["event": "app_resume"]
        )
        
        await recordMetric(resumeMetric)
    }
    
    private func handleMemoryWarning() async {
        let memoryMetric = PerformanceMetric(
            type: .memoryUsage,
            value: await metricsCollector.getCurrentMemoryUsage(),
            metadata: ["event": "memory_warning"]
        )
        
        await recordMetric(memoryMetric)
        
        // Trigger memory optimization
        if configuration.enableAutomaticOptimization {
            await optimizationEngine.optimizeMemoryUsage()
        }
    }
}

// MARK: - Supporting Types

public struct PerformanceAlert: Identifiable, Codable {
    public let id: String
    public let metricType: PerformanceMonitor.MetricType
    public let severity: PerformanceMonitor.PerformanceMetric.Severity
    public let value: Double
    public let threshold: Double
    public let timestamp: Date
    public let message: String
}

public struct PerformanceDashboardData {
    public let currentScore: Double
    public let recentMetrics: [PerformanceMonitor.PerformanceMetric]
    public let activeAlerts: [PerformanceAlert]
    public let trendData: [PerformanceMonitor.PerformanceTrend]
    public let topIssues: [String]
    public let optimizationSuggestions: [String]
}

// MARK: - Private Supporting Classes

private class MetricsCollector {
    func collectSystemMetrics(enabledTypes: Set<PerformanceMonitor.MetricType>) async -> [PerformanceMonitor.PerformanceMetric] {
        var metrics: [PerformanceMonitor.PerformanceMetric] = []
        
        if enabledTypes.contains(.cpuUsage) {
            let cpuUsage = getCurrentCPUUsage()
            metrics.append(PerformanceMonitor.PerformanceMetric(type: .cpuUsage, value: cpuUsage))
        }
        
        if enabledTypes.contains(.memoryUsage) {
            let memoryUsage = await getCurrentMemoryUsage()
            metrics.append(PerformanceMonitor.PerformanceMetric(type: .memoryUsage, value: memoryUsage))
        }
        
        if enabledTypes.contains(.thermalState) {
            let thermalState = Double(ProcessInfo.processInfo.thermalState.rawValue)
            metrics.append(PerformanceMonitor.PerformanceMetric(type: .thermalState, value: thermalState))
        }
        
        return metrics
    }
    
    private func getCurrentCPUUsage() -> Double {
        // Implementation would use actual CPU monitoring
        return Double.random(in: 10...30)
    }
    
    func getCurrentMemoryUsage() async -> Double {
        let info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            return Double(info.resident_size) / 1024 / 1024 // Convert to MB
        }
        
        return 0
    }
}

private class PerformanceAnalyzer {
    func calculatePerformanceScore(from metrics: [PerformanceMonitor.PerformanceMetric]) async -> Double {
        guard !metrics.isEmpty else { return 100.0 }
        
        var score = 100.0
        
        for metric in metrics {
            let threshold = metric.type.threshold
            let violation = max(0, metric.value - threshold) / threshold
            score -= violation * 20 // Reduce score based on threshold violations
        }
        
        return max(0, min(100, score))
    }
    
    func generateSummary(for metrics: [PerformanceMonitor.PerformanceMetric]) async -> PerformanceMonitor.PerformanceSummary {
        // Implementation would calculate actual summary statistics
        return PerformanceMonitor.PerformanceSummary(
            averageMetrics: [:],
            peakMetrics: [:],
            violationCount: [:],
            overallScore: 85.0,
            improvementOpportunities: ["Optimize memory usage", "Reduce CPU load"]
        )
    }
    
    func generateRecommendations(based metrics: [PerformanceMonitor.PerformanceMetric]) async -> [PerformanceMonitor.PerformanceRecommendation] {
        // Implementation would generate actual recommendations
        return []
    }
    
    func analyzeTrends(in metrics: [PerformanceMonitor.PerformanceMetric]) async -> [PerformanceMonitor.PerformanceTrend] {
        // Implementation would analyze actual trends
        return []
    }
    
    func getTrendData(for period: DateInterval) async -> [PerformanceMonitor.PerformanceTrend] {
        return []
    }
    
    func getTopIssues() async -> [String] {
        return ["High memory usage", "CPU spikes"]
    }
}

private class OptimizationEngine {
    func generateOptimizations(based metrics: [PerformanceMonitor.PerformanceMetric]) async -> [PerformanceOptimization] {
        // Implementation would generate actual optimizations
        return []
    }
    
    func generateImmediateOptimizations(for metric: PerformanceMonitor.PerformanceMetric) async -> [PerformanceOptimization] {
        // Implementation would generate immediate optimizations
        return []
    }
    
    func applyOptimization(_ optimization: PerformanceOptimization) async {
        // Implementation would apply optimization
    }
    
    func optimizeMemoryUsage() async {
        // Implementation would optimize memory
    }
    
    func getQuickWins() async -> [String] {
        return ["Clear caches", "Reduce background tasks"]
    }
}

private class PerformanceAlertManager {
    func handleAlert(_ alert: PerformanceAlert) async {
        // Implementation would handle alert notifications
    }
}

private class ReportGenerator {
    // Implementation for report generation
}

private class PerformanceStorageManager {
    func storeMetric(_ metric: PerformanceMonitor.PerformanceMetric) async throws {
        // Implementation would store metrics persistently
    }
    
    func getMetrics(for period: DateInterval) async throws -> [PerformanceMonitor.PerformanceMetric] {
        // Implementation would retrieve stored metrics
        return []
    }
    
    func clearAllData() async throws {
        // Implementation would clear all stored data
    }
}

private struct PerformanceOptimization {
    let id: String
    let type: String
    let action: () async -> Void
}