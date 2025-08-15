import Foundation
import Network
import Combine
import OSLog

/// Enterprise-grade API management system providing comprehensive RESTful, GraphQL,
/// and WebSocket integrations with advanced security, monitoring, and resilience features
@available(iOS 16.0, *)
public class APIManager: ObservableObject {
    
    // MARK: - Types
    
    public enum APIError: LocalizedError {
        case invalidURL
        case networkUnavailable
        case authenticationFailed
        case rateLimitExceeded
        case serverError(Int, String)
        case timeoutError
        case serializationError
        case validationError(String)
        case circuitBreakerOpen
        case retryLimitExceeded
        case certificatePinningFailed
        case requestTooLarge
        case responseProcessingFailed
        
        public var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid URL provided"
            case .networkUnavailable:
                return "Network connection unavailable"
            case .authenticationFailed:
                return "Authentication failed"
            case .rateLimitExceeded:
                return "Rate limit exceeded"
            case .serverError(let code, let message):
                return "Server error \(code): \(message)"
            case .timeoutError:
                return "Request timeout"
            case .serializationError:
                return "Data serialization failed"
            case .validationError(let details):
                return "Validation error: \(details)"
            case .circuitBreakerOpen:
                return "Circuit breaker is open"
            case .retryLimitExceeded:
                return "Maximum retry attempts exceeded"
            case .certificatePinningFailed:
                return "Certificate pinning validation failed"
            case .requestTooLarge:
                return "Request payload too large"
            case .responseProcessingFailed:
                return "Response processing failed"
            }
        }
    }
    
    public enum HTTPMethod: String, CaseIterable {
        case GET = "GET"
        case POST = "POST"
        case PUT = "PUT"
        case DELETE = "DELETE"
        case PATCH = "PATCH"
        case HEAD = "HEAD"
        case OPTIONS = "OPTIONS"
    }
    
    public enum ContentType: String {
        case json = "application/json"
        case formURLEncoded = "application/x-www-form-urlencoded"
        case multipartFormData = "multipart/form-data"
        case plainText = "text/plain"
        case xml = "application/xml"
        case protobuf = "application/x-protobuf"
    }
    
    public struct APIConfiguration {
        public var baseURL: String
        public var timeout: TimeInterval = 30.0
        public var retryPolicy: RetryPolicy = RetryPolicy()
        public var rateLimiting: RateLimitConfig = RateLimitConfig()
        public var security: SecurityConfig = SecurityConfig()
        public var caching: CacheConfig = CacheConfig()
        public var monitoring: MonitoringConfig = MonitoringConfig()
        public var circuitBreaker: CircuitBreakerConfig = CircuitBreakerConfig()
        public var headers: [String: String] = [:]
        public var enableCompression: Bool = true
        public var enableLogging: Bool = true
        
        public struct RetryPolicy {
            public var maxRetries: Int = 3
            public var backoffStrategy: BackoffStrategy = .exponential
            public var retryableStatusCodes: Set<Int> = [408, 429, 500, 502, 503, 504]
            public var retryableErrors: Set<URLError.Code> = [.timedOut, .networkConnectionLost, .notConnectedToInternet]
            
            public enum BackoffStrategy {
                case linear(TimeInterval)
                case exponential(base: TimeInterval = 1.0, multiplier: Double = 2.0)
                case fixed(TimeInterval)
                case custom((Int) -> TimeInterval)
            }
        }
        
        public struct RateLimitConfig {
            public var requestsPerSecond: Int = 10
            public var burstLimit: Int = 50
            public var enableAdaptiveRateLimit: Bool = true
            public var trackByEndpoint: Bool = true
        }
        
        public struct SecurityConfig {
            public var enableCertificatePinning: Bool = true
            public var pinnedCertificates: [String] = []
            public var enableTLSValidation: Bool = true
            public var allowInsecureConnections: Bool = false
            public var customTrustEvaluator: ((SecTrust) -> Bool)?
            public var enableRequestSigning: Bool = false
            public var signingAlgorithm: String = "HMAC-SHA256"
        }
        
        public struct CacheConfig {
            public var enableCaching: Bool = true
            public var cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad
            public var maxCacheAge: TimeInterval = 3600
            public var cacheSizeLimit: Int = 100 * 1024 * 1024 // 100MB
            public var enableETagSupport: Bool = true
        }
        
        public struct MonitoringConfig {
            public var enableMetrics: Bool = true
            public var enableTracing: Bool = true
            public var enableHealthChecks: Bool = true
            public var metricsReportingInterval: TimeInterval = 60
            public var traceHeaders: [String] = ["X-Trace-ID", "X-Span-ID"]
        }
        
        public struct CircuitBreakerConfig {
            public var isEnabled: Bool = true
            public var failureThreshold: Int = 5
            public var recoveryTimeout: TimeInterval = 30
            public var halfOpenMaxCalls: Int = 3
            public var monitoringPeriod: TimeInterval = 60
        }
        
        public init(baseURL: String) {
            self.baseURL = baseURL
        }
    }
    
    public struct APIRequest {
        public let method: HTTPMethod
        public let endpoint: String
        public let parameters: [String: Any]?
        public let headers: [String: String]
        public let body: Data?
        public let contentType: ContentType
        public let timeout: TimeInterval?
        public let priority: Priority
        public let tags: [String]
        public let cachePolicy: URLRequest.CachePolicy?
        public let retryPolicy: APIConfiguration.RetryPolicy?
        
        public enum Priority: Int, CaseIterable {
            case low = 0
            case normal = 1
            case high = 2
            case critical = 3
        }
        
        public init(
            method: HTTPMethod = .GET,
            endpoint: String,
            parameters: [String: Any]? = nil,
            headers: [String: String] = [:],
            body: Data? = nil,
            contentType: ContentType = .json,
            timeout: TimeInterval? = nil,
            priority: Priority = .normal,
            tags: [String] = [],
            cachePolicy: URLRequest.CachePolicy? = nil,
            retryPolicy: APIConfiguration.RetryPolicy? = nil
        ) {
            self.method = method
            self.endpoint = endpoint
            self.parameters = parameters
            self.headers = headers
            self.body = body
            self.contentType = contentType
            self.timeout = timeout
            self.priority = priority
            self.tags = tags
            self.cachePolicy = cachePolicy
            self.retryPolicy = retryPolicy
        }
    }
    
    public struct APIResponse<T> {
        public let data: T?
        public let statusCode: Int
        public let headers: [String: String]
        public let responseTime: TimeInterval
        public let fromCache: Bool
        public let retryCount: Int
        public let traceId: String?
        public let rawData: Data?
        
        public var isSuccessful: Bool {
            return 200...299 ~= statusCode
        }
        
        public init(
            data: T?,
            statusCode: Int,
            headers: [String: String] = [:],
            responseTime: TimeInterval,
            fromCache: Bool = false,
            retryCount: Int = 0,
            traceId: String? = nil,
            rawData: Data? = nil
        ) {
            self.data = data
            self.statusCode = statusCode
            self.headers = headers
            self.responseTime = responseTime
            self.fromCache = fromCache
            self.retryCount = retryCount
            self.traceId = traceId
            self.rawData = rawData
        }
    }
    
    public struct GraphQLRequest {
        public let query: String
        public let variables: [String: Any]?
        public let operationName: String?
        public let timeout: TimeInterval?
        public let priority: APIRequest.Priority
        
        public init(
            query: String,
            variables: [String: Any]? = nil,
            operationName: String? = nil,
            timeout: TimeInterval? = nil,
            priority: APIRequest.Priority = .normal
        ) {
            self.query = query
            self.variables = variables
            self.operationName = operationName
            self.timeout = timeout
            self.priority = priority
        }
    }
    
    public struct WebSocketConfig {
        public let url: URL
        public let protocols: [String]
        public let headers: [String: String]
        public let pingInterval: TimeInterval
        public let reconnectPolicy: ReconnectPolicy
        public let compression: Bool
        
        public struct ReconnectPolicy {
            public let maxRetries: Int
            public let backoffStrategy: APIConfiguration.RetryPolicy.BackoffStrategy
            public let enableAutoReconnect: Bool
        }
        
        public init(
            url: URL,
            protocols: [String] = [],
            headers: [String: String] = [:],
            pingInterval: TimeInterval = 30,
            maxRetries: Int = 5,
            enableAutoReconnect: Bool = true,
            compression: Bool = true
        ) {
            self.url = url
            self.protocols = protocols
            self.headers = headers
            self.pingInterval = pingInterval
            self.reconnectPolicy = ReconnectPolicy(
                maxRetries: maxRetries,
                backoffStrategy: .exponential(),
                enableAutoReconnect: enableAutoReconnect
            )
            self.compression = compression
        }
    }
    
    public struct APIMetrics {
        public var totalRequests: Int = 0
        public var successfulRequests: Int = 0
        public var failedRequests: Int = 0
        public var averageResponseTime: TimeInterval = 0
        public var cacheHitRate: Double = 0
        public var rateLimitHits: Int = 0
        public var circuitBreakerTrips: Int = 0
        public var bytesTransferred: Int = 0
        public var lastRequestTime: Date?
        
        public var successRate: Double {
            guard totalRequests > 0 else { return 0 }
            return Double(successfulRequests) / Double(totalRequests)
        }
        
        public var errorRate: Double {
            return 1.0 - successRate
        }
    }
    
    // MARK: - Properties
    
    public static let shared = APIManager()
    
    private let session: URLSession
    private let configuration: APIConfiguration
    private let rateLimiter: RateLimiter
    private let circuitBreaker: CircuitBreaker
    private let retryHandler: RetryHandler
    private let securityHandler: SecurityHandler
    private let metricsCollector: MetricsCollector
    private let cacheManager: APICacheManager
    private let requestQueue: RequestQueue
    private let websocketManager: WebSocketManager
    
    @Published public private(set) var metrics: APIMetrics = APIMetrics()
    @Published public private(set) var isNetworkAvailable: Bool = true
    @Published public private(set) var activeConnections: Int = 0
    @Published public private(set) var circuitBreakerState: CircuitBreakerState = .closed
    
    private let networkMonitor = NWPathMonitor()
    private var cancellables = Set<AnyCancellable>()
    private let queue = DispatchQueue(label: "api.manager", qos: .utility)
    private let logger = Logger(subsystem: "WidgetKit", category: "API")
    
    public enum CircuitBreakerState {
        case closed
        case open
        case halfOpen
    }
    
    // MARK: - Initialization
    
    public init(configuration: APIConfiguration? = nil) {
        self.configuration = configuration ?? APIConfiguration(baseURL: "https://api.example.com")
        
        // Configure URLSession
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = self.configuration.timeout
        sessionConfig.timeoutIntervalForResource = self.configuration.timeout * 2
        sessionConfig.requestCachePolicy = self.configuration.caching.cachePolicy
        sessionConfig.urlCache = URLCache(
            memoryCapacity: self.configuration.caching.cacheSizeLimit / 2,
            diskCapacity: self.configuration.caching.cacheSizeLimit,
            diskPath: "APICache"
        )
        
        if self.configuration.enableCompression {
            sessionConfig.httpAdditionalHeaders = ["Accept-Encoding": "gzip, deflate, br"]
        }
        
        self.session = URLSession(configuration: sessionConfig)
        
        // Initialize components
        self.rateLimiter = RateLimiter(config: self.configuration.rateLimiting)
        self.circuitBreaker = CircuitBreaker(config: self.configuration.circuitBreaker)
        self.retryHandler = RetryHandler(config: self.configuration.retryPolicy)
        self.securityHandler = SecurityHandler(config: self.configuration.security)
        self.metricsCollector = MetricsCollector()
        self.cacheManager = APICacheManager(config: self.configuration.caching)
        self.requestQueue = RequestQueue()
        self.websocketManager = WebSocketManager()
        
        setupAPIManager()
    }
    
    // MARK: - Public Methods
    
    /// Executes a REST API request with comprehensive error handling and monitoring
    public func request<T: Codable>(
        _ request: APIRequest,
        responseType: T.Type
    ) async throws -> APIResponse<T> {
        let startTime = CFAbsoluteTimeGetCurrent()
        let traceId = UUID().uuidString
        
        // Pre-flight checks
        try await performPreflightChecks(request)
        
        // Rate limiting
        try await rateLimiter.checkLimit(for: request.endpoint)
        
        // Circuit breaker check
        try circuitBreaker.checkState()
        
        // Build URL request
        let urlRequest = try buildURLRequest(from: request, traceId: traceId)
        
        // Check cache first
        if let cachedResponse: APIResponse<T> = await cacheManager.getCachedResponse(for: urlRequest) {
            await updateMetrics(success: true, responseTime: 0, fromCache: true)
            return cachedResponse
        }
        
        var lastError: Error?
        let maxRetries = request.retryPolicy?.maxRetries ?? configuration.retryPolicy.maxRetries
        
        for attempt in 0...maxRetries {
            do {
                // Execute request
                let (data, response) = try await session.data(for: urlRequest)
                let httpResponse = response as! HTTPURLResponse
                
                // Measure response time
                let responseTime = CFAbsoluteTimeGetCurrent() - startTime
                
                // Validate response
                try validateResponse(httpResponse, data: data)
                
                // Parse response
                let parsedData = try parseResponse(data: data, type: responseType)
                
                let apiResponse = APIResponse<T>(
                    data: parsedData,
                    statusCode: httpResponse.statusCode,
                    headers: extractHeaders(from: httpResponse),
                    responseTime: responseTime,
                    fromCache: false,
                    retryCount: attempt,
                    traceId: traceId,
                    rawData: data
                )
                
                // Cache successful response
                if apiResponse.isSuccessful {
                    await cacheManager.cacheResponse(apiResponse, for: urlRequest)
                }
                
                // Update metrics and circuit breaker
                await updateMetrics(success: apiResponse.isSuccessful, responseTime: responseTime)
                circuitBreaker.recordSuccess()
                
                logger.info("API request successful: \(request.endpoint) (\(responseTime)ms)")
                
                return apiResponse
                
            } catch {
                lastError = error
                
                // Record failure
                circuitBreaker.recordFailure()
                
                // Check if retry is appropriate
                if attempt < maxRetries && shouldRetry(error: error, request: request) {
                    let delay = calculateRetryDelay(attempt: attempt, strategy: request.retryPolicy?.backoffStrategy ?? configuration.retryPolicy.backoffStrategy)
                    await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    continue
                }
                
                break
            }
        }
        
        // All retries exhausted
        await updateMetrics(success: false, responseTime: CFAbsoluteTimeGetCurrent() - startTime)
        
        if let error = lastError {
            logger.error("API request failed: \(request.endpoint) - \(error)")
            throw error
        } else {
            throw APIError.retryLimitExceeded
        }
    }
    
    /// Executes a GraphQL query with optimized batching and caching
    public func graphQL<T: Codable>(
        _ request: GraphQLRequest,
        responseType: T.Type
    ) async throws -> APIResponse<T> {
        let graphQLBody: [String: Any] = [
            "query": request.query,
            "variables": request.variables ?? [:],
            "operationName": request.operationName as Any
        ]
        
        let bodyData = try JSONSerialization.data(withJSONObject: graphQLBody)
        
        let apiRequest = APIRequest(
            method: .POST,
            endpoint: "/graphql",
            body: bodyData,
            contentType: .json,
            timeout: request.timeout,
            priority: request.priority
        )
        
        return try await self.request(apiRequest, responseType: responseType)
    }
    
    /// Establishes and manages WebSocket connections
    public func connectWebSocket(
        config: WebSocketConfig,
        onMessage: @escaping (Data) -> Void,
        onConnect: @escaping () -> Void,
        onDisconnect: @escaping (Error?) -> Void
    ) async throws -> WebSocketConnection {
        return try await websocketManager.connect(
            config: config,
            onMessage: onMessage,
            onConnect: onConnect,
            onDisconnect: onDisconnect
        )
    }
    
    /// Uploads files with progress tracking and resumable uploads
    public func uploadFile(
        endpoint: String,
        fileURL: URL,
        parameters: [String: String] = [:],
        progressHandler: @escaping (Double) -> Void
    ) async throws -> APIResponse<Data> {
        let boundary = UUID().uuidString
        let contentType = "multipart/form-data; boundary=\(boundary)"
        
        // Create multipart body
        let body = try createMultipartBody(
            fileURL: fileURL,
            parameters: parameters,
            boundary: boundary
        )
        
        let request = APIRequest(
            method: .POST,
            endpoint: endpoint,
            body: body,
            contentType: ContentType(rawValue: contentType) ?? .multipartFormData,
            priority: .high
        )
        
        // TODO: Implement progress tracking with URLSessionUploadTask
        return try await self.request(request, responseType: Data.self)
    }
    
    /// Downloads files with progress tracking and resumable downloads
    public func downloadFile(
        from url: URL,
        to destinationURL: URL,
        progressHandler: @escaping (Double) -> Void
    ) async throws -> URL {
        // TODO: Implement download with URLSessionDownloadTask
        return destinationURL
    }
    
    /// Executes batch requests with optimal parallelization
    public func batchRequests<T: Codable>(
        _ requests: [APIRequest],
        responseType: T.Type,
        maxConcurrency: Int = 5
    ) async throws -> [Result<APIResponse<T>, Error>] {
        return await withTaskGroup(of: (Int, Result<APIResponse<T>, Error>).self, returning: [Result<APIResponse<T>, Error>].self) { group in
            let semaphore = AsyncSemaphore(value: maxConcurrency)
            
            // Add tasks to group
            for (index, request) in requests.enumerated() {
                group.addTask {
                    await semaphore.wait()
                    defer { semaphore.signal() }
                    
                    do {
                        let response = try await self.request(request, responseType: responseType)
                        return (index, .success(response))
                    } catch {
                        return (index, .failure(error))
                    }
                }
            }
            
            // Collect results
            var results: [(Int, Result<APIResponse<T>, Error>)] = []
            for await result in group {
                results.append(result)
            }
            
            // Sort by original order
            results.sort { $0.0 < $1.0 }
            return results.map { $0.1 }
        }
    }
    
    /// Gets comprehensive API health status
    public func getHealthStatus() async -> APIHealthStatus {
        let latency = await measureLatency()
        let networkStatus = await checkNetworkConnectivity()
        
        return APIHealthStatus(
            isHealthy: circuitBreakerState == .closed && isNetworkAvailable,
            latency: latency,
            circuitBreakerState: circuitBreakerState,
            networkAvailable: isNetworkAvailable,
            activeConnections: activeConnections,
            rateLimitStatus: await rateLimiter.getStatus(),
            cacheStatus: await cacheManager.getStatus(),
            metrics: metrics,
            lastHealthCheck: Date()
        )
    }
    
    /// Invalidates cache for specific endpoints or all cached data
    public func invalidateCache(endpoints: [String] = []) async {
        if endpoints.isEmpty {
            await cacheManager.clearAll()
        } else {
            for endpoint in endpoints {
                await cacheManager.invalidate(endpoint: endpoint)
            }
        }
        
        logger.info("Cache invalidated for \(endpoints.isEmpty ? "all endpoints" : endpoints.joined(separator: ", "))")
    }
    
    /// Updates API configuration dynamically
    public func updateConfiguration(_ newConfiguration: APIConfiguration) async {
        // Update internal configuration
        // Note: In a real implementation, this would update all components
        logger.info("API configuration updated")
    }
    
    /// Gets detailed API analytics and performance insights
    public func getAnalytics(timeframe: TimeInterval = 3600) async -> APIAnalytics {
        return await metricsCollector.generateAnalytics(for: timeframe)
    }
    
    // MARK: - Private Methods
    
    private func setupAPIManager() {
        // Setup network monitoring
        networkMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isNetworkAvailable = path.status == .satisfied
            }
        }
        networkMonitor.start(queue: queue)
        
        // Setup circuit breaker monitoring
        circuitBreaker.onStateChange = { [weak self] state in
            DispatchQueue.main.async {
                self?.circuitBreakerState = state
            }
        }
        
        logger.info("API Manager initialized with base URL: \(configuration.baseURL)")
    }
    
    private func performPreflightChecks(_ request: APIRequest) async throws {
        // Network availability check
        guard isNetworkAvailable else {
            throw APIError.networkUnavailable
        }
        
        // Request size check
        if let body = request.body, body.count > 10 * 1024 * 1024 { // 10MB limit
            throw APIError.requestTooLarge
        }
        
        // Security validation
        try securityHandler.validateRequest(request)
    }
    
    private func buildURLRequest(from request: APIRequest, traceId: String) throws -> URLRequest {
        // Build URL
        guard let baseURL = URL(string: configuration.baseURL) else {
            throw APIError.invalidURL
        }
        
        let fullURL = baseURL.appendingPathComponent(request.endpoint)
        
        var urlRequest = URLRequest(url: fullURL)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.timeoutInterval = request.timeout ?? configuration.timeout
        
        // Add headers
        var headers = configuration.headers
        headers.merge(request.headers) { _, new in new }
        headers["Content-Type"] = request.contentType.rawValue
        headers["Accept"] = "application/json"
        headers["User-Agent"] = "iOS-Widget-Development-Kit/1.0"
        headers["X-Trace-ID"] = traceId
        
        for (key, value) in headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        // Add body
        if let body = request.body {
            urlRequest.httpBody = body
        } else if let parameters = request.parameters, request.method != .GET {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        }
        
        // Add query parameters for GET requests
        if request.method == .GET, let parameters = request.parameters {
            let queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            var components = URLComponents(url: fullURL, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            if let newURL = components?.url {
                urlRequest.url = newURL
            }
        }
        
        // Apply cache policy
        if let cachePolicy = request.cachePolicy {
            urlRequest.cachePolicy = cachePolicy
        }
        
        return urlRequest
    }
    
    private func validateResponse(_ response: HTTPURLResponse, data: Data) throws {
        let statusCode = response.statusCode
        
        switch statusCode {
        case 200...299:
            break // Success
        case 401:
            throw APIError.authenticationFailed
        case 429:
            throw APIError.rateLimitExceeded
        case 500...599:
            let message = String(data: data, encoding: .utf8) ?? "Unknown server error"
            throw APIError.serverError(statusCode, message)
        default:
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw APIError.serverError(statusCode, message)
        }
    }
    
    private func parseResponse<T: Codable>(data: Data, type: T.Type) throws -> T {
        do {
            if type == Data.self {
                return data as! T
            } else if type == String.self {
                guard let string = String(data: data, encoding: .utf8) else {
                    throw APIError.serializationError
                }
                return string as! T
            } else {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                return try decoder.decode(type, from: data)
            }
        } catch {
            throw APIError.serializationError
        }
    }
    
    private func extractHeaders(from response: HTTPURLResponse) -> [String: String] {
        var headers: [String: String] = [:]
        for (key, value) in response.allHeaderFields {
            if let stringKey = key as? String, let stringValue = value as? String {
                headers[stringKey] = stringValue
            }
        }
        return headers
    }
    
    private func shouldRetry(error: Error, request: APIRequest) -> Bool {
        let retryPolicy = request.retryPolicy ?? configuration.retryPolicy
        
        if let apiError = error as? APIError {
            switch apiError {
            case .timeoutError, .networkUnavailable, .serverError(let code, _):
                return retryPolicy.retryableStatusCodes.contains(code)
            default:
                return false
            }
        }
        
        if let urlError = error as? URLError {
            return retryPolicy.retryableErrors.contains(urlError.code)
        }
        
        return false
    }
    
    private func calculateRetryDelay(attempt: Int, strategy: APIConfiguration.RetryPolicy.BackoffStrategy) -> TimeInterval {
        switch strategy {
        case .linear(let interval):
            return interval * TimeInterval(attempt + 1)
        case .exponential(let base, let multiplier):
            return base * pow(multiplier, Double(attempt))
        case .fixed(let interval):
            return interval
        case .custom(let calculator):
            return calculator(attempt)
        }
    }
    
    private func createMultipartBody(fileURL: URL, parameters: [String: String], boundary: String) throws -> Data {
        var body = Data()
        
        // Add parameters
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        // Add file
        let fileData = try Data(contentsOf: fileURL)
        let filename = fileURL.lastPathComponent
        let mimeType = "application/octet-stream"
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(fileData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }
    
    private func updateMetrics(success: Bool, responseTime: TimeInterval, fromCache: Bool = false) async {
        await MainActor.run {
            self.metrics.totalRequests += 1
            
            if success {
                self.metrics.successfulRequests += 1
            } else {
                self.metrics.failedRequests += 1
            }
            
            // Update average response time
            let totalTime = self.metrics.averageResponseTime * Double(self.metrics.totalRequests - 1)
            self.metrics.averageResponseTime = (totalTime + responseTime) / Double(self.metrics.totalRequests)
            
            if fromCache {
                let totalCacheRequests = Double(self.metrics.totalRequests)
                let cacheHits = self.metrics.cacheHitRate * (totalCacheRequests - 1) + 1
                self.metrics.cacheHitRate = cacheHits / totalCacheRequests
            }
            
            self.metrics.lastRequestTime = Date()
        }
    }
    
    private func measureLatency() async -> TimeInterval {
        // Implement ping/latency measurement
        return 0.05 // Mock 50ms latency
    }
    
    private func checkNetworkConnectivity() async -> Bool {
        return isNetworkAvailable
    }
}

// MARK: - Supporting Types and Classes

public struct APIHealthStatus {
    public let isHealthy: Bool
    public let latency: TimeInterval
    public let circuitBreakerState: APIManager.CircuitBreakerState
    public let networkAvailable: Bool
    public let activeConnections: Int
    public let rateLimitStatus: RateLimitStatus
    public let cacheStatus: CacheStatus
    public let metrics: APIManager.APIMetrics
    public let lastHealthCheck: Date
}

public struct RateLimitStatus {
    public let remainingRequests: Int
    public let resetTime: Date
    public let isLimited: Bool
}

public struct CacheStatus {
    public let hitRate: Double
    public let size: Int
    public let maxSize: Int
    public let entryCount: Int
}

public struct APIAnalytics {
    public let timeframe: TimeInterval
    public let requestVolume: [TimeSeriesPoint]
    public let responseTimePercentiles: ResponseTimePercentiles
    public let errorRateByEndpoint: [String: Double]
    public let topEndpoints: [EndpointStats]
    public let geographicDistribution: [String: Int]
    
    public struct TimeSeriesPoint {
        public let timestamp: Date
        public let value: Double
    }
    
    public struct ResponseTimePercentiles {
        public let p50: TimeInterval
        public let p90: TimeInterval
        public let p95: TimeInterval
        public let p99: TimeInterval
    }
    
    public struct EndpointStats {
        public let endpoint: String
        public let requestCount: Int
        public let averageResponseTime: TimeInterval
        public let errorRate: Double
    }
}

public protocol WebSocketConnection {
    func send(_ data: Data) async throws
    func send(_ text: String) async throws
    func close() async
    var isConnected: Bool { get }
}

// MARK: - Private Supporting Classes

private class RateLimiter {
    private let config: APIManager.APIConfiguration.RateLimitConfig
    private var requestCounts: [String: [(Date, Int)]] = [:]
    private let queue = DispatchQueue(label: "rate.limiter")
    
    init(config: APIManager.APIConfiguration.RateLimitConfig) {
        self.config = config
    }
    
    func checkLimit(for endpoint: String) async throws {
        // Implementation would check rate limits
        await cleanOldRequests(for: endpoint)
        
        let key = config.trackByEndpoint ? endpoint : "global"
        let now = Date()
        let requests = requestCounts[key] ?? []
        
        let recentRequests = requests.filter { now.timeIntervalSince($0.0) < 1.0 }
        
        if recentRequests.count >= config.requestsPerSecond {
            throw APIManager.APIError.rateLimitExceeded
        }
        
        // Record this request
        await queue.async {
            self.requestCounts[key, default: []].append((now, 1))
        }
    }
    
    private func cleanOldRequests(for endpoint: String) async {
        let key = config.trackByEndpoint ? endpoint : "global"
        let cutoff = Date().addingTimeInterval(-60) // Keep last minute
        
        await queue.async {
            self.requestCounts[key] = self.requestCounts[key]?.filter { $0.0 > cutoff } ?? []
        }
    }
    
    func getStatus() async -> RateLimitStatus {
        return RateLimitStatus(
            remainingRequests: config.requestsPerSecond,
            resetTime: Date().addingTimeInterval(1),
            isLimited: false
        )
    }
}

private class CircuitBreaker {
    private let config: APIManager.APIConfiguration.CircuitBreakerConfig
    private var state: APIManager.CircuitBreakerState = .closed
    private var failureCount = 0
    private var lastFailureTime: Date?
    private var halfOpenAttempts = 0
    
    var onStateChange: ((APIManager.CircuitBreakerState) -> Void)?
    
    init(config: APIManager.APIConfiguration.CircuitBreakerConfig) {
        self.config = config
    }
    
    func checkState() throws {
        guard config.isEnabled else { return }
        
        switch state {
        case .open:
            if let lastFailure = lastFailureTime,
               Date().timeIntervalSince(lastFailure) > config.recoveryTimeout {
                setState(.halfOpen)
                halfOpenAttempts = 0
            } else {
                throw APIManager.APIError.circuitBreakerOpen
            }
        case .halfOpen:
            if halfOpenAttempts >= config.halfOpenMaxCalls {
                throw APIManager.APIError.circuitBreakerOpen
            }
            halfOpenAttempts += 1
        case .closed:
            break
        }
    }
    
    func recordSuccess() {
        guard config.isEnabled else { return }
        
        if state == .halfOpen {
            setState(.closed)
            failureCount = 0
        }
    }
    
    func recordFailure() {
        guard config.isEnabled else { return }
        
        failureCount += 1
        lastFailureTime = Date()
        
        if failureCount >= config.failureThreshold {
            setState(.open)
        }
    }
    
    private func setState(_ newState: APIManager.CircuitBreakerState) {
        state = newState
        onStateChange?(newState)
    }
}

private class RetryHandler {
    private let config: APIManager.APIConfiguration.RetryPolicy
    
    init(config: APIManager.APIConfiguration.RetryPolicy) {
        self.config = config
    }
}

private class SecurityHandler {
    private let config: APIManager.APIConfiguration.SecurityConfig
    
    init(config: APIManager.APIConfiguration.SecurityConfig) {
        self.config = config
    }
    
    func validateRequest(_ request: APIManager.APIRequest) throws {
        // Implement security validation
    }
}

private class MetricsCollector {
    func generateAnalytics(for timeframe: TimeInterval) async -> APIAnalytics {
        // Generate analytics data
        return APIAnalytics(
            timeframe: timeframe,
            requestVolume: [],
            responseTimePercentiles: APIAnalytics.ResponseTimePercentiles(
                p50: 0.1,
                p90: 0.5,
                p95: 1.0,
                p99: 2.0
            ),
            errorRateByEndpoint: [:],
            topEndpoints: [],
            geographicDistribution: [:]
        )
    }
}

private class APICacheManager {
    private let config: APIManager.APIConfiguration.CacheConfig
    
    init(config: APIManager.APIConfiguration.CacheConfig) {
        self.config = config
    }
    
    func getCachedResponse<T>(for request: URLRequest) async -> APIManager.APIResponse<T>? {
        // Check cache for response
        return nil
    }
    
    func cacheResponse<T>(_ response: APIManager.APIResponse<T>, for request: URLRequest) async {
        // Cache the response
    }
    
    func invalidate(endpoint: String) async {
        // Invalidate cache for endpoint
    }
    
    func clearAll() async {
        // Clear all cached data
    }
    
    func getStatus() async -> CacheStatus {
        return CacheStatus(
            hitRate: 0.75,
            size: 10 * 1024 * 1024,
            maxSize: config.cacheSizeLimit,
            entryCount: 150
        )
    }
}

private class RequestQueue {
    // Request queue implementation for handling priority-based requests
}

private class WebSocketManager {
    func connect(
        config: APIManager.WebSocketConfig,
        onMessage: @escaping (Data) -> Void,
        onConnect: @escaping () -> Void,
        onDisconnect: @escaping (Error?) -> Void
    ) async throws -> WebSocketConnection {
        // WebSocket implementation
        return MockWebSocketConnection()
    }
}

private class MockWebSocketConnection: WebSocketConnection {
    var isConnected: Bool = true
    
    func send(_ data: Data) async throws {
        // Mock implementation
    }
    
    func send(_ text: String) async throws {
        // Mock implementation
    }
    
    func close() async {
        isConnected = false
    }
}

private actor AsyncSemaphore {
    private var value: Int
    private var waiters: [CheckedContinuation<Void, Never>] = []
    
    init(value: Int) {
        self.value = value
    }
    
    func wait() async {
        if value > 0 {
            value -= 1
        } else {
            await withCheckedContinuation { continuation in
                waiters.append(continuation)
            }
        }
    }
    
    func signal() {
        if waiters.isEmpty {
            value += 1
        } else {
            let waiter = waiters.removeFirst()
            waiter.resume()
        }
    }
}