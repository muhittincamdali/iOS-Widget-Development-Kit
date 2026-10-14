import Foundation
import Testing
@testable import WidgetDevelopmentKit

/// Replays scripted responses and records requests and sleeps.
private final class ScriptedTransport: @unchecked Sendable {
    enum Step {
        case status(Int, String)
        case failure(URLError.Code)
        case notHTTP
    }

    private let lock = NSLock()
    private var steps: [Step]
    private(set) var requestCount = 0
    private(set) var sleeps: [Duration] = []

    init(_ steps: [Step]) { self.steps = steps }

    func respond(to request: URLRequest) throws -> (Data, URLResponse) {
        let step: Step = lock.withLock {
            requestCount += 1
            return steps.removeFirst()
        }
        let url = request.url!
        switch step {
        case .status(let code, let body):
            let response = HTTPURLResponse(url: url, statusCode: code, httpVersion: nil, headerFields: nil)!
            return (Data(body.utf8), response)
        case .failure(let code):
            throw URLError(code)
        case .notHTTP:
            return (Data(), URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil))
        }
    }

    func recordSleep(_ duration: Duration) {
        lock.withLock { sleeps.append(duration) }
    }

    func loader(maxAttempts: Int = 3) -> WidgetDataLoader {
        WidgetDataLoader(
            retryPolicy: RetryPolicy(maxAttempts: maxAttempts, initialDelay: .milliseconds(100)),
            transport: { try self.respond(to: $0) },
            sleep: { self.recordSleep($0) }
        )
    }
}

private struct Quote: Decodable, Equatable {
    let text: String
}

@Suite("WidgetDataLoader")
struct WidgetDataLoaderTests {
    let request = URLRequest(url: URL(string: "https://example.com/quote")!)

    @Test func decodesSuccessfulResponse() async throws {
        let transport = ScriptedTransport([.status(200, #"{"text":"Hello"}"#)])
        let quote = try await transport.loader().load(Quote.self, from: request)
        #expect(quote == Quote(text: "Hello"))
        #expect(transport.requestCount == 1)
    }

    @Test func retriesServerErrorsWithBackoff() async throws {
        let transport = ScriptedTransport([
            .status(503, ""), .failure(.timedOut), .status(200, #"{"text":"Third time"}"#)
        ])
        let quote = try await transport.loader().load(Quote.self, from: request)
        #expect(quote.text == "Third time")
        #expect(transport.requestCount == 3)
        #expect(transport.sleeps == [.milliseconds(100), .milliseconds(200)])
    }

    @Test func doesNotRetryClientErrors() async {
        let transport = ScriptedTransport([.status(404, ""), .status(200, "{}")])
        await #expect(throws: WidgetNetworkError.httpStatus(404)) {
            try await transport.loader().loadData(from: request)
        }
        #expect(transport.requestCount == 1)
        #expect(transport.sleeps.isEmpty)
    }

    @Test func stopsAfterMaxAttempts() async {
        let transport = ScriptedTransport([.status(500, ""), .status(502, "")])
        await #expect(throws: WidgetNetworkError.httpStatus(502)) {
            try await transport.loader(maxAttempts: 2).loadData(from: request)
        }
        #expect(transport.requestCount == 2)
    }

    @Test func reportsDecodingAndResponseErrors() async {
        let badJSON = ScriptedTransport([.status(200, "not json")])
        await #expect {
            try await badJSON.loader().load(Quote.self, from: request)
        } throws: { error in
            guard case WidgetNetworkError.decodingFailed = error else { return false }
            return true
        }
        #expect(badJSON.requestCount == 1)

        let notHTTP = ScriptedTransport([.notHTTP])
        await #expect(throws: WidgetNetworkError.invalidResponse) {
            try await notHTTP.loader().loadData(from: request)
        }
    }

    @Test func offlineIsTransientButCancelledIsNot() {
        #expect(WidgetNetworkError.transport(.notConnectedToInternet).isTransient)
        #expect(WidgetNetworkError.transport(.cancelled).isTransient == false)
        #expect(WidgetNetworkError.httpStatus(429).isTransient == false)
        #expect(WidgetNetworkError.httpStatus(408).isTransient)
    }
}

@Suite("RetryPolicy")
struct RetryPolicyTests {
    @Test func delaysDoubleAfterFirstRetry() {
        let policy = RetryPolicy(maxAttempts: 4, initialDelay: .seconds(1))
        #expect(policy.delay(beforeAttempt: 1) == .zero)
        #expect(policy.delay(beforeAttempt: 2) == .seconds(1))
        #expect(policy.delay(beforeAttempt: 3) == .seconds(2))
        #expect(policy.delay(beforeAttempt: 4) == .seconds(4))
    }

    @Test func atLeastOneAttempt() {
        #expect(RetryPolicy(maxAttempts: 0).maxAttempts == 1)
        #expect(RetryPolicy.none.maxAttempts == 1)
    }
}

@Suite("Endpoint")
struct EndpointTests {
    let base = URL(string: "https://api.example.com/v1")!

    @Test func buildsPathQueryAndHeaders() throws {
        var endpoint = Endpoint(base: base)
            .appendingPath("quotes/random/")
            .adding(query: "lang", "en")
            .adding(query: "tag", "swift")
            .adding(query: "tag", "ios")
            .adding(header: "Accept", "application/json")
        endpoint.method = "POST"

        let request = try #require(endpoint.request)
        #expect(request.url?.absoluteString == "https://api.example.com/v1/quotes/random?lang=en&tag=swift&tag=ios")
        #expect(request.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(request.httpMethod == "POST")
    }

    @Test func encodesPathSegmentsAndKeepsBaseQuery() throws {
        let baseWithQuery = try #require(URL(string: "https://api.example.com?key=abc"))
        let url = try #require(Endpoint(base: baseWithQuery).appendingPath("city/New York").adding(query: "q", "a&b").url)
        #expect(url.absoluteString == "https://api.example.com/city/New%20York?key=abc&q=a%26b")
    }

    @Test func emptyPathLeavesBaseUnchanged() {
        #expect(Endpoint(base: base).appendingPath("//").url == base)
    }
}
