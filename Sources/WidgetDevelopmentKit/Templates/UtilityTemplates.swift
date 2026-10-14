import SwiftUI
import WidgetKit

// MARK: - Battery Widget

/// Device battery status widget
public struct BatteryWidget: View {
    public struct Device: Identifiable {
        public let id = UUID()
        public let name: String
        public let icon: String
        public let batteryLevel: Double
        public let isCharging: Bool

        public init(name: String, icon: String, batteryLevel: Double, isCharging: Bool = false) {
            self.name = name
            self.icon = icon
            self.batteryLevel = batteryLevel
            self.isCharging = isCharging
        }

        var batteryColor: Color {
            if isCharging { return .green }
            if batteryLevel < 0.2 { return .red }
            if batteryLevel < 0.5 { return .orange }
            return .green
        }
    }

    let devices: [Device]

    public init(devices: [Device]) {
        self.devices = devices
    }

    public var body: some View {
        VStack(spacing: 12) {
            ForEach(devices.prefix(3)) { device in
                HStack(spacing: 12) {
                    Image(systemName: device.icon)
                        .font(.title2)
                        .frame(width: 30)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(device.name)
                            .font(.caption)
                            .lineLimit(1)

                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color.secondary.opacity(0.2))

                                RoundedRectangle(cornerRadius: 3)
                                    .fill(device.batteryColor)
                                    .frame(width: geo.size.width * device.batteryLevel)
                            }
                        }
                        .frame(height: 8)
                    }

                    HStack(spacing: 2) {
                        if device.isCharging {
                            Image(systemName: "bolt.fill")
                                .font(.system(size: 10))
                                .foregroundStyle(.green)
                        }
                        Text("\(Int(device.batteryLevel * 100))%")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .frame(width: 45, alignment: .trailing)
                }
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - Shortcuts Widget

/// Quick shortcuts grid widget
public struct ShortcutsWidget: View {
    public struct Shortcut: Identifiable {
        public let id = UUID()
        public let name: String
        public let icon: String
        public let color: Color
        public let url: URL?

        public init(name: String, icon: String, color: Color, url: URL? = nil) {
            self.name = name
            self.icon = icon
            self.color = color
            self.url = url
        }
    }

    let shortcuts: [Shortcut]

    public init(shortcuts: [Shortcut]) {
        self.shortcuts = shortcuts
    }

    public var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
            ForEach(shortcuts.prefix(4)) { shortcut in
                ShortcutLink(url: shortcut.url) {
                    VStack(spacing: 6) {
                        Image(systemName: shortcut.icon)
                            .font(.title2)
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(shortcut.color)
                            .clipShape(RoundedRectangle(cornerRadius: 10))

                        Text(shortcut.name)
                            .font(.caption2)
                            .foregroundStyle(.primary)
                            .lineLimit(1)
                    }
                }
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - Helpers

/// Wraps content in a `Link` only when a URL is available, so a missing URL
/// does not produce a tappable element pointing nowhere.
struct ShortcutLink<Content: View>: View {
    let url: URL?
    @ViewBuilder let content: () -> Content

    var body: some View {
        if let url {
            Link(destination: url, label: content)
        } else {
            content()
        }
    }
}
