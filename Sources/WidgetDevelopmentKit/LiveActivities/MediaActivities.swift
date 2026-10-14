// Live Activity attributes and views. ActivityKit exists only on iOS.

#if canImport(ActivityKit) && os(iOS)
import ActivityKit
import SwiftUI
import WidgetKit

// MARK: - Sports Score Activity

/// Live sports score tracking
public struct SportsScoreAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var homeScore: Int
        public var awayScore: Int
        public var gameTime: String
        public var period: String
        public var isLive: Bool
        public var lastEvent: String?

        public init(homeScore: Int, awayScore: Int, gameTime: String, period: String, isLive: Bool, lastEvent: String? = nil) {
            self.homeScore = homeScore
            self.awayScore = awayScore
            self.gameTime = gameTime
            self.period = period
            self.isLive = isLive
            self.lastEvent = lastEvent
        }
    }

    public let homeTeam: String
    public let awayTeam: String
    public let homeTeamAbbr: String
    public let awayTeamAbbr: String
    public let league: String

    public init(homeTeam: String, awayTeam: String, homeTeamAbbr: String, awayTeamAbbr: String, league: String) {
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.homeTeamAbbr = homeTeamAbbr
        self.awayTeamAbbr = awayTeamAbbr
        self.league = league
    }
}

public struct SportsActivityView: View {
    let context: ActivityViewContext<SportsScoreAttributes>

    public init(context: ActivityViewContext<SportsScoreAttributes>) {
        self.context = context
    }

    public var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(context.attributes.league)
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                Spacer()

                if context.state.isLive {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(.red)
                            .frame(width: 6, height: 6)
                        Text("LIVE")
                            .font(.caption2)
                            .foregroundStyle(.red)
                    }
                }

                Text(context.state.period)
                    .font(.caption)
                    .fontWeight(.medium)
            }

            HStack {
                TeamScoreView(
                    name: context.attributes.homeTeamAbbr,
                    score: context.state.homeScore,
                    isWinning: context.state.homeScore > context.state.awayScore
                )

                Spacer()

                VStack {
                    Text(context.state.gameTime)
                        .font(.headline)
                        .monospacedDigit()
                }

                Spacer()

                TeamScoreView(
                    name: context.attributes.awayTeamAbbr,
                    score: context.state.awayScore,
                    isWinning: context.state.awayScore > context.state.homeScore
                )
            }

            if let event = context.state.lastEvent {
                Text(event)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding()
    }

    public var compactLeading: some View {
        HStack(spacing: 4) {
            Text(context.attributes.homeTeamAbbr)
                .font(.caption2)
                .fontWeight(.bold)
            Text("\(context.state.homeScore)")
                .font(.caption)
        }
    }

    public var compactTrailing: some View {
        HStack(spacing: 4) {
            Text("\(context.state.awayScore)")
                .font(.caption)
            Text(context.attributes.awayTeamAbbr)
                .font(.caption2)
                .fontWeight(.bold)
        }
    }

    struct TeamScoreView: View {
        let name: String
        let score: Int
        let isWinning: Bool

        var body: some View {
            VStack(spacing: 4) {
                Text(name)
                    .font(.caption)
                    .fontWeight(.medium)
                Text("\(score)")
                    .font(.title)
                    .fontWeight(isWinning ? .bold : .regular)
                    .foregroundStyle(isWinning ? .primary : .secondary)
            }
        }
    }
}

// MARK: - Music Now Playing Activity

/// Music player Live Activity
public struct NowPlayingAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var trackName: String
        public var artistName: String
        public var albumName: String
        public var progress: Double
        public var duration: TimeInterval
        public var isPlaying: Bool

        public init(trackName: String, artistName: String, albumName: String, progress: Double, duration: TimeInterval, isPlaying: Bool) {
            self.trackName = trackName
            self.artistName = artistName
            self.albumName = albumName
            self.progress = progress
            self.duration = duration
            self.isPlaying = isPlaying
        }
    }

    public let appName: String

    public init(appName: String = "Music") {
        self.appName = appName
    }
}

public struct NowPlayingActivityView: View {
    let context: ActivityViewContext<NowPlayingAttributes>

    public init(context: ActivityViewContext<NowPlayingAttributes>) {
        self.context = context
    }

    public var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(LinearGradient(colors: [.purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 60, height: 60)
                .overlay {
                    Image(systemName: "music.note")
                        .font(.title2)
                        .foregroundStyle(.white)
                }

            VStack(alignment: .leading, spacing: 4) {
                Text(context.state.trackName)
                    .font(.headline)
                    .lineLimit(1)

                Text(context.state.artistName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.secondary.opacity(0.3))

                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.pink)
                            .frame(width: geo.size.width * context.state.progress)
                    }
                }
                .frame(height: 4)
            }

            VStack(spacing: 8) {
                Image(systemName: context.state.isPlaying ? "pause.fill" : "play.fill")
                    .font(.title3)

                Image(systemName: "forward.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }

    public var compactLeading: some View {
        Image(systemName: context.state.isPlaying ? "waveform" : "pause.fill")
            .foregroundStyle(.pink)
    }

    public var compactTrailing: some View {
        Text(context.state.trackName)
            .font(.caption2)
            .lineLimit(1)
    }
}
#endif
