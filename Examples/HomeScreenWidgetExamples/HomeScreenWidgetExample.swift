import SwiftUI
import WidgetKit

// MARK: - Home Screen Widget Example
struct HomeScreenWidgetExample: Widget {
    let kind: String = "com.company.app.homescreenwidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HomeScreenWidgetProvider()) { entry in
            HomeScreenWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Home Screen Widget")
        .description("A beautiful home screen widget example")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Widget Provider
struct HomeScreenWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> HomeScreenWidgetEntry {
        HomeScreenWidgetEntry(date: Date(), title: "Welcome", message: "Tap to open app")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (HomeScreenWidgetEntry) -> ()) {
        let entry = HomeScreenWidgetEntry(date: Date(), title: "Welcome", message: "Tap to open app")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<HomeScreenWidgetEntry>) -> ()) {
        let currentDate = Date()
        let entry = HomeScreenWidgetEntry(date: currentDate, title: "Welcome", message: "Tap to open app")
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

// MARK: - Widget Entry
struct HomeScreenWidgetEntry: TimelineEntry {
    let date: Date
    let title: String
    let message: String
}

// MARK: - Widget Entry View
struct HomeScreenWidgetEntryView: View {
    let entry: HomeScreenWidgetEntry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "house.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                
                Spacer()
                
                Text(entry.title)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            Text(entry.message)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button("Open App") {
                // Deep link to app
            }
            .buttonStyle(.bordered)
            .font(.caption)
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

// MARK: - Preview
struct HomeScreenWidgetExample_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenWidgetEntryView(entry: HomeScreenWidgetEntry(date: Date(), title: "Welcome", message: "Tap to open app"))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
} 