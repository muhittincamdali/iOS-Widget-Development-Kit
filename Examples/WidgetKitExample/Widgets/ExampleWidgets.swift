import SwiftUI
import WidgetKit

@main
struct ExampleWidgets: WidgetBundle {
    var body: some Widget {
        LaunchCountdownWidget()
        StepsWidget()
        WaterWidget()
    }
}
