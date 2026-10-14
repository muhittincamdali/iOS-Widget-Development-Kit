import SwiftUI
import WidgetKit

// MARK: - StandBy Fitness Widget

/// Fitness activity rings for StandBy mode
public struct StandByFitnessWidget: View {
    let calories: Double
    let caloriesGoal: Double
    let exercise: Double
    let exerciseGoal: Double
    let standing: Double
    let standingGoal: Double

    public init(
        calories: Double,
        caloriesGoal: Double = 500,
        exercise: Double,
        exerciseGoal: Double = 30,
        standing: Double,
        standingGoal: Double = 12
    ) {
        self.calories = calories
        self.caloriesGoal = caloriesGoal
        self.exercise = exercise
        self.exerciseGoal = exerciseGoal
        self.standing = standing
        self.standingGoal = standingGoal
    }

    public var body: some View {
        HStack(spacing: 40) {
            // Activity rings
            ZStack {
                ActivityRing(progress: WidgetMath.fraction(calories, of: caloriesGoal), color: .red, lineWidth: 16)
                    .frame(width: 140, height: 140)

                ActivityRing(progress: WidgetMath.fraction(exercise, of: exerciseGoal), color: .green, lineWidth: 14)
                    .frame(width: 108, height: 108)

                ActivityRing(progress: WidgetMath.fraction(standing, of: standingGoal), color: .cyan, lineWidth: 12)
                    .frame(width: 80, height: 80)
            }

            // Stats
            VStack(alignment: .leading, spacing: 20) {
                StatRow(label: "Move", value: "\(Int(calories))", unit: "CAL", color: .red, progress: WidgetMath.fraction(calories, of: caloriesGoal))
                StatRow(label: "Exercise", value: "\(Int(exercise))", unit: "MIN", color: .green, progress: WidgetMath.fraction(exercise, of: exerciseGoal))
                StatRow(label: "Stand", value: "\(Int(standing))", unit: "HRS", color: .cyan, progress: WidgetMath.fraction(standing, of: standingGoal))
            }
        }
        .padding()
        .containerBackground(.black.gradient, for: .widget)
    }

    struct ActivityRing: View {
        let progress: Double
        let color: Color
        let lineWidth: CGFloat

        var body: some View {
            Circle()
                .stroke(color.opacity(0.3), lineWidth: lineWidth)
                .overlay {
                    Circle()
                        .trim(from: 0, to: WidgetMath.clampedFraction(progress))
                        .stroke(
                            color,
                            style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                }
        }
    }

    struct StatRow: View {
        let label: String
        let value: String
        let unit: String
        let color: Color
        let progress: Double

        var body: some View {
            HStack(spacing: 8) {
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)

                VStack(alignment: .leading, spacing: 2) {
                    Text(label)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))

                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(value)
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(unit)
                            .font(.caption)
                    }
                    .foregroundStyle(.white)
                }
            }
        }
    }
}

// MARK: - StandBy Music Widget

/// Now playing widget for StandBy mode
public struct StandByMusicWidget: View {
    let trackName: String
    let artistName: String
    let albumName: String
    let isPlaying: Bool
    let progress: Double
    let accentColor: Color

    public init(
        trackName: String,
        artistName: String,
        albumName: String,
        isPlaying: Bool = true,
        progress: Double = 0.5,
        accentColor: Color = .purple
    ) {
        self.trackName = trackName
        self.artistName = artistName
        self.albumName = albumName
        self.isPlaying = isPlaying
        self.progress = progress
        self.accentColor = accentColor
    }

    public var body: some View {
        HStack(spacing: 24) {
            // Album art placeholder
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [accentColor, accentColor.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 140, height: 140)
                .overlay {
                    Image(systemName: "music.note")
                        .font(.system(size: 48))
                        .foregroundStyle(.white.opacity(0.5))
                }
                .shadow(color: accentColor.opacity(0.5), radius: 20)

            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(trackName)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .lineLimit(1)

                    Text(artistName)
                        .font(.title3)
                        .foregroundStyle(.white.opacity(0.7))
                        .lineLimit(1)

                    Text(albumName)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.5))
                        .lineLimit(1)
                }
                .foregroundStyle(.white)

                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.white.opacity(0.3))

                        RoundedRectangle(cornerRadius: 2)
                            .fill(accentColor)
                            .frame(width: geo.size.width * WidgetMath.clampedFraction(progress))
                    }
                }
                .frame(height: 4)

                // Controls
                HStack(spacing: 32) {
                    Image(systemName: "backward.fill")
                        .font(.title2)

                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 36))

                    Image(systemName: "forward.fill")
                        .font(.title2)
                }
                .foregroundStyle(.white)
            }
        }
        .padding()
        .containerBackground(.black.gradient, for: .widget)
    }
}

// MARK: - StandBy Countdown Widget

/// Event countdown for StandBy mode
public struct StandByCountdownWidget: View {
    let eventName: String
    let targetDate: Date
    let referenceDate: Date
    let accentColor: Color

    /// - Parameters:
    ///   - eventName: Title shown above the countdown.
    ///   - targetDate: The moment being counted down to.
    ///   - referenceDate: The timeline entry date the countdown is computed from.
    ///     Widgets render a static snapshot per entry, so pass `entry.date` here.
    ///   - accentColor: Color of the digits.
    public init(
        eventName: String,
        targetDate: Date,
        referenceDate: Date = Date(),
        accentColor: Color = .orange
    ) {
        self.eventName = eventName
        self.targetDate = targetDate
        self.referenceDate = referenceDate
        self.accentColor = accentColor
    }

    public var body: some View {
        let remaining = CountdownComponents(from: referenceDate, to: targetDate)
        VStack(spacing: 24) {
            Text(eventName)
                .font(.title2)
                .foregroundStyle(.white.opacity(0.8))

            HStack(spacing: 16) {
                CountdownUnit(value: remaining.days, label: "DAYS", color: accentColor)
                CountdownUnit(value: remaining.hours, label: "HOURS", color: accentColor)
                CountdownUnit(value: remaining.minutes, label: "MIN", color: accentColor)
            }

            Text(targetDate, format: .dateTime.month().day().year())
                .font(.caption)
                .foregroundStyle(.white.opacity(0.5))
        }
        .padding()
        .containerBackground(.black.gradient, for: .widget)
    }

    struct CountdownUnit: View {
        let value: Int
        let label: String
        let color: Color

        var body: some View {
            VStack(spacing: 8) {
                Text(String(format: "%02d", value))
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(color)

                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
    }
}
