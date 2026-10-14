import Foundation
import SwiftUI

/// A deep link from a widget into the host app, e.g. `myapp://content/article?id=42`.
///
/// Widgets can only open the app through URLs (`widgetURL` or `Link`). Building and
/// parsing them with one type keeps both sides in agreement.
///
/// ```swift
/// let link = WidgetDeepLink(scheme: "myapp", host: "content", path: "article", parameters: ["id": "42"])
/// Text(title).widgetURL(link.url)
///
/// // In the app:
/// .onOpenURL { url in
///     guard let link = WidgetDeepLink(url: url, expectedScheme: "myapp") else { return }
///     router.open(link)
/// }
/// ```
public struct WidgetDeepLink: Hashable, Sendable {
    public let scheme: String
    public let host: String
    /// Path components without slashes, e.g. `["article"]`.
    public let pathComponents: [String]
    public let parameters: [String: String]

    public init(scheme: String, host: String, path: String = "", parameters: [String: String] = [:]) {
        self.scheme = scheme.lowercased()
        self.host = host
        self.pathComponents = path.split(separator: "/").map(String.init)
        self.parameters = parameters
    }

    /// Parses `url`. Returns `nil` if it has no host, or if `expectedScheme` is given and differs.
    public init?(url: URL, expectedScheme: String? = nil) {
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let scheme = components.scheme?.lowercased(),
            let host = components.host, !host.isEmpty
        else { return nil }
        if let expectedScheme, expectedScheme.lowercased() != scheme { return nil }

        var parameters: [String: String] = [:]
        for item in components.queryItems ?? [] {
            guard let value = item.value else { continue }
            // First occurrence wins, so a repeated key cannot override an earlier one.
            if parameters[item.name] == nil { parameters[item.name] = value }
        }

        self.scheme = scheme
        self.host = host
        self.pathComponents = components.path.split(separator: "/").map(String.init)
        self.parameters = parameters
    }

    /// The path joined with slashes, without a leading slash.
    public var path: String { pathComponents.joined(separator: "/") }

    /// The URL, with query items sorted by name so equal links produce identical URLs.
    public var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = pathComponents.isEmpty ? "" : "/" + path
        if !parameters.isEmpty {
            components.queryItems = parameters
                .sorted { $0.key < $1.key }
                .map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        return components.url
    }
}

extension View {
    /// Sets the widget's tap target to `link`; does nothing if the link cannot form a URL.
    public func widgetURL(_ link: WidgetDeepLink) -> some View {
        widgetURL(link.url)
    }
}
