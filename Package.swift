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
        // Main library product - Complete framework
        .library(
            name: "WidgetDevelopmentKit",
            targets: ["WidgetDevelopmentKit"]
        ),
        // Core functionality only
        .library(
            name: "WidgetDevelopmentKitCore",
            targets: ["WidgetDevelopmentKitCore"]
        ),
        // Security features only
        .library(
            name: "WidgetDevelopmentKitSecurity",
            targets: ["WidgetDevelopmentKitSecurity"]
        ),
        // Performance features only
        .library(
            name: "WidgetDevelopmentKitPerformance",
            targets: ["WidgetDevelopmentKitPerformance"]
        ),
        // Enterprise features only
        .library(
            name: "WidgetDevelopmentKitEnterprise",
            targets: ["WidgetDevelopmentKitEnterprise"]
        ),
        // Integration features only
        .library(
            name: "WidgetDevelopmentKitIntegration",
            targets: ["WidgetDevelopmentKitIntegration"]
        )
    ],
    dependencies: [
        // Apple's async algorithms for advanced async operations
        .package(url: "https://github.com/apple/swift-async-algorithms", from: "1.0.0"),
        // Apple's collections for efficient data structures
        .package(url: "https://github.com/apple/swift-collections", from: "1.0.0"),
        // Apple's crypto for enterprise-grade encryption
        .package(url: "https://github.com/apple/swift-crypto", from: "3.0.0"),
        // Apple's metrics for performance monitoring
        .package(url: "https://github.com/apple/swift-metrics", from: "2.0.0"),
        // Apple's log for structured logging
        .package(url: "https://github.com/apple/swift-log", from: "1.0.0"),
        // Networking with Alamofire
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.8.0"),
        // Image loading and caching
        .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI", from: "2.0.0"),
        // Keychain wrapper for secure storage
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", from: "4.0.0"),
        // Network reachability monitoring
        .package(url: "https://github.com/ashleymills/Reachability.swift", from: "5.0.0"),
        // Testing frameworks
        .package(url: "https://github.com/Quick/Quick", from: "7.0.0"),
        .package(url: "https://github.com/Quick/Nimble", from: "13.0.0")
    ],
    targets: [
        // Main target combining all features
        .target(
            name: "WidgetDevelopmentKit",
            dependencies: [
                "WidgetDevelopmentKitCore",
                "WidgetDevelopmentKitSecurity",
                "WidgetDevelopmentKitPerformance",
                "WidgetDevelopmentKitEnterprise",
                "WidgetDevelopmentKitIntegration"
            ],
            path: "Sources",
            exclude: ["Info.plist", "Resources/.gitkeep"],
            resources: [
                .process("Resources")
            ],
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug)),
                .define("RELEASE", .when(configuration: .release)),
                .enableExperimentalFeature("StrictConcurrency"),
                .enableUpcomingFeature("BareSlashRegexLiterals")
            ]
        ),
        
        // Core functionality
        .target(
            name: "WidgetDevelopmentKitCore",
            dependencies: [
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "Logging", package: "swift-log")
            ],
            path: "Sources/Core",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        
        // Security features
        .target(
            name: "WidgetDevelopmentKitSecurity",
            dependencies: [
                "WidgetDevelopmentKitCore",
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "KeychainAccess", package: "KeychainAccess")
            ],
            path: "Sources/Security",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        
        // Performance features
        .target(
            name: "WidgetDevelopmentKitPerformance",
            dependencies: [
                "WidgetDevelopmentKitCore",
                .product(name: "Metrics", package: "swift-metrics"),
                .product(name: "SDWebImageSwiftUI", package: "SDWebImageSwiftUI")
            ],
            path: "Sources/Performance",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        
        // Enterprise features
        .target(
            name: "WidgetDevelopmentKitEnterprise",
            dependencies: [
                "WidgetDevelopmentKitCore",
                "WidgetDevelopmentKitSecurity"
            ],
            path: "Sources/Enterprise",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        
        // Integration features
        .target(
            name: "WidgetDevelopmentKitIntegration",
            dependencies: [
                "WidgetDevelopmentKitCore",
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "Reachability", package: "Reachability.swift")
            ],
            path: "Sources/Integration",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        
        // Test targets
        .testTarget(
            name: "WidgetDevelopmentKitTests",
            dependencies: [
                "WidgetDevelopmentKit",
                .product(name: "Quick", package: "Quick"),
                .product(name: "Nimble", package: "Nimble")
            ],
            path: "Tests/WidgetDevelopmentKitTests",
            resources: [
                .process("Resources")
            ]
        ),
        
        .testTarget(
            name: "WidgetDevelopmentKitCoreTests",
            dependencies: [
                "WidgetDevelopmentKitCore",
                .product(name: "Quick", package: "Quick"),
                .product(name: "Nimble", package: "Nimble")
            ],
            path: "Tests/CoreTests"
        ),
        
        .testTarget(
            name: "WidgetDevelopmentKitSecurityTests",
            dependencies: [
                "WidgetDevelopmentKitSecurity",
                .product(name: "Quick", package: "Quick"),
                .product(name: "Nimble", package: "Nimble")
            ],
            path: "Tests/SecurityTests"
        ),
        
        .testTarget(
            name: "WidgetDevelopmentKitPerformanceTests",
            dependencies: [
                "WidgetDevelopmentKitPerformance",
                .product(name: "Quick", package: "Quick"),
                .product(name: "Nimble", package: "Nimble")
            ],
            path: "Tests/PerformanceTests"
        ),
        
        .testTarget(
            name: "WidgetDevelopmentKitEnterpriseTests",
            dependencies: [
                "WidgetDevelopmentKitEnterprise",
                .product(name: "Quick", package: "Quick"),
                .product(name: "Nimble", package: "Nimble")
            ],
            path: "Tests/EnterpriseTests"
        ),
        
        .testTarget(
            name: "WidgetDevelopmentKitIntegrationTests",
            dependencies: [
                "WidgetDevelopmentKitIntegration",
                .product(name: "Quick", package: "Quick"),
                .product(name: "Nimble", package: "Nimble")
            ],
            path: "Tests/IntegrationTests"
        )
    ],
    swiftLanguageVersions: [.v5]
) 