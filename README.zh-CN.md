<!-- i18n-source: README.md@a6ec189434335e917ee452566170f8aecc856cd6 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/banner-zh-CN-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/banner-zh-CN-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/banner-zh-CN-light.svg" alt="iOS Widget Development Kit: 用于 WidgetKit 小组件和 Live Activities 的 SwiftUI 视图与时间线辅助工具。"></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/actions/workflows/ci.yml/badge.svg" alt="CI 状态"></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-platforms-light.svg" alt="支持的平台: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-language-light.svg" alt="语言版本: Swift 6.0+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-license-light.svg" alt="许可证: MIT"></picture></a>
</p>

<p align="center">
<a href="#快速开始"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-start-zh-CN-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-start-zh-CN-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-start-zh-CN-light.svg" alt="开始使用"></picture></a>
<a href="https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-docs-zh-CN-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-docs-zh-CN-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-docs-zh-CN-light.svg" alt="文档"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-examples-zh-CN-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-examples-zh-CN-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-examples-zh-CN-light.svg" alt="示例"></picture></a>
</p>

> 本文是英文 README 的译文。如两者内容不一致，以英文版为准。

<!-- brand:end -->

WidgetDevelopmentKit 是一个 Swift 软件包，面向为 iOS 应用开发小组件的开发者。它包含用于主屏幕、锁定屏幕和 StandBy 小组件的现成 SwiftUI 视图，适合小组件尺寸的图表视图，用于时间线以及应用与小组件共享数据的辅助工具，用于小组件按钮的 App Intents，以及用于 Live Activities 的 ActivityKit 属性和视图。小组件扩展仍需你自己编写；这个软件包为你省去视图，以及每个小组件都需要的日期、存储和重试逻辑。

## 亮点

- **20 个主屏幕模板** —— 天气、统计、财务、日历、倒计时、时钟、备忘、名言、音乐、播客、新闻、健身圆环、习惯追踪、待办、饮水、电池等。
- **锁定屏幕和 StandBy** —— 15 个配件视图（圆形、矩形、行内）和 7 个 StandBy 视图。
- **时间线辅助工具** —— 条目日期、重新加载策略，以及带有效期的快照存储，让小组件读取应用通过 App Group 保存的数据。
- **交互式小组件** —— 5 个 App Intent，以及 8 个带有调用这些 Intent 的按钮的视图。
- **Live Activities** —— 10 个 `ActivityAttributes` 类型，带有锁定屏幕视图和紧凑型 Dynamic Island 视图，以及一个拒绝乱序更新的状态机。
- **经过测试的逻辑** —— 日期、数值和重试代码都有 Swift Testing 测试覆盖，包括 `NaN`、目标为零、夏令时切换日等边界情况。

## 快速开始

**1. 添加软件包**

你的应用需要一个小组件扩展。如果还没有，请在 Xcode 中选择 **File › New › Target…**，然后选择 **Widget Extension**。接着选择 **File › Add Package Dependencies…**，把下面的 URL 粘贴到右上角的搜索框中，然后点击 **Add Package**：

```text
https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git
```

在下一个对话框中，把 `WidgetDevelopmentKit` 的 **Add to Target** 设为你的小组件扩展，然后点击 **Add Package**。

**2. 导入模块**

在小组件扩展中某个 Swift 文件的顶部加入：

```swift
import WidgetDevelopmentKit
```

**3. 开始使用**

把这个小组件添加到扩展中。它使用软件包中的 `CountdownWidget` 视图倒数到某个日期。然后在扩展的 `WidgetBundle`（即标有 `@main` 的类型）中列出 `LaunchCountdownWidget()`。

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

在 iPhone 模拟器上运行应用。在主屏幕上长按空白处，轻点 **Edit › Add Widget**，找到你的应用并添加 **Countdown**。同样的代码也在 [`Examples/WidgetKitExample`](Examples/WidgetKitExample/Widgets/LaunchCountdownWidget.swift) 中。

## 安装

### Swift Package Manager

在 Xcode 中选择 **File › Add Package Dependencies…**，然后输入仓库地址：

```text
https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git
```

