<!-- i18n-source: README.md@21d649e6f03399b9ae6f8c248f63c32d4a134aab status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/banner-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/banner-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/banner-ko-light.svg" alt="iOS Widget Development Kit: WidgetKit 위젯과 Live Activities를 위한 SwiftUI 뷰와 타임라인 헬퍼."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/actions/workflows/ci.yml/badge.svg" alt="CI 상태"></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-platforms-light.svg" alt="지원 플랫폼: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-language-light.svg" alt="언어 버전: Swift 6.0+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-license-light.svg" alt="라이선스: MIT"></picture></a>
</p>

<p align="center">
<a href="#빠른-시작"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-start-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-start-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-start-ko-light.svg" alt="시작하기"></picture></a>
<a href="https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-docs-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-docs-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-docs-ko-light.svg" alt="문서"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-examples-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-examples-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-examples-ko-light.svg" alt="예제"></picture></a>
</p>

> 이 문서는 영어 README의 번역본입니다. 내용이 다를 경우 영어 버전이 최신입니다.

<!-- brand:end -->

WidgetDevelopmentKit은 iOS 앱용 위젯을 만드는 개발자를 위한 Swift 패키지입니다. 홈 화면, 잠금 화면, StandBy 위젯을 위한 SwiftUI 뷰, 위젯 크기에 맞춘 차트 뷰, 타임라인과 앱이 위젯과 공유하는 데이터를 위한 헬퍼, 위젯 버튼용 App Intents, Live Activities용 ActivityKit 속성과 뷰가 들어 있습니다. 위젯 익스텐션은 직접 작성해야 하지만, 뷰와 모든 위젯에 필요한 날짜·저장·재시도 로직은 이 패키지가 대신합니다.

## 주요 기능

- **홈 화면 템플릿 20개** — 날씨, 통계, 금융, 캘린더, 카운트다운, 시계, 메모, 명언, 음악, 팟캐스트, 뉴스, 피트니스 링, 습관 추적, 할 일, 물 섭취, 배터리 등.
- **잠금 화면과 StandBy** — 액세서리 뷰 15개(원형, 직사각형, 인라인)와 StandBy 뷰 7개.
- **타임라인 헬퍼** — 항목 날짜, 다시 로드 정책, 만료 시간이 있는 스냅숏 저장소. 위젯은 앱이 App Group을 통해 저장한 데이터를 읽습니다.
- **인터랙티브 위젯** — App Intent 5개와, 이를 실행하는 버튼이 있는 뷰 8개.
- **Live Activities** — 잠금 화면 뷰와 컴팩트 Dynamic Island 뷰를 갖춘 `ActivityAttributes` 타입 10개, 그리고 순서가 뒤바뀐 업데이트를 거부하는 상태 머신.
- **테스트된 로직** — 날짜, 숫자, 재시도 코드는 Swift Testing 테스트로 검증하며, `NaN`, 목표값 0, 일광 절약 시간 전환일 같은 경계 사례도 포함합니다.

## 빠른 시작

**1. 패키지 추가**

앱에 위젯 익스텐션이 있어야 합니다. 아직 없다면 Xcode에서 **File › New › Target…**을 선택하고 **Widget Extension**을 고르세요. 그런 다음 **File › Add Package Dependencies…**를 선택하고, 오른쪽 위 검색 필드에 이 URL을 붙여 넣은 뒤 **Add Package**를 클릭하세요.

```text
https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git
```

다음 대화 상자에서 `WidgetDevelopmentKit`의 **Add to Target**을 위젯 익스텐션으로 지정하고 **Add Package**를 클릭하세요.

**2. 모듈 가져오기**

위젯 익스텐션에 있는 Swift 파일 맨 위에 추가하세요.

```swift
import WidgetDevelopmentKit
```

**3. 사용하기**

이 위젯을 익스텐션에 추가하세요. 패키지의 `CountdownWidget` 뷰로 특정 날짜까지 남은 시간을 보여 줍니다. 그다음 익스텐션의 `WidgetBundle`(`@main`이 붙은 타입)에 `LaunchCountdownWidget()`을 추가하세요.

```swift
struct LaunchEntry: TimelineEntry {
    let date: Date
}

struct LaunchProvider: TimelineProvider {
    func placeholder(in context: Context) -> LaunchEntry {
        LaunchEntry(date: .now)
    }

    func getSnapshot(in context: Context, completion: @escaping (LaunchEntry) -> Void) {
        completion(LaunchEntry(date: .now))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<LaunchEntry>) -> Void) {
        // One entry per hour for the next six hours, then WidgetKit asks again.
        let entries = TimelineSchedule.dates(from: .now, every: 60 * 60, count: 6).map(LaunchEntry.init)
        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

struct LaunchCountdownWidget: Widget {
    let launchDay = DateComponents(calendar: .current, year: 2027, month: 1, day: 1).date ?? .now

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "launch", provider: LaunchProvider()) { entry in
            CountdownWidget(title: "Launch", targetDate: launchDay, referenceDate: entry.date)
        }
        .configurationDisplayName("Countdown")
        .supportedFamilies([.systemSmall])
    }
}
```

