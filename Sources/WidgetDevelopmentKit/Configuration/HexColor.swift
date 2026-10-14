import SwiftUI

/// An sRGB color parsed from a hex string such as `"#34C759"`, `"0af"` or `"#FF3B3080"`.
public struct HexColor: Hashable, Sendable {
    public let red: Double
    public let green: Double
    public let blue: Double
    public let opacity: Double

    /// Accepts 3, 6 or 8 hex digits (`RGB`, `RRGGBB`, `RRGGBBAA`), with or without a
    /// leading `#`. Returns `nil` for any other length or a non-hex character.
    public init?(_ string: String) {
        var hex = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if hex.hasPrefix("#") { hex.removeFirst() }
        guard hex.allSatisfy(\.isHexDigit) else { return nil }

        switch hex.count {
        case 3:
            hex = hex.map { "\($0)\($0)" }.joined() + "FF"
        case 6:
            hex += "FF"
        case 8:
            break
        default:
            return nil
        }

        guard let value = UInt32(hex, radix: 16) else { return nil }
        red = Double((value >> 24) & 0xFF) / 255
        green = Double((value >> 16) & 0xFF) / 255
        blue = Double((value >> 8) & 0xFF) / 255
        opacity = Double(value & 0xFF) / 255
    }

    /// Uppercase `#RRGGBB`, or `#RRGGBBAA` when not fully opaque.
    public var hexString: String {
        func byte(_ component: Double) -> String {
            String(format: "%02X", Int((component * 255).rounded()))
        }
        let rgb = "#" + byte(red) + byte(green) + byte(blue)
        return opacity < 1 ? rgb + byte(opacity) : rgb
    }

    public var color: Color {
        Color(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

extension Color {
    /// Creates a color from a hex string; see ``HexColor`` for the accepted formats.
    public init?(hex: String) {
        guard let parsed = HexColor(hex) else { return nil }
        self = parsed.color
    }
}
