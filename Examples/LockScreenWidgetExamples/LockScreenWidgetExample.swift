import SwiftUI
import WidgetKit

// MARK: - Lock Screen Widget Example
struct LockScreenWidgetExample: Widget {
    let kind: String = "com.company.app.lockscreenwidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LockScreenWidgetProvider()) { entry in
            LockScreenWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Lock Screen Widget")
        .description("A beautiful lock screen widget example")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Widget Provider
struct LockScreenWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> LockScreenWidgetEntry {
        LockScreenWidgetEntry(date: Date(), icon: "message.fill", title: "Messages", count: "3 new")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (LockScreenWidgetEntry) -> ()) {
        let entry = LockScreenWidgetEntry(date: Date(), icon: "message.fill", title: "Messages", count: "3 new")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<LockScreenWidgetEntry>) -> ()) {
        let currentDate = Date()
        let entry = LockScreenWidgetEntry(date: currentDate, icon: "message.fill", title: "Messages", count: "3 new")
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

// MARK: - Widget Entry
struct LockScreenWidgetEntry: TimelineEntry {
    let date: Date
    let icon: String
    let title: String
    let count: String
}

// MARK: - Widget Entry View
struct LockScreenWidgetEntryView: View {
    let entry: LockScreenWidgetEntry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: entry.icon)
                .foregroundColor(.blue)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(entry.count)
                    .font(.caption2)
                    .foregroundColor(.primary)
                    .fontWeight(.medium)
            }
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
}

// MARK: - Preview
struct LockScreenWidgetExample_Previews: PreviewProvider {
    static var previews: some View {
        LockScreenWidgetEntryView(entry: LockScreenWidgetEntry(date: Date(), icon: "message.fill", title: "Messages", count: "3 new"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
} 