import SwiftUI
import WidgetKit
import WidgetTemplates

// MARK: - Calendar Widget Example
// This example demonstrates how to create a beautiful calendar widget
// with event management and date navigation

struct CalendarWidgetExample: Widget {
    static let kind: String = "com.company.app.calendarwidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CalendarTimelineProvider()) { entry in
            CalendarWidgetView(entry: entry)
        }
        .configurationDisplayName("Calendar Widget")
        .description("Displays calendar events and date information")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Calendar Timeline Provider
struct CalendarTimelineProvider: TimelineProvider {
    typealias Entry = CalendarWidgetEntry
    
    func placeholder(in context: Context) -> CalendarWidgetEntry {
        CalendarWidgetEntry(
            date: Date(),
            currentDate: Date(),
            events: [
                CalendarEvent(title: "Team Meeting", time: "10:00 AM", isAllDay: false),
                CalendarEvent(title: "Lunch", time: "12:00 PM", isAllDay: false),
                CalendarEvent(title: "Project Deadline", time: "5:00 PM", isAllDay: false)
            ],
            eventCount: 3,
            nextEvent: CalendarEvent(title: "Team Meeting", time: "10:00 AM", isAllDay: false)
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (CalendarWidgetEntry) -> Void) {
        let entry = CalendarWidgetEntry(
            date: Date(),
            currentDate: Date(),
            events: [
                CalendarEvent(title: "Team Meeting", time: "10:00 AM", isAllDay: false),
                CalendarEvent(title: "Lunch", time: "12:00 PM", isAllDay: false),
                CalendarEvent(title: "Project Deadline", time: "5:00 PM", isAllDay: false)
            ],
            eventCount: 3,
            nextEvent: CalendarEvent(title: "Team Meeting", time: "10:00 AM", isAllDay: false)
        )
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<CalendarWidgetEntry>) -> Void) {
        let currentDate = Date()
        let calendar = Calendar.current
        
        // Generate entries for the next 7 days
        let entries = (0..<7).map { dayOffset in
            let entryDate = calendar.date(byAdding: .day, value: dayOffset, to: currentDate)!
            let events = generateEvents(for: entryDate)
            
            return CalendarWidgetEntry(
                date: entryDate,
                currentDate: entryDate,
                events: events,
                eventCount: events.count,
                nextEvent: events.first
            )
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    private func generateEvents(for date: Date) -> [CalendarEvent] {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        
        var events: [CalendarEvent] = []
        
        // Add events based on the day of the week
        switch weekday {
        case 1: // Sunday
            events = [
                CalendarEvent(title: "Family Brunch", time: "11:00 AM", isAllDay: false),
                CalendarEvent(title: "Weekly Planning", time: "2:00 PM", isAllDay: false)
            ]
        case 2: // Monday
            events = [
                CalendarEvent(title: "Team Meeting", time: "9:00 AM", isAllDay: false),
                CalendarEvent(title: "Client Call", time: "2:00 PM", isAllDay: false),
                CalendarEvent(title: "Gym Session", time: "6:00 PM", isAllDay: false)
            ]
        case 3: // Tuesday
            events = [
                CalendarEvent(title: "Project Review", time: "10:00 AM", isAllDay: false),
                CalendarEvent(title: "Lunch with Colleague", time: "12:30 PM", isAllDay: false)
            ]
        case 4: // Wednesday
            events = [
                CalendarEvent(title: "Board Meeting", time: "11:00 AM", isAllDay: false),
                CalendarEvent(title: "Team Building", time: "4:00 PM", isAllDay: false)
            ]
        case 5: // Thursday
            events = [
                CalendarEvent(title: "Product Demo", time: "10:00 AM", isAllDay: false),
                CalendarEvent(title: "Weekly Report", time: "3:00 PM", isAllDay: false)
            ]
        case 6: // Friday
            events = [
                CalendarEvent(title: "Weekend Planning", time: "2:00 PM", isAllDay: false),
                CalendarEvent(title: "Happy Hour", time: "5:00 PM", isAllDay: false)
            ]
        case 7: // Saturday
            events = [
                CalendarEvent(title: "Shopping", time: "10:00 AM", isAllDay: false),
                CalendarEvent(title: "Movie Night", time: "7:00 PM", isAllDay: false)
            ]
        default:
            events = []
        }
        
        return events
    }
}

// MARK: - Calendar Widget Entry
struct CalendarWidgetEntry: TimelineEntry {
    let date: Date
    let currentDate: Date
    let events: [CalendarEvent]
    let eventCount: Int
    let nextEvent: CalendarEvent?
}

// MARK: - Calendar Event
struct CalendarEvent {
    let title: String
    let time: String
    let isAllDay: Bool
}

// MARK: - Calendar Widget View
struct CalendarWidgetView: View {
    let entry: CalendarWidgetEntry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallCalendarWidgetView(entry: entry)
        case .systemMedium:
            MediumCalendarWidgetView(entry: entry)
        default:
            SmallCalendarWidgetView(entry: entry)
        }
    }
}

