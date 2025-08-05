import SwiftUI
import ActivityKit
import WidgetKit

// MARK: - Live Activity Example
struct LiveActivityExample: Widget {
    let kind: String = "com.company.app.liveactivity"
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityAttributes.self) { context in
            LiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        Image(systemName: "shippingbox.fill")
                            .foregroundColor(.blue)
                        Text("Order #\(context.state.orderNumber)")
                            .font(.caption)
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.status)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    ProgressView(value: context.state.progress)
                        .progressViewStyle(.linear)
                }
            } compactLeading: {
                Image(systemName: "shippingbox.fill")
                    .foregroundColor(.blue)
            } compactTrailing: {
                Text(context.state.status)
                    .font(.caption2)
            } minimal: {
                Image(systemName: "shippingbox.fill")
                    .foregroundColor(.blue)
            }
        }
    }
}

// MARK: - Live Activity Attributes
struct LiveActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var orderNumber: String
        var status: String
        var progress: Double
        var estimatedTime: String
    }
    
    var orderNumber: String
    var customerName: String
}

// MARK: - Live Activity View
struct LiveActivityView: View {
    let context: ActivityViewContext<LiveActivityAttributes>
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "shippingbox.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                
                VStack(alignment: .leading) {
                    Text("Order #\(context.state.orderNumber)")
                        .font(.headline)
                    
                    Text(context.state.status)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(context.state.estimatedTime)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            ProgressView(value: context.state.progress)
                .progressViewStyle(.linear)
                .tint(.blue)
            
            HStack {
                Button("Track Order") {
                    // Open app to track order
                }
                .buttonStyle(.bordered)
                
                Spacer()
                
                Button("Contact Support") {
                    // Contact support
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

// MARK: - Live Activity Manager
class LiveActivityManager {
    static let shared = LiveActivityManager()
    
    private var activity: Activity<LiveActivityAttributes>?
    
    func startLiveActivity(orderNumber: String, customerName: String) {
        let attributes = LiveActivityAttributes(
            orderNumber: orderNumber,
            customerName: customerName
        )
        
        let contentState = LiveActivityAttributes.ContentState(
            orderNumber: orderNumber,
            status: "Order confirmed",
            progress: 0.1,
            estimatedTime: "2:30 PM"
        )
        
        do {
            activity = try Activity.request(
                attributes: attributes,
                contentState: contentState,
                pushType: nil
            )
            print("✅ Live activity started")
        } catch {
            print("❌ Live activity failed: \(error)")
        }
    }
    
    func updateLiveActivity(status: String, progress: Double, estimatedTime: String) {
        Task {
            let contentState = LiveActivityAttributes.ContentState(
                orderNumber: activity?.attributes.orderNumber ?? "",
                status: status,
                progress: progress,
                estimatedTime: estimatedTime
            )
            
            await activity?.update(using: contentState)
        }
    }
    
    func endLiveActivity() {
        Task {
            await activity?.end(dismissalPolicy: .immediate)
        }
    }
} 