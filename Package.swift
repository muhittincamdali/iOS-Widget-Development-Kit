// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
        .library(name: "WidgetDevelopmentKitCore", targets: ["WidgetDevelopmentKitCore"]),
        .library(name: "WidgetDevelopmentKitSecurity", targets: ["WidgetDevelopmentKitSecurity"]),
        .library(name: "WidgetDevelopmentKitPerformance", targets: ["WidgetDevelopmentKitPerformance"])
    ],
    dependencies: [
        // Only Apple standard libraries and internal core tools allowed
        .package(url: "https://github.com/apple/swift-async-algorithms", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-collections", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-crypto", from: "3.0.0"),
        // Testing frameworks
        .package(url: "https://github.com/Quick/Quick", from: "7.0.0"),
        .package(url: "https://github.com/Quick/Nimble", from: "13.0.0")
    ],
    targets: [
        .target(
            name: "WidgetDevelopmentKit",
            dependencies: [
                "WidgetDevelopmentKitCore",
                "WidgetDevelopmentKitSecurity",
                "WidgetDevelopmentKitPerformance"
            ],
            path: "Sources",
            exclude: ["Core", "Security", "Performance", "Integration", "Enterprise"],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        
        .target(
            name: "WidgetDevelopmentKitCore",
            dependencies: [
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
                .product(name: "Collections", package: "swift-collections")
            ],
            path: "Sources/Core",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        
        .target(
            name: "WidgetDevelopmentKitSecurity",
            dependencies: [
                "WidgetDevelopmentKitCore",
                .product(name: "Crypto", package: "swift-crypto")
            ],
            path: "Sources/Security",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        
        .target(
            name: "WidgetDevelopmentKitPerformance",
            dependencies: [
                "WidgetDevelopmentKitCore"
            ],
            path: "Sources/Performance",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        
        // Test targets
        .testTarget(
            name: "UnitTests",
            dependencies: [
                "WidgetDevelopmentKit",
                .product(name: "Quick", package: "Quick"),
                .product(name: "Nimble", package: "Nimble")
            ],
            path: "Tests/Unit"
        ),
        
        .testTarget(
            name: "IntegrationTests",
            dependencies: [
                "WidgetDevelopmentKit",
                .product(name: "Quick", package: "Quick"),
                .product(name: "Nimble", package: "Nimble")
            ],
            path: "Tests/Integration"
        ),
        
        .testTarget(
            name: "PerformanceTests",
            dependencies: [
                "WidgetDevelopmentKit",
                .product(name: "Quick", package: "Quick"),
                .product(name: "Nimble", package: "Nimble")
            ],
            path: "Tests/Performance"
        )
    ]
)