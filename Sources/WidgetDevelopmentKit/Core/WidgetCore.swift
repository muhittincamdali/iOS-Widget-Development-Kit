import Foundation
import WidgetKit

/// Main Widget Development Kit namespace
public enum WidgetDevKit {
    public static let version = "2.0.0"
}

/// A protocol for data sources that provide data to widgets
public protocol WidgetDataSource: Sendable {
    associatedtype DataType: Codable & Sendable
    func fetchData() async throws -> DataType
}

/// A standard configuration for widgets
public struct WidgetConfiguration: Codable, Equatable, Sendable {
    public let identifier: String
    public let refreshInterval: TimeInterval
    
    public init(identifier: String, refreshInterval: TimeInterval = 3600) {
        self.identifier = identifier
        self.refreshInterval = refreshInterval
    }
}
