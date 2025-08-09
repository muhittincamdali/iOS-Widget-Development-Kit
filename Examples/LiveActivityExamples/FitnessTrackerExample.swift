import SwiftUI
import ActivityKit
import WidgetKit
import LiveDataIntegration

// MARK: - Fitness Tracker Live Activity Example
// This example demonstrates how to create a comprehensive fitness tracking
// Live Activity with real-time updates and Dynamic Island integration

struct FitnessTrackerAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var currentDistance: Double
        var currentPace: String
        var currentHeartRate: Int
        var elapsedTime: TimeInterval
        var targetDistance: Double
        var isActive: Bool
    }
    
    var activityName: String
    var activityType: String
    var startTime: Date
}

// MARK: - Fitness Tracker Live Activity
struct FitnessTrackerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FitnessTrackerAttributes.self) { context in
            // Lock screen/banner UI
            LockScreenLiveActivityView(context: context)
        } dynamicIsland: { context in
            // Dynamic Island UI
            DynamicIsland {
                // Expanded UI
                DynamicIslandExpandedRegion(.leading) {
                    FitnessExpandedLeadingView(context: context)
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    FitnessExpandedTrailingView(context: context)
                }
                
                DynamicIslandExpandedRegion(.center) {
                    FitnessExpandedCenterView(context: context)
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    FitnessExpandedBottomView(context: context)
                }
            } compactLeading: {
                // Compact leading
                FitnessCompactLeadingView(context: context)
            } compactTrailing: {
                // Compact trailing
                FitnessCompactTrailingView(context: context)
            } minimal: {
                // Minimal
                FitnessMinimalView(context: context)
            }
        }
    }
}

// MARK: - Lock Screen Live Activity View
struct LockScreenLiveActivityView: View {
    let context: ActivityViewContext<FitnessTrackerAttributes>
    
