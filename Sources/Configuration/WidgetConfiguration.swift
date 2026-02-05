// WidgetConfiguration.swift
// iOS-Widget-Development-Kit
//
// Widget Configuration and Deep Linking Support
// Created by Muhittin Camdali

import SwiftUI
import WidgetKit
import AppIntents

// MARK: - Deep Link Manager

/// Handles widget deep links to main app
public final class WidgetDeepLinkManager {
    public static let shared = WidgetDeepLinkManager()
    
    public typealias DeepLinkHandler = (URL) -> Void
    private var handlers: [String: DeepLinkHandler] = [:]
    
    private init() {}
    
    /// Build a deep link URL
    public func buildURL(
        scheme: String = "widget",
        host: String,
        path: String = "",
        parameters: [String: String] = [:]
    ) -> URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path.isEmpty ? "" : "/\(path)"
        
        if !parameters.isEmpty {
            components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        return components.url
    }
    
    /// Build URL for specific widget action
    public func buildActionURL(
        action: String,
        widgetKind: String,
        parameters: [String: String] = []
    ) -> URL? {
        var params = parameters
        params["action"] = action
        params["widgetKind"] = widgetKind
        return buildURL(host: "action", parameters: params)
    }
    
    /// Build URL to open specific content
    public func buildContentURL(
        contentType: String,
        contentId: String,
        parameters: [String: String] = [:]
    ) -> URL? {
        var params = parameters
        params["type"] = contentType
        params["id"] = contentId
        return buildURL(host: "content", parameters: params)
    }
    
    /// Register handler for deep link
    public func registerHandler(for host: String, handler: @escaping DeepLinkHandler) {
        handlers[host] = handler
    }
    
    /// Handle incoming deep link
    @discardableResult
    public func handle(url: URL) -> Bool {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let host = components.host else {
            return false
        }
        
        if let handler = handlers[host] {
            handler(url)
            return true
        }
        
        return false
    }
    
    /// Parse parameters from URL
    public func parseParameters(from url: URL) -> [String: String] {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return [:]
        }
        
        var params: [String: String] = [:]
        for item in queryItems {
            if let value = item.value {
                params[item.name] = value
            }
        }
        return params
    }
}

// MARK: - Widget Link Builder

/// Convenience builder for widget links
@available(iOS 17.0, *)
public struct WidgetLinkBuilder {
    
    /// Create a link that opens the app
    public static func openApp<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        Link(destination: URL(string: "widget://app")!) {
            content()
        }
    }
    
    /// Create a link with specific action
    public static func action<Content: View>(
        _ action: String,
        parameters: [String: String] = [:],
        @ViewBuilder content: () -> Content
    ) -> some View {
        let url = WidgetDeepLinkManager.shared.buildActionURL(
            action: action,
            widgetKind: "",
            parameters: parameters
        ) ?? URL(string: "widget://app")!
        
        return Link(destination: url) {
            content()
        }
    }
    
    /// Create a link to specific content
    public static func content<Content: View>(
        type: String,
        id: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        let url = WidgetDeepLinkManager.shared.buildContentURL(
            contentType: type,
            contentId: id
        ) ?? URL(string: "widget://app")!
        
        return Link(destination: url) {
            content()
        }
    }
}

// MARK: - Widget Configuration Protocol

/// Protocol for configurable widgets
public protocol ConfigurableWidgetProtocol {
    associatedtype Configuration: WidgetConfigurationIntent
    var configuration: Configuration { get }
}

// MARK: - Configuration Options

/// Common widget configuration options
public struct WidgetConfigurationOptions: Codable {
    public var refreshInterval: Int
    public var showTitle: Bool
    public var accentColorHex: String
    public var fontSize: FontSize
    public var layoutStyle: LayoutStyle
    
    public enum FontSize: String, Codable, CaseIterable {
        case small, medium, large
    }
    
    public enum LayoutStyle: String, Codable, CaseIterable {
        case compact, standard, expanded
    }
    
    public init(
        refreshInterval: Int = 15,
        showTitle: Bool = true,
        accentColorHex: String = "#007AFF",
        fontSize: FontSize = .medium,
        layoutStyle: LayoutStyle = .standard
    ) {
        self.refreshInterval = refreshInterval
        self.showTitle = showTitle
        self.accentColorHex = accentColorHex
        self.fontSize = fontSize
        self.layoutStyle = layoutStyle
    }
    
    public static let `default` = WidgetConfigurationOptions()
}

// MARK: - Configuration Storage

/// Manages widget configuration persistence
public final class WidgetConfigurationStorage {
    public static let shared = WidgetConfigurationStorage()
    
    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private init() {
        defaults = UserDefaults(suiteName: "group.widget.configuration") ?? .standard
    }
    
    /// Save configuration
    public func save<T: Encodable>(_ configuration: T, for widgetId: String) throws {
        let data = try encoder.encode(configuration)
        defaults.set(data, forKey: "config_\(widgetId)")
    }
    
    /// Load configuration
    public func load<T: Decodable>(_ type: T.Type, for widgetId: String) throws -> T? {
        guard let data = defaults.data(forKey: "config_\(widgetId)") else {
            return nil
        }
        return try decoder.decode(type, from: data)
    }
    
    /// Remove configuration
    public func remove(for widgetId: String) {
        defaults.removeObject(forKey: "config_\(widgetId)")
    }
    
