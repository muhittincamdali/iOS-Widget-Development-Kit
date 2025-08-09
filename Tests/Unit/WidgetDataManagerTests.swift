import XCTest
import Quick
import Nimble
@testable import WidgetKit
@testable import LiveDataIntegration

final class WidgetDataManagerTests: QuickSpec {
    override func spec() {
        describe("WidgetDataManager") {
            var dataManager: WidgetDataManager!
            var mockDataSource: MockWidgetDataSource!
            
            beforeEach {
                dataManager = WidgetDataManager()
                mockDataSource = MockWidgetDataSource()
            }
            
            afterEach {
                dataManager = nil
                mockDataSource = nil
            }
            
            context("Data Source Connection") {
                it("should connect to data source successfully") {
                    dataManager.connect(mockDataSource) { result in
                        expect(result).to(beSuccess())
                    }
                }
                
                it("should handle connection failure") {
                    let failingDataSource = MockFailingDataSource()
                    
                    dataManager.connect(failingDataSource) { result in
                        expect(result).to(beFailure())
                    }
                }
                
                it("should disconnect from data source") {
                    dataManager.connect(mockDataSource) { _ in
                        dataManager.disconnect { result in
                            expect(result).to(beSuccess())
                        }
                    }
                }
            }
            
            context("Data Fetching") {
                it("should fetch data successfully") {
                    dataManager.connect(mockDataSource) { _ in
                        dataManager.fetchData { result in
                            expect(result).to(beSuccess())
                            expect(result.value?.id).to(equal("test-data"))
                        }
                    }
                }
                
                it("should handle fetch failure") {
                    let failingDataSource = MockFailingDataSource()
                    
                    dataManager.connect(failingDataSource) { _ in
                        dataManager.fetchData { result in
                            expect(result).to(beFailure())
                        }
                    }
                }
                
                it("should fetch data with caching") {
                    dataManager.enableCaching = true
                    dataManager.connect(mockDataSource) { _ in
                        dataManager.fetchData { result in
                            expect(result).to(beSuccess())
                            
                            // Second fetch should use cache
                            dataManager.fetchData { cachedResult in
                                expect(cachedResult).to(beSuccess())
                                expect(cachedResult.value?.id).to(equal("test-data"))
                            }
                        }
                    }
                }
            }
            
            context("Real-time Updates") {
                it("should receive real-time updates") {
                    let expectation = XCTestExpectation(description: "Real-time update")
                    
                    dataManager.connect(mockDataSource) { _ in
                        dataManager.onDataUpdate { data in
                            expect(data.id).to(equal("real-time-data"))
                            expectation.fulfill()
                        }
                        
                        mockDataSource.simulateUpdate()
                    }
                    
                    wait(for: [expectation], timeout: 2.0)
                }
                
                it("should handle multiple subscribers") {
                    let expectation1 = XCTestExpectation(description: "Subscriber 1")
                    let expectation2 = XCTestExpectation(description: "Subscriber 2")
                    
                    dataManager.connect(mockDataSource) { _ in
                        dataManager.onDataUpdate { _ in
                            expectation1.fulfill()
                        }
                        
                        dataManager.onDataUpdate { _ in
                            expectation2.fulfill()
                        }
                        
                        mockDataSource.simulateUpdate()
                    }
                    
                    wait(for: [expectation1, expectation2], timeout: 2.0)
                }
            }
            
            context("Data Caching") {
                it("should cache data successfully") {
                    let testData = WidgetData(id: "cache-test", content: ["key": "value"])
                    
                    dataManager.cache(testData) { result in
                        expect(result).to(beSuccess())
                    }
                }
                
                it("should retrieve cached data") {
                    let testData = WidgetData(id: "retrieve-test", content: ["key": "value"])
                    
                    dataManager.cache(testData) { _ in
                        dataManager.retrieve(id: "retrieve-test") { result in
                            expect(result).to(beSuccess())
                            expect(result.value?.content["key"]).to(equal("value"))
                        }
                    }
                }
                
                it("should handle cache miss") {
                    dataManager.retrieve(id: "non-existent") { result in
                        expect(result).to(beFailure())
                    }
                }
                
                it("should clear cache") {
                    let testData = WidgetData(id: "clear-test", content: ["key": "value"])
                    
                    dataManager.cache(testData) { _ in
                        dataManager.clearCache { result in
                            expect(result).to(beSuccess())
                            
                            dataManager.retrieve(id: "clear-test") { result in
                                expect(result).to(beFailure())
                            }
                        }
                    }
                }
            }
            
            context("Data Validation") {
                it("should validate data format") {
                    let validData = WidgetData(id: "valid", content: ["key": "value"])
                    let invalidData = WidgetData(id: "", content: [:])
                    
                    dataManager.validateData(validData) { result in
                        expect(result).to(beSuccess())
                    }
                    
                    dataManager.validateData(invalidData) { result in
                        expect(result).to(beFailure())
                    }
                }
                
                it("should handle data transformation") {
                    let rawData = ["temperature": "72", "humidity": "65"]
                    
                    dataManager.transformData(rawData) { result in
                        expect(result).to(beSuccess())
                        expect(result.value?.content["temperature"]).to(equal("72°F"))
                    }
                }
            }
            
            context("Error Handling") {
                it("should handle network errors") {
                    let networkErrorDataSource = MockNetworkErrorDataSource()
                    
                    dataManager.connect(networkErrorDataSource) { result in
                        expect(result).to(beFailure())
                    }
                }
                
                it("should handle timeout errors") {
                    let timeoutDataSource = MockTimeoutDataSource()
                    
                    dataManager.connect(timeoutDataSource) { result in
                        expect(result).to(beFailure())
                    }
                }
                
                it("should retry failed operations") {
                    let retryDataSource = MockRetryDataSource()
                    
                    dataManager.connect(retryDataSource) { result in
                        expect(result).to(beSuccess())
                    }
                }
            }
            
            context("Performance") {
                it("should handle large datasets efficiently") {
                    let largeDataSource = MockLargeDataSource()
                    
                    measure {
                        dataManager.connect(largeDataSource) { _ in
                            dataManager.fetchData { _ in }
                        }
                    }
                }
                
                it("should handle concurrent operations") {
                    let expectation = XCTestExpectation(description: "Concurrent operations")
                    expectation.expectedFulfillmentCount = 5
                    
                    for i in 0..<5 {
                        DispatchQueue.global().async {
                            dataManager.fetchData { _ in
                                expectation.fulfill()
                            }
                        }
                    }
                    
                    wait(for: [expectation], timeout: 5.0)
                }
            }
        }
    }
}

