// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "WidgetDevelopmentKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "WidgetDevelopmentKit", targets: ["WidgetDevelopmentKit"])
    ],
    targets: [
        .target(
            name: "WidgetDevelopmentKit",
            path: "Sources/WidgetDevelopmentKit"
        )
    ]
)
