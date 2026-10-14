import SwiftUI
import WidgetKit

// MARK: - Quote Widget

/// Inspirational quote widget
public struct QuoteWidget: View {
    let quote: String
    let author: String
    let category: String?

    public init(quote: String, author: String, category: String? = nil) {
        self.quote = quote
        self.author = author
        self.category = category
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let category = category {
                Text(category.uppercased())
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(.secondary)
            }

            Text("\u{201C}\(quote)\u{201D}")
                .font(.system(.body, design: .serif))
                .italic()
                .lineLimit(4)

            Spacer()

            HStack {
                Text("— \(author)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Image(systemName: "quote.closing")
                    .foregroundStyle(.tertiary)
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - Music Widget

/// Music player widget with album art placeholder
public struct MusicWidget: View {
    let trackName: String
    let artistName: String
    let albumName: String
    let isPlaying: Bool
    let progress: Double

    public init(
        trackName: String,
        artistName: String,
        albumName: String,
        isPlaying: Bool = true,
        progress: Double = 0.5
    ) {
        self.trackName = trackName
        self.artistName = artistName
        self.albumName = albumName
        self.isPlaying = isPlaying
        self.progress = progress
    }

    public var body: some View {
        HStack(spacing: 12) {
            // Album art placeholder
            RoundedRectangle(cornerRadius: 8)
                .fill(LinearGradient(
                    colors: [.purple, .blue],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: 60, height: 60)
                .overlay {
                    Image(systemName: "music.note")
                        .font(.title2)
                        .foregroundStyle(.white)
                }

            VStack(alignment: .leading, spacing: 4) {
                Text(trackName)
                    .font(.headline)
                    .lineLimit(1)

                Text(artistName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.secondary.opacity(0.3))

                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.purple)
                            .frame(width: geo.size.width * WidgetMath.clampedFraction(progress))
                    }
                }
                .frame(height: 4)

                HStack {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    Spacer()
                    Image(systemName: "forward.fill")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - Photo Widget

/// Photo frame widget with customizable styling
public struct PhotoFrameWidget: View {
    let imageName: String?
    let caption: String?
    let date: Date?
    let style: FrameStyle

    public enum FrameStyle {
        case minimal
        case polaroid
        case modern
        case vintage
    }

    public init(
        imageName: String? = nil,
        caption: String? = nil,
        date: Date? = nil,
        style: FrameStyle = .modern
    ) {
        self.imageName = imageName
        self.caption = caption
        self.date = date
        self.style = style
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Image placeholder
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.gray.opacity(0.3), .gray.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay {
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                }

            if style == .polaroid, let caption = caption {
                VStack(spacing: 4) {
                    Text(caption)
                        .font(.caption)
                        .lineLimit(1)

                    if let date = date {
                        Text(date, style: .date)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(.white)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: style == .minimal ? 0 : 12))
        .shadow(radius: style == .modern ? 8 : 0)
        .containerBackground(.clear, for: .widget)
    }
}

// MARK: - Podcast Widget

/// Podcast player widget
public struct PodcastWidget: View {
    let podcastName: String
    let episodeTitle: String
    let currentTime: TimeInterval
    let duration: TimeInterval
    let isPlaying: Bool

    public init(
        podcastName: String,
        episodeTitle: String,
        currentTime: TimeInterval,
        duration: TimeInterval,
        isPlaying: Bool = false
    ) {
        self.podcastName = podcastName
        self.episodeTitle = episodeTitle
        self.currentTime = currentTime
        self.duration = duration
        self.isPlaying = isPlaying
    }

    public var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(LinearGradient(colors: [.orange, .pink], startPoint: .top, endPoint: .bottom))
                .frame(width: 50, height: 50)
                .overlay {
                    Image(systemName: "mic.fill")
                        .foregroundStyle(.white)
                }

            VStack(alignment: .leading, spacing: 4) {
                Text(podcastName)
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                Text(episodeTitle)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(2)

                HStack {
                    Text(formatTime(currentTime))

                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.secondary.opacity(0.3))

                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.orange)
                                .frame(width: geo.size.width * WidgetMath.fraction(currentTime, of: duration))
                        }
                    }
                    .frame(height: 3)

                    Text(formatTime(duration))
                }
                .font(.system(size: 9))
                .foregroundStyle(.secondary)
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }

    private func formatTime(_ interval: TimeInterval) -> String {
        WidgetFormat.playbackTime(interval)
    }
}

// MARK: - News Headlines Widget

/// News headlines widget
public struct NewsWidget: View {
    public struct Article: Identifiable {
        public let id = UUID()
        public let headline: String
        public let source: String
        public let timeAgo: String
        public let category: String

        public init(headline: String, source: String, timeAgo: String, category: String) {
            self.headline = headline
            self.source = source
            self.timeAgo = timeAgo
            self.category = category
        }
    }

    let articles: [Article]
    let category: String

    public init(articles: [Article], category: String = "Top Stories") {
        self.articles = articles
        self.category = category
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(category)
                    .font(.headline)
                Spacer()
                Image(systemName: "newspaper.fill")
                    .foregroundStyle(.red)
            }

            ForEach(articles.prefix(3)) { article in
                VStack(alignment: .leading, spacing: 4) {
                    Text(article.headline)
                        .font(.caption)
                        .fontWeight(.medium)
                        .lineLimit(2)

                    HStack {
                        Text(article.source)
                        Text("•")
                        Text(article.timeAgo)
                    }
                    .font(.system(size: 9))
                    .foregroundStyle(.secondary)
                }

                if article.id != articles.prefix(3).last?.id {
                    Divider()
                }
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}
