import SwiftUI
import WidgetKit
import WidgetDevelopmentKit

struct WaterEntry: TimelineEntry {
    let date: Date
    let intake: Int
}

struct WaterProvider: TimelineProvider {
    func placeholder(in context: Context) -> WaterEntry {
        WaterEntry(date: .now, intake: 750)
    }

    func getSnapshot(in context: Context, completion: @escaping (WaterEntry) -> Void) {
        completion(currentEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WaterEntry>) -> Void) {
        // IncrementIntent reloads the timeline after each tap, so no scheduled reload is needed.
        completion(.single(currentEntry(), policy: .never))
    }

    private func currentEntry() -> WaterEntry {
        WaterEntry(date: .now, intake: WidgetStateStore.shared.value("water"))
    }
}

/// The "+" button runs `IncrementIntent` in the extension, which adds 250 ml to the
/// "water" counter in the App Group named by `WidgetDevelopmentKitAppGroup` in Info.plist.
struct WaterWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "water", provider: WaterProvider()) { entry in
            InteractiveWaterWidget(trackerId: "water", currentIntake: Double(entry.intake))
        }
        .configurationDisplayName("Water")
        .supportedFamilies([.systemSmall])
    }
}
