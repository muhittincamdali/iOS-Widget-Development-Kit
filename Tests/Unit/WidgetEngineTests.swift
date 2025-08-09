import XCTest
import Quick
import Nimble
@testable import WidgetKit

final class WidgetEngineTests: QuickSpec {
    override func spec() {
        describe("WidgetEngine") {
            var widgetEngine: WidgetEngine!
            
            beforeEach {
                widgetEngine = WidgetEngine()
            }
            
            afterEach {
                widgetEngine = nil
            }
            
            context("Initialization") {
                it("should initialize with default configuration") {
                    expect(widgetEngine).toNot(beNil())
                    expect(widgetEngine.isRunning).to(beFalse())
                }
                
                it("should have correct default settings") {
                    expect(widgetEngine.configuration.enableHomeScreenWidgets).to(beTrue())
                    expect(widgetEngine.configuration.enableLockScreenWidgets).to(beTrue())
                    expect(widgetEngine.configuration.enableLiveActivities).to(beTrue())
                }
            }
            
            context("Widget Registration") {
                it("should register home screen widget successfully") {
                    let widget = HomeScreenWidget(kind: "test.widget")
                    
                    widgetEngine.register(widget) { result in
                        expect(result).to(beSuccess())
                    }
                }
                
                it("should register lock screen widget successfully") {
                    let widget = LockScreenWidget(kind: "test.lockwidget")
                    
                    widgetEngine.register(widget) { result in
                        expect(result).to(beSuccess())
                    }
                }
                
                it("should fail to register widget with invalid kind") {
                    let widget = HomeScreenWidget(kind: "")
                    
                    widgetEngine.register(widget) { result in
                        expect(result).to(beFailure())
                    }
                }
            }
            
            context("Widget Management") {
                it("should start widget engine successfully") {
                    widgetEngine.start { result in
                        expect(result).to(beSuccess())
                        expect(widgetEngine.isRunning).to(beTrue())
                    }
                }
                
                it("should stop widget engine successfully") {
                    widgetEngine.start { _ in
                        widgetEngine.stop { result in
                            expect(result).to(beSuccess())
                            expect(widgetEngine.isRunning).to(beFalse())
                        }
                    }
                }
                
                it("should update widget configuration") {
                    let newConfig = WidgetConfiguration()
                    newConfig.enableHomeScreenWidgets = false
                    
                    widgetEngine.updateConfiguration(newConfig) { result in
                        expect(result).to(beSuccess())
                        expect(widgetEngine.configuration.enableHomeScreenWidgets).to(beFalse())
                    }
                }
            }
            
            context("Data Integration") {
                it("should fetch widget data successfully") {
                    let dataSource = WidgetDataSource(type: .api, endpoint: "https://api.test.com")
                    
                    widgetEngine.fetchData(from: dataSource) { result in
                        expect(result).to(beSuccess())
                    }
                }
                
                it("should handle data fetch failure") {
                    let dataSource = WidgetDataSource(type: .api, endpoint: "https://invalid-url.com")
                    
                    widgetEngine.fetchData(from: dataSource) { result in
                        expect(result).to(beFailure())
                    }
                }
            }
            
            context("Performance") {
                it("should register multiple widgets efficiently") {
                    let widgets = (0..<10).map { HomeScreenWidget(kind: "widget.\($0)") }
                    
                    measure {
                        for widget in widgets {
                            widgetEngine.register(widget) { _ in }
                        }
                    }
                }
                
                it("should handle concurrent widget updates") {
                    let expectation = XCTestExpectation(description: "Concurrent updates")
                    expectation.expectedFulfillmentCount = 5
                    
                    for i in 0..<5 {
                        DispatchQueue.global().async {
                            let widget = HomeScreenWidget(kind: "concurrent.\(i)")
                            widgetEngine.register(widget) { _ in
                                expectation.fulfill()
                            }
                        }
                    }
                    
                    wait(for: [expectation], timeout: 5.0)
                }
            }
            
            context("Error Handling") {
                it("should handle invalid widget configuration") {
                    let invalidConfig = WidgetConfiguration()
                    invalidConfig.refreshInterval = -1
                    
                    widgetEngine.updateConfiguration(invalidConfig) { result in
                        expect(result).to(beFailure())
                    }
                }
                
                it("should handle network errors gracefully") {
                    let dataSource = WidgetDataSource(type: .api, endpoint: "https://unreachable-url.com")
                    
                    widgetEngine.fetchData(from: dataSource) { result in
                        expect(result).to(beFailure())
                    }
                }
            }
        }
    }
}

// MARK: - Test Helpers

extension Result {
    func beSuccess() -> Predicate<Result> {
        return Predicate { actual in
            let message = ExpectationMessage.expectedActualValueTo("be success")
            
            guard let actual = try actual.evaluate() else {
                return PredicateResult(status: .fail, message: message.appendedBeNilHint())
            }
            
            switch actual {
            case .success:
                return PredicateResult(status: .matches, message: message)
            case .failure:
                return PredicateResult(status: .fail, message: message)
            }
        }
    }
    
    func beFailure() -> Predicate<Result> {
        return Predicate { actual in
            let message = ExpectationMessage.expectedActualValueTo("be failure")
            
            guard let actual = try actual.evaluate() else {
                return PredicateResult(status: .fail, message: message.appendedBeNilHint())
            }
            
            switch actual {
            case .success:
                return PredicateResult(status: .fail, message: message)
            case .failure:
                return PredicateResult(status: .matches, message: message)
            }
        }
    }
} 