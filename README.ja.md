<!-- i18n-source: README.md@21d649e6f03399b9ae6f8c248f63c32d4a134aab status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/banner-ja-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/banner-ja-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/banner-ja-light.svg" alt="iOS Widget Development Kit: WidgetKit ウィジェットと Live Activities のための SwiftUI ビューとタイムラインヘルパー。"></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/actions/workflows/ci.yml/badge.svg" alt="CI ステータス"></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-platforms-light.svg" alt="対応プラットフォーム: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-language-light.svg" alt="言語バージョン: Swift 6.0+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-license-light.svg" alt="ライセンス: MIT"></picture></a>
</p>

<p align="center">
<a href="#クイックスタート"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-start-ja-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-start-ja-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-start-ja-light.svg" alt="はじめる"></picture></a>
<a href="https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-docs-ja-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-docs-ja-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-docs-ja-light.svg" alt="ドキュメント"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-examples-ja-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-examples-ja-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-examples-ja-light.svg" alt="サンプル"></picture></a>
</p>

> このドキュメントは英語版 README の翻訳です。内容が異なる場合は英語版が最新です。

<!-- brand:end -->

WidgetDevelopmentKit は、iOS アプリのウィジェットを開発する人のための Swift パッケージです。ホーム画面、ロック画面、StandBy のウィジェット向けの SwiftUI ビュー、ウィジェットのサイズに合わせたチャートビュー、タイムラインとアプリがウィジェットと共有するデータのためのヘルパー、ウィジェットのボタン用の App Intents、Live Activities 用の ActivityKit 属性とビューが含まれています。ウィジェット拡張そのものは自分で書きますが、ビューと、どのウィジェットにも必要な日付・ストレージ・リトライの処理はこのパッケージに任せられます。

## 主な特長

- **20 種類のホーム画面テンプレート** — 天気、統計、家計、カレンダー、カウントダウン、時計、メモ、名言、音楽、ポッドキャスト、ニュース、フィットネスリング、習慣トラッカー、ToDo、水分、バッテリーなど。
- **ロック画面と StandBy** — 15 種類のアクセサリビュー（円形、長方形、インライン）と 7 種類の StandBy ビュー。
- **タイムラインのヘルパー** — エントリの日時、再読み込みポリシー、有効期限付きのスナップショットストア。アプリが App Group 経由で保存したデータをウィジェットが読み取れます。
- **インタラクティブウィジェット** — 5 つの App Intent と、それを実行するボタンを持つ 8 つのビュー。
- **Live Activities** — ロック画面とコンパクトな Dynamic Island のビューを備えた 10 種類の `ActivityAttributes` 型と、順序が入れ替わった更新を拒否するステートマシン。
- **テスト済みのロジック** — 日付・数値・リトライのコードは Swift Testing のテストでカバーされており、`NaN`、目標値ゼロ、夏時間の切り替え日などのエッジケースも含みます。

## クイックスタート

**1. パッケージを追加する**

アプリにはウィジェット拡張が必要です。まだない場合は、Xcode で **File › New › Target…** を選び、**Widget Extension** を選択します。次に **File › Add Package Dependencies…** を選び、右上の検索フィールドに次の URL を貼り付けて **Add Package** をクリックします。

```text
https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git
```

次のダイアログで、`WidgetDevelopmentKit` の **Add to Target** をウィジェット拡張に設定し、**Add Package** をクリックします。

**2. モジュールをインポートする**

ウィジェット拡張の Swift ファイルの先頭に追加します。

```swift
import WidgetDevelopmentKit
```

**3. 使ってみる**

このウィジェットを拡張に追加します。パッケージの `CountdownWidget` ビューで、ある日付までのカウントダウンを表示します。続いて、拡張の `WidgetBundle`（`@main` が付いた型）に `LaunchCountdownWidget()` を追加します。

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

iPhone シミュレータでアプリを実行します。ホーム画面の空いている場所を長押しし、**Edit › Add Widget** をタップして、アプリを探して **Countdown** を追加します。同じコードは [`Examples/WidgetKitExample`](Examples/WidgetKitExample/Widgets/LaunchCountdownWidget.swift) にもあります。

## インストール

### Swift Package Manager

Xcode で **File › Add Package Dependencies…** を選び、リポジトリの URL を入力します。

```text
https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git
```

または `Package.swift` の `dependencies` に追加します。

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

唯一のタグ `v1.0.0` は現在のコードより古く、ビルドできません。次のタグ付きリリースまでは `main` を使ってください。このパッケージはサードパーティの依存関係を持ちません。

## 使い方

このセクションの Swift のサンプルはすべて、CI がビルドする [`Examples/WidgetKitExample`](Examples/WidgetKitExample)、またはテストと一緒にコンパイルされる [`ReadmeExamplesTests.swift`](Tests/WidgetDevelopmentKitTests/ReadmeExamplesTests.swift) から取ったものです。ここにあるコードブロックがそのコードと一致しなくなると、テストが失敗します。

### タイムラインプロバイダで共有データを読む

`TimelineSchedule` がエントリの日時を作り、`TimelineBuilder` がエントリを並べ替えて `WidgetUpdatePolicy` を WidgetKit の再読み込みポリシーに変換し、`WidgetSnapshotStore` がアプリが共有 App Group に保存したデータを読み取ります。

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

### アプリでデータを保存する

アプリは有効期限付きで値を書き込み、WidgetKit にウィジェットの再読み込みを依頼します。

```swift
try store.save(steps, forKey: "steps", lifetime: 30 * 60)
WidgetCenter.shared.reloadTimelines(ofKind: "steps")
```

