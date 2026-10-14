import Foundation
import Testing

/// README.md says its Swift examples are copied from compiled code. This suite holds it to
/// that: every Swift block in README.md must appear, line by line, in a Swift file under
/// Examples/ (built by the Examples workflow) or in ReadmeExamplesTests.swift (built with
/// the tests). Indentation and blank lines are ignored, so a block may come from inside a
/// function. The `Package.swift` fragment is the only block that is exempt.
@Suite("README code blocks")
struct ReadmeSyncTests {
    static let root = URL(filePath: #filePath)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .deletingLastPathComponent()

    static func normalizedLines(_ text: String) -> [String] {
        text.split(separator: "\n", omittingEmptySubsequences: false)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }

    static func swiftBlocks(in markdown: String) -> [String] {
        var blocks: [String] = []
        var current: [String]?
        for line in markdown.split(separator: "\n", omittingEmptySubsequences: false) {
            if current == nil, line.hasPrefix("```swift") {
                current = []
            } else if current != nil, line.hasPrefix("```") {
                blocks.append(current?.joined(separator: "\n") ?? "")
                current = nil
            } else {
                current?.append(String(line))
            }
        }
        return blocks
    }

    static func sourceFiles() throws -> [[String]] {
        var urls = [root.appending(path: "Tests/WidgetDevelopmentKitTests/ReadmeExamplesTests.swift")]
        let examples = root.appending(path: "Examples")
        let enumerator = FileManager.default.enumerator(at: examples, includingPropertiesForKeys: nil)
        while let url = enumerator?.nextObject() as? URL {
            if url.pathExtension == "swift" { urls.append(url) }
        }
        return try urls.map { normalizedLines(try String(contentsOf: $0, encoding: .utf8)) }
    }

    static func contains(_ haystack: [String], _ needle: [String]) -> Bool {
        guard !needle.isEmpty, needle.count <= haystack.count else { return needle.isEmpty }
        return (0...(haystack.count - needle.count)).contains { start in
            Array(haystack[start..<(start + needle.count)]) == needle
        }
    }

    @Test func everySwiftBlockComesFromCompiledCode() throws {
        let readme = try String(contentsOf: Self.root.appending(path: "README.md"), encoding: .utf8)
        let blocks = Self.swiftBlocks(in: readme)
            .filter { !$0.hasPrefix("dependencies:") }
        #expect(blocks.count >= 5, "expected the README's Swift examples, found \(blocks.count)")
        let sources = try Self.sourceFiles()
        #expect(sources.count > 1, "no Swift files found under Examples/")
        for block in blocks {
            let lines = Self.normalizedLines(block)
            #expect(sources.contains { Self.contains($0, lines) }, "not found in Examples/ or ReadmeExamplesTests.swift:\n\(block)")
        }
    }

    @Test func matchingIgnoresIndentationButNotContent() {
        let file = Self.normalizedLines("func f() {\n    let a = 1\n\n    let b = 2\n}")
        #expect(Self.contains(file, Self.normalizedLines("let a = 1\nlet b = 2")))
        #expect(!Self.contains(file, Self.normalizedLines("let a = 1\nlet b = 3")))
        #expect(!Self.contains(file, Self.normalizedLines("let b = 2\nlet a = 1")))
    }

    @Test func extractsOnlySwiftBlocks() {
        let markdown = "text\n```swift\nlet a = 1\n```\n```sh\nswift test\n```\n```swift\nlet b = 2\n```"
        #expect(Self.swiftBlocks(in: markdown) == ["let a = 1", "let b = 2"])
    }
}
