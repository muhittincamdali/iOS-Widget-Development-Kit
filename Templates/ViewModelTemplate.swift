// MARK: - Widget ViewModel Template
// Use this template for creating new Widget ViewModels

import Foundation
import WidgetKit
import SwiftUI

// MARK: - Timeline Provider
struct __NAME__Provider: TimelineProvider {
    typealias Entry = __NAME__Entry
    
    // MARK: - Placeholder
    func placeholder(in context: Context) -> __NAME__Entry {
        __NAME__Entry(date: Date(), data: .placeholder)
    }
    
    // MARK: - Snapshot
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        let entry = __NAME__Entry(date: Date(), data: .placeholder)
        completion(entry)
    }
    
    // MARK: - Timeline
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        Task {
            do {
                let data = try await fetchData()
                let entry = __NAME__Entry(date: Date(), data: data)
                let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                let entry = __NAME__Entry(date: Date(), data: .placeholder)
                let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(300)))
                completion(timeline)
            }
        }
    }
    
    // MARK: - Data Fetching
    private func fetchData() async throws -> __NAME__Data {
        // Implement data fetching logic
        return .placeholder
    }
}

// MARK: - Entry
struct __NAME__Entry: TimelineEntry {
    let date: Date
    let data: __NAME__Data
}

// MARK: - Data Model
struct __NAME__Data {
    let title: String
    let subtitle: String
    let value: Double
    
    static var placeholder: __NAME__Data {
        __NAME__Data(title: "Loading...", subtitle: "", value: 0)
    }
}

// MARK: - Widget View
struct __NAME__WidgetEntryView: View {
    var entry: __NAME__Provider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

// MARK: - Size-Specific Views
private struct SmallWidgetView: View {
    let entry: __NAME__Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(entry.data.title)
                .font(.headline)
            Text(entry.data.subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

private struct MediumWidgetView: View {
    let entry: __NAME__Entry
    
    var body: some View {
        HStack {
            SmallWidgetView(entry: entry)
            Spacer()
            Text("\(entry.data.value, specifier: "%.1f")")
                .font(.largeTitle)
                .bold()
        }
        .padding()
    }
}

private struct LargeWidgetView: View {
    let entry: __NAME__Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            MediumWidgetView(entry: entry)
            // Add more content for large widget
        }
        .padding()
    }
}

// MARK: - Widget Definition
struct __NAME__Widget: Widget {
    let kind: String = "__NAME__Widget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: __NAME__Provider()) { entry in
            __NAME__WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("__NAME__ Widget")
        .description("Widget description goes here.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