// MARK: - Mock Classes

class MockWidgetDataSource: WidgetDataSource {
    private var updateCallbacks: [() -> Void] = []
    
    func fetch() async throws -> WidgetData {
        return WidgetData(id: "test-data", content: ["key": "value"])
    }
    
    func subscribe(to updates: @escaping (WidgetData) -> Void) {
        updateCallbacks.append {
            updates(WidgetData(id: "real-time-data", content: ["updated": "true"]))
        }
    }
    
    func unsubscribe() {
        updateCallbacks.removeAll()
    }
    
    func simulateUpdate() {
        updateCallbacks.forEach { $0() }
    }
}

class MockFailingDataSource: WidgetDataSource {
    func fetch() async throws -> WidgetData {
        throw WidgetError.dataFetchFailed
    }
    
    func subscribe(to updates: @escaping (WidgetData) -> Void) {
        // No updates
    }
    
    func unsubscribe() {
        // No cleanup needed
    }
}

class MockNetworkErrorDataSource: WidgetDataSource {
    func fetch() async throws -> WidgetData {
        throw WidgetError.networkError
    }
    
    func subscribe(to updates: @escaping (WidgetData) -> Void) {
        // No updates
    }
    
    func unsubscribe() {
        // No cleanup needed
    }
}

class MockTimeoutDataSource: WidgetDataSource {
    func fetch() async throws -> WidgetData {
        try await Task.sleep(nanoseconds: 5_000_000_000) // 5 seconds
        throw WidgetError.networkTimeout
    }
    
    func subscribe(to updates: @escaping (WidgetData) -> Void) {
        // No updates
    }
    
    func unsubscribe() {
        // No cleanup needed
    }
}

class MockRetryDataSource: WidgetDataSource {
    private var attemptCount = 0
    
    func fetch() async throws -> WidgetData {
        attemptCount += 1
        if attemptCount < 3 {
            throw WidgetError.dataFetchFailed
        }
        return WidgetData(id: "retry-success", content: ["attempts": "\(attemptCount)"])
    }
    
    func subscribe(to updates: @escaping (WidgetData) -> Void) {
        // No updates
    }
    
    func unsubscribe() {
        // No cleanup needed
    }
}

class MockLargeDataSource: WidgetDataSource {
    func fetch() async throws -> WidgetData {
        var largeContent: [String: String] = [:]
        for i in 0..<1000 {
            largeContent["key\(i)"] = "value\(i)"
        }
        return WidgetData(id: "large-data", content: largeContent)
    }
    
    func subscribe(to updates: @escaping (WidgetData) -> Void) {
        // No updates
    }
    
    func unsubscribe() {
        // No cleanup needed
    }
}

// MARK: - Additional Errors

extension WidgetError {
    static let networkTimeout = WidgetError.networkError
} 