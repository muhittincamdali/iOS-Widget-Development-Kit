import Foundation
import SwiftUI
import Testing
@testable import WidgetDevelopmentKit

@Suite("WidgetDeepLink")
struct WidgetDeepLinkTests {
    @Test func buildsURLWithSortedQuery() {
        let link = WidgetDeepLink(
            scheme: "MyApp",
            host: "content",
            path: "/article/",
            parameters: ["id": "42", "source": "widget", "a": "1"]
        )
        #expect(link.url?.absoluteString == "myapp://content/article?a=1&id=42&source=widget")
    }

    @Test func roundTripsThroughURL() throws {
        let link = WidgetDeepLink(scheme: "myapp", host: "action", path: "toggle/item", parameters: ["id": "a b&c"])
        let url = try #require(link.url)
        #expect(WidgetDeepLink(url: url) == link)
        #expect(WidgetDeepLink(url: url)?.path == "toggle/item")
    }

    @Test func linkWithoutPathOrParameters() {
        let link = WidgetDeepLink(scheme: "myapp", host: "home")
        #expect(link.url?.absoluteString == "myapp://home")
        #expect(link.pathComponents.isEmpty)
    }

    @Test func rejectsWrongSchemeAndMissingHost() throws {
        let url = try #require(URL(string: "other://content/article"))
        #expect(WidgetDeepLink(url: url, expectedScheme: "myapp") == nil)
        #expect(WidgetDeepLink(url: url, expectedScheme: "OTHER") != nil)

        let noHost = try #require(URL(string: "myapp:///path"))
        #expect(WidgetDeepLink(url: noHost) == nil)
    }

    @Test func firstRepeatedParameterWinsAndValuelessItemsAreSkipped() throws {
        let url = try #require(URL(string: "myapp://content?id=1&id=2&flag"))
        let link = try #require(WidgetDeepLink(url: url))
        #expect(link.parameters == ["id": "1"])
    }
}

@Suite("HexColor")
struct HexColorTests {
    @Test func parsesSixDigits() throws {
        let color = try #require(HexColor("#34C759"))
        #expect(color.red == 0x34 / 255.0)
        #expect(color.green == 0xC7 / 255.0)
        #expect(color.blue == 0x59 / 255.0)
        #expect(color.opacity == 1)
    }

    @Test func parsesShortAndAlphaForms() throws {
        #expect(try #require(HexColor("0af")).hexString == "#00AAFF")
        let translucent = try #require(HexColor("FF3B3080"))
        #expect(translucent.opacity == 0x80 / 255.0)
        #expect(translucent.hexString == "#FF3B3080")
        #expect(HexColor("  #ffffff \n")?.hexString == "#FFFFFF")
    }

    @Test(arguments: ["", "#", "12345", "#GG0000", "#12345678FF", "red", "#１２３"])
    func rejectsInvalidInput(_ input: String) {
        #expect(HexColor(input) == nil)
    }

    @Test func colorInitializer() {
        #expect(Color(hex: "#007AFF") != nil)
        #expect(Color(hex: "nope") == nil)
    }
}

@Suite("Configuration entities")
struct ConfigurationEntityTests {
    @Test func everyAccentColorHexIsValidAndIdsAreUnique() {
        #expect(AccentColorOption.all.count == 8)
        #expect(Set(AccentColorOption.all.map(\.id)).count == AccentColorOption.all.count)
    }

    @Test func queriesReturnRequestedEntities() async throws {
        let colors = try await AccentColorQuery().entities(for: ["green", "missing", "red"])
        #expect(colors.map(\.id) == ["green", "red"])

        let intervals = try await RefreshIntervalQuery().entities(for: [60])
        #expect(intervals.first?.displayName == "1 hour")
        #expect(try await RefreshIntervalQuery().suggestedEntities() == RefreshIntervalOption.all)
    }

    @Test func refreshIntervalMapsToUpdatePolicy() throws {
        let option = try #require(RefreshIntervalOption.all.first { $0.minutes == 30 })
        let start = Date(timeIntervalSince1970: 0)
        #expect(option.updatePolicy.nextUpdateDate(from: start, calendar: TestCalendar.gregorian())
            == start.addingTimeInterval(30 * 60))
    }
}
