import SwiftUI
import WidgetKit
import WidgetDevelopmentKit

/// Writes the data the widgets read and previews the steps widget's timeline.
struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var steps = 6_000
    @State private var waterIntake = 0
    @State private var status = "Not saved yet"
    @State private var timeline = StepsProvider().makeTimeline(now: .now)

    private let store = WidgetSnapshotStore(defaults: UserDefaults(suiteName: "group.com.example.widgets") ?? .standard)

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Stepper("\(steps.formatted()) steps", value: $steps, in: 0...30_000, step: 500)
                    Button("Save for the widget") { saveSteps() }
                    Text(status)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                } header: {
                    Text("Steps widget data")
                }

                Section {
                    WidgetTimelineScrubber(entries: timeline.entries) { entry in
                        StepsWidgetView(entry: entry)
                    }
                    .frame(maxWidth: .infinity)
                } header: {
                    Text("Steps timeline")
                } footer: {
                    Text("The entries StepsProvider gives WidgetKit, rendered with the widget's view.")
                }

                Section {
                    LabeledContent("Today", value: "\(waterIntake) ml")
                    Button("Reset", role: .destructive) {
                        WidgetStateStore.shared.setValue(0, for: "water")
                        WidgetCenter.shared.reloadTimelines(ofKind: "water")
                        waterIntake = 0
                    }
                } header: {
                    Text("Water widget")
                } footer: {
                    Text("Add the Water widget to the Home Screen and tap + to change this value.")
                }
            }
            .navigationTitle("Widget Kit Example")
        }
        .onAppear { waterIntake = WidgetStateStore.shared.value("water") }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                waterIntake = WidgetStateStore.shared.value("water")
            }
        }
    }

    private func saveSteps() {
        do {
            try store.save(steps, forKey: "steps", lifetime: 30 * 60)
            WidgetCenter.shared.reloadTimelines(ofKind: "steps")
            timeline = StepsProvider().makeTimeline(now: .now)
            status = "Saved \(steps.formatted()) steps"
        } catch {
            status = "Could not save: \(error.localizedDescription)"
        }
    }
}

#Preview {
    ContentView()
}
