import SwiftUI
import WidgetKit

/// A SwiftUI view for scrubbing through a widget's timeline.
/// 
/// This tool allows developers to visualize how their widget changes over time.
public struct WidgetTimelineScrubber<Content: View, T: TimelineEntry>: View {
    public let entries: [T]
    public let content: (T) -> Content
    
    @State private var currentIndex: Int = 0
    
    public init(entries: [T], @ViewBuilder content: @escaping (T) -> Content) {
        self.entries = entries
        self.content = content
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            if entries.isEmpty {
                Text("No timeline entries provided")
                    .foregroundColor(.secondary)
            } else {
                let currentEntry = entries[currentIndex]
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Timeline Entry \(currentIndex + 1) of \(entries.count)")
                        .font(.caption.bold())
                        .foregroundColor(.secondary)
                    
                    Text("Date: \(currentEntry.date.description)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                content(currentEntry)
                    .frame(width: 158, height: 158) // Standard small widget size
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .shadow(radius: 10)
                
                Slider(value: Binding(
                    get: { Double(currentIndex) },
                    set: { currentIndex = Int($0) }
                ), in: 0...Double(max(0, entries.count - 1)), step: 1)
                .padding(.horizontal)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }
}
