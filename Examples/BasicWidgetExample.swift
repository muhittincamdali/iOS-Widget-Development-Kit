import SwiftUI
import WidgetKit
import WidgetTemplates

@available(iOS 16.0, *)
struct BasicWidgetExample: View {
    @StateObject private var widgetEngine = WidgetEngine.shared
    @State private var selectedTemplate: WidgetTemplate?
    @State private var widgetConfiguration: WidgetConfiguration?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Template Selection
                VStack(alignment: .leading, spacing: 10) {
                    Text("Select Widget Template")
                        .font(.headline)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            TemplateCard(
                                template: WeatherWidgetTemplate(),
                                isSelected: selectedTemplate?.identifier == "weather_widget"
                            ) {
                                selectedTemplate = WeatherWidgetTemplate()
                            }
                            
                            TemplateCard(
                                template: CalendarWidgetTemplate(),
                                isSelected: selectedTemplate?.identifier == "calendar_widget"
                            ) {
                                selectedTemplate = CalendarWidgetTemplate()
                            }
                            
                            TemplateCard(
                                template: FitnessWidgetTemplate(),
                                isSelected: selectedTemplate?.identifier == "fitness_widget"
                            ) {
                                selectedTemplate = FitnessWidgetTemplate()
                            }
                            
                            TemplateCard(
                                template: NewsWidgetTemplate(),
                                isSelected: selectedTemplate?.identifier == "news_widget"
                            ) {
                                selectedTemplate = NewsWidgetTemplate()
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Widget Preview
                if let configuration = widgetConfiguration {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Widget Preview")
                            .font(.headline)
                        
                        widgetEngine.createWidget(with: configuration)
                            .frame(height: 200)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                    }
                }
                
                // Customization Options
                if let template = selectedTemplate {
                    CustomizationPanel(template: template) { configuration in
                        self.widgetConfiguration = configuration
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Widget Builder")
        }
    }
}

@available(iOS 16.0, *)
struct TemplateCard: View {
    let template: WidgetTemplate
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: iconName)
                .font(.title)
                .foregroundColor(isSelected ? .white : .blue)
            
            Text(template.displayName)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .frame(width: 80, height: 80)
        .background(isSelected ? Color.blue : Color.gray.opacity(0.1))
        .cornerRadius(12)
        .onTapGesture {
            onTap()
        }
    }
    
    private var iconName: String {
        switch template.identifier {
        case "weather_widget": return "cloud.sun.fill"
        case "calendar_widget": return "calendar"
        case "fitness_widget": return "figure.walk"
        case "news_widget": return "newspaper"
        default: return "square.fill"
        }
    }
}

@available(iOS 16.0, *)
struct CustomizationPanel: View {
    let template: WidgetTemplate
    let onConfigurationChange: (WidgetConfiguration) -> Void
    
    @State private var backgroundColor = Color.blue.opacity(0.1)
    @State private var textColor = Color.primary
    @State private var accentColor = Color.blue
    @State private var cornerRadius: CGFloat = 12
    @State private var refreshInterval: Double = 30.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Customization")
                .font(.headline)
            
            VStack(spacing: 10) {
                ColorPicker("Background Color", selection: $backgroundColor)
                ColorPicker("Text Color", selection: $textColor)
                ColorPicker("Accent Color", selection: $accentColor)
                
                HStack {
                    Text("Corner Radius")
                    Slider(value: $cornerRadius, in: 0...20)
                    Text("\(Int(cornerRadius))")
                }
                
                HStack {
                    Text("Refresh Interval")
                    Slider(value: $refreshInterval, in: 10...300)
                    Text("\(Int(refreshInterval))s")
                }
            }
            
            Button("Create Widget") {
                createWidget()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func createWidget() {
        let customization = WidgetCustomization(
            backgroundColor: backgroundColor,
            textColor: textColor,
            accentColor: accentColor,
            cornerRadius: cornerRadius
        )
        
        let widgetDefinition = WidgetDefinition(
            id: "custom_widget",
            type: widgetType,
            dataSourceIdentifier: dataSourceIdentifier,
            customization: customization
        )
        
        let configuration = WidgetConfiguration(
            id: "custom_config",
            templateIdentifier: template.identifier,
            widgets: [widgetDefinition],
            settings: WidgetSettings(refreshInterval: refreshInterval)
        )
        
        onConfigurationChange(configuration)
    }
    
    private var widgetType: WidgetType {
        switch template.identifier {
        case "weather_widget": return .weather
        case "calendar_widget": return .calendar
        case "fitness_widget": return .fitness
        case "news_widget": return .news
        default: return .weather
        }
    }
    
    private var dataSourceIdentifier: String {
        switch template.identifier {
        case "weather_widget": return "weather_api"
        case "calendar_widget": return "calendar_events"
        case "fitness_widget": return "health_kit"
        case "news_widget": return "news_api"
        default: return "default_api"
        }
    }
}

@available(iOS 16.0, *)
struct BasicWidgetExample_Previews: PreviewProvider {
    static var previews: some View {
        BasicWidgetExample()
    }
} 