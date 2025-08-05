import SwiftUI
import ActivityKit
import WidgetKit

// MARK: - Dynamic Island Example
struct DynamicIslandExample: Widget {
    let kind: String = "com.company.app.dynamicisland"
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DynamicIslandAttributes.self) { context in
            // This is the Live Activity view
            DynamicIslandLiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        Image(systemName: "music.note")
                            .foregroundColor(.blue)
                        Text("Now Playing")
                            .font(.caption)
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    Text("2:30")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                DynamicIslandExpandedRegion(.center) {
                    VStack(spacing: 8) {
                        Text("Song Title")
                            .font(.headline)
                        
                        Text("Artist Name")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    HStack(spacing: 20) {
                        Button("Previous") {
                            // Previous track
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Play/Pause") {
                            // Play/Pause
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Next") {
                            // Next track
                        }
                        .buttonStyle(.bordered)
                    }
                }
            } compactLeading: {
                // Compact leading
                Image(systemName: "music.note")
                    .foregroundColor(.blue)
            } compactTrailing: {
                // Compact trailing
                Text("2:30")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            } minimal: {
                // Minimal
                Image(systemName: "music.note")
                    .foregroundColor(.blue)
            }
        }
    }
}

// MARK: - Dynamic Island Attributes
struct DynamicIslandAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var songTitle: String
        var artistName: String
        var isPlaying: Bool
        var currentTime: String
        var duration: String
        var progress: Double
    }
    
    var playlistName: String
}

// MARK: - Live Activity View
struct DynamicIslandLiveActivityView: View {
    let context: ActivityViewContext<DynamicIslandAttributes>
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "music.note")
                    .foregroundColor(.blue)
                    .font(.title2)
                
                VStack(alignment: .leading) {
                    Text(context.state.songTitle)
                        .font(.headline)
                    
                    Text(context.state.artistName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("\(context.state.currentTime) / \(context.state.duration)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            ProgressView(value: context.state.progress)
                .progressViewStyle(.linear)
                .tint(.blue)
            
            HStack(spacing: 20) {
                Button("Previous") {
                    // Previous track
                }
                .buttonStyle(.bordered)
                
                Button(context.state.isPlaying ? "Pause" : "Play") {
                    // Play/Pause
                }
                .buttonStyle(.bordered)
                
                Button("Next") {
                    // Next track
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

// MARK: - Dynamic Island Manager
class DynamicIslandManager {
    static let shared = DynamicIslandManager()
    
    private var activity: Activity<DynamicIslandAttributes>?
    
    func startDynamicIsland(playlistName: String, songTitle: String, artistName: String) {
        let attributes = DynamicIslandAttributes(playlistName: playlistName)
        
        let contentState = DynamicIslandAttributes.ContentState(
            songTitle: songTitle,
            artistName: artistName,
            isPlaying: true,
            currentTime: "1:30",
            duration: "3:45",
            progress: 0.4
        )
        
        do {
            activity = try Activity.request(
                attributes: attributes,
                contentState: contentState,
                pushType: nil
            )
            print("✅ Dynamic Island activity started")
        } catch {
            print("❌ Dynamic Island activity failed: \(error)")
        }
    }
    
    func updateDynamicIsland(songTitle: String, artistName: String, isPlaying: Bool, currentTime: String, duration: String, progress: Double) {
        Task {
            let contentState = DynamicIslandAttributes.ContentState(
                songTitle: songTitle,
                artistName: artistName,
                isPlaying: isPlaying,
                currentTime: currentTime,
                duration: duration,
                progress: progress
            )
            
            await activity?.update(using: contentState)
        }
    }
    
    func endDynamicIsland() {
        Task {
            await activity?.end(dismissalPolicy: .immediate)
        }
    }
} 