    var body: some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading) {
                    Text(context.attributes.activityName)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(context.attributes.activityType)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Activity status
                Circle()
                    .fill(context.state.isActive ? Color.green : Color.red)
                    .frame(width: 12, height: 12)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
            }
            
            // Progress section
            VStack(spacing: 8) {
                // Distance progress
                HStack {
                    Text("Distance")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(String(format: "%.2f", context.state.currentDistance)) km")
                        .font(.caption)
                        .foregroundColor(.primary)
                }
                
                ProgressView(value: context.state.currentDistance, total: context.state.targetDistance)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                
                // Time and pace
                HStack {
                    VStack(alignment: .leading) {
                        Text("Time")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(formatTime(context.state.elapsedTime))
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Pace")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(context.state.currentPace)
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                }
            }
            
            // Heart rate
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .font(.caption)
                
                Text("\(context.state.currentHeartRate) BPM")
                    .font(.caption)
                    .foregroundColor(.primary)
                
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        let seconds = Int(timeInterval) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

// MARK: - Dynamic Island Views

// Expanded Leading View
struct FitnessExpandedLeadingView: View {
    let context: ActivityViewContext<FitnessTrackerAttributes>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Distance")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("\(String(format: "%.2f", context.state.currentDistance)) km")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("of \(String(format: "%.2f", context.state.targetDistance)) km")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// Expanded Trailing View
struct FitnessExpandedTrailingView: View {
    let context: ActivityViewContext<FitnessTrackerAttributes>
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            Text("Pace")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(context.state.currentPace)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("per km")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// Expanded Center View
struct FitnessExpandedCenterView: View {
    let context: ActivityViewContext<FitnessTrackerAttributes>
    
    var body: some View {
        VStack(spacing: 8) {
            Text(context.attributes.activityName)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(formatTime(context.state.elapsedTime))
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.blue)
        }
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        let seconds = Int(timeInterval) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

// Expanded Bottom View
struct FitnessExpandedBottomView: View {
    let context: ActivityViewContext<FitnessTrackerAttributes>
    
    var body: some View {
        HStack(spacing: 16) {
            // Heart rate
            VStack(spacing: 4) {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .font(.caption)
                
                Text("\(context.state.currentHeartRate)")
                    .font(.caption)
                    .fontWeight(.semibold)
                
                Text("BPM")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            // Progress bar
            VStack(spacing: 4) {
                ProgressView(value: context.state.currentDistance, total: context.state.targetDistance)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                
                Text("\(Int((context.state.currentDistance / context.state.targetDistance) * 100))%")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            // Status indicator
            VStack(spacing: 4) {
                Circle()
                    .fill(context.state.isActive ? Color.green : Color.red)
                    .frame(width: 8, height: 8)
                
                Text(context.state.isActive ? "Active" : "Paused")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// Compact Leading View
struct FitnessCompactLeadingView: View {
    let context: ActivityViewContext<FitnessTrackerAttributes>
    
    var body: some View {
        Image(systemName: "figure.run")
            .foregroundColor(.blue)
            .font(.title2)
    }
}

// Compact Trailing View
struct FitnessCompactTrailingView: View {
    let context: ActivityViewContext<FitnessTrackerAttributes>
    
    var body: some View {
        Text(formatTime(context.state.elapsedTime))
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.primary)
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// Minimal View
struct FitnessMinimalView: View {
    let context: ActivityViewContext<FitnessTrackerAttributes>
    
    var body: some View {
        Image(systemName: "figure.run")
            .foregroundColor(.blue)
            .font(.title3)
    }
}

// MARK: - Fitness Activity Manager
class FitnessActivityManager: ObservableObject {
    static let shared = FitnessActivityManager()
    
    @Published var currentActivity: Activity<FitnessTrackerAttributes>?
    @Published var isActivityActive = false
    
    private var activityTimer: Timer?
    private var startTime: Date?
    
    private init() {}
    
    func startActivity(name: String, type: String, targetDistance: Double) {
        let attributes = FitnessTrackerAttributes(
            activityName: name,
            activityType: type,
            startTime: Date()
        )
        
        let contentState = FitnessTrackerAttributes.ContentState(
            currentDistance: 0.0,
            currentPace: "0:00",
            currentHeartRate: 0,
            elapsedTime: 0,
            targetDistance: targetDistance,
            isActive: true
        )
        
        do {
            let activity = try Activity.request(
                attributes: attributes,
                contentState: contentState,
                pushType: nil
            )
            
            currentActivity = activity
            isActivityActive = true
            startTime = Date()
            
            startTimer()
            
            print("✅ Fitness activity started: \(activity.id)")
        } catch {
            print("❌ Failed to start fitness activity: \(error)")
        }
    }
    
    func updateActivity(distance: Double, pace: String, heartRate: Int) {
        guard let activity = currentActivity, isActivityActive else { return }
        
        let elapsedTime = startTime?.timeIntervalSinceNow ?? 0
        let contentState = FitnessTrackerAttributes.ContentState(
            currentDistance: distance,
            currentPace: pace,
            currentHeartRate: heartRate,
            elapsedTime: abs(elapsedTime),
            targetDistance: activity.attributes.targetDistance,
            isActive: true
        )
        
        Task {
            await activity.update(using: contentState)
        }
    }
    
    func pauseActivity() {
        guard let activity = currentActivity else { return }
        
        let contentState = FitnessTrackerAttributes.ContentState(
            currentDistance: activity.content.state.currentDistance,
            currentPace: activity.content.state.currentPace,
            currentHeartRate: activity.content.state.currentHeartRate,
            elapsedTime: activity.content.state.elapsedTime,
            targetDistance: activity.attributes.targetDistance,
            isActive: false
        )
        
        Task {
            await activity.update(using: contentState)
        }
        
        isActivityActive = false
        stopTimer()
    }
    
    func resumeActivity() {
        guard let activity = currentActivity else { return }
        
        let contentState = FitnessTrackerAttributes.ContentState(
            currentDistance: activity.content.state.currentDistance,
            currentPace: activity.content.state.currentPace,
            currentHeartRate: activity.content.state.currentHeartRate,
            elapsedTime: activity.content.state.elapsedTime,
            targetDistance: activity.attributes.targetDistance,
            isActive: true
        )
        
        Task {
            await activity.update(using: contentState)
        }
        
        isActivityActive = true
        startTimer()
    }
    
    func endActivity() {
        guard let activity = currentActivity else { return }
        
        let contentState = FitnessTrackerAttributes.ContentState(
            currentDistance: activity.content.state.currentDistance,
            currentPace: activity.content.state.currentPace,
            currentHeartRate: activity.content.state.currentHeartRate,
            elapsedTime: activity.content.state.elapsedTime,
            targetDistance: activity.attributes.targetDistance,
            isActive: false
        )
        
        Task {
            await activity.end(using: contentState, dismissalPolicy: .immediate)
        }
        
        currentActivity = nil
        isActivityActive = false
        stopTimer()
        
        print("✅ Fitness activity ended")
    }
    
    private func startTimer() {
        activityTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateElapsedTime()
        }
    }
    
    private func stopTimer() {
        activityTimer?.invalidate()
        activityTimer = nil
    }
    
    private func updateElapsedTime() {
        guard let activity = currentActivity, isActivityActive else { return }
        
        let elapsedTime = startTime?.timeIntervalSinceNow ?? 0
        
        let contentState = FitnessTrackerAttributes.ContentState(
            currentDistance: activity.content.state.currentDistance,
            currentPace: activity.content.state.currentPace,
            currentHeartRate: activity.content.state.currentHeartRate,
            elapsedTime: abs(elapsedTime),
            targetDistance: activity.attributes.targetDistance,
            isActive: true
        )
        
        Task {
            await activity.update(using: contentState)
        }
    }
}

// MARK: - Widget Bundle
@main
struct FitnessTrackerWidgetBundle: WidgetBundle {
    var body: some Widget {
        FitnessTrackerLiveActivity()
    }
}

// MARK: - Preview
struct FitnessTrackerLiveActivity_Previews: PreviewProvider {
    static let attributes = FitnessTrackerAttributes(
        activityName: "Morning Run",
        activityType: "Running",
        startTime: Date()
    )
    
    static let contentState = FitnessTrackerAttributes.ContentState(
        currentDistance: 2.5,
        currentPace: "5:30",
        currentHeartRate: 145,
        elapsedTime: 1800,
        targetDistance: 5.0,
        isActive: true
    )
    
    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Lock Screen")
        
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Dynamic Island Compact")
        
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Dynamic Island Expanded")
        
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Dynamic Island Minimal")
    }
} 