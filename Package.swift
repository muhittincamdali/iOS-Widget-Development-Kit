// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iOSWidgetDevelopmentKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "WidgetKit",
            targets: ["WidgetKit"]
        ),
        .library(
            name: "WidgetTemplates",
            targets: ["WidgetTemplates"]
        ),
        .library(
            name: "LiveDataIntegration",
            targets: ["LiveDataIntegration"]
        ),
        .library(
            name: "WidgetAnalytics",
            targets: ["WidgetAnalytics"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.1"),
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.54.0"),
        .package(url: "https://github.com/Quick/Quick.git", from: "7.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "13.7.1")
    ],
    targets: [
        .target(
            name: "WidgetKit",
            dependencies: ["Alamofire"],
            path: "Sources/Core",
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug)),
                .define("RELEASE", .when(configuration: .release))
            ]
        ),
        .target(
            name: "WidgetTemplates",
            dependencies: ["WidgetKit"],
            path: "Sources/Widgets",
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "LiveDataIntegration",
            dependencies: ["WidgetKit", "Alamofire"],
            path: "Sources/LiveData"
        ),
        .target(
            name: "WidgetAnalytics",
            dependencies: ["WidgetKit"],
            path: "Sources/Analytics"
        ),
        .testTarget(
            name: "WidgetKitTests",
            dependencies: ["WidgetKit", "Quick", "Nimble"],
            path: "Tests/Unit"
        ),
        .testTarget(
            name: "WidgetTemplatesTests",
            dependencies: ["WidgetTemplates", "Quick", "Nimble"],
            path: "Tests/Integration"
        ),
        .testTarget(
            name: "LiveDataIntegrationTests",
            dependencies: ["LiveDataIntegration", "Quick", "Nimble"],
            path: "Tests/Performance"
        )
    ]
) 