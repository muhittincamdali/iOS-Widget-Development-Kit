# Installation Guide

<!-- TOC START -->
## Table of Contents
- [Installation Guide](#installation-guide)
- [Prerequisites](#prerequisites)
- [Installation Methods](#installation-methods)
  - [Swift Package Manager (Recommended)](#swift-package-manager-recommended)
  - [Manual Installation](#manual-installation)
- [Configuration](#configuration)
  - [Basic Setup](#basic-setup)
  - [Advanced Configuration](#advanced-configuration)
- [Dependencies](#dependencies)
- [Troubleshooting](#troubleshooting)
  - [Common Issues](#common-issues)
  - [Support](#support)
<!-- TOC END -->


## Prerequisites

- iOS 16.0+
- Xcode 14.0+
- Swift 5.9+
- macOS 13.0+ (for development)

## Installation Methods

### Swift Package Manager (Recommended)

1. Open your Xcode project
2. Go to File → Add Package Dependencies
3. Enter the repository URL:
   ```
   https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git
   ```
4. Select version 3.2.0 or later
5. Choose the targets you want to include:
   - WidgetKit (Core functionality)
   - WidgetTemplates (Pre-built templates)
   - LiveDataIntegration (Real-time data)
   - WidgetAnalytics (Performance tracking)

### Manual Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git
   ```

2. Add the package to your project:
   ```swift
   dependencies: [
       .package(path: "path/to/iOS-Widget-Development-Kit")
   ]
   ```

## Configuration

### Basic Setup

```swift
import WidgetKit
import WidgetTemplates
import LiveDataIntegration
import WidgetAnalytics

// Initialize the widget engine
let widgetEngine = WidgetEngine.shared

// Register default templates
let weatherTemplate = WeatherWidgetTemplate()
widgetEngine.registerTemplate(weatherTemplate)
```

### Advanced Configuration

```swift
// Configure performance settings
let performanceSettings = WidgetPerformanceSettings(
    maxMemoryUsage: 100 * 1024 * 1024, // 100MB
    refreshInterval: 30.0, // 30 seconds
    enableBatteryOptimization: true
)

widgetEngine.configurePerformance(performanceSettings)

// Configure analytics
let analyticsConfig = AnalyticsConfiguration(
    enableExternalAnalytics: false,
    maxEventLogSize: 1000,
    enablePerformanceTracking: true,
    enableErrorTracking: true
)

WidgetAnalyticsService.shared.configure(analyticsConfig)
```

## Dependencies

The framework includes the following dependencies:

- **Alamofire**: Network requests and API integration
- **SwiftLint**: Code quality enforcement
- **Quick/Nimble**: Testing framework

These are automatically resolved when using Swift Package Manager.

## Troubleshooting

### Common Issues

1. **Build Errors**: Ensure you're using iOS 16.0+ and Swift 5.9+
2. **Import Errors**: Check that all targets are properly linked
3. **Runtime Errors**: Verify that templates are registered before use

### Support

For additional help, see:
- [Documentation](Documentation/)
- [GitHub Issues](https://github.com/muhittincamdali/iOS-Widget-Development-Kit/issues)
- [Examples](Examples/) 