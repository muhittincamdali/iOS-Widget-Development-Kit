// MARK: - Widget Test Template
// Use this template for testing Widget components

import XCTest
import WidgetKit
@testable import __MODULE__

final class __NAME__WidgetTests: XCTestCase {
    // MARK: - Properties
    private var sut: __NAME__Provider!
    private var mockService: Mock__NAME__Service!
    
    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        mockService = Mock__NAME__Service()
        sut = __NAME__Provider(service: mockService)
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }
    
    // MARK: - Placeholder Tests
    func test_placeholder_returnsValidEntry() {
        // Given
        let context = MockTimelineProviderContext()
        
        // When
        let entry = sut.placeholder(in: context)
        
        // Then
        XCTAssertNotNil(entry)
        XCTAssertNotNil(entry.date)
    }
    
    // MARK: - Snapshot Tests
    func test_getSnapshot_returnsEntryImmediately() {
        // Given
        let context = MockTimelineProviderContext()
        let expectation = expectation(description: "Snapshot returned")
        
        // When
        sut.getSnapshot(in: context) { entry in
            // Then
            XCTAssertNotNil(entry)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Timeline Tests
    func test_getTimeline_whenSuccessful_returnsEntriesWithPolicy() {
        // Given
        let context = MockTimelineProviderContext()
        let expectation = expectation(description: "Timeline returned")
        mockService.fetchResult = .success(.mock)
        
        // When
        sut.getTimeline(in: context) { timeline in
            // Then
            XCTAssertFalse(timeline.entries.isEmpty)
            XCTAssertEqual(timeline.policy, .atEnd)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_getTimeline_whenFails_returnsPlaceholderEntry() {
        // Given
        let context = MockTimelineProviderContext()
        let expectation = expectation(description: "Timeline returned")
        mockService.fetchResult = .failure(NSError(domain: "test", code: 1))
        
        // When
        sut.getTimeline(in: context) { timeline in
            // Then
            XCTAssertEqual(timeline.entries.count, 1)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Entry Tests
    func test_entry_formatsDateCorrectly() {
        // Given
        let date = Date()
        let data = __NAME__Data.mock
        
        // When
        let entry = __NAME__Entry(date: date, data: data)
        
        // Then
        XCTAssertEqual(entry.date, date)
        XCTAssertEqual(entry.data.title, data.title)
    }
    
    // MARK: - View Tests
    func test_widgetView_rendersWithoutCrash() {
        // Given
        let entry = __NAME__Entry(date: Date(), data: .mock)
        
        // When/Then - should not crash
        let view = __NAME__WidgetEntryView(entry: entry)
        XCTAssertNotNil(view)
    }
}

// MARK: - Mock Objects
final class Mock__NAME__Service: __NAME__ServiceProtocol {
    var fetchCalled = false
    var fetchResult: Result<__TYPE__, Error> = .success(.mock)
    
    func fetchData() async throws -> __TYPE__ {
        fetchCalled = true
        return try fetchResult.get()
    }
    
    func refreshWidget() {
        // No-op for testing
    }
}

final class MockTimelineProviderContext: TimelineProviderContext {
    var family: WidgetFamily { .systemSmall }
    var isPreview: Bool { false }
    var displaySize: CGSize { CGSize(width: 169, height: 169) }
    var environmentVariants: EnvironmentVariants { [:] }
}

// MARK: - Test Data
extension __NAME__Data {
    static var mock: __NAME__Data {
        __NAME__Data(
            title: "Test Title",
            subtitle: "Test Subtitle",
            value: 42.0
        )
    }
}

extension __TYPE__ {
    static var mock: __TYPE__ {
        // Return mock instance
        fatalError("Implement mock data")
    }
}
