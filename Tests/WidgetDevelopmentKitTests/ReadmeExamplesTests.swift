// README.md quotes the interactive button and the networking example below; its other
// examples come from Examples/WidgetKitExample. The steps provider is repeated here so
// its timeline can be tested, and the last example is the one in the Interactive Widgets
// DocC article. ReadmeSyncTests checks that every Swift block in README.md appears in
// this file or in Examples/.

import AppIntents
import Foundation
import SwiftUI
import Testing
import WidgetKit
import WidgetDevelopmentKit

// Same provider as Examples/WidgetKitExample/Shared/Steps.swift
struct StepsEntry: TimelineEntry {
    let date: Date
    let steps: Int
}

struct StepsProvider: TimelineProvider {
    let store = WidgetSnapshotStore(defaults: UserDefaults(suiteName: "group.com.example.widgets") ?? .standard)

    func placeholder(in context: Context) -> StepsEntry {
        StepsEntry(date: .now, steps: 6_000)
    }

    func getSnapshot(in context: Context, completion: @escaping (StepsEntry) -> Void) {
        completion(placeholder(in: context))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<StepsEntry>) -> Void) {
        completion(makeTimeline(now: .now))
    }

    func makeTimeline(now: Date) -> Timeline<StepsEntry> {
        // Written by the app; stale data is better than an empty widget.
        let steps = store.staleValue(Int.self, forKey: "steps") ?? 0
        let entries = TimelineSchedule
            .dates(from: now, every: 15 * 60, count: 4)
            .map { StepsEntry(date: $0, steps: steps) }
        return TimelineBuilder(entries: entries)
            .reloading(.every(minutes: 60), from: now)
            .build()
    }
}

// Same view and configuration as Examples/WidgetKitExample
struct StepsWidgetView: View {
    let entry: StepsEntry

    var body: some View {
        WidgetProgressRing(progress: Double(entry.steps), total: 10_000, colors: [.green, .mint])
            .padding()
            .containerBackground(.fill.tertiary, for: .widget)
            .widgetURL(WidgetDeepLink(scheme: "steps", host: "today"))
    }
}

struct StepsWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "steps", provider: StepsProvider()) { entry in
            StepsWidgetView(entry: entry)
        }
        .configurationDisplayName("Steps")
        .supportedFamilies([.systemSmall])
    }
}

// README: Interactive button
struct WaterButton: View {
    var body: some View {
        Button(intent: IncrementIntent(counterId: "water", amount: 250)) {
            Label("+250 ml", systemImage: "drop.fill")
        }
    }
}

// README: Networking
struct RandomQuote: Decodable {
    let text: String
}

func loadQuote() async throws -> RandomQuote {
    guard let base = URL(string: "https://api.example.com") else { throw URLError(.badURL) }
    let endpoint = Endpoint(base: base)
        .appendingPath("v1/quotes/random")
        .adding(query: "lang", "en")
    guard let request = endpoint.request else { throw URLError(.badURL) }
    return try await WidgetDataLoader().load(RandomQuote.self, from: request)
}

@Suite("README examples")
struct ReadmeExamplesTests {
    @Test func providerBuildsFourEntriesAndHourlyReload() throws {
        let now = Date(timeIntervalSince1970: 1_800_000_000)
        let timeline = StepsProvider().makeTimeline(now: now)
        #expect(timeline.entries.count == 4)
        #expect(timeline.entries.last?.date == now.addingTimeInterval(45 * 60))
        #expect(timeline.policy == .after(now.addingTimeInterval(60 * 60)))
    }
}

// DocC article "Interactive Widgets": register the package's intents
struct AppIntentsRoot: AppIntentsPackage {
    static var includedPackages: [any AppIntentsPackage.Type] {
        [WidgetDevelopmentKitIntents.self]
    }
}
