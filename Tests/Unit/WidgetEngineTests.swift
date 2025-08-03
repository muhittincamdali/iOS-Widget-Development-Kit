import XCTest
import Quick
import Nimble
@testable import WidgetKit

@available(iOS 16.0, *)
class WidgetEngineTests: QuickSpec {
    
    override func spec() {
        describe("WidgetEngine") {
            var widgetEngine: WidgetEngine!
            
            beforeEach {
                widgetEngine = WidgetEngine.shared
            }
            
            context("when initializing") {
                it("should have default templates registered") {
                    expect(widgetEngine).toNot(beNil())
                }
                
                it("should have performance metrics initialized") {
                    expect(widgetEngine.performanceMetrics).toNot(beNil())
                }
            }
            
            context("when registering templates") {
                it("should register weather template") {
                    let template = WeatherWidgetTemplate()
                    widgetEngine.registerTemplate(template)
                    
                    // Verify template is registered
                    expect(template.identifier).to(equal("weather_widget"))
                }
                
                it("should register calendar template") {
                    let template = CalendarWidgetTemplate()
                    widgetEngine.registerTemplate(template)
                    
                    expect(template.identifier).to(equal("calendar_widget"))
                }
                
                it("should register fitness template") {
                    let template = FitnessWidgetTemplate()
                    widgetEngine.registerTemplate(template)
                    
                    expect(template.identifier).to(equal("fitness_widget"))
                }
            }
            
            context("when creating widgets") {
                it("should create weather widget with valid configuration") {
                    let template = WeatherWidgetTemplate()
                    widgetEngine.registerTemplate(template)
                    
                    let configuration = template.getDefaultConfiguration()
                    let widget = widgetEngine.createWidget(with: configuration)
                    
                    expect(widget).toNot(beNil())
                }
                
                it("should create calendar widget with valid configuration") {
                    let template = CalendarWidgetTemplate()
                    widgetEngine.registerTemplate(template)
                    
                    let configuration = template.getDefaultConfiguration()
                    let widget = widgetEngine.createWidget(with: configuration)
                    
                    expect(widget).toNot(beNil())
                }
                
                it("should create fitness widget with valid configuration") {
                    let template = FitnessWidgetTemplate()
                    widgetEngine.registerTemplate(template)
                    
                    let configuration = template.getDefaultConfiguration()
                    let widget = widgetEngine.createWidget(with: configuration)
                    
                    expect(widget).toNot(beNil())
                }
            }
            
            context("when updating widgets") {
                it("should update widget with new data") {
                    let widgetId = "test_widget"
                    let data = WidgetData(
                        id: widgetId,
                        type: .weather,
                        content: ["temperature": 25]
                    )
                    
                    widgetEngine.updateWidget(widgetId, with: data)
                    
                    // Verify update was processed
                    expect(data.id).to(equal(widgetId))
                }
            }
            
            context("when configuring performance") {
                it("should update performance settings") {
                    let settings = WidgetPerformanceSettings(
                        maxMemoryUsage: 50 * 1024 * 1024,
                        refreshInterval: 60.0,
                        enableBatteryOptimization: true
                    )
                    
                    widgetEngine.configurePerformance(settings)
                    
                    expect(widgetEngine.performanceMetrics.settings.maxMemoryUsage).to(equal(settings.maxMemoryUsage))
                }
            }
            
            context("when getting analytics") {
                it("should return analytics data") {
                    let analytics = widgetEngine.getAnalytics()
                    
                    expect(analytics).toNot(beNil())
                }
            }
        }
        
        describe("WidgetConfiguration") {
            context("when creating configuration") {
                it("should create valid configuration") {
                    let widget = WidgetDefinition(
                        id: "test_widget",
                        type: .weather,
                        dataSourceIdentifier: "weather_api",
                        customization: WidgetCustomization()
                    )
                    
                    let configuration = WidgetConfiguration(
                        id: "test_config",
                        templateIdentifier: "weather_widget",
                        widgets: [widget],
                        settings: WidgetSettings()
                    )
                    
                    expect(configuration.id).to(equal("test_config"))
                    expect(configuration.templateIdentifier).to(equal("weather_widget"))
                    expect(configuration.widgets.count).to(equal(1))
                }
            }
        }
        
        describe("WidgetData") {
            context("when creating data") {
                it("should create valid data") {
                    let data = WidgetData(
                        id: "test_data",
                        type: .weather,
                        content: ["temperature": 22, "condition": "sunny"]
                    )
                    
                    expect(data.id).to(equal("test_data"))
                    expect(data.type).to(equal(.weather))
                    expect(data.content["temperature"] as? Int).to(equal(22))
                }
            }
        }
        
        describe("WidgetPerformanceMetrics") {
            context("when updating metrics") {
                it("should update memory usage") {
                    let metrics = WidgetPerformanceMetrics()
                    let usage: UInt64 = 100 * 1024 * 1024
                    
                    metrics.updateMemoryUsage(usage)
                    
                    expect(metrics.memoryUsage).to(equal(usage))
                }
                
                it("should update battery level") {
                    let metrics = WidgetPerformanceMetrics()
                    let level: Float = 0.75
                    
                    metrics.updateBatteryLevel(level)
                    
                    expect(metrics.batteryLevel).to(equal(level))
                }
                
                it("should update background refresh count") {
                    let metrics = WidgetPerformanceMetrics()
                    let initialCount = metrics.refreshCount
                    
                    metrics.updateBackgroundRefresh()
                    
                    expect(metrics.refreshCount).to(equal(initialCount + 1))
                }
            }
        }
        
        describe("WidgetCustomization") {
            context("when creating customization") {
                it("should create with default values") {
                    let customization = WidgetCustomization()
                    
                    expect(customization.backgroundColor).to(equal(.clear))
                    expect(customization.textColor).to(equal(.primary))
                    expect(customization.accentColor).to(equal(.blue))
                    expect(customization.cornerRadius).to(equal(12))
                }
                
                it("should create with custom values") {
                    let customization = WidgetCustomization(
                        backgroundColor: .red,
                        textColor: .white,
                        accentColor: .green,
                        cornerRadius: 20
                    )
                    
                    expect(customization.backgroundColor).to(equal(.red))
                    expect(customization.textColor).to(equal(.white))
                    expect(customization.accentColor).to(equal(.green))
                    expect(customization.cornerRadius).to(equal(20))
                }
            }
        }
        
        describe("WidgetSettings") {
            context("when creating settings") {
                it("should create with default values") {
                    let settings = WidgetSettings()
                    
                    expect(settings.refreshInterval).to(equal(30.0))
                    expect(settings.enableAnimations).to(beTrue())
                    expect(settings.enableHaptics).to(beTrue())
                    expect(settings.enableSound).to(beFalse())
                }
                
                it("should create with custom values") {
                    let settings = WidgetSettings(
                        refreshInterval: 60.0,
                        enableAnimations: false,
                        enableHaptics: false,
                        enableSound: true
                    )
                    
                    expect(settings.refreshInterval).to(equal(60.0))
                    expect(settings.enableAnimations).to(beFalse())
                    expect(settings.enableHaptics).to(beFalse())
                    expect(settings.enableSound).to(beTrue())
                }
            }
        }
        
        describe("WidgetType") {
            context("when using widget types") {
                it("should have all required types") {
                    let types = WidgetType.allCases
                    
                    expect(types).to(contain(.weather))
                    expect(types).to(contain(.calendar))
                    expect(types).to(contain(.fitness))
                    expect(types).to(contain(.news))
                    expect(types).to(contain(.social))
                    expect(types).to(contain(.productivity))
                    expect(types).to(contain(.entertainment))
                    expect(types).to(contain(.finance))
                    expect(types).to(contain(.health))
                    expect(types).to(contain(.travel))
                }
                
                it("should have correct raw values") {
                    expect(WidgetType.weather.rawValue).to(equal("weather"))
                    expect(WidgetType.calendar.rawValue).to(equal("calendar"))
                    expect(WidgetType.fitness.rawValue).to(equal("fitness"))
                }
            }
        }
    }
} 