// MARK: - Small Calendar Widget
struct SmallCalendarWidgetView: View {
    let entry: CalendarWidgetEntry
    
    var body: some View {
        VStack(spacing: 8) {
            // Date header
            HStack {
                Text(formatDate(entry.currentDate))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(entry.eventCount)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue)
                    .clipShape(Circle())
            }
            
            // Next event
            if let nextEvent = entry.nextEvent {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Next")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    
                    Text(nextEvent.title)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text(nextEvent.time)
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text("No events today")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            Spacer()
            
            // Calendar icon
            Image(systemName: "calendar")
                .font(.system(size: 20))
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color(.systemBackground))
        .widgetURL(URL(string: "calendarwidget://open"))
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

// MARK: - Medium Calendar Widget
struct MediumCalendarWidgetView: View {
    let entry: CalendarWidgetEntry
    
    var body: some View {
        HStack(spacing: 16) {
            // Left side - Date and event count
            VStack(alignment: .leading, spacing: 8) {
                // Date
                Text(formatDate(entry.currentDate))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                // Day of week
                Text(formatDayOfWeek(entry.currentDate))
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                
                // Event count
                HStack {
                    Image(systemName: "calendar")
                        .font(.system(size: 12))
                        .foregroundColor(.blue)
                    
                    Text("\(entry.eventCount) events")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Right side - Events list
            VStack(alignment: .leading, spacing: 6) {
                Text("Today")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.secondary)
                
                if entry.events.isEmpty {
                    Text("No events")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                } else {
                    ForEach(Array(entry.events.prefix(3).enumerated()), id: \.offset) { index, event in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 6, height: 6)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(event.title)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                                
                                Text(event.time)
                                    .font(.system(size: 9))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    if entry.events.count > 3 {
                        Text("+\(entry.events.count - 3) more")
                            .font(.system(size: 10))
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .widgetURL(URL(string: "calendarwidget://open"))
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
    
    private func formatDayOfWeek(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
}

// MARK: - Calendar Widget Manager
class CalendarWidgetManager: ObservableObject {
    static let shared = CalendarWidgetManager()
    
    @Published var currentEvents: [CalendarEvent] = []
    @Published var selectedDate: Date = Date()
    
    private let calendar = Calendar.current
    private let eventStore = EventStore()
    
    private init() {
        loadEvents()
    }
    
    func loadEvents() {
        eventStore.fetchEvents(for: selectedDate) { events in
            DispatchQueue.main.async {
                self.currentEvents = events
            }
        }
    }
    
    func selectDate(_ date: Date) {
        selectedDate = date
        loadEvents()
    }
    
    func addEvent(_ event: CalendarEvent) {
        eventStore.addEvent(event, for: selectedDate) { success in
            if success {
                self.loadEvents()
            }
        }
    }
    
    func removeEvent(_ event: CalendarEvent) {
        eventStore.removeEvent(event, for: selectedDate) { success in
            if success {
                self.loadEvents()
            }
        }
    }
}

// MARK: - Event Store
class EventStore {
    private var events: [Date: [CalendarEvent]] = [:]
    
    func fetchEvents(for date: Date, completion: @escaping ([CalendarEvent]) -> Void) {
        let key = Calendar.current.startOfDay(for: date)
        completion(events[key] ?? [])
    }
    
    func addEvent(_ event: CalendarEvent, for date: Date, completion: @escaping (Bool) -> Void) {
        let key = Calendar.current.startOfDay(for: date)
        if events[key] == nil {
            events[key] = []
        }
        events[key]?.append(event)
        completion(true)
    }
    
    func removeEvent(_ event: CalendarEvent, for date: Date, completion: @escaping (Bool) -> Void) {
        let key = Calendar.current.startOfDay(for: date)
        events[key]?.removeAll { $0.title == event.title && $0.time == event.time }
        completion(true)
    }
}

// MARK: - Widget Bundle
@main
struct CalendarWidgetBundle: WidgetBundle {
    var body: some Widget {
        CalendarWidgetExample()
    }
}

// MARK: - Preview
struct CalendarWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        let entry = CalendarWidgetEntry(
            date: Date(),
            currentDate: Date(),
            events: [
                CalendarEvent(title: "Team Meeting", time: "10:00 AM", isAllDay: false),
                CalendarEvent(title: "Lunch", time: "12:00 PM", isAllDay: false),
                CalendarEvent(title: "Project Deadline", time: "5:00 PM", isAllDay: false)
            ],
            eventCount: 3,
            nextEvent: CalendarEvent(title: "Team Meeting", time: "10:00 AM", isAllDay: false)
        )
        
        Group {
            CalendarWidgetView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .previewDisplayName("Small Calendar Widget")
            
            CalendarWidgetView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .previewDisplayName("Medium Calendar Widget")
        }
    }
} 