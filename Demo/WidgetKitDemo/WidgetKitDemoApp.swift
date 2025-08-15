import SwiftUI
import WidgetKit

/// Main demo application showcasing all iOS Widget Development Kit features
@main
@available(iOS 16.0, *)
struct WidgetKitDemoApp: App {
    @StateObject private var widgetManager = WidgetKitManager()
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var dataManager = DataManager()
    @StateObject private var performanceMonitor = PerformanceMonitor.shared
    
    init() {
        setupApplication()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(widgetManager)
                .environmentObject(themeManager)
                .environmentObject(dataManager)
                .environmentObject(performanceMonitor)
                .onAppear {
                    Task {
                        await initializeFramework()
                    }
                }
        }
    }
    
    private func setupApplication() {
        // Configure appearance
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        
        // Configure tab bar
        UITabBar.appearance().backgroundColor = UIColor.systemBackground
        UITabBar.appearance().tintColor = UIColor.systemBlue
    }
    
    private func initializeFramework() async {
        // Initialize security
        let encryptionManager = EncryptionManager()
        let authManager = AuthenticationManager()
        let privacyManager = PrivacyManager(encryptionManager: encryptionManager)
        
        // Initialize performance monitoring
        do {
            try await performanceMonitor.startMonitoring()
        } catch {
            print("Failed to start performance monitoring: \(error)")
        }
        
        // Configure widget manager
        widgetManager.configure { config in
            config.enableHomeScreenWidgets = true
            config.enableLockScreenWidgets = true
            config.enableLiveActivities = true
            config.enableDynamicIsland = true
            config.refreshInterval = 300 // 5 minutes
        }
        
        // Setup data sources
        await dataManager.setupDataSources()
        
        // Request necessary permissions
        await requestPermissions()
        
        // Register for remote notifications
        await registerForNotifications()
    }
    
    private func requestPermissions() async {
        // Request privacy permissions
        let privacyManager = PrivacyManager(encryptionManager: EncryptionManager())
        
        let purposes: [PrivacyManager.DataPurpose] = [
            .widgetFunctionality,
            .performanceAnalytics,
            .usageAnalytics,
            .personalization
        ]
        
        do {
            _ = try await privacyManager.requestConsent(for: purposes)
        } catch {
            print("Consent request failed: \(error)")
        }
    }
    
    private func registerForNotifications() async {
        let center = UNUserNotificationCenter.current()
        
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
            if granted {
                await UIApplication.shared.registerForRemoteNotifications()
            }
        } catch {
            print("Notification authorization failed: \(error)")
        }
    }
}

// MARK: - Content View

@available(iOS 16.0, *)
struct ContentView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var widgetManager: WidgetKitManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            WidgetsView()
                .tabItem {
                    Label("Widgets", systemImage: "square.grid.2x2.fill")
                }
                .tag(1)
            
            LiveActivitiesView()
                .tabItem {
                    Label("Live", systemImage: "bolt.circle.fill")
                }
                .tag(2)
            
            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(4)
        }
        .accentColor(themeManager.currentTheme.accentColor)
    }
}

// MARK: - Home View

@available(iOS 16.0, *)
struct HomeView: View {
    @EnvironmentObject var widgetManager: WidgetKitManager
    @State private var showingWelcome = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Welcome Card
                    WelcomeCard()
                        .padding(.horizontal)
                    
                    // Quick Actions
                    QuickActionsSection()
                        .padding(.horizontal)
                    
                    // Featured Widgets
                    FeaturedWidgetsSection()
                        .padding(.horizontal)
                    
                    // Recent Activity
                    RecentActivitySection()
                        .padding(.horizontal)
                    
                    // Performance Overview
                    PerformanceOverviewCard()
                        .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Widget Kit Demo")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Show notifications
                    }) {
                        Image(systemName: "bell.badge")
                    }
                }
            }
        }
    }
}

// MARK: - Widgets View

@available(iOS 16.0, *)
struct WidgetsView: View {
    @EnvironmentObject var widgetManager: WidgetKitManager
    @State private var selectedCategory = "All"
    
    let categories = ["All", "Home Screen", "Lock Screen", "StandBy", "Custom"]
    
    var body: some View {
        NavigationView {
            VStack {
                // Category Picker
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(categories, id: \.self) { category in
                            CategoryChip(
                                title: category,
                                isSelected: selectedCategory == category
                            ) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
                
                // Widget Grid
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(widgetManager.availableWidgets) { widget in
                            WidgetCard(widget: widget)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Widgets")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        // Show widget creation
                    }
                }
            }
        }
    }
}