    /// Get all configured widget IDs
    public func allConfiguredWidgetIds() -> [String] {
        defaults.dictionaryRepresentation().keys
            .filter { $0.hasPrefix("config_") }
            .map { String($0.dropFirst(7)) }
    }
}

// MARK: - App Intent Configurations

/// Base configuration intent for widgets
@available(iOS 17.0, *)
public protocol WidgetConfigurationIntent: AppIntent {
    static var intentIdentifier: String { get }
}

/// Refresh interval configuration
@available(iOS 17.0, *)
public struct RefreshIntervalConfiguration: AppEntity {
    public static var typeDisplayRepresentation: TypeDisplayRepresentation = "Refresh Interval"
    public static var defaultQuery = RefreshIntervalQuery()
    
    public var id: Int
    public var displayName: String
    
    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: LocalizedStringResource(stringLiteral: displayName))
    }
    
    public static let intervals: [RefreshIntervalConfiguration] = [
        RefreshIntervalConfiguration(id: 5, displayName: "5 minutes"),
        RefreshIntervalConfiguration(id: 15, displayName: "15 minutes"),
        RefreshIntervalConfiguration(id: 30, displayName: "30 minutes"),
        RefreshIntervalConfiguration(id: 60, displayName: "1 hour")
    ]
    
    public init(id: Int, displayName: String) {
        self.id = id
        self.displayName = displayName
    }
}

@available(iOS 17.0, *)
public struct RefreshIntervalQuery: EntityQuery {
    public init() {}
    
    public func entities(for identifiers: [Int]) async throws -> [RefreshIntervalConfiguration] {
        RefreshIntervalConfiguration.intervals.filter { identifiers.contains($0.id) }
    }
    
    public func suggestedEntities() async throws -> [RefreshIntervalConfiguration] {
        RefreshIntervalConfiguration.intervals
    }
}

// MARK: - Color Configuration

/// Color selection for widgets
@available(iOS 17.0, *)
public struct ColorConfiguration: AppEntity {
    public static var typeDisplayRepresentation: TypeDisplayRepresentation = "Accent Color"
    public static var defaultQuery = ColorConfigurationQuery()
    
    public var id: String
    public var displayName: String
    public var hexValue: String
    
    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: LocalizedStringResource(stringLiteral: displayName))
    }
    
    public var color: Color {
        Color(hex: hexValue) ?? .blue
    }
    
    public static let colors: [ColorConfiguration] = [
        ColorConfiguration(id: "blue", displayName: "Blue", hexValue: "#007AFF"),
        ColorConfiguration(id: "green", displayName: "Green", hexValue: "#34C759"),
        ColorConfiguration(id: "red", displayName: "Red", hexValue: "#FF3B30"),
        ColorConfiguration(id: "orange", displayName: "Orange", hexValue: "#FF9500"),
        ColorConfiguration(id: "purple", displayName: "Purple", hexValue: "#AF52DE"),
        ColorConfiguration(id: "pink", displayName: "Pink", hexValue: "#FF2D55"),
        ColorConfiguration(id: "teal", displayName: "Teal", hexValue: "#5AC8FA"),
        ColorConfiguration(id: "indigo", displayName: "Indigo", hexValue: "#5856D6")
    ]
    
    public init(id: String, displayName: String, hexValue: String) {
        self.id = id
        self.displayName = displayName
        self.hexValue = hexValue
    }
}

@available(iOS 17.0, *)
public struct ColorConfigurationQuery: EntityQuery {
    public init() {}
    
    public func entities(for identifiers: [String]) async throws -> [ColorConfiguration] {
        ColorConfiguration.colors.filter { identifiers.contains($0.id) }
    }
    
    public func suggestedEntities() async throws -> [ColorConfiguration] {
        ColorConfiguration.colors
    }
}

// MARK: - Color Hex Extension

extension Color {
    /// Initialize Color from hex string
    public init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }
        
        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
    
    /// Convert Color to hex string
    public var hexString: String? {
        #if canImport(UIKit)
        guard let components = UIColor(self).cgColor.components else { return nil }
        #else
        guard let components = NSColor(self).cgColor.components else { return nil }
        #endif
        
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}

// MARK: - Widget URL Handler View Modifier

/// View modifier to handle widget URLs
@available(iOS 17.0, *)
public struct WidgetURLHandler: ViewModifier {
    let handler: (URL) -> Void
    
    public func body(content: Content) -> some View {
        content
            .onOpenURL { url in
                handler(url)
            }
    }
}

@available(iOS 17.0, *)
extension View {
    /// Handle widget deep links
    public func onWidgetURL(_ handler: @escaping (URL) -> Void) -> some View {
        modifier(WidgetURLHandler(handler: handler))
    }
}

// MARK: - Configuration Migration

/// Handles migration of widget configurations between versions
public final class ConfigurationMigrationManager {
    public static let shared = ConfigurationMigrationManager()
    
    private let defaults = UserDefaults(suiteName: "group.widget.configuration") ?? .standard
    private let versionKey = "config_version"
    
    private init() {}
    
    /// Current configuration version
    public var currentVersion: Int {
        get { defaults.integer(forKey: versionKey) }
        set { defaults.set(newValue, forKey: versionKey) }
    }
    
    /// Run migrations if needed
    public func migrateIfNeeded(targetVersion: Int, migrations: [Int: () -> Void]) {
        guard currentVersion < targetVersion else { return }
        
        for version in (currentVersion + 1)...targetVersion {
            if let migration = migrations[version] {
                migration()
            }
        }
        
        currentVersion = targetVersion
    }
}