iPhone 시뮬레이터에서 앱을 실행하세요. 홈 화면의 빈 곳을 길게 누르고 **Edit › Add Widget**을 탭한 다음, 앱을 찾아 **Countdown**을 추가하세요. 같은 코드가 [`Examples/WidgetKitExample`](Examples/WidgetKitExample/Widgets/LaunchCountdownWidget.swift)에도 있습니다.

## 설치

### Swift Package Manager

Xcode에서 **File › Add Package Dependencies…**를 선택하고 저장소 URL을 입력하세요.

```text
https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git
```

또는 `Package.swift`의 `dependencies`에 추가하세요.

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git", branch: "main")
],
targets: [
    .target(name: "YourApp", dependencies: [
        .product(name: "WidgetDevelopmentKit", package: "iOS-Widget-Development-Kit")
    ])
]
```

유일한 태그인 `v1.0.0`은 현재 코드보다 오래되었고 빌드되지 않습니다. 다음 태그 릴리스가 나올 때까지 `main`을 사용하세요. 이 패키지에는 서드파티 의존성이 없습니다.

## 사용법

이 섹션의 모든 Swift 예제는 CI가 빌드하는 [`Examples/WidgetKitExample`](Examples/WidgetKitExample) 또는 테스트와 함께 컴파일되는 [`ReadmeExamplesTests.swift`](Tests/WidgetDevelopmentKitTests/ReadmeExamplesTests.swift)에서 가져왔습니다. 여기 있는 코드 블록이 해당 코드와 달라지면 테스트가 실패합니다.

### 타임라인 프로바이더에서 공유 데이터 읽기

`TimelineSchedule`은 항목 날짜를 만들고, `TimelineBuilder`는 항목을 정렬하고 `WidgetUpdatePolicy`를 WidgetKit의 다시 로드 정책으로 바꾸며, `WidgetSnapshotStore`는 앱이 공유 App Group에 저장한 데이터를 읽습니다.

```swift
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
```

### 앱에서 데이터 저장하기

앱은 유효 기간과 함께 값을 쓰고 WidgetKit에 위젯을 다시 로드하도록 요청합니다.

```swift
try store.save(steps, forKey: "steps", lifetime: 30 * 60)
WidgetCenter.shared.reloadTimelines(ofKind: "steps")
```

앱과 익스텐션에 같은 식별자로 **App Groups** capability를 추가하세요. 저장소는 암호화되지 않는 `UserDefaults`를 사용하므로 비밀 정보는 넣지 마세요.

### 항목 표시하기

```swift
struct StepsWidgetView: View {
    let entry: StepsEntry

