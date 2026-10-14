import AppIntents
import WidgetDevelopmentKit

// Without this, the App Intents metadata processor does not see the package's intents,
// and the buttons in the water widget do nothing.
struct AppIntentsRoot: AppIntentsPackage {
    static var includedPackages: [any AppIntentsPackage.Type] {
        [WidgetDevelopmentKitIntents.self]
    }
}
