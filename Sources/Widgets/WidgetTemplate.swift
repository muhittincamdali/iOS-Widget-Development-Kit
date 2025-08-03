import SwiftUI
import WidgetKit

/// Base protocol for all widget templates
@available(iOS 16.0, *)
public protocol WidgetTemplate {
    /// Unique identifier for the template
    var identifier: String { get }
    
    /// Display name for the template
    var displayName: String { get }
    
    /// Template description
    var description: String { get }
    
    /// Supported widget sizes
    var supportedSizes: [WidgetFamily] { get }
    
    /// Create widget view with configuration
    func createWidget(configuration: WidgetConfiguration) -> AnyView
    
    /// Validate configuration
    func validateConfiguration(_ configuration: WidgetConfiguration) -> Bool
    
    /// Get default configuration
    func getDefaultConfiguration() -> WidgetConfiguration
}

/// Weather widget template
@available(iOS 16.0, *)
public class WeatherWidgetTemplate: WidgetTemplate {
    public let identifier = "weather_widget"
    public let displayName = "Weather Widget"
    public let description = "Display current weather conditions with beautiful animations"
    public let supportedSizes: [WidgetFamily] = [.systemSmall, .systemMedium, .systemLarge]
    
    public func createWidget(configuration: WidgetConfiguration) -> AnyView {
        return AnyView(WeatherWidgetView(configuration: configuration))
    }
    
    public func validateConfiguration(_ configuration: WidgetConfiguration) -> Bool {
        return configuration.widgets.contains { $0.type == .weather }
    }
    
    public func getDefaultConfiguration() -> WidgetConfiguration {
        let weatherWidget = WidgetDefinition(
            id: "weather_main",
            type: .weather,
            dataSourceIdentifier: "weather_api",
            customization: WidgetCustomization(
                backgroundColor: Color.blue.opacity(0.1),
                textColor: .primary,
                accentColor: .blue,
                cornerRadius: 16,
                padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
            )
        )
        
        return WidgetConfiguration(
            id: "weather_config",
            templateIdentifier: identifier,
            widgets: [weatherWidget],
            settings: WidgetSettings(refreshInterval: 300.0, enableAnimations: true)
        )
    }
}

/// Calendar widget template
@available(iOS 16.0, *)
public class CalendarWidgetTemplate: WidgetTemplate {
    public let identifier = "calendar_widget"
    public let displayName = "Calendar Widget"
    public let description = "Show upcoming events and calendar information"
    public let supportedSizes: [WidgetFamily] = [.systemSmall, .systemMedium, .systemLarge]
    
    public func createWidget(configuration: WidgetConfiguration) -> AnyView {
        return AnyView(CalendarWidgetView(configuration: configuration))
    }
    
    public func validateConfiguration(_ configuration: WidgetConfiguration) -> Bool {
        return configuration.widgets.contains { $0.type == .calendar }
    }
    
    public func getDefaultConfiguration() -> WidgetConfiguration {
        let calendarWidget = WidgetDefinition(
            id: "calendar_main",
            type: .calendar,
            dataSourceIdentifier: "calendar_events",
            customization: WidgetCustomization(
                backgroundColor: Color.green.opacity(0.1),
                textColor: .primary,
                accentColor: .green,
                cornerRadius: 16,
                padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
            )
        )
        
        return WidgetConfiguration(
            id: "calendar_config",
            templateIdentifier: identifier,
            widgets: [calendarWidget],
            settings: WidgetSettings(refreshInterval: 600.0, enableAnimations: true)
        )
    }
}

/// Fitness widget template
@available(iOS 16.0, *)
public class FitnessWidgetTemplate: WidgetTemplate {
    public let identifier = "fitness_widget"
    public let displayName = "Fitness Widget"
    public let description = "Track fitness metrics and workout progress"
    public let supportedSizes: [WidgetFamily] = [.systemSmall, .systemMedium, .systemLarge]
    
    public func createWidget(configuration: WidgetConfiguration) -> AnyView {
        return AnyView(FitnessWidgetView(configuration: configuration))
    }
    
    public func validateConfiguration(_ configuration: WidgetConfiguration) -> Bool {
        return configuration.widgets.contains { $0.type == .fitness }
    }
    
    public func getDefaultConfiguration() -> WidgetConfiguration {
        let fitnessWidget = WidgetDefinition(
            id: "fitness_main",
            type: .fitness,
            dataSourceIdentifier: "health_kit",
            customization: WidgetCustomization(
                backgroundColor: Color.orange.opacity(0.1),
                textColor: .primary,
                accentColor: .orange,
                cornerRadius: 16,
                padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
            )
        )
        
        return WidgetConfiguration(
            id: "fitness_config",
            templateIdentifier: identifier,
            widgets: [fitnessWidget],
            settings: WidgetSettings(refreshInterval: 900.0, enableAnimations: true)
        )
    }
}

