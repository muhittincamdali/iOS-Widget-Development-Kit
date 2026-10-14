import Foundation

/// Errors thrown by ``WidgetDataLoader``.
public enum WidgetNetworkError: Error, Sendable, Equatable {
    /// The response was not an HTTP response.
    case invalidResponse
    /// The server answered with a non-2xx status code.
    case httpStatus(Int)
    /// The body could not be decoded into the requested type.
    case decodingFailed(String)
    /// A transport error, such as no connection or a timeout.
    case transport(URLError.Code)

    /// Whether retrying the same request could reasonably succeed.
    public var isTransient: Bool {
        switch self {
        case .httpStatus(let code):
            return code == 408 || (500...599).contains(code)
        case .transport(let code):
            return [.timedOut, .networkConnectionLost, .notConnectedToInternet, .cannotConnectToHost]
                .contains(code)
        case .invalidResponse, .decodingFailed:
            return false
        }
    }
}

/// Retry settings sized for a widget extension, which only gets a few seconds of
/// runtime per timeline request.
public struct RetryPolicy: Sendable, Equatable {
    /// Total attempts, including the first one.
    public let maxAttempts: Int
    /// Delay before the second attempt; each later attempt doubles it.
    public let initialDelay: Duration

    public init(maxAttempts: Int = 2, initialDelay: Duration = .milliseconds(500)) {
        self.maxAttempts = max(maxAttempts, 1)
        self.initialDelay = initialDelay
    }

    public static let none = RetryPolicy(maxAttempts: 1)

    /// Delay before attempt number `attempt` (1-based); zero for the first attempt.
    public func delay(beforeAttempt attempt: Int) -> Duration {
        guard attempt > 1 else { return .zero }
        return initialDelay * (1 << (attempt - 2))
    }
}

/// Fetches and decodes JSON for a timeline provider, retrying only transient failures.
///
/// ```swift
/// let loader = WidgetDataLoader()
/// let quote = try await loader.load(Quote.self, from: URLRequest(url: quoteURL))
/// ```
public struct WidgetDataLoader: Sendable {
    public typealias Transport = @Sendable (URLRequest) async throws -> (Data, URLResponse)
    public typealias Sleep = @Sendable (Duration) async throws -> Void

    private let transport: Transport
    private let sleep: Sleep
    private let retryPolicy: RetryPolicy

    /// - Parameters:
    ///   - session: Session used for requests. The default does not wait for connectivity,
    ///     so a widget without network fails fast and can fall back to cached data.
    ///   - retryPolicy: How many times to retry transient errors.
    public init(session: URLSession = .widgetDefault, retryPolicy: RetryPolicy = RetryPolicy()) {
        self.init(
            retryPolicy: retryPolicy,
            transport: { try await session.data(for: $0) },
            sleep: { try await Task.sleep(for: $0) }
        )
    }

    /// Creates a loader with a custom transport, for tests or non-URLSession clients.
    public init(retryPolicy: RetryPolicy = RetryPolicy(), transport: @escaping Transport, sleep: @escaping Sleep) {
        self.transport = transport
        self.sleep = sleep
        self.retryPolicy = retryPolicy
    }

    /// Loads `request` and decodes the body as `type`.
    public func load<Value: Decodable>(
        _ type: Value.Type,
        from request: URLRequest,
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> Value {
        let data = try await loadData(from: request)
        do {
            return try decoder.decode(type, from: data)
        } catch {
            throw WidgetNetworkError.decodingFailed(String(describing: error))
        }
    }

    /// Loads `request` and returns the body of a 2xx response.
    public func loadData(from request: URLRequest) async throws -> Data {
        var attempt = 1
        while true {
            do {
                return try await performOnce(request)
            } catch let error as WidgetNetworkError where error.isTransient && attempt < retryPolicy.maxAttempts {
                attempt += 1
                try await sleep(retryPolicy.delay(beforeAttempt: attempt))
            }
        }
    }

    private func performOnce(_ request: URLRequest) async throws -> Data {
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await transport(request)
        } catch let error as URLError {
            throw WidgetNetworkError.transport(error.code)
        }
        guard let http = response as? HTTPURLResponse else {
            throw WidgetNetworkError.invalidResponse
        }
        guard (200...299).contains(http.statusCode) else {
            throw WidgetNetworkError.httpStatus(http.statusCode)
        }
        return data
    }
}

extension URLSession {
    /// An ephemeral session with short timeouts and no waiting for connectivity.
    public static let widgetDefault: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 15
        configuration.waitsForConnectivity = false
        return URLSession(configuration: configuration)
    }()
}
