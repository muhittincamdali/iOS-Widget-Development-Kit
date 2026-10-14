// Live Activity attributes and views. ActivityKit exists only on iOS.

#if canImport(ActivityKit) && os(iOS)
import ActivityKit
import SwiftUI
import WidgetKit

// MARK: - Meeting Activity

/// Calendar meeting Live Activity
public struct MeetingAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var status: MeetingStatus
        public var participantCount: Int
        public var elapsedTime: TimeInterval
        public var hasRecording: Bool

        public init(status: MeetingStatus, participantCount: Int, elapsedTime: TimeInterval, hasRecording: Bool = false) {
            self.status = status
            self.participantCount = participantCount
            self.elapsedTime = elapsedTime
            self.hasRecording = hasRecording
        }
    }

    public enum MeetingStatus: String, Codable {
        case upcoming = "Starting Soon"
        case inProgress = "In Progress"
        case ending = "Ending Soon"
        case ended = "Ended"
    }

    public let title: String
    public let startTime: Date
    public let endTime: Date
    public let organizer: String
    public let meetingLink: String?

    public init(title: String, startTime: Date, endTime: Date, organizer: String, meetingLink: String? = nil) {
        self.title = title
        self.startTime = startTime
        self.endTime = endTime
        self.organizer = organizer
        self.meetingLink = meetingLink
    }
}

public struct MeetingActivityView: View {
    let context: ActivityViewContext<MeetingAttributes>

    public init(context: ActivityViewContext<MeetingAttributes>) {
        self.context = context
    }

    private func formatDuration(_ interval: TimeInterval) -> String {
        WidgetFormat.playbackTime(interval)
    }

    public var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(context.attributes.title)
                        .font(.headline)
                        .lineLimit(1)

                    Text("by \(context.attributes.organizer)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing) {
                    if context.state.hasRecording {
                        Label("Recording", systemImage: "record.circle")
                            .font(.caption2)
                            .foregroundStyle(.red)
                    }

                    HStack {
                        Image(systemName: "person.2.fill")
                        Text("\(context.state.participantCount)")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }

            HStack {
                Label(context.state.status.rawValue, systemImage: "video.fill")
                    .font(.caption)
                    .foregroundStyle(.green)

                Spacer()

                Text(formatDuration(context.state.elapsedTime))
                    .font(.headline)
                    .monospacedDigit()
            }
        }
        .padding()
    }

    public var compactLeading: some View {
        Image(systemName: "video.fill")
            .foregroundStyle(.green)
    }

    public var compactTrailing: some View {
        Text(formatDuration(context.state.elapsedTime))
            .font(.caption2)
            .monospacedDigit()
    }
}
#endif
