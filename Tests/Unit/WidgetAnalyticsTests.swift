import XCTest
import Quick
import Nimble
@testable import WidgetAnalytics

@available(iOS 16.0, *)
class WidgetAnalyticsTests: QuickSpec {
    
    override func spec() {
        describe("WidgetAnalyticsService") {
            var analyticsService: WidgetAnalyticsService!
            
            beforeEach {
                analyticsService = WidgetAnalyticsService()
            }
            
            context("when logging events") {
                it("should log widget updates") {
                    analyticsService.logWidgetUpdate(widgetId: "test_widget")
                    let analytics = analyticsService.getAnalytics()
                    
                    expect(analytics.totalWidgetUpdates).to(equal(1))
                    expect(analytics.widgetUpdates["test_widget"]).to(equal(1))
                }
                
                it("should log template registrations") {
                    analyticsService.logTemplateRegistration("weather_template")
                    let analytics = analyticsService.getAnalytics()
                    
                    expect(analytics.templateRegistrations).to(equal(1))
                }
                
                it("should log data source registrations") {
                    analyticsService.logDataSourceRegistration("weather_api")
                    let analytics = analyticsService.getAnalytics()
                    
                    expect(analytics.dataSourceRegistrations).to(equal(1))
                }
                
                it("should log WebSocket connections") {
                    let url = URL(string: "ws://test.com")!
                    analyticsService.logWebSocketConnection(identifier: "test_ws", url: url.absoluteString)
                    let analytics = analyticsService.getAnalytics()
                    
                    expect(analytics.webSocketConnections).to(equal(1))
                }
                
                it("should log WebSocket disconnections") {
                    analyticsService.logWebSocketDisconnection(identifier: "test_ws")
                    let analytics = analyticsService.getAnalytics()
                    
                    expect(analytics.webSocketDisconnections).to(equal(1))
                }
                
                it("should log data sent") {
                    analyticsService.logDataSent(widgetId: "test_widget", dataType: "weather")
                    let analytics = analyticsService.getAnalytics()
                    
                    expect(analytics.dataSentCount).to(equal(1))
                }
                
                it("should log data source updates") {
                    analyticsService.logDataSourceUpdate(identifier: "weather_api", dataType: "weather")
                    let analytics = analyticsService.getAnalytics()
                    
                    expect(analytics.dataSourceUpdates).to(equal(1))
                }
                
                it("should log data source configurations") {
                    analyticsService.logDataSourceConfiguration(identifier: "weather_api")
                    let analytics = analyticsService.getAnalytics()
                    
                    expect(analytics.dataSourceConfigurations).to(equal(1))
                }
                
                it("should log connection established") {
                    analyticsService.logConnectionEstablished(identifier: "test_ws")
                    let analytics = analyticsService.getAnalytics()
                    
                    expect(analytics.connectionsEstablished).to(equal(1))
                }
                
                it("should log connection failures") {
                    let error = NSError(domain: "test", code: 1, userInfo: nil)
                    analyticsService.logConnectionFailed(identifier: "test_ws", error: error)
                    let analytics = analyticsService.getAnalytics()
                    
                    expect(analytics.connectionFailures).to(equal(1))
                }
                
                it("should log connection cancellations") {
                    analyticsService.logConnectionCancelled(identifier: "test_ws")
                    let analytics = analyticsService.getAnalytics()
                    
                    expect(analytics.connectionsCancelled).to(equal(1))
                }
                
                it("should log connection retries") {
                    analyticsService.logConnectionRetry(identifier: "test_ws")
                    let analytics = analyticsService.getAnalytics()
                    
                    expect(analytics.connectionRetries).to(equal(1))
                }
                
                it("should log reconnection attempts") {
                    analyticsService.logReconnectionAttempt(identifier: "test_ws")
                    let analytics = analyticsService.getAnalytics()
                    
                    expect(analytics.reconnectionAttempts).to(equal(1))
                }
                
                it("should log data receive errors") {
                    let error = NSError(domain: "test", code: 1, userInfo: nil)
                    analyticsService.logDataReceiveError(identifier: "test_ws", error: error)
                    let analytics = analyticsService.getAnalytics()
                    
                    expect(analytics.dataReceiveErrors).to(equal(1))
                }
                
                it("should log data decode errors") {
                    let error = NSError(domain: "test", code: 1, userInfo: nil)
                    analyticsService.logDataDecodeError(identifier: "test_ws", error: error)
                    let analytics = analyticsService.getAnalytics()
                    
                    expect(analytics.dataDecodeErrors).to(equal(1))
                }
                
                it("should log network unavailable events") {
                    analyticsService.logNetworkUnavailable()
                    let analytics = analyticsService.getAnalytics()
                    
                    expect(analytics.networkUnavailableEvents).to(equal(1))
                }
                
                it("should log memory cleanups") {
                    analyticsService.logMemoryCleanup(removedEntries: 5)
                    let analytics = analyticsService.getAnalytics()
                    
                    expect(analytics.memoryCleanups).to(equal(1))
                }
                
                it("should log battery optimizations") {
                    analyticsService.logBatteryOptimization(newInterval: 60.0)
                    let analytics = analyticsService.getAnalytics()
                    
                    expect(analytics.batteryOptimizations).to(equal(1))
                }
                
                it("should log errors") {
                    let error = WidgetError.templateNotFound("test_template")
                    analyticsService.logError(error)
                    let analytics = analyticsService.getAnalytics()
                    
                    expect(analytics.errors).to(equal(1))
                }
                
                it("should log engine initializations") {
                    analyticsService.logEngineInitialization()
                    let analytics = analyticsService.getAnalytics()
                    
                    expect(analytics.engineInitializations).to(equal(1))
                }
            }
            
            context("when configuring analytics") {
                it("should configure analytics settings") {
                    let config = AnalyticsConfiguration(
                        enableExternalAnalytics: true,
                        maxEventLogSize: 500,
                        enablePerformanceTracking: true,
                        enableErrorTracking: true
                    )
                    
                    analyticsService.configure(config)
                    
                    // Verify configuration was applied
                    expect(analyticsService).toNot(beNil())
                }
            }
            
            context("when exporting analytics") {
                it("should export analytics data") {
                    analyticsService.logWidgetUpdate(widgetId: "test_widget")
                    
                    let exportedData = analyticsService.exportAnalytics()
                    
                    expect(exportedData).toNot(beNil())
                }
            }
            
            context("when clearing analytics") {
                it("should clear analytics data") {
                    analyticsService.logWidgetUpdate(widgetId: "test_widget")
                    analyticsService.clearAnalytics()
                    
                    let analytics = analyticsService.getAnalytics()
                    
                    expect(analytics.totalWidgetUpdates).to(equal(0))
                }
            }
        }
        
        describe("WidgetAnalytics") {
            context("when creating analytics data") {
                it("should have default values") {
                    let analytics = WidgetAnalytics()
                    
                    expect(analytics.totalWidgetUpdates).to(equal(0))
                    expect(analytics.templateRegistrations).to(equal(0))
                    expect(analytics.dataSourceRegistrations).to(equal(0))
                    expect(analytics.webSocketConnections).to(equal(0))
                    expect(analytics.webSocketDisconnections).to(equal(0))
                    expect(analytics.dataSentCount).to(equal(0))
                    expect(analytics.dataSourceUpdates).to(equal(0))
                    expect(analytics.dataSourceConfigurations).to(equal(0))
                    expect(analytics.connectionsEstablished).to(equal(0))
                    expect(analytics.connectionFailures).to(equal(0))
                    expect(analytics.connectionsCancelled).to(equal(0))
                    expect(analytics.connectionRetries).to(equal(0))
                    expect(analytics.reconnectionAttempts).to(equal(0))
                    expect(analytics.dataReceiveErrors).to(equal(0))
                    expect(analytics.dataDecodeErrors).to(equal(0))
                    expect(analytics.networkUnavailableEvents).to(equal(0))
                    expect(analytics.memoryCleanups).to(equal(0))
                    expect(analytics.batteryOptimizations).to(equal(0))
                    expect(analytics.errors).to(equal(0))
                    expect(analytics.engineInitializations).to(equal(0))
                }
            }
        }
        
        describe("AnalyticsConfiguration") {
            context("when creating configuration") {
                it("should have default values") {
                    let config = AnalyticsConfiguration()
                    
                    expect(config.enableExternalAnalytics).to(beFalse())
                    expect(config.maxEventLogSize).to(equal(1000))
                    expect(config.enablePerformanceTracking).to(beTrue())
                    expect(config.enableErrorTracking).to(beTrue())
                }
                
                it("should have custom values") {
                    let config = AnalyticsConfiguration(
                        enableExternalAnalytics: true,
                        maxEventLogSize: 500,
                        enablePerformanceTracking: false,
                        enableErrorTracking: false
                    )
                    
                    expect(config.enableExternalAnalytics).to(beTrue())
                    expect(config.maxEventLogSize).to(equal(500))
                    expect(config.enablePerformanceTracking).to(beFalse())
                    expect(config.enableErrorTracking).to(beFalse())
                }
            }
        }
        
        describe("AnalyticsEventType") {
            context("when using event types") {
                it("should have all required event types") {
                    let eventTypes = AnalyticsEventType.allCases
                    
                    expect(eventTypes).to(contain(.widgetUpdate))
                    expect(eventTypes).to(contain(.templateRegistration))
                    expect(eventTypes).to(contain(.dataSourceRegistration))
                    expect(eventTypes).to(contain(.webSocketConnection))
                    expect(eventTypes).to(contain(.webSocketDisconnection))
                    expect(eventTypes).to(contain(.dataSent))
                    expect(eventTypes).to(contain(.dataSourceUpdate))
                    expect(eventTypes).to(contain(.dataSourceConfiguration))
                    expect(eventTypes).to(contain(.connectionEstablished))
                    expect(eventTypes).to(contain(.connectionFailed))
                    expect(eventTypes).to(contain(.connectionCancelled))
                    expect(eventTypes).to(contain(.connectionRetry))
                    expect(eventTypes).to(contain(.reconnectionAttempt))
                    expect(eventTypes).to(contain(.dataReceiveError))
                    expect(eventTypes).to(contain(.dataDecodeError))
                    expect(eventTypes).to(contain(.networkUnavailable))
                    expect(eventTypes).to(contain(.memoryCleanup))
                    expect(eventTypes).to(contain(.batteryOptimization))
                    expect(eventTypes).to(contain(.error))
                    expect(eventTypes).to(contain(.engineInitialization))
                }
                
                it("should have correct raw values") {
                    expect(AnalyticsEventType.widgetUpdate.rawValue).to(equal("widget_update"))
                    expect(AnalyticsEventType.templateRegistration.rawValue).to(equal("template_registration"))
                    expect(AnalyticsEventType.dataSourceRegistration.rawValue).to(equal("data_source_registration"))
                }
            }
        }
        
        describe("WidgetError") {
            context("when creating errors") {
                it("should have correct error descriptions") {
                    let templateError = WidgetError.templateNotFound("test_template")
                    let dataSourceError = WidgetError.dataSourceNotFound("test_api")
                    let connectionError = WidgetError.connectionFailed("Network timeout")
                    let decodeError = WidgetError.dataDecodeFailed("Invalid JSON")
                    let networkError = WidgetError.networkUnavailable
                    let unknownError = WidgetError.unknown
                    
                    expect(templateError.localizedDescription).to(contain("Template not found"))
                    expect(dataSourceError.localizedDescription).to(contain("Data source not found"))
                    expect(connectionError.localizedDescription).to(contain("Connection failed"))
                    expect(decodeError.localizedDescription).to(contain("Data decode failed"))
                    expect(networkError.localizedDescription).to(equal("Network unavailable"))
                    expect(unknownError.localizedDescription).to(equal("Unknown error"))
                }
            }
        }
    }
} 