# Comprehensive Troubleshooting Guide — iOS Widget Development Kit

## Overview

This comprehensive troubleshooting guide provides solutions for common issues, debugging strategies, and performance optimization techniques for the iOS Widget Development Kit. Whether you're facing build errors, runtime issues, or performance problems, this guide offers step-by-step solutions.

## Table of Contents

1. [Build & Compilation Issues](#build--compilation-issues)
2. [Runtime Errors](#runtime-errors)
3. [Performance Issues](#performance-issues)
4. [Widget Display Problems](#widget-display-problems)
5. [Data & Network Issues](#data--network-issues)
6. [Security & Privacy Issues](#security--privacy-issues)
7. [Memory & Resource Issues](#memory--resource-issues)
8. [Debugging Techniques](#debugging-techniques)
9. [Common Error Codes](#common-error-codes)
10. [Platform-Specific Issues](#platform-specific-issues)

## Build & Compilation Issues

### Issue: Module 'WidgetDevelopmentKit' Not Found

**Symptoms:**
```
error: no such module 'WidgetDevelopmentKit'
import WidgetDevelopmentKit
       ^
```

**Solutions:**

1. **Verify SPM Installation:**
```bash
# Clean and reset SPM
rm -rf .build
rm Package.resolved
swift package reset
swift package resolve
```

2. **Check Package.swift:**
```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git", from: "3.2.0")
]
```

3. **Xcode Integration:**
- File → Add Package Dependencies
- Enter repository URL
- Select version rule: "Up to Next Major Version"
- Add to target

### Issue: Swift Version Incompatibility

**Symptoms:**
```
error: compiling for iOS 15.0, but module was compiled for iOS 16.0
```

**Solutions:**

1. **Update Deployment Target:**
```swift
// In your target settings
platforms: [
    .iOS(.v16)
]
```

2. **Check Swift Version:**
```bash
swift --version
# Should be Swift 5.7 or later
```

3. **Update Build Settings:**
- Project → Build Settings → Swift Language Version → Swift 5
- Deployment Target → iOS 16.0

### Issue: Ambiguous Type References

**Symptoms:**
```
error: 'Widget' is ambiguous for type lookup in this context
```

**Solution:**
```swift
// Use fully qualified names
typealias AppWidget = WidgetDevelopmentKit.Widget
typealias SystemWidget = WidgetKit.Widget

// Or use explicit module prefix
let widget = WidgetDevelopmentKit.Widget(configuration: config)
```

## Runtime Errors

### Issue: Widget Not Updating

**Symptoms:**
- Widget shows stale data
- Update timeline not triggering
- Background refresh not working

**Debugging Steps:**

1. **Check Update Configuration:**
```swift
// Verify update interval
let configuration = WidgetConfiguration(
    type: .weather,
    size: .medium,
    updateInterval: 300 // 5 minutes minimum
)

// Enable debug logging
configuration.behavior.intelligentScheduling = false
```

2. **Verify Timeline Provider:**
```swift
func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    let currentDate = Date()
    let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
    
    // Create timeline with proper refresh policy
    let timeline = Timeline(entries: entries, policy: .after(refreshDate))
    
    // Log for debugging
    logger.debug("Timeline refresh scheduled for: \(refreshDate)")
    
    completion(timeline)
}
```

3. **Check Background App Refresh:**
```swift
// In Info.plist
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>processing</string>
</array>

// In AppDelegate
func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    Task {
        do {
            try await WidgetCenter.shared.reloadAllTimelines()
            completionHandler(.newData)
        } catch {
            completionHandler(.failed)
        }
    }
}
```

### Issue: Widget Crashes on Launch

**Symptoms:**
```
Thread 1: EXC_BAD_ACCESS (code=1, address=0x0)
```

**Solutions:**

1. **Enable Zombie Objects:**
- Edit Scheme → Run → Diagnostics → Enable Zombie Objects

2. **Add Exception Breakpoint:**
```swift
// Identify crash location
class WidgetDebugger {
    static func captureException() {
        NSSetUncaughtExceptionHandler { exception in
            print("Exception: \(exception)")
            print("Stack trace: \(exception.callStackSymbols)")
        }
    }
}
```

3. **Check Memory Management:**
```swift
// Avoid retain cycles
class WidgetViewModel {
    weak var delegate: WidgetDelegate?
    
    func loadData() {
        dataLoader.fetch { [weak self] data in
            self?.processData(data)
        }
    }
}
```

### Issue: Authentication Failures

**Symptoms:**
```
AuthenticationError: Biometric authentication failed
```

**Solutions:**

1. **Check Biometric Availability:**
```swift
func authenticateUser() async throws {
    let authManager = AuthenticationManager.shared
    
    // Check availability first
    guard await authManager.isBiometricAvailable() else {
        // Fallback to passcode
        return try await authManager.authenticateWithPasscode()
    }
    
    do {
        try await authManager.authenticate(
            reason: "Authenticate to access widget data",
            allowFallback: true
        )
    } catch AuthenticationError.biometricLockout {
        // Handle lockout
        try await authManager.resetBiometric()
    }
}
```

2. **Add Info.plist Keys:**
```xml
<key>NSFaceIDUsageDescription</key>
<string>Authenticate to access secure widget data</string>
```

## Performance Issues

### Issue: Slow Widget Rendering

**Symptoms:**
- Widget takes >100ms to render
- UI freezes during updates
- High CPU usage

**Performance Analysis:**

1. **Profile with Instruments:**
```swift
// Add signposts for profiling
import os.signpost

let log = OSLog(subsystem: "com.app.widget", category: .pointsOfInterest)

func renderWidget() {
    let signpostID = OSSignpostID(log: log)
    
    os_signpost(.begin, log: log, name: "Widget Render", signpostID: signpostID)
    defer {
        os_signpost(.end, log: log, name: "Widget Render", signpostID: signpostID)
    }
    
    // Rendering code
}
```

2. **Optimize View Hierarchy:**
```swift
// ❌ Bad: Complex nested views
struct ComplexWidget: View {
    var body: some View {
        VStack {
            ForEach(0..<100) { _ in
                HStack {
                    ForEach(0..<10) { _ in
                        Text("Item")
                    }
                }
            }
        }
    }
}

// ✅ Good: Optimized flat structure
struct OptimizedWidget: View {
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(items) { item in
                ItemView(item: item)
            }
        }
    }
}
```

3. **Implement Caching:**
```swift
class WidgetDataCache {
    private let cache = NSCache<NSString, CachedData>()
    
    func getCachedData(for key: String) -> Data? {
        // Set memory limits
        cache.totalCostLimit = 10 * 1024 * 1024 // 10MB
        cache.countLimit = 50
        
        return cache.object(forKey: NSString(string: key))?.data
    }
}
```

### Issue: High Memory Usage

**Symptoms:**
```
Received memory pressure notification
Widget terminated due to memory pressure
```

**Solutions:**

1. **Monitor Memory Usage:**
```swift
class MemoryMonitor {
    func getCurrentMemoryUsage() -> Int64 {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
        
        let result = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        return result == KERN_SUCCESS ? Int64(info.resident_size) : 0
    }
    
    func handleMemoryWarning() {
        // Clear caches
        URLCache.shared.removeAllCachedResponses()
        
        // Release non-essential resources
        ImageCache.shared.clearMemoryCache()
        
        // Force garbage collection
        autoreleasepool { }
    }
}
```

2. **Optimize Image Loading:**
```swift
// ❌ Bad: Loading full resolution
let image = UIImage(named: "large_image")

// ✅ Good: Downsampling for widgets
func downsampledImage(at url: URL, maxSize: CGSize) -> UIImage? {
    let options: [CFString: Any] = [
        kCGImageSourceThumbnailMaxPixelSize: max(maxSize.width, maxSize.height),
        kCGImageSourceCreateThumbnailFromImageAlways: true,
        kCGImageSourceCreateThumbnailWithTransform: true
    ]
    
    guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil),
          let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) else {
        return nil
    }
    
    return UIImage(cgImage: cgImage)
}
```

## Widget Display Problems

### Issue: Widget Not Appearing

**Symptoms:**
- Widget not in widget gallery
- "Unable to Load" message

**Solutions:**

1. **Verify Widget Extension Configuration:**
```swift
@main
struct WidgetBundle: WidgetBundle {
    var body: some Widget {
        WeatherWidget()
        CalendarWidget()
    }
}

// Ensure proper configuration
struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WeatherWidgetView(entry: entry)
        }
        .configurationDisplayName("Weather")
        .description("Shows current weather")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
```

2. **Check Entitlements:**
```xml
<!-- Widget Extension entitlements -->
<key>com.apple.security.application-groups</key>
<array>
    <string>group.com.yourapp.widgets</string>
</array>
```

### Issue: Widget Layout Issues

**Symptoms:**
- Content clipped or overflowing
- Incorrect sizing
- Layout breaking on different devices

**Solutions:**

```swift
struct AdaptiveWidgetView: View {
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        GeometryReader { geometry in
            content(for: geometry.size)
        }
    }
    
    @ViewBuilder
    func content(for size: CGSize) -> some View {
        switch family {
        case .systemSmall:
            SmallWidgetLayout()
                .frame(width: size.width, height: size.height)
        case .systemMedium:
            MediumWidgetLayout()
                .frame(width: size.width, height: size.height)
        case .systemLarge:
            LargeWidgetLayout()
                .frame(width: size.width, height: size.height)
        default:
            EmptyView()
        }
    }
}
```

## Data & Network Issues

### Issue: API Rate Limiting

**Symptoms:**
```
Error: Rate limit exceeded (429)
```

**Solutions:**

1. **Implement Exponential Backoff:**
```swift
class RetryManager {
    func performRequestWithRetry<T>(
        operation: () async throws -> T,
        maxAttempts: Int = 3
    ) async throws -> T {
        var lastError: Error?
        
        for attempt in 0..<maxAttempts {
            do {
                return try await operation()
            } catch let error as APIError where error.statusCode == 429 {
                let delay = pow(2.0, Double(attempt)) // Exponential backoff
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                lastError = error
            } catch {
                throw error
            }
        }
        
        throw lastError ?? APIError.unknown
    }
}
```

2. **Implement Request Throttling:**
```swift
actor RequestThrottler {
    private var requestTimestamps: [Date] = []
    private let maxRequestsPerMinute = 60
    
    func canMakeRequest() -> Bool {
        let now = Date()
        let oneMinuteAgo = now.addingTimeInterval(-60)
        
        // Remove old timestamps
        requestTimestamps.removeAll { $0 < oneMinuteAgo }
        
        return requestTimestamps.count < maxRequestsPerMinute
    }
    
    func recordRequest() {
        requestTimestamps.append(Date())
    }
}
```

### Issue: Data Synchronization Conflicts

**Symptoms:**
- Conflicting data between devices
- Lost updates
- Sync failures

**Solution:**
```swift
class ConflictResolver {
    func resolveConflict(local: WidgetData, remote: WidgetData) -> WidgetData {
        // Last-write-wins strategy
        if local.lastModified > remote.lastModified {
            return local
        } else if remote.lastModified > local.lastModified {
            return remote
        } else {
            // Same timestamp - merge changes
            return mergeData(local: local, remote: remote)
        }
    }
    
    private func mergeData(local: WidgetData, remote: WidgetData) -> WidgetData {
        // Custom merge logic based on your data structure
        var merged = local
        
        // Example: Combine arrays, prefer remote for conflicts
        merged.items = Array(Set(local.items + remote.items))
        merged.settings = remote.settings // Prefer remote settings
        
        return merged
    }
}
```

## Security & Privacy Issues

### Issue: Keychain Access Errors

**Symptoms:**
```
Error: errSecItemNotFound (-25300)
```

**Solutions:**

1. **Proper Keychain Configuration:**
```swift
class KeychainManager {
    func saveToKeychain(data: Data, for key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrAccessGroup as String: "group.com.yourapp.widgets",
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        
        // Delete existing item first
        SecItemDelete(query as CFDictionary)
        
        // Add new item
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw KeychainError.saveFailed(status)
        }
    }
}
```

2. **Handle Keychain Sharing:**
```xml
<!-- Main app entitlements -->
<key>keychain-access-groups</key>
<array>
    <string>$(AppIdentifierPrefix)com.yourapp.sharedkeychain</string>
</array>
```

### Issue: Privacy Compliance Violations

**Symptoms:**
- App Store rejection for privacy issues
- GDPR compliance warnings

**Solutions:**

```swift
class PrivacyComplianceChecker {
    func validateDataCollection() throws {
        // Check for PII in logs
        Logger.shared.setPIIFilter { message in
            // Remove email addresses
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            var filtered = message.replacingOccurrences(
                of: emailRegex,
                with: "[EMAIL]",
                options: .regularExpression
            )
            
            // Remove phone numbers
            let phoneRegex = "\\b\\d{3}[-.]?\\d{3}[-.]?\\d{4}\\b"
            filtered = filtered.replacingOccurrences(
                of: phoneRegex,
                with: "[PHONE]",
                options: .regularExpression
            )
            
            return filtered
        }
        
        // Ensure consent before tracking
        guard PrivacyManager.shared.hasUserConsent() else {
            throw PrivacyError.noConsent
        }
    }
}
```

## Memory & Resource Issues

### Issue: Widget Extension Terminated

**Symptoms:**
```
Message from debugger: Terminated due to memory issue
```

**Solutions:**

1. **Implement Memory Budget:**
```swift
class MemoryBudgetManager {
    private let maxMemoryMB: Int = 30 // Widget extension limit
    
    func canAllocateMemory(bytes: Int) -> Bool {
        let currentUsage = getCurrentMemoryUsageMB()
        let requestedMB = bytes / (1024 * 1024)
        
        return (currentUsage + requestedMB) < maxMemoryMB
    }
    
    func optimizeMemoryUsage() {
        // Clear image cache
        SDImageCache.shared.clearMemory()
        
        // Reduce data cache size
        URLCache.shared.memoryCapacity = 5 * 1024 * 1024 // 5MB
        
        // Force cleanup
        autoreleasepool {
            // Temporary objects will be released
        }
    }
}
```

2. **Use Lazy Loading:**
```swift
struct LazyWidgetView: View {
    @StateObject private var viewModel = WidgetViewModel()
    
    var body: some View {
        Group {
            if viewModel.isLoaded {
                ContentView(data: viewModel.data)
            } else {
                PlaceholderView()
                    .onAppear {
                        Task {
                            await viewModel.loadDataIfNeeded()
                        }
                    }
            }
        }
    }
}
```

## Debugging Techniques

### Advanced Debugging Setup

1. **Enable Verbose Logging:**
```swift
class DebugLogger {
    static let shared = DebugLogger()
    
    private let subsystem = "com.app.widget"
    
    func configureLogging() {
        #if DEBUG
        // Enable all log levels in debug
        Logger.logLevel = .debug
        
        // Log to file for analysis
        let documentsPath = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first!
        
        let logFile = documentsPath.appendingPathComponent("widget_debug.log")
        freopen(logFile.path, "a+", stderr)
        #endif
    }
    
    func log(_ message: String, type: OSLogType = .debug) {
        let logger = Logger(subsystem: subsystem, category: "Debug")
        logger.log(level: type, "\(message)")
        
        #if DEBUG
        print("🔍 [\(Date())] \(message)")
        #endif
    }
}
```

2. **Network Debugging:**
```swift
class NetworkDebugger: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        #if DEBUG
        print("📡 Request: \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")")
        if let headers = request.allHTTPHeaderFields {
            print("   Headers: \(headers)")
        }
        if let body = request.httpBody {
            print("   Body: \(String(data: body, encoding: .utf8) ?? "Binary data")")
        }
        #endif
        return false
    }
}

// Register in app
URLProtocol.registerClass(NetworkDebugger.self)
```

3. **Widget Preview Debugging:**
```swift
struct WidgetPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            WeatherWidgetView(entry: .mock())
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .previewDisplayName("Small")
            
            WeatherWidgetView(entry: .mockError())
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .previewDisplayName("Error State")
            
            WeatherWidgetView(entry: .mockLoading())
                .previewContext(WidgetPreviewContext(family: .systemLarge))
                .previewDisplayName("Loading State")
        }
        .environment(\.colorScheme, .dark)
    }
}
```

## Common Error Codes

### Framework-Specific Error Codes

| Error Code | Description | Solution |
|------------|-------------|----------|
| WDK-001 | Invalid configuration | Verify WidgetConfiguration parameters |
| WDK-002 | Template not found | Check template ID and registration |
| WDK-003 | Quota exceeded | Reduce number of active widgets |
| WDK-004 | Orchestration failed | Check widget dependencies |
| WDK-005 | Lifecycle error | Review widget state transitions |
| WDK-100 | Encryption failed | Verify encryption keys and Secure Enclave |
| WDK-101 | Authentication failed | Check biometric availability and permissions |
| WDK-102 | Privacy violation | Ensure GDPR/CCPA compliance |
| WDK-200 | Cache overflow | Implement cache eviction policy |
| WDK-201 | Performance threshold exceeded | Optimize rendering and data loading |
| WDK-300 | API timeout | Increase timeout or optimize request |
| WDK-301 | Cloud sync failed | Check network and cloud credentials |
| WDK-302 | Data source unavailable | Verify data source configuration |

### System Error Codes

| Error Code | Description | Solution |
|------------|-------------|----------|
| -25300 | Keychain item not found | Create keychain item before accessing |
| -25299 | Keychain duplicate item | Delete existing item before adding |
| -9806 | SSL connection failed | Check certificate and TLS configuration |
| -1009 | No internet connection | Implement offline mode |
| -1001 | Request timeout | Increase timeout or retry |

## Platform-Specific Issues

### iOS 16 Specific

**Lock Screen Widgets:**
```swift
// Ensure minimal UI for lock screen
struct LockScreenWidget: View {
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    
    var body: some View {
        if isLuminanceReduced {
            // Simplified UI for always-on display
            MinimalWidgetView()
        } else {
            // Regular lock screen widget
            StandardWidgetView()
        }
    }
}
```

### iOS 17 Specific

**Interactive Widgets:**
```swift
struct InteractiveWidget: View {
    var body: some View {
        Button(intent: ToggleIntent()) {
            Text("Toggle")
        }
        .buttonStyle(.plain)
    }
}

// App Intent
struct ToggleIntent: AppIntent {
    static var title: LocalizedStringResource = "Toggle Widget"
    
    func perform() async throws -> some IntentResult {
        // Handle interaction
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
```

### iPad Specific

**Size Class Handling:**
```swift
struct iPadWidget: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        if horizontalSizeClass == .regular && verticalSizeClass == .regular {
            // iPad layout
            iPadOptimizedLayout()
        } else {
            // Compact layout
            CompactLayout()
        }
    }
}
```

## Getting Help

### Debug Information Collection

When reporting issues, include:

1. **System Information:**
```swift
func collectDebugInfo() -> String {
    return """
    Device: \(UIDevice.current.model)
    OS Version: \(UIDevice.current.systemVersion)
    App Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown")
    Framework Version: 3.2.0
    Memory Usage: \(getCurrentMemoryUsageMB())MB
    Active Widgets: \(AdvancedWidgetManager.shared.widgets.count)
    """
}
```

2. **Crash Logs:**
- Xcode → Window → Devices and Simulators → View Device Logs

3. **Sample Code:**
- Minimal reproducible example
- Configuration used
- Expected vs actual behavior

### Support Resources

- **GitHub Issues**: [Report bugs](https://github.com/muhittincamdali/iOS-Widget-Development-Kit/issues)
- **Discussions**: [Ask questions](https://github.com/muhittincamdali/iOS-Widget-Development-Kit/discussions)
- **Stack Overflow**: Tag with `ios-widget-development-kit`
- **Documentation**: [Full documentation](https://github.com/muhittincamdali/iOS-Widget-Development-Kit/tree/main/Documentation)

### Filing Bug Reports

Use this template:

```markdown
## Environment
- Framework Version: 3.2.0
- iOS Version: 17.0
- Xcode Version: 15.0
- Device: iPhone 15 Pro

## Description
Brief description of the issue

## Steps to Reproduce
1. Step one
2. Step two
3. Step three

## Expected Behavior
What should happen

## Actual Behavior
What actually happens

## Code Sample
```swift
// Minimal code to reproduce
```

## Logs
```
// Relevant error messages or logs
```
```

## Conclusion

This troubleshooting guide covers the most common issues and their solutions. For issues not covered here, please:

1. Check the latest documentation
2. Search existing GitHub issues
3. Post in discussions for community help
4. File a detailed bug report if needed

Remember to always test on real devices, as simulator behavior may differ, especially for features like widgets, background refresh, and biometric authentication.