    var body: some View {
        WidgetProgressRing(progress: Double(entry.steps), total: 10_000, colors: [.green, .mint])
            .padding()
            .containerBackground(.fill.tertiary, for: .widget)
            .widgetURL(WidgetDeepLink(scheme: "steps", host: "today"))
    }
}
```

시간에 따라 달라지는 값을 보여 주는 뷰(`CountdownWidget`, `StandByCountdownWidget`, `LockScreenCountdownWidget`)는 `referenceDate`를 받습니다. 각 항목이 자신의 시점을 그리도록 `entry.date`를 전달하세요.

### 위젯에 버튼 추가하기

```swift
struct WaterButton: View {
    var body: some View {
        Button(intent: IncrementIntent(counterId: "water", amount: 250)) {
            Label("+250 ml", systemImage: "drop.fill")
        }
    }
}
```

Intent는 위젯 익스텐션에서 실행되며 `WidgetStateStore.shared`에 기록합니다. 이 저장소는 Info.plist의 `WidgetDevelopmentKitAppGroup` 키로 지정한 App Group을 사용합니다. 앱과 익스텐션 모두에 이 키를 추가하고 패키지의 Intent를 등록하세요.

```swift
struct AppIntentsRoot: AppIntentsPackage {
    static var includedPackages: [any AppIntentsPackage.Type] {
        [WidgetDevelopmentKitIntents.self]
    }
}
```

### 서버에서 데이터 불러오기

```swift
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
```

`WidgetDataLoader`는 타임아웃이 짧고 연결을 기다리지 않는 ephemeral 세션을 사용합니다. 5xx와 408 응답, 타임아웃, 오프라인 오류는 재시도하지만(기본 1회, `RetryPolicy`로 변경 가능) 4xx 응답과 디코딩 오류는 재시도하지 않습니다.

## 데모

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/images/home-screen-dark.png">
  <img src="docs/images/home-screen-light.png" alt="패키지로 렌더링한 날씨, 물 섭취, 피트니스, 카운트다운, 명언, 습관 위젯" width="404">
</picture>
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/images/charts-dark.png">
  <img src="docs/images/charts-light.png" alt="통계 스파크라인, 진행률 링, 꺾은선 차트, 막대 차트 뷰" width="404">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/images/lock-screen-dark.png">
  <img src="docs/images/lock-screen-light.png" alt="잠금 화면의 배터리, 활동 링, 카운트다운, 날씨, 통계 위젯" width="304">
</picture>

이미지는 [`scripts/render-screenshots.sh`](scripts/render-screenshots.sh)가 `ImageRenderer`로 패키지의 뷰를 렌더링한 것입니다. WidgetKit 밖에서 그렸기 때문에 위젯 테두리, 잠금 화면의 바이브런시, StandBy 야간 모드는 시스템이 만든 것이 아니라 근사치입니다.

위젯을 직접 사용해 보려면 [`Examples/WidgetKitExample/WidgetKitExample.xcodeproj`](Examples/WidgetKitExample)를 열고 iPhone 시뮬레이터에서 **WidgetKitExample** 스킴을 실행하세요. [`Examples/README.md`](Examples/README.md)에서 세 가지 위젯과 홈 화면에 추가하는 방법을 설명합니다.

## 문서

API 레퍼런스와 문서:

- GitHub Pages의 [API 레퍼런스](https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/). 소스 코드의 DocC 주석으로 만듭니다.
- Xcode에서는 **Product › Build Documentation**을 선택하거나 `xcodebuild docbuild -scheme WidgetDevelopmentKit -destination 'generic/platform=iOS Simulator'`를 실행하세요.

## 가이드

- [Getting Started](https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/gettingstarted): 위젯 익스텐션과 패키지 추가, App Group을 통한 데이터 공유, 타임라인 구성, 항목 렌더링.
- [Interactive Widgets](https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/interactivewidgets): App Group 설정, Intent 등록, 버튼 추가, 프로바이더와 앱에서 버튼 상태 읽기.

## 요구 사항

| 플랫폼 | 최소 버전 |
| ------ | --------- |
| iOS    | 17.0      |
| macOS  | 14.0      |
| 툴체인 | Swift 6.0 |

잠금 화면 뷰와 Live Activities는 iOS 전용입니다. macOS 타깃은 플랫폼과 무관한 코드와 그 테스트를 `swift test`로 실행하기 위해 있습니다. CI는 GitHub `macos-26` 이미지의 기본 Xcode로 빌드하며, 로컬 개발에는 Xcode 27을 사용합니다. 더 오래된 Xcode 버전에서는 시험해 보지 않았습니다.

## 아키텍처

```text
Sources/WidgetDevelopmentKit/
├── Core/            Pure helpers: clamping, formatting, month grid, countdown math
├── Timeline/        Update policy, timeline builder and schedule, snapshot store
├── Networking/      Data loader with retry policy, endpoint builder
├── Configuration/   Deep links, hex colors, App Intents entities
├── Interactive/     App Intents, shared state store, interactive views
├── Templates/       Home Screen views
├── Charts/          Swift Charts views
├── LockScreen/      Accessory family views (iOS)
├── StandBy/         StandBy views
├── LiveActivities/  ActivityKit attributes and views (iOS), state machine
├── UI/              Timeline scrubber
└── WidgetDevelopmentKit.docc/
```

뷰는 얇게 유지합니다. 실제 데이터에서 잘못되기 쉬운 계산(목표값 0, `NaN`, 뒤집힌 날짜 범위, 일광 절약 시간 전환일)은 단위 테스트가 있는 순수 함수로 `Core`와 `Timeline`에 둡니다. 저장소나 네트워크를 다루는 타입은 의존성(`UserDefaults`, 시계, 전송 계층, 대기)을 매개변수로 받으므로 App Group이나 서버 없이 테스트할 수 있습니다. SwiftUI 뷰의 body는 스냅숏 테스트를 하지 않습니다.

macOS와 iOS 시뮬레이터에서 테스트를 실행하세요.

```sh
swift test
xcodebuild test -scheme WidgetDevelopmentKit -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

iOS 테스트 3개는 의도적으로 건너뜁니다. README 이미지를 렌더링하는 테스트로, `scripts/render-screenshots.sh`를 통해서만 실행됩니다.

## 로드맵

- 버전으로 패키지를 추가할 수 있도록 현재 코드에 맞는 릴리스 태그 만들기.
- 뷰 body에 대한 스냅숏 테스트.
- 예제 앱에 Live Activity 예제 추가.

지금까지의 변경 사항은 [CHANGELOG](CHANGELOG.md)에 기록되어 있습니다. `v1.0.0` 코드가 빌드되지 않는다는 사실이 확인된 뒤 2026년 10월에 패키지를 어떻게 복원했는지도 포함됩니다.

## 기여하기

기여를 환영합니다. pull request를 열기 전에 [기여 가이드](https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/CONTRIBUTING.md)와 [행동 강령](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md)을 읽어 주세요. 보안 문제는 [보안 정책](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md)에 따라 비공개로 제보해 주세요.

## 라이선스

MIT 라이선스로 배포됩니다. 자세한 내용은 [LICENSE](LICENSE)를 참고하세요.
