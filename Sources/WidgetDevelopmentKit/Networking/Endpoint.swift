import Foundation

/// A value-type description of an HTTP endpoint that produces a `URLRequest`.
///
/// ```swift
/// let request = Endpoint(base: apiURL)
///     .appendingPath("v1/quotes/random")
///     .adding(query: "lang", "en")
///     .adding(header: "Accept", "application/json")
///     .request
/// ```
public struct Endpoint: Hashable, Sendable {
    public let base: URL
    public private(set) var pathComponents: [String] = []
    public private(set) var queryItems: [URLQueryItem] = []
    public private(set) var headers: [String: String] = [:]
    public var method = "GET"

    public init(base: URL) {
        self.base = base
    }

    /// Appends one or more slash-separated path segments; empty segments are ignored.
    public func appendingPath(_ path: String) -> Endpoint {
        var copy = self
        copy.pathComponents += path.split(separator: "/").map(String.init)
        return copy
    }

    /// Adds a query item; repeated names are kept in order.
    public func adding(query name: String, _ value: String?) -> Endpoint {
        var copy = self
        copy.queryItems.append(URLQueryItem(name: name, value: value))
        return copy
    }

    public func adding(header name: String, _ value: String) -> Endpoint {
        var copy = self
        copy.headers[name] = value
        return copy
    }

    /// The full URL, or `nil` if the components do not form a valid URL.
    public var url: URL? {
        let fullURL = pathComponents.reduce(base) { $0.appending(path: $1) }
        guard var components = URLComponents(url: fullURL, resolvingAgainstBaseURL: false) else {
            return nil
        }
        if !queryItems.isEmpty {
            components.queryItems = (components.queryItems ?? []) + queryItems
        }
        return components.url
    }

    /// A request for this endpoint, or `nil` if ``url`` is `nil`.
    public var request: URLRequest? {
        guard let url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method
        for (name, value) in headers {
            request.setValue(value, forHTTPHeaderField: name)
        }
        return request
    }
}