// MARK: - Live Activities View

@available(iOS 16.0, *)
struct LiveActivitiesView: View {
    @State private var activeLiveActivities: [LiveActivityItem] = []
    @State private var showingCreateActivity = false
    
    var body: some View {
        NavigationView {
            VStack {
                if activeLiveActivities.isEmpty {
                    EmptyStateView(
                        icon: "bolt.circle",
                        title: "No Active Live Activities",
                        description: "Start a Live Activity to see real-time updates here"
                    ) {
                        showingCreateActivity = true
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(activeLiveActivities) { activity in
                                LiveActivityCard(activity: activity)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Live Activities")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingCreateActivity = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $showingCreateActivity) {
                CreateLiveActivityView()
            }
        }
    }
}

// MARK: - Analytics View

@available(iOS 16.0, *)
struct AnalyticsView: View {
    @EnvironmentObject var performanceMonitor: PerformanceMonitor
    @State private var selectedTimeRange = "Today"
    @State private var selectedMetric = "All"
    
    let timeRanges = ["Today", "Week", "Month", "Year"]
    let metrics = ["All", "CPU", "Memory", "Battery", "Network"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Time Range Selector
                    Picker("Time Range", selection: $selectedTimeRange) {
                        ForEach(timeRanges, id: \.self) { range in
                            Text(range).tag(range)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    // Performance Score Card
                    PerformanceScoreCard(score: performanceMonitor.performanceScore)
                        .padding(.horizontal)
                    
                    // Metrics Charts
                    MetricsChartsSection(selectedMetric: selectedMetric)
                        .padding(.horizontal)
                    
                    // Detailed Metrics
                    DetailedMetricsSection()
                        .padding(.horizontal)
                    
                    // Recommendations
                    RecommendationsSection()
                        .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Analytics")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Export") {
                        // Export analytics data
                    }
                }
            }
        }
    }
}

// MARK: - Settings View

@available(iOS 16.0, *)
struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var widgetManager: WidgetKitManager
    @State private var enableNotifications = true
    @State private var enableAnalytics = true
    @State private var enableAutoUpdate = true
    @State private var selectedTheme = "System"
    
    var body: some View {
        NavigationView {
            Form {
                // Appearance Section
                Section("Appearance") {
                    Picker("Theme", selection: $selectedTheme) {
                        Text("System").tag("System")
                        Text("Light").tag("Light")
                        Text("Dark").tag("Dark")
                    }
                    
                    ColorPicker("Accent Color", selection: $themeManager.accentColor)
                    
                    Toggle("Dynamic Colors", isOn: $themeManager.enableDynamicColors)
                }
                
                // Widget Settings
                Section("Widget Settings") {
                    Toggle("Home Screen Widgets", isOn: $widgetManager.enableHomeScreen)
                    Toggle("Lock Screen Widgets", isOn: $widgetManager.enableLockScreen)
                    Toggle("Live Activities", isOn: $widgetManager.enableLiveActivities)
                    Toggle("Dynamic Island", isOn: $widgetManager.enableDynamicIsland)
                    
                    HStack {
                        Text("Refresh Interval")
                        Spacer()
                        Text("5 min")
                            .foregroundColor(.secondary)
                    }
                }
                
                // Privacy & Security
                Section("Privacy & Security") {
                    NavigationLink("Privacy Settings") {
                        PrivacySettingsView()
                    }
                    
                    NavigationLink("Security Settings") {
                        SecuritySettingsView()
                    }
                    
                    Toggle("Analytics", isOn: $enableAnalytics)
                }
                
                // Notifications
                Section("Notifications") {
                    Toggle("Enable Notifications", isOn: $enableNotifications)
                    
                    NavigationLink("Notification Preferences") {
                        NotificationPreferencesView()
                    }
                }
                
                // Data Management
                Section("Data Management") {
                    NavigationLink("Cache Management") {
                        CacheManagementView()
                    }
                    
                    Toggle("Auto Update", isOn: $enableAutoUpdate)
                    
                    Button("Clear All Data") {
                        // Clear data action
                    }
                    .foregroundColor(.red)
                }
                
                // About
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    NavigationLink("Documentation") {
                        DocumentationView()
                    }
                    
                    NavigationLink("Support") {
                        SupportView()
                    }
                    
                    NavigationLink("License") {
                        LicenseView()
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

// MARK: - Supporting Views

@available(iOS 16.0, *)
struct WelcomeCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Welcome to")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("Widget Kit Demo")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                Spacer()
                Image(systemName: "sparkles")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
            }
            
            Text("Explore the most advanced widget development framework for iOS")
                .font(.body)
                .foregroundColor(.secondary)
            
            HStack(spacing: 20) {
                StatItem(value: "50+", label: "Widgets")
                StatItem(value: "15K+", label: "Lines")
                StatItem(value: "95%", label: "Coverage")
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
    }
}

@available(iOS 16.0, *)
struct QuickActionsSection: View {
    let actions = [
        QuickAction(icon: "plus.app", title: "Create Widget", color: .blue),
        QuickAction(icon: "bolt.fill", title: "Start Live Activity", color: .orange),
        QuickAction(icon: "chart.line.uptrend.xyaxis", title: "View Analytics", color: .green),
        QuickAction(icon: "gear", title: "Settings", color: .gray)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(actions) { action in
                        QuickActionButton(action: action)
                    }
                }
            }
        }
    }
}