/// News widget template
@available(iOS 16.0, *)
public class NewsWidgetTemplate: WidgetTemplate {
    public let identifier = "news_widget"
    public let displayName = "News Widget"
    public let description = "Display latest news and headlines"
    public let supportedSizes: [WidgetFamily] = [.systemSmall, .systemMedium, .systemLarge]
    
    public func createWidget(configuration: WidgetConfiguration) -> AnyView {
        return AnyView(NewsWidgetView(configuration: configuration))
    }
    
    public func validateConfiguration(_ configuration: WidgetConfiguration) -> Bool {
        return configuration.widgets.contains { $0.type == .news }
    }
    
    public func getDefaultConfiguration() -> WidgetConfiguration {
        let newsWidget = WidgetDefinition(
            id: "news_main",
            type: .news,
            dataSourceIdentifier: "news_api",
            customization: WidgetCustomization(
                backgroundColor: Color.purple.opacity(0.1),
                textColor: .primary,
                accentColor: .purple,
                cornerRadius: 16,
                padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
            )
        )
        
        return WidgetConfiguration(
            id: "news_config",
            templateIdentifier: identifier,
            widgets: [newsWidget],
            settings: WidgetSettings(refreshInterval: 1800.0, enableAnimations: true)
        )
    }
}

/// Social media widget template
@available(iOS 16.0, *)
public class SocialMediaWidgetTemplate: WidgetTemplate {
    public let identifier = "social_media_widget"
    public let displayName = "Social Media Widget"
    public let description = "Show social media updates and notifications"
    public let supportedSizes: [WidgetFamily] = [.systemSmall, .systemMedium, .systemLarge]
    
    public func createWidget(configuration: WidgetConfiguration) -> AnyView {
        return AnyView(SocialMediaWidgetView(configuration: configuration))
    }
    
    public func validateConfiguration(_ configuration: WidgetConfiguration) -> Bool {
        return configuration.widgets.contains { $0.type == .social }
    }
    
    public func getDefaultConfiguration() -> WidgetConfiguration {
        let socialWidget = WidgetDefinition(
            id: "social_main",
            type: .social,
            dataSourceIdentifier: "social_api",
            customization: WidgetCustomization(
                backgroundColor: Color.pink.opacity(0.1),
                textColor: .primary,
                accentColor: .pink,
                cornerRadius: 16,
                padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
            )
        )
        
        return WidgetConfiguration(
            id: "social_config",
            templateIdentifier: identifier,
            widgets: [socialWidget],
            settings: WidgetSettings(refreshInterval: 1200.0, enableAnimations: true)
        )
    }
}

/// Productivity widget template
@available(iOS 16.0, *)
public class ProductivityWidgetTemplate: WidgetTemplate {
    public let identifier = "productivity_widget"
    public let displayName = "Productivity Widget"
    public let description = "Track tasks, goals, and productivity metrics"
    public let supportedSizes: [WidgetFamily] = [.systemSmall, .systemMedium, .systemLarge]
    
    public func createWidget(configuration: WidgetConfiguration) -> AnyView {
        return AnyView(ProductivityWidgetView(configuration: configuration))
    }
    
    public func validateConfiguration(_ configuration: WidgetConfiguration) -> Bool {
        return configuration.widgets.contains { $0.type == .productivity }
    }
    
    public func getDefaultConfiguration() -> WidgetConfiguration {
        let productivityWidget = WidgetDefinition(
            id: "productivity_main",
            type: .productivity,
            dataSourceIdentifier: "productivity_data",
            customization: WidgetCustomization(
                backgroundColor: Color.indigo.opacity(0.1),
                textColor: .primary,
                accentColor: .indigo,
                cornerRadius: 16,
                padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
            )
        )
        
        return WidgetConfiguration(
            id: "productivity_config",
            templateIdentifier: identifier,
            widgets: [productivityWidget],
            settings: WidgetSettings(refreshInterval: 600.0, enableAnimations: true)
        )
    }
}

/// Entertainment widget template
@available(iOS 16.0, *)
public class EntertainmentWidgetTemplate: WidgetTemplate {
    public let identifier = "entertainment_widget"
    public let displayName = "Entertainment Widget"
    public let description = "Show entertainment content and recommendations"
    public let supportedSizes: [WidgetFamily] = [.systemSmall, .systemMedium, .systemLarge]
    
    public func createWidget(configuration: WidgetConfiguration) -> AnyView {
        return AnyView(EntertainmentWidgetView(configuration: configuration))
    }
    
