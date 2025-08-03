import XCTest
import Quick
import Nimble
@testable import WidgetTemplates

@available(iOS 16.0, *)
class WidgetTemplatesTests: QuickSpec {
    
    override func spec() {
        describe("Widget Templates") {
            context("Weather Widget Template") {
                var template: WeatherWidgetTemplate!
                
                beforeEach {
                    template = WeatherWidgetTemplate()
                }
                
                it("should have correct identifier") {
                    expect(template.identifier).to(equal("weather_widget"))
                }
                
                it("should have correct display name") {
                    expect(template.displayName).to(equal("Weather Widget"))
                }
                
                it("should have correct description") {
                    expect(template.description).to(contain("weather conditions"))
                }
                
                it("should support all widget sizes") {
                    expect(template.supportedSizes).to(contain(.systemSmall))
                    expect(template.supportedSizes).to(contain(.systemMedium))
                    expect(template.supportedSizes).to(contain(.systemLarge))
                }
                
                it("should create widget with valid configuration") {
                    let configuration = template.getDefaultConfiguration()
                    let widget = template.createWidget(configuration: configuration)
                    
                    expect(widget).toNot(beNil())
                }
                
                it("should validate configuration correctly") {
                    let validConfiguration = template.getDefaultConfiguration()
                    let isValid = template.validateConfiguration(validConfiguration)
                    
                    expect(isValid).to(beTrue())
                }
                
                it("should return default configuration") {
                    let configuration = template.getDefaultConfiguration()
                    
                    expect(configuration.id).to(equal("weather_config"))
                    expect(configuration.templateIdentifier).to(equal("weather_widget"))
                    expect(configuration.widgets.count).to(equal(1))
                }
            }
            
            context("Calendar Widget Template") {
                var template: CalendarWidgetTemplate!
                
                beforeEach {
                    template = CalendarWidgetTemplate()
                }
                
                it("should have correct identifier") {
                    expect(template.identifier).to(equal("calendar_widget"))
                }
                
                it("should have correct display name") {
                    expect(template.displayName).to(equal("Calendar Widget"))
                }
                
                it("should have correct description") {
                    expect(template.description).to(contain("events"))
                }
                
                it("should support all widget sizes") {
                    expect(template.supportedSizes).to(contain(.systemSmall))
                    expect(template.supportedSizes).to(contain(.systemMedium))
                    expect(template.supportedSizes).to(contain(.systemLarge))
                }
                
                it("should create widget with valid configuration") {
                    let configuration = template.getDefaultConfiguration()
                    let widget = template.createWidget(configuration: configuration)
                    
                    expect(widget).toNot(beNil())
                }
                
                it("should validate configuration correctly") {
                    let validConfiguration = template.getDefaultConfiguration()
                    let isValid = template.validateConfiguration(validConfiguration)
                    
                    expect(isValid).to(beTrue())
                }
                
                it("should return default configuration") {
                    let configuration = template.getDefaultConfiguration()
                    
                    expect(configuration.id).to(equal("calendar_config"))
                    expect(configuration.templateIdentifier).to(equal("calendar_widget"))
                    expect(configuration.widgets.count).to(equal(1))
                }
            }
            
            context("Fitness Widget Template") {
                var template: FitnessWidgetTemplate!
                
                beforeEach {
                    template = FitnessWidgetTemplate()
                }
                
                it("should have correct identifier") {
                    expect(template.identifier).to(equal("fitness_widget"))
                }
                
                it("should have correct display name") {
                    expect(template.displayName).to(equal("Fitness Widget"))
                }
                
                it("should have correct description") {
                    expect(template.description).to(contain("fitness metrics"))
                }
                
                it("should support all widget sizes") {
                    expect(template.supportedSizes).to(contain(.systemSmall))
                    expect(template.supportedSizes).to(contain(.systemMedium))
                    expect(template.supportedSizes).to(contain(.systemLarge))
                }
                
                it("should create widget with valid configuration") {
                    let configuration = template.getDefaultConfiguration()
                    let widget = template.createWidget(configuration: configuration)
                    
                    expect(widget).toNot(beNil())
                }
                
                it("should validate configuration correctly") {
                    let validConfiguration = template.getDefaultConfiguration()
                    let isValid = template.validateConfiguration(validConfiguration)
                    
                    expect(isValid).to(beTrue())
                }
                
                it("should return default configuration") {
                    let configuration = template.getDefaultConfiguration()
                    
                    expect(configuration.id).to(equal("fitness_config"))
                    expect(configuration.templateIdentifier).to(equal("fitness_widget"))
                    expect(configuration.widgets.count).to(equal(1))
                }
            }
            
            context("News Widget Template") {
                var template: NewsWidgetTemplate!
                
                beforeEach {
                    template = NewsWidgetTemplate()
                }
                
                it("should have correct identifier") {
                    expect(template.identifier).to(equal("news_widget"))
                }
                
                it("should have correct display name") {
                    expect(template.displayName).to(equal("News Widget"))
                }
                
                it("should have correct description") {
                    expect(template.description).to(contain("news"))
                }
                
                it("should support all widget sizes") {
                    expect(template.supportedSizes).to(contain(.systemSmall))
                    expect(template.supportedSizes).to(contain(.systemMedium))
                    expect(template.supportedSizes).to(contain(.systemLarge))
                }
                
                it("should create widget with valid configuration") {
                    let configuration = template.getDefaultConfiguration()
                    let widget = template.createWidget(configuration: configuration)
                    
                    expect(widget).toNot(beNil())
                }
                
                it("should validate configuration correctly") {
                    let validConfiguration = template.getDefaultConfiguration()
                    let isValid = template.validateConfiguration(validConfiguration)
                    
                    expect(isValid).to(beTrue())
                }
                
                it("should return default configuration") {
                    let configuration = template.getDefaultConfiguration()
                    
                    expect(configuration.id).to(equal("news_config"))
                    expect(configuration.templateIdentifier).to(equal("news_widget"))
                    expect(configuration.widgets.count).to(equal(1))
                }
            }
            
            context("Social Media Widget Template") {
                var template: SocialMediaWidgetTemplate!
                
                beforeEach {
                    template = SocialMediaWidgetTemplate()
                }
                
                it("should have correct identifier") {
                    expect(template.identifier).to(equal("social_media_widget"))
                }
                
                it("should have correct display name") {
                    expect(template.displayName).to(equal("Social Media Widget"))
                }
                
                it("should have correct description") {
                    expect(template.description).to(contain("social media"))
                }
                
                it("should support all widget sizes") {
                    expect(template.supportedSizes).to(contain(.systemSmall))
                    expect(template.supportedSizes).to(contain(.systemMedium))
                    expect(template.supportedSizes).to(contain(.systemLarge))
                }
                
                it("should create widget with valid configuration") {
                    let configuration = template.getDefaultConfiguration()
                    let widget = template.createWidget(configuration: configuration)
                    
                    expect(widget).toNot(beNil())
                }
                
                it("should validate configuration correctly") {
                    let validConfiguration = template.getDefaultConfiguration()
                    let isValid = template.validateConfiguration(validConfiguration)
                    
                    expect(isValid).to(beTrue())
                }
                
                it("should return default configuration") {
                    let configuration = template.getDefaultConfiguration()
                    
                    expect(configuration.id).to(equal("social_config"))
                    expect(configuration.templateIdentifier).to(equal("social_media_widget"))
                    expect(configuration.widgets.count).to(equal(1))
                }
            }
            
            context("Productivity Widget Template") {
                var template: ProductivityWidgetTemplate!
                
                beforeEach {
                    template = ProductivityWidgetTemplate()
                }
                
                it("should have correct identifier") {
                    expect(template.identifier).to(equal("productivity_widget"))
                }
                
                it("should have correct display name") {
                    expect(template.displayName).to(equal("Productivity Widget"))
                }
                
                it("should have correct description") {
                    expect(template.description).to(contain("productivity"))
                }
                
                it("should support all widget sizes") {
                    expect(template.supportedSizes).to(contain(.systemSmall))
                    expect(template.supportedSizes).to(contain(.systemMedium))
                    expect(template.supportedSizes).to(contain(.systemLarge))
                }
                
                it("should create widget with valid configuration") {
                    let configuration = template.getDefaultConfiguration()
                    let widget = template.createWidget(configuration: configuration)
                    
                    expect(widget).toNot(beNil())
                }
                
                it("should validate configuration correctly") {
                    let validConfiguration = template.getDefaultConfiguration()
                    let isValid = template.validateConfiguration(validConfiguration)
                    
                    expect(isValid).to(beTrue())
                }
                
                it("should return default configuration") {
                    let configuration = template.getDefaultConfiguration()
                    
                    expect(configuration.id).to(equal("productivity_config"))
                    expect(configuration.templateIdentifier).to(equal("productivity_widget"))
                    expect(configuration.widgets.count).to(equal(1))
                }
            }
            
            context("Entertainment Widget Template") {
                var template: EntertainmentWidgetTemplate!
                
                beforeEach {
                    template = EntertainmentWidgetTemplate()
                }
                
                it("should have correct identifier") {
                    expect(template.identifier).to(equal("entertainment_widget"))
                }
                
                it("should have correct display name") {
                    expect(template.displayName).to(equal("Entertainment Widget"))
                }
                
                it("should have correct description") {
                    expect(template.description).to(contain("entertainment"))
                }
                
                it("should support all widget sizes") {
                    expect(template.supportedSizes).to(contain(.systemSmall))
                    expect(template.supportedSizes).to(contain(.systemMedium))
                    expect(template.supportedSizes).to(contain(.systemLarge))
                }
                
                it("should create widget with valid configuration") {
                    let configuration = template.getDefaultConfiguration()
                    let widget = template.createWidget(configuration: configuration)
                    
                    expect(widget).toNot(beNil())
                }
                
                it("should validate configuration correctly") {
                    let validConfiguration = template.getDefaultConfiguration()
                    let isValid = template.validateConfiguration(validConfiguration)
                    
                    expect(isValid).to(beTrue())
                }
                
                it("should return default configuration") {
                    let configuration = template.getDefaultConfiguration()
                    
                    expect(configuration.id).to(equal("entertainment_config"))
                    expect(configuration.templateIdentifier).to(equal("entertainment_widget"))
                    expect(configuration.widgets.count).to(equal(1))
                }
            }
            
            context("Finance Widget Template") {
                var template: FinanceWidgetTemplate!
                
                beforeEach {
                    template = FinanceWidgetTemplate()
                }
                
                it("should have correct identifier") {
                    expect(template.identifier).to(equal("finance_widget"))
                }
                
                it("should have correct display name") {
                    expect(template.displayName).to(equal("Finance Widget"))
                }
                
                it("should have correct description") {
                    expect(template.description).to(contain("financial"))
                }
                
                it("should support all widget sizes") {
                    expect(template.supportedSizes).to(contain(.systemSmall))
                    expect(template.supportedSizes).to(contain(.systemMedium))
                    expect(template.supportedSizes).to(contain(.systemLarge))
                }
                
                it("should create widget with valid configuration") {
                    let configuration = template.getDefaultConfiguration()
                    let widget = template.createWidget(configuration: configuration)
                    
                    expect(widget).toNot(beNil())
                }
                
                it("should validate configuration correctly") {
                    let validConfiguration = template.getDefaultConfiguration()
                    let isValid = template.validateConfiguration(validConfiguration)
                    
                    expect(isValid).to(beTrue())
                }
                
                it("should return default configuration") {
                    let configuration = template.getDefaultConfiguration()
                    
                    expect(configuration.id).to(equal("finance_config"))
                    expect(configuration.templateIdentifier).to(equal("finance_widget"))
                    expect(configuration.widgets.count).to(equal(1))
                }
            }
            
            context("Health Widget Template") {
                var template: HealthWidgetTemplate!
                
                beforeEach {
                    template = HealthWidgetTemplate()
                }
                
                it("should have correct identifier") {
                    expect(template.identifier).to(equal("health_widget"))
                }
                
                it("should have correct display name") {
                    expect(template.displayName).to(equal("Health Widget"))
                }
                
                it("should have correct description") {
                    expect(template.description).to(contain("health"))
                }
                
                it("should support all widget sizes") {
                    expect(template.supportedSizes).to(contain(.systemSmall))
                    expect(template.supportedSizes).to(contain(.systemMedium))
                    expect(template.supportedSizes).to(contain(.systemLarge))
                }
                
                it("should create widget with valid configuration") {
                    let configuration = template.getDefaultConfiguration()
                    let widget = template.createWidget(configuration: configuration)
                    
                    expect(widget).toNot(beNil())
                }
                
                it("should validate configuration correctly") {
                    let validConfiguration = template.getDefaultConfiguration()
                    let isValid = template.validateConfiguration(validConfiguration)
                    
                    expect(isValid).to(beTrue())
                }
                
                it("should return default configuration") {
                    let configuration = template.getDefaultConfiguration()
                    
                    expect(configuration.id).to(equal("health_config"))
                    expect(configuration.templateIdentifier).to(equal("health_widget"))
                    expect(configuration.widgets.count).to(equal(1))
                }
            }
            
            context("Travel Widget Template") {
                var template: TravelWidgetTemplate!
                
                beforeEach {
                    template = TravelWidgetTemplate()
                }
                
                it("should have correct identifier") {
                    expect(template.identifier).to(equal("travel_widget"))
                }
                
                it("should have correct display name") {
                    expect(template.displayName).to(equal("Travel Widget"))
                }
                
                it("should have correct description") {
                    expect(template.description).to(contain("travel"))
                }
                
                it("should support all widget sizes") {
                    expect(template.supportedSizes).to(contain(.systemSmall))
                    expect(template.supportedSizes).to(contain(.systemMedium))
                    expect(template.supportedSizes).to(contain(.systemLarge))
                }
                
                it("should create widget with valid configuration") {
                    let configuration = template.getDefaultConfiguration()
                    let widget = template.createWidget(configuration: configuration)
                    
                    expect(widget).toNot(beNil())
                }
                
                it("should validate configuration correctly") {
                    let validConfiguration = template.getDefaultConfiguration()
                    let isValid = template.validateConfiguration(validConfiguration)
                    
                    expect(isValid).to(beTrue())
                }
                
                it("should return default configuration") {
                    let configuration = template.getDefaultConfiguration()
                    
                    expect(configuration.id).to(equal("travel_config"))
                    expect(configuration.templateIdentifier).to(equal("travel_widget"))
                    expect(configuration.widgets.count).to(equal(1))
                }
            }
        }
    }
} 