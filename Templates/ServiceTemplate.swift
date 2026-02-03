// MARK: - Widget Service Template
// Use this template for creating Widget data services

import Foundation
import WidgetKit

// MARK: - Protocol
protocol __NAME__WidgetServiceProtocol: Sendable {
    func fetchData() async throws -> __TYPE__
    func refreshWidget()
}

// MARK: - Service Implementation
final class __NAME__WidgetService: __NAME__WidgetServiceProtocol, @unchecked Sendable {
    // MARK: - Singleton
    static let shared = __NAME__WidgetService()
    
    // MARK: - Properties
    private let networkClient: NetworkClientProtocol
    private let cache: WidgetCacheProtocol
    private let userDefaults: UserDefaults
    
    // MARK: - Constants
    private enum Constants {
        static let cacheKey = "__NAME__WidgetCache"
        static let suiteName = "group.com.yourcompany.widget"
        static let cacheExpiration: TimeInterval = 3600 // 1 hour
    }
    
    // MARK: - Initialization
    init(
        networkClient: NetworkClientProtocol = NetworkClient.shared,
        cache: WidgetCacheProtocol = WidgetCache.shared,
        userDefaults: UserDefaults = UserDefaults(suiteName: Constants.suiteName)!
    ) {
        self.networkClient = networkClient
        self.cache = cache
        self.userDefaults = userDefaults
    }
    
    // MARK: - Fetch Data
    func fetchData() async throws -> __TYPE__ {
        // Try cache first
        if let cached = loadFromCache(), !isCacheExpired() {
            return cached
        }
        
        // Fetch from network
        let data = try await fetchFromNetwork()
        saveToCache(data)
        return data
    }
    
    // MARK: - Refresh Widget
    func refreshWidget() {
        WidgetCenter.shared.reloadTimelines(ofKind: "__NAME__Widget")
    }
    
    func refreshAllWidgets() {
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    // MARK: - Cache Management
    private func loadFromCache() -> __TYPE__? {
        guard let data = userDefaults.data(forKey: Constants.cacheKey) else {
            return nil
        }
        return try? JSONDecoder().decode(__TYPE__.self, from: data)
    }
    
    private func saveToCache(_ value: __TYPE__) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        userDefaults.set(data, forKey: Constants.cacheKey)
        userDefaults.set(Date(), forKey: "\(Constants.cacheKey)_timestamp")
    }
    
    private func isCacheExpired() -> Bool {
        guard let timestamp = userDefaults.object(forKey: "\(Constants.cacheKey)_timestamp") as? Date else {
            return true
        }
        return Date().timeIntervalSince(timestamp) > Constants.cacheExpiration
    }
    
    private func clearCache() {
        userDefaults.removeObject(forKey: Constants.cacheKey)
        userDefaults.removeObject(forKey: "\(Constants.cacheKey)_timestamp")
    }
    
    // MARK: - Network
    private func fetchFromNetwork() async throws -> __TYPE__ {
        let url = URL(string: "https://api.example.com/__ENDPOINT__")!
        return try await networkClient.get(url)
    }
}

// MARK: - Widget Cache Protocol
protocol WidgetCacheProtocol {
    func get<T: Decodable>(for key: String) -> T?
    func set<T: Encodable>(_ value: T, for key: String)
    func remove(for key: String)
}

// MARK: - Widget Cache Implementation
final class WidgetCache: WidgetCacheProtocol {
    static let shared = WidgetCache()
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = UserDefaults(suiteName: "group.com.yourcompany.widget")!) {
        self.userDefaults = userDefaults
    }
    
    func get<T: Decodable>(for key: String) -> T? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    func set<T: Encodable>(_ value: T, for key: String) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func remove(for key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
