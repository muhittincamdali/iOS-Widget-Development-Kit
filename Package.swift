// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "WidgetDevelopmentKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .watchOS(.v9),
        .tvOS(.v16),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "WidgetDevelopmentKit", targets: ["WidgetDevelopmentKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-async-algorithms", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "WidgetDevelopmentKit",
            dependencies: [
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
            ],
            path: "Sources/WidgetDevelopmentKit",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "WidgetDevelopmentKitTests",
            dependencies: ["WidgetDevelopmentKit"],
            path: "Tests/Unit"
        )
    ]
)
