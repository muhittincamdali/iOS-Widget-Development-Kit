import SwiftUI
import WidgetKit

/// A debugging view that steps through a widget's timeline entries.
///
/// Embed it in an app target or a SwiftUI preview to check how a widget looks at
/// each entry without waiting for WidgetKit to advance the timeline.
///
/// ```swift
/// WidgetTimelineScrubber(entries: timeline.entries) { entry in
///     MyWidgetView(entry: entry)
/// }
/// ```
public struct WidgetTimelineScrubber<Content: View, Entry: TimelineEntry>: View {
    public let entries: [Entry]
    public let widgetSize: CGSize
    public let content: (Entry) -> Content

    @State private var selectedIndex = 0

    /// - Parameter widgetSize: Frame used for the preview; defaults to a small widget on a 6.1" iPhone.
    public init(
        entries: [Entry],
        widgetSize: CGSize = CGSize(width: 158, height: 158),
        @ViewBuilder content: @escaping (Entry) -> Content
    ) {
        self.entries = entries
        self.widgetSize = widgetSize
        self.content = content
    }

    public var body: some View {
        VStack(spacing: 20) {
            if entries.isEmpty {
                Text("No timeline entries provided")
                    .foregroundStyle(.secondary)
            } else {
                let index = Self.clampedIndex(selectedIndex, count: entries.count)
                let entry = entries[index]

                VStack(alignment: .leading, spacing: 4) {
                    Text("Entry \(index + 1) of \(entries.count)")
                        .font(.caption.bold())
                    Text(entry.date, format: .dateTime.month().day().hour().minute())
                        .font(.caption2)
                }
                .foregroundStyle(.secondary)

                content(entry)
                    .frame(width: widgetSize.width, height: widgetSize.height)
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .shadow(radius: 10)

                if entries.count > 1 {
                    Slider(
                        value: Binding(
                            get: { Double(index) },
                            set: { selectedIndex = Int($0.rounded()) }
                        ),
                        in: 0...Double(entries.count - 1),
                        step: 1
                    )
                    .padding(.horizontal)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
    }

    /// Keeps a stored index valid when the entries array shrinks.
    static func clampedIndex(_ index: Int, count: Int) -> Int {
        guard count > 0 else { return 0 }
        return min(max(index, 0), count - 1)
    }
}
