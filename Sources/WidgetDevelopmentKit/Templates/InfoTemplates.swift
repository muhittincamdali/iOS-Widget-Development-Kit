import SwiftUI
import WidgetKit

// MARK: - Gradient Card Widget

/// Beautiful gradient card widget with customizable colors
public struct GradientCardWidget<Content: View>: View {
    let title: String
    let subtitle: String
    let gradient: LinearGradient
    let icon: String
    let content: () -> Content

    public init(
        title: String,
        subtitle: String,
        gradient: LinearGradient = LinearGradient(
            colors: [.blue, .purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        icon: String = "star.fill",
        @ViewBuilder content: @escaping () -> Content = { EmptyView() }
    ) {
        self.title = title
        self.subtitle = subtitle
        self.gradient = gradient
        self.icon = icon
        self.content = content
    }

    public var body: some View {
        ZStack {
            gradient

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundStyle(.white.opacity(0.9))
                    Spacer()
                }

                Spacer()

                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)

                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))

                content()
            }
            .padding()
        }
    }
}

// MARK: - Stats Widget

/// Statistics widget with progress indicators
public struct StatsWidget: View {
    public struct StatItem: Identifiable {
        public let id = UUID()
        public let title: String
        public let value: String
        public let progress: Double
        public let color: Color

        public init(title: String, value: String, progress: Double, color: Color = .blue) {
            self.title = title
            self.value = value
            self.progress = progress
            self.color = color
        }
    }

    let title: String
    let stats: [StatItem]

    public init(title: String, stats: [StatItem]) {
        self.title = title
        self.stats = stats
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)

            ForEach(stats) { stat in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(stat.title)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(stat.value)
                            .font(.caption)
                            .fontWeight(.semibold)
                    }

                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(stat.color.opacity(0.2))

                            RoundedRectangle(cornerRadius: 4)
                                .fill(stat.color)
                                .frame(width: geo.size.width * WidgetMath.clampedFraction(stat.progress))
                        }
                    }
                    .frame(height: 6)
                }
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - Weather Widget

/// Beautiful weather widget with conditions
public struct WeatherWidget: View {
    public enum Condition: String, CaseIterable {
        case sunny = "sun.max.fill"
        case cloudy = "cloud.fill"
        case rainy = "cloud.rain.fill"
        case stormy = "cloud.bolt.rain.fill"
        case snowy = "cloud.snow.fill"
        case partlyCloudy = "cloud.sun.fill"
        case foggy = "cloud.fog.fill"
        case windy = "wind"

        var color: Color {
            switch self {
            case .sunny: return .yellow
            case .cloudy: return .gray
            case .rainy: return .blue
            case .stormy: return .purple
            case .snowy: return .cyan
            case .partlyCloudy: return .orange
            case .foggy: return .gray
            case .windy: return .teal
            }
        }
    }

    let temperature: Int
    let condition: Condition
    let location: String
    let high: Int
    let low: Int

    public init(
        temperature: Int,
        condition: Condition,
        location: String,
        high: Int,
        low: Int
    ) {
        self.temperature = temperature
        self.condition = condition
        self.location = location
        self.high = high
        self.low = low
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(location)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Image(systemName: condition.rawValue)
                    .font(.title)
                    .foregroundStyle(condition.color)
            }

            Spacer()

            Text("\(temperature)°")
                .font(.system(size: 48, weight: .thin))

            HStack {
                Text("H:\(high)°")
                Text("L:\(low)°")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - Finance Widget

/// Financial overview widget
public struct FinanceWidget: View {
    public struct Account: Identifiable {
        public let id = UUID()
        public let name: String
        public let balance: Double
        public let change: Double
        public let icon: String

        public init(name: String, balance: Double, change: Double, icon: String = "creditcard") {
            self.name = name
            self.balance = balance
            self.change = change
            self.icon = icon
        }
    }

    let totalBalance: Double
    let accounts: [Account]
    let currency: String

    public init(totalBalance: Double, accounts: [Account], currency: String = "$") {
        self.totalBalance = totalBalance
        self.accounts = accounts
        self.currency = currency
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Total Balance")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text("\(currency)\(totalBalance, specifier: "%.2f")")
                    .font(.title2)
                    .fontWeight(.bold)
            }

            Divider()

            ForEach(accounts.prefix(2)) { account in
                HStack {
                    Image(systemName: account.icon)
                        .font(.caption)
                        .foregroundStyle(.blue)
                        .frame(width: 24, height: 24)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 6))

                    VStack(alignment: .leading) {
                        Text(account.name)
                            .font(.caption)
                        Text("\(currency)\(account.balance, specifier: "%.2f")")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Text("\(account.change >= 0 ? "+" : "")\(account.change, specifier: "%.1f")%")
                        .font(.caption)
                        .foregroundStyle(account.change >= 0 ? .green : .red)
                }
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - Social Stats Widget

/// Social media statistics widget
public struct SocialStatsWidget: View {
    let platform: String
    let platformIcon: String
    let platformColor: Color
    let followers: Int
    let following: Int
    let posts: Int
    let engagement: Double

    public init(
        platform: String,
        platformIcon: String,
        platformColor: Color,
        followers: Int,
        following: Int,
        posts: Int,
        engagement: Double
    ) {
        self.platform = platform
        self.platformIcon = platformIcon
        self.platformColor = platformColor
        self.followers = followers
        self.following = following
        self.posts = posts
        self.engagement = engagement
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: platformIcon)
                    .foregroundStyle(platformColor)
                Text(platform)
                    .font(.headline)
            }

            HStack(spacing: 16) {
                StatBox(value: formatNumber(followers), label: "Followers")
                StatBox(value: formatNumber(following), label: "Following")
                StatBox(value: formatNumber(posts), label: "Posts")
            }

            HStack {
                Text("Engagement")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(engagement, specifier: "%.1f")%")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }

    private func formatNumber(_ num: Int) -> String {
        WidgetFormat.compactNumber(num)
    }

    struct StatBox: View {
        let value: String
        let label: String

        var body: some View {
            VStack(spacing: 2) {
                Text(value)
                    .font(.headline)
                Text(label)
                    .font(.system(size: 9))
                    .foregroundStyle(.secondary)
            }
        }
    }
}