或者将其添加到 `Package.swift` 的 `dependencies` 中：

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git", from: "2.0.0")
],
targets: [
    .target(name: "YourApp", dependencies: [
        .product(name: "WidgetDevelopmentKit", package: "iOS-Widget-Development-Kit")
    ])
]
```

可用版本从 2.0.0 开始；更早的 `v1.0.0` 标签早于当前代码，无法编译。该软件包没有第三方依赖。

## 使用方法

本节中的每个 Swift 示例都取自 CI 会构建的 [`Examples/WidgetKitExample`](Examples/WidgetKitExample)，或取自随测试一起编译的 [`ReadmeExamplesTests.swift`](Tests/WidgetDevelopmentKitTests/ReadmeExamplesTests.swift)。如果这里的代码块与那些代码不再一致，就会有测试失败。

### 在时间线提供者中读取共享数据

`TimelineSchedule` 生成条目日期，`TimelineBuilder` 对条目排序并把 `WidgetUpdatePolicy` 转换为 WidgetKit 的重新加载策略，`WidgetSnapshotStore` 读取应用保存到共享 App Group 中的数据。

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

### 在应用中保存数据

应用写入带有效期的值，并请求 WidgetKit 重新加载小组件：

```swift
try store.save(steps, forKey: "steps", lifetime: 30 * 60)
WidgetCenter.shared.reloadTimelines(ofKind: "steps")
```

为应用和扩展添加 **App Groups** 功能，并使用同一个标识符。存储使用未加密的 `UserDefaults`，因此不要在其中保存机密信息。

### 显示一个条目

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

显示与时间相关数值的视图（`CountdownWidget`、`StandByCountdownWidget`、`LockScreenCountdownWidget`）接受一个 `referenceDate` 参数；传入 `entry.date`，让每个条目显示它自己的时刻。

### 为小组件添加按钮

```swift
struct WaterButton: View {
    var body: some View {
        Button(intent: IncrementIntent(counterId: "water", amount: 250)) {
            Label("+250 ml", systemImage: "drop.fill")
        }
    }
}
```

这些 Intent 在小组件扩展中运行，并写入 `WidgetStateStore.shared`。它使用 Info.plist 中 `WidgetDevelopmentKitAppGroup` 键所指定的 App Group。请在应用和扩展中都添加这个键，并注册软件包中的 Intent：

```swift
struct AppIntentsRoot: AppIntentsPackage {
    static var includedPackages: [any AppIntentsPackage.Type] {
        [WidgetDevelopmentKitIntents.self]
    }
}
```

### 从服务器加载数据

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

`WidgetDataLoader` 使用一个超时较短、不等待网络连接的临时（ephemeral）会话。它会重试 5xx 和 408 响应、超时以及离线错误（默认重试一次；可通过 `RetryPolicy` 修改），但不会重试 4xx 响应或解码错误。

## 演示

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/images/home-screen-dark.png">
  <img src="docs/images/home-screen-light.png" alt="由软件包渲染的天气、饮水、健身、倒计时、名言和习惯小组件" width="404">
</picture>
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/images/charts-dark.png">
  <img src="docs/images/charts-light.png" alt="统计迷你折线图、进度圆环、折线图和柱状图视图" width="404">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/images/lock-screen-dark.png">
  <img src="docs/images/lock-screen-light.png" alt="锁定屏幕上的电池、活动圆环、倒计时、天气和统计小组件" width="304">
</picture>

这些图片由 [`scripts/render-screenshots.sh`](scripts/render-screenshots.sh) 使用 `ImageRenderer` 从软件包的视图渲染而成。由于它们是在 WidgetKit 之外绘制的，小组件边框、锁定屏幕的鲜明效果（vibrancy）和 StandBy 夜间模式都是近似效果，而不是由系统生成的。

想亲自试用这些小组件，请打开 [`Examples/WidgetKitExample/WidgetKitExample.xcodeproj`](Examples/WidgetKitExample)，在 iPhone 模拟器上运行 **WidgetKitExample** scheme；[`Examples/README.md`](Examples/README.md) 介绍了这三个小组件以及如何把它们添加到主屏幕。

## 文档

API 参考文档与文章：

- GitHub Pages 上的 [API 参考](https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/)，由源代码中的 DocC 注释生成。
- 在 Xcode 中：**Product › Build Documentation**，或运行 `xcodebuild docbuild -scheme WidgetDevelopmentKit -destination 'generic/platform=iOS Simulator'`。

## 指南

- [Getting Started](https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/gettingstarted)：添加小组件扩展和软件包，通过 App Group 共享数据，构建时间线并渲染条目。
- [Interactive Widgets](https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/interactivewidgets)：配置 App Group，注册 Intent，添加按钮，并在提供者和应用中读取按钮状态。

## 系统要求

| 平台   | 最低版本  |
| ------ | --------- |
| iOS    | 17.0      |
| macOS  | 14.0      |
| 工具链 | Swift 6.0 |

锁定屏幕视图和 Live Activities 仅适用于 iOS。macOS 目标的存在是为了让与平台无关的代码及其测试可以通过 `swift test` 运行。CI 使用 GitHub `macos-26` 镜像的默认 Xcode 构建；本地开发使用 Xcode 27。尚未在更早的 Xcode 版本上尝试。

## 架构

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

视图保持精简：在真实数据下可能出错的计算（目标为零、`NaN`、颠倒的日期范围、夏令时切换日）以纯函数的形式放在 `Core` 和 `Timeline` 中，并有单元测试。涉及存储或网络的类型通过参数接收依赖（`UserDefaults`、时钟、传输层、等待），因此无需 App Group 或服务器即可测试。SwiftUI 视图的 body 没有快照测试。

在 macOS 和 iOS 模拟器上运行测试：

```sh
swift test
xcodebuild test -scheme WidgetDevelopmentKit -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

有三个 iOS 测试是有意跳过的：它们用于渲染 README 中的图片，只通过 `scripts/render-screenshots.sh` 运行。

## 路线图

- 为当前代码打一个发布标签，以便按版本添加软件包。
- 为视图 body 添加快照测试。
- 在示例应用中加入一个 Live Activity 示例。

[CHANGELOG](CHANGELOG.md) 记录了迄今为止的变更，包括在发现 `v1.0.0` 的代码无法编译之后，软件包于 2026 年 10 月是如何恢复的。

## 参与贡献

欢迎参与贡献。提交 pull request 之前，请先阅读[贡献指南](https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/CONTRIBUTING.md)和[行为准则](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md)。如发现安全问题，请按照[安全策略](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md)私下报告。

## 许可证

基于 MIT 许可证发布。详见 [LICENSE](LICENSE)。