アプリと拡張の両方に、同じ識別子で **App Groups** の capability を追加してください。ストアは暗号化されない `UserDefaults` を使うため、秘密の情報は保存しないでください。

### エントリを表示する

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

時間によって変わる値を表示するビュー（`CountdownWidget`、`StandByCountdownWidget`、`LockScreenCountdownWidget`）は `referenceDate` を受け取ります。各エントリがそれぞれの時点を表示するように `entry.date` を渡してください。

### ウィジェットにボタンを追加する

```swift
struct WaterButton: View {
    var body: some View {
        Button(intent: IncrementIntent(counterId: "water", amount: 250)) {
            Label("+250 ml", systemImage: "drop.fill")
        }
    }
}
```

Intent はウィジェット拡張の中で実行され、`WidgetStateStore.shared` に書き込みます。このストアは Info.plist の `WidgetDevelopmentKitAppGroup` キーで指定された App Group を使います。アプリと拡張の両方にこのキーを追加し、パッケージの Intent を登録してください。

```swift
struct AppIntentsRoot: AppIntentsPackage {
    static var includedPackages: [any AppIntentsPackage.Type] {
        [WidgetDevelopmentKitIntents.self]
    }
}
```

### サーバーからデータを読み込む

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

`WidgetDataLoader` は、タイムアウトが短く接続を待たない ephemeral セッションを使います。5xx と 408 のレスポンス、タイムアウト、オフラインのエラーはリトライします（デフォルトは 1 回。`RetryPolicy` で変更できます）が、4xx のレスポンスとデコードエラーはリトライしません。

## デモ

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/images/home-screen-dark.png">
  <img src="docs/images/home-screen-light.png" alt="パッケージから描画した天気、水分、フィットネス、カウントダウン、名言、習慣のウィジェット" width="404">
</picture>
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/images/charts-dark.png">
  <img src="docs/images/charts-light.png" alt="統計スパークライン、進捗リング、折れ線グラフ、棒グラフのビュー" width="404">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/images/lock-screen-dark.png">
  <img src="docs/images/lock-screen-light.png" alt="ロック画面のバッテリー、アクティビティリング、カウントダウン、天気、統計のウィジェット" width="304">
</picture>

画像は [`scripts/render-screenshots.sh`](scripts/render-screenshots.sh) が `ImageRenderer` を使ってパッケージのビューから描画したものです。WidgetKit の外で描画しているため、ウィジェットの枠、ロック画面のバイブランシー、StandBy のナイトモードはシステムが生成したものではなく、近似です。

ウィジェットを自分で試すには、[`Examples/WidgetKitExample/WidgetKitExample.xcodeproj`](Examples/WidgetKitExample) を開き、**WidgetKitExample** スキームを iPhone シミュレータで実行してください。3 つのウィジェットとホーム画面への追加方法は [`Examples/README.md`](Examples/README.md) で説明しています。

## ドキュメント

API リファレンスと解説記事：

- GitHub Pages の [API リファレンス](https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/)。ソースコードの DocC コメントから生成しています。
- Xcode では **Product › Build Documentation**、またはコマンド `xcodebuild docbuild -scheme WidgetDevelopmentKit -destination 'generic/platform=iOS Simulator'` で生成できます。

## ガイド

- [Getting Started](https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/gettingstarted)：ウィジェット拡張とパッケージの追加、App Group を使ったデータ共有、タイムラインの作成、エントリの描画。
- [Interactive Widgets](https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/interactivewidgets)：App Group の設定、Intent の登録、ボタンの追加、プロバイダとアプリでのボタンの状態の読み取り。

## 動作要件

| プラットフォーム | 最小バージョン |
| ---------------- | -------------- |
| iOS              | 17.0           |
| macOS            | 14.0           |
| ツールチェーン   | Swift 6.0      |

ロック画面のビューと Live Activities は iOS のみです。macOS のターゲットは、プラットフォームに依存しないコードとそのテストを `swift test` で実行するためにあります。CI は GitHub の `macos-26` イメージのデフォルトの Xcode でビルドし、ローカルの開発には Xcode 27 を使っています。それより古い Xcode では試していません。

## アーキテクチャ

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

ビューは薄く保っています。実際のデータで問題を起こしやすい計算（目標値ゼロ、`NaN`、逆転した日付範囲、夏時間の切り替え日）は、単体テスト付きの純粋関数として `Core` と `Timeline` に置いています。ストレージやネットワークを扱う型は依存（`UserDefaults`、時計、通信、待機）を引数で受け取るので、App Group やサーバーなしでテストできます。SwiftUI のビューの body にはスナップショットテストがありません。

macOS と iOS シミュレータでテストを実行します。

```sh
swift test
xcodebuild test -scheme WidgetDevelopmentKit -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

3 つの iOS テストは意図的にスキップされます。README の画像を描画するためのもので、`scripts/render-screenshots.sh` からのみ実行されます。

## ロードマップ

- バージョンを指定してパッケージを追加できるよう、現在のコードに対応するリリースのタグを付ける。
- ビューの body のスナップショットテスト。
- サンプルアプリに Live Activity のサンプルを追加する。

これまでの変更は [CHANGELOG](CHANGELOG.md) に記録しています。`v1.0.0` のコードがビルドできないと分かった後、2026 年 10 月にパッケージをどのように復元したかも含まれます。

## コントリビューション

コントリビューションを歓迎します。pull request を作成する前に[コントリビューションガイド](https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/CONTRIBUTING.md)と[行動規範](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md)をお読みください。セキュリティ上の問題は[セキュリティポリシー](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md)に従って非公開で報告してください。

## ライセンス

MIT ライセンスで公開しています。詳細は [LICENSE](LICENSE) を参照してください。
