import SwiftUI
import WidgetKit
import WidgetDevelopmentKit

struct StepsWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "steps", provider: StepsProvider()) { entry in
            StepsWidgetView(entry: entry)
        }
        .configurationDisplayName("Steps")
        .supportedFamilies([.systemSmall])
    }
}