@available(iOS 16.0, *)
struct FeaturedWidgetsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Featured Widgets")
                    .font(.headline)
                Spacer()
                Button("See All") {
                    // Navigate to widgets
                }
                .font(.caption)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<5) { index in
                        FeaturedWidgetCard(index: index)
                    }
                }
            }
        }
    }
}

@available(iOS 16.0, *)
struct RecentActivitySection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Activity")
                .font(.headline)
            
            VStack(spacing: 8) {
                ActivityRow(icon: "square.grid.2x2", title: "Weather Widget Updated", time: "2 min ago")
                ActivityRow(icon: "bolt.circle", title: "Delivery Tracking Started", time: "15 min ago")
                ActivityRow(icon: "chart.bar", title: "Analytics Report Generated", time: "1 hour ago")
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
        }
    }
}

// MARK: - Helper Views

@available(iOS 16.0, *)
struct StatItem: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

@available(iOS 16.0, *)
struct QuickAction: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let color: Color
}

@available(iOS 16.0, *)
struct QuickActionButton: View {
    let action: QuickAction
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: action.icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(action.color)
                .cornerRadius(12)
            
            Text(action.title)
                .font(.caption)
                .multilineTextAlignment(.center)
                .frame(width: 70)
        }
    }
}

@available(iOS 16.0, *)
struct FeaturedWidgetCard: View {
    let index: Int
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.2))
                .frame(width: 150, height: 150)
                .overlay(
                    Image(systemName: "square.grid.2x2")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                )
            
            Text("Widget \(index + 1)")
                .font(.caption)
                .fontWeight(.medium)
        }
    }
}

@available(iOS 16.0, *)
struct ActivityRow: View {
    let icon: String
    let title: String
    let time: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            Text(title)
                .font(.subheadline)
            
            Spacer()
            
            Text(time)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Supporting Types

@available(iOS 16.0, *)
struct LiveActivityItem: Identifiable {
    let id = UUID()
    let title: String
    let status: String
    let progress: Double
}

@available(iOS 16.0, *)
struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color(UIColor.secondarySystemBackground))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

// Additional placeholder views for navigation destinations
@available(iOS 16.0, *)
struct CreateLiveActivityView: View {
    var body: some View {
        Text("Create Live Activity")
    }
}

@available(iOS 16.0, *)
struct PrivacySettingsView: View {
    var body: some View {
        Text("Privacy Settings")
    }
}

@available(iOS 16.0, *)
struct SecuritySettingsView: View {
    var body: some View {
        Text("Security Settings")
    }
}

@available(iOS 16.0, *)
struct NotificationPreferencesView: View {
    var body: some View {
        Text("Notification Preferences")
    }
}

@available(iOS 16.0, *)
struct CacheManagementView: View {
    var body: some View {
        Text("Cache Management")
    }
}

@available(iOS 16.0, *)
struct DocumentationView: View {
    var body: some View {
        Text("Documentation")
    }
}

@available(iOS 16.0, *)
struct SupportView: View {
    var body: some View {
        Text("Support")
    }
}

@available(iOS 16.0, *)
struct LicenseView: View {
    var body: some View {
        Text("License")
    }
}