    public func validateConfiguration(_ configuration: WidgetConfiguration) -> Bool {
        return configuration.widgets.contains { $0.type == .entertainment }
    }
    
    public func getDefaultConfiguration() -> WidgetConfiguration {
        let entertainmentWidget = WidgetDefinition(
            id: "entertainment_main",
            type: .entertainment,
            dataSourceIdentifier: "entertainment_api",
            customization: WidgetCustomization(
                backgroundColor: Color.red.opacity(0.1),
                textColor: .primary,
                accentColor: .red,
                cornerRadius: 16,
                padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
            )
        )
        
        return WidgetConfiguration(
            id: "entertainment_config",
            templateIdentifier: identifier,
            widgets: [entertainmentWidget],
            settings: WidgetSettings(refreshInterval: 3600.0, enableAnimations: true)
        )
    }
}

/// Finance widget template
@available(iOS 16.0, *)
public class FinanceWidgetTemplate: WidgetTemplate {
    public let identifier = "finance_widget"
    public let displayName = "Finance Widget"
    public let description = "Display financial data and market information"
    public let supportedSizes: [WidgetFamily] = [.systemSmall, .systemMedium, .systemLarge]
    
    public func createWidget(configuration: WidgetConfiguration) -> AnyView {
        return AnyView(FinanceWidgetView(configuration: configuration))
    }
    
    public func validateConfiguration(_ configuration: WidgetConfiguration) -> Bool {
        return configuration.widgets.contains { $0.type == .finance }
    }
    
    public func getDefaultConfiguration() -> WidgetConfiguration {
        let financeWidget = WidgetDefinition(
            id: "finance_main",
            type: .finance,
            dataSourceIdentifier: "finance_api",
            customization: WidgetCustomization(
                backgroundColor: Color.green.opacity(0.1),
                textColor: .primary,
                accentColor: .green,
                cornerRadius: 16,
                padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
            )
        )
        
        return WidgetConfiguration(
            id: "finance_config",
            templateIdentifier: identifier,
            widgets: [financeWidget],
            settings: WidgetSettings(refreshInterval: 300.0, enableAnimations: true)
        )
    }
}

/// Health widget template
@available(iOS 16.0, *)
public class HealthWidgetTemplate: WidgetTemplate {
    public let identifier = "health_widget"
    public let displayName = "Health Widget"
    public let description = "Monitor health metrics and wellness data"
    public let supportedSizes: [WidgetFamily] = [.systemSmall, .systemMedium, .systemLarge]
    
    public func createWidget(configuration: WidgetConfiguration) -> AnyView {
        return AnyView(HealthWidgetView(configuration: configuration))
    }
    
    public func validateConfiguration(_ configuration: WidgetConfiguration) -> Bool {
        return configuration.widgets.contains { $0.type == .health }
    }
    
    public func getDefaultConfiguration() -> WidgetConfiguration {
        let healthWidget = WidgetDefinition(
            id: "health_main",
            type: .health,
            dataSourceIdentifier: "health_kit",
            customization: WidgetCustomization(
                backgroundColor: Color.teal.opacity(0.1),
                textColor: .primary,
                accentColor: .teal,
                cornerRadius: 16,
                padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
            )
        )
        
        return WidgetConfiguration(
            id: "health_config",
            templateIdentifier: identifier,
            widgets: [healthWidget],
            settings: WidgetSettings(refreshInterval: 1800.0, enableAnimations: true)
        )
    }
}

/// Travel widget template
@available(iOS 16.0, *)
public class TravelWidgetTemplate: WidgetTemplate {
    public let identifier = "travel_widget"
    public let displayName = "Travel Widget"
    public let description = "Show travel information and trip details"
    public let supportedSizes: [WidgetFamily] = [.systemSmall, .systemMedium, .systemLarge]
    
    public func createWidget(configuration: WidgetConfiguration) -> AnyView {
        return AnyView(TravelWidgetView(configuration: configuration))
    }
    
    public func validateConfiguration(_ configuration: WidgetConfiguration) -> Bool {
        return configuration.widgets.contains { $0.type == .travel }
    }
    
    public func getDefaultConfiguration() -> WidgetConfiguration {
        let travelWidget = WidgetDefinition(
            id: "travel_main",
            type: .travel,
            dataSourceIdentifier: "travel_api",
            customization: WidgetCustomization(
                backgroundColor: Color.cyan.opacity(0.1),
                textColor: .primary,
                accentColor: .cyan,
                cornerRadius: 16,
                padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
            )
        )
        
        return WidgetConfiguration(
            id: "travel_config",
            templateIdentifier: identifier,
            widgets: [travelWidget],
            settings: WidgetSettings(refreshInterval: 900.0, enableAnimations: true)
        )
    }
} 