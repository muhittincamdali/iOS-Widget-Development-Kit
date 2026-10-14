import AppIntents
import SwiftUI

/// A refresh interval the user can pick when editing a configurable widget.
///
/// Use it as a parameter of your `WidgetConfigurationIntent`:
///
/// ```swift
/// struct ConfigurationIntent: WidgetConfigurationIntent {
///     static let title: LocalizedStringResource = "Configure"
///     @Parameter(title: "Refresh") var refresh: RefreshIntervalOption?
/// }
/// ```
public struct RefreshIntervalOption: AppEntity, Hashable, Sendable {
    public static let typeDisplayRepresentation: TypeDisplayRepresentation = "Refresh Interval"
    public static let defaultQuery = RefreshIntervalQuery()

    /// Interval in minutes.
    public let id: Int
    public let displayName: String

    public init(minutes: Int, displayName: String) {
        self.id = minutes
        self.displayName = displayName
    }

    public var minutes: Int { id }

    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(displayName)")
    }

    /// The update policy matching this interval.
    public var updatePolicy: WidgetUpdatePolicy { .every(minutes: minutes) }

    public static let all: [RefreshIntervalOption] = [
        RefreshIntervalOption(minutes: 15, displayName: "15 minutes"),
        RefreshIntervalOption(minutes: 30, displayName: "30 minutes"),
        RefreshIntervalOption(minutes: 60, displayName: "1 hour"),
        RefreshIntervalOption(minutes: 240, displayName: "4 hours")
    ]
}

public struct RefreshIntervalQuery: EntityQuery {
    public init() {}

    public func entities(for identifiers: [Int]) async throws -> [RefreshIntervalOption] {
        RefreshIntervalOption.all.filter { identifiers.contains($0.id) }
    }

    public func suggestedEntities() async throws -> [RefreshIntervalOption] {
        RefreshIntervalOption.all
    }
}

/// An accent color the user can pick when editing a configurable widget.
public struct AccentColorOption: AppEntity, Hashable, Sendable {
    public static let typeDisplayRepresentation: TypeDisplayRepresentation = "Accent Color"
    public static let defaultQuery = AccentColorQuery()

    public let id: String
    public let displayName: String
    public let hex: HexColor

    public init(id: String, displayName: String, hex: HexColor) {
        self.id = id
        self.displayName = displayName
        self.hex = hex
    }

    public var color: Color { hex.color }

    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(displayName)")
    }

    /// Values match the iOS system colors in light mode.
    public static let all: [AccentColorOption] = [
        ("blue", "Blue", "#007AFF"),
        ("green", "Green", "#34C759"),
        ("red", "Red", "#FF3B30"),
        ("orange", "Orange", "#FF9500"),
        ("purple", "Purple", "#AF52DE"),
        ("pink", "Pink", "#FF2D55"),
        ("teal", "Teal", "#5AC8FA"),
        ("indigo", "Indigo", "#5856D6")
    ].compactMap { id, name, hex in
        HexColor(hex).map { AccentColorOption(id: id, displayName: name, hex: $0) }
    }
}

public struct AccentColorQuery: EntityQuery {
    public init() {}

    public func entities(for identifiers: [String]) async throws -> [AccentColorOption] {
        AccentColorOption.all.filter { identifiers.contains($0.id) }
    }

    public func suggestedEntities() async throws -> [AccentColorOption] {
        AccentColorOption.all
    }
}

/// Lets the App Intents metadata processor find the entities and intents defined in
/// this package. List it in your app's and widget extension's own `AppIntentsPackage`:
///
/// ```swift
/// struct AppIntentsRoot: AppIntentsPackage {
///     static let includedPackages: [any AppIntentsPackage.Type] = [WidgetDevelopmentKitIntents.self]
/// }
/// ```
public struct WidgetDevelopmentKitIntents: AppIntentsPackage {}
