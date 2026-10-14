<!-- i18n-source: README.md@a6ec189434335e917ee452566170f8aecc856cd6 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/banner-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/banner-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/banner-de-light.svg" alt="iOS Widget Development Kit: SwiftUI-Views und Timeline-Hilfen für WidgetKit-Widgets und Live Activities."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/actions/workflows/ci.yml/badge.svg" alt="CI-Status"></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-platforms-light.svg" alt="Unterstützte Plattformen: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-language-light.svg" alt="Sprachversion: Swift 6.0+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-license-light.svg" alt="Lizenz: MIT"></picture></a>
</p>

<p align="center">
<a href="#schnellstart"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-start-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-start-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-start-de-light.svg" alt="Loslegen"></picture></a>
<a href="https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-docs-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-docs-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-docs-de-light.svg" alt="Dokumentation"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-examples-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-examples-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-examples-de-light.svg" alt="Beispiele"></picture></a>
</p>

> Dies ist eine Übersetzung der englischen README. Bei Abweichungen gilt die englische Fassung.

<!-- brand:end -->

WidgetDevelopmentKit ist ein Swift-Paket für alle, die Widgets für ihre iOS-Apps bauen. Es
enthält fertige SwiftUI-Views für Widgets auf dem Home-Bildschirm, dem Sperrbildschirm und in
StandBy, Diagramm-Views in Widget-Größe, Hilfstypen für Timelines und für die Daten, die die
App mit ihrem Widget teilt, App Intents für Widget-Buttons sowie ActivityKit-Attribute und
-Views für Live Activities. Die Widget-Extension schreibst du weiterhin selbst; das Paket nimmt
dir die Views und die Datums-, Speicher- und Wiederholungslogik ab, die jedes Widget braucht.

## Highlights

- **20 Vorlagen für den Home-Bildschirm** – Wetter, Statistiken, Finanzen, Kalender,
  Countdown, Uhr, Notizen, Zitate, Musik, Podcast, Nachrichten, Fitnessringe,
  Gewohnheitstracker, To-dos, Wasser, Batterie und mehr.
- **Sperrbildschirm und StandBy** – 15 Accessory-Views (kreisförmig, rechteckig, inline) und 7
  StandBy-Views.
- **Timeline-Hilfen** – Eintragsdaten, Reload-Richtlinien und ein Snapshot-Speicher mit
  Ablaufzeit, damit das Widget liest, was die App über eine App Group gespeichert hat.
- **Interaktive Widgets** – 5 App Intents und 8 Views mit Buttons, die sie ausführen.
- **Live Activities** – 10 `ActivityAttributes`-Typen mit Views für den Sperrbildschirm und
  die kompakte Dynamic Island sowie ein Zustandsautomat, der Updates in falscher Reihenfolge
  ablehnt.
- **Getestete Logik** – der Code für Datumswerte, Zahlen und Wiederholungen ist mit Swift
  Testing getestet, auch für Grenzfälle wie `NaN`, Ziele von null und Tage mit
  Zeitumstellung.

## Schnellstart

**1. Paket hinzufügen**

Deine App braucht eine Widget-Extension. Falls es noch keine gibt, wähle in Xcode **File ›
New › Target…** und dann **Widget Extension**. Wähle anschließend **File › Add Package
Dependencies…**, füge diese URL oben rechts in das Suchfeld ein und klicke auf **Add
Package**:

```text
https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git
```

Stelle im nächsten Dialog in der Spalte **Add to Target** für `WidgetDevelopmentKit` deine
Widget-Extension ein und klicke auf **Add Package**.

**2. Modul importieren**

Am Anfang einer Swift-Datei der Widget-Extension:

```swift
import WidgetDevelopmentKit
```

**3. Verwenden**

Füge dieses Widget zur Extension hinzu. Es zählt mit der `CountdownWidget`-View des Pakets
bis zu einem Datum herunter. Trage danach `LaunchCountdownWidget()` im `WidgetBundle` der
Extension ein, also im Typ, der mit `@main` markiert ist.

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

Starte die App in einem iPhone-Simulator. Halte auf dem Home-Bildschirm eine freie Stelle
gedrückt, tippe auf **Edit › Add Widget**, suche deine App und füge **Countdown** hinzu.
Derselbe Code steht in
[`Examples/WidgetKitExample`](Examples/WidgetKitExample/Widgets/LaunchCountdownWidget.swift).

## Installation

### Swift Package Manager

Wähle in Xcode **File › Add Package Dependencies…** und gib die Repository-URL ein:

```text
https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git
```

Oder füge es zu den `dependencies` in deiner `Package.swift` hinzu:

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

Releases beginnen mit 2.0.0; das frühere Tag `v1.0.0` ist älter als der aktuelle Code und
lässt sich nicht bauen. Das Paket hat keine Abhängigkeiten von Drittanbietern.

## Verwendung

Alle Swift-Beispiele in diesem Abschnitt stammen aus
[`Examples/WidgetKitExample`](Examples/WidgetKitExample), das CI baut, oder aus
[`ReadmeExamplesTests.swift`](Tests/WidgetDevelopmentKitTests/ReadmeExamplesTests.swift), das
mit den Tests kompiliert wird. Ein Test schlägt fehl, wenn ein Block hier nicht mehr mit diesem
Code übereinstimmt.

### Geteilte Daten in einem Timeline-Provider lesen

`TimelineSchedule` erzeugt die Eintragsdaten, `TimelineBuilder` sortiert die Einträge und
übersetzt eine `WidgetUpdatePolicy` in die Reload-Richtlinie von WidgetKit, und
`WidgetSnapshotStore` liest, was die App in der gemeinsamen App Group gespeichert hat.

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

### Daten in der App speichern

Die App schreibt den Wert mit einer Gültigkeitsdauer und bittet WidgetKit, das Widget neu zu
laden:

```swift
try store.save(steps, forKey: "steps", lifetime: 30 * 60)
WidgetCenter.shared.reloadTimelines(ofKind: "steps")
```

Füge der App und der Extension die Capability **App Groups** mit derselben Kennung hinzu. Der
Speicher nutzt `UserDefaults`, das nicht verschlüsselt ist; lege dort also keine Geheimnisse
ab.

### Einen Eintrag anzeigen

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

Views, die zeitabhängige Werte zeigen (`CountdownWidget`, `StandByCountdownWidget`,
`LockScreenCountdownWidget`), erhalten ein `referenceDate`; übergib `entry.date`, damit jeder
Eintrag seinen eigenen Zeitpunkt darstellt.

### Einem Widget einen Button hinzufügen

```swift
struct WaterButton: View {
    var body: some View {
        Button(intent: IncrementIntent(counterId: "water", amount: 250)) {
            Label("+250 ml", systemImage: "drop.fill")
        }
    }
}
```

Die Intents laufen in der Widget-Extension und schreiben in `WidgetStateStore.shared`. Dieser
Speicher verwendet die App Group, die im Schlüssel `WidgetDevelopmentKitAppGroup` der
Info.plist steht. Trage den Schlüssel in der App und in der Extension ein und registriere die
Intents des Pakets:

```swift
struct AppIntentsRoot: AppIntentsPackage {
    static var includedPackages: [any AppIntentsPackage.Type] {
        [WidgetDevelopmentKitIntents.self]
    }
}
```

### Daten von einem Server laden

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

`WidgetDataLoader` verwendet eine flüchtige (ephemeral) Session mit kurzen Timeouts, die nicht
auf eine Verbindung wartet. Er wiederholt Antworten mit 5xx und 408, Timeouts und
Offline-Fehler (standardmäßig einmal; mit einer `RetryPolicy` änderbar), aber keine
4xx-Antworten oder Decodierungsfehler.

## Demo

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/images/home-screen-dark.png">
  <img src="docs/images/home-screen-light.png" alt="Mit dem Paket gerenderte Widgets für Wetter, Wasser, Fitness, Countdown, Zitat und Gewohnheiten" width="404">
</picture>
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/images/charts-dark.png">
  <img src="docs/images/charts-light.png" alt="Views für Statistik mit Sparkline, Fortschrittsring, Liniendiagramm und Balkendiagramm" width="404">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/images/lock-screen-dark.png">
  <img src="docs/images/lock-screen-light.png" alt="Sperrbildschirm-Widgets für Batterie, Aktivitätsringe, Countdown, Wetter und Statistik" width="304">
</picture>

Die Bilder werden von [`scripts/render-screenshots.sh`](scripts/render-screenshots.sh) mit
`ImageRenderer` aus den Views des Pakets gerendert. Da sie außerhalb von WidgetKit entstehen,
sind Widget-Rahmen, Sperrbildschirm-Vibrancy und der Nachtmodus von StandBy nur angenähert und
nicht vom System erzeugt.

Um die Widgets selbst auszuprobieren, öffne
[`Examples/WidgetKitExample/WidgetKitExample.xcodeproj`](Examples/WidgetKitExample) und starte
das Schema **WidgetKitExample** in einem iPhone-Simulator;
[`Examples/README.md`](Examples/README.md) beschreibt die drei Widgets und wie du sie zum
Home-Bildschirm hinzufügst.

## Dokumentation

API-Referenz und Artikel:

- [API-Referenz](https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/)
  auf GitHub Pages, erzeugt aus den DocC-Kommentaren im Quellcode.
- In Xcode: **Product › Build Documentation**, oder
  `xcodebuild docbuild -scheme WidgetDevelopmentKit -destination 'generic/platform=iOS Simulator'`.

## Anleitungen

- [Getting Started](https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/gettingstarted):
  Widget-Extension und Paket hinzufügen, Daten über eine App Group teilen, die Timeline
  aufbauen und einen Eintrag darstellen.
- [Interactive Widgets](https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/interactivewidgets):
  App Group einrichten, Intents registrieren, Buttons hinzufügen und ihren Zustand im Provider
  und in der App lesen.

## Voraussetzungen

| Plattform | Mindestversion |
| --------- | -------------- |
| iOS       | 17.0           |
| macOS     | 14.0           |
| Toolchain | Swift 6.0      |

Sperrbildschirm-Views und Live Activities gibt es nur unter iOS. Das macOS-Ziel existiert,
damit der plattformunabhängige Code und seine Tests mit `swift test` laufen. CI baut mit dem
Standard-Xcode des `macos-26`-Images von GitHub; lokal wird mit Xcode 27 entwickelt. Ältere
Xcode-Versionen wurden nicht ausprobiert.

## Architektur

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

Die Views bleiben schlank: Berechnungen, die mit echten Daten schiefgehen können (Ziele von
null, `NaN`, vertauschte Datumsbereiche, Tage mit Zeitumstellung), liegen als reine Funktionen
mit Unit-Tests in `Core` und `Timeline`. Typen, die auf Speicher oder Netzwerk zugreifen,
erhalten ihre Abhängigkeiten (`UserDefaults`, Uhr, Transport, Warten) als Parameter und lassen
sich so ohne App Group oder Server testen. Für die Bodies der SwiftUI-Views gibt es keine
Snapshot-Tests.

Führe die Tests unter macOS und in einem iOS-Simulator aus:

```sh
swift test
xcodebuild test -scheme WidgetDevelopmentKit -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

Drei iOS-Tests werden absichtlich übersprungen: Sie rendern die Bilder der README und laufen nur
über `scripts/render-screenshots.sh`.

## Roadmap

- Ein Release taggen, das zum aktuellen Code passt, damit sich das Paket per Version einbinden
  lässt.
- Snapshot-Tests für die View-Bodies.
- Eine Beispiel-Live-Activity in der Beispiel-App.

Das [CHANGELOG](CHANGELOG.md) hält fest, was sich bisher geändert hat, auch wie das Paket im
Oktober 2026 wiederhergestellt wurde, nachdem sich herausgestellt hatte, dass der Code von
`v1.0.0` nicht baut.

## Mitwirken

Beiträge sind willkommen. Lies vor einem Pull Request den [Leitfaden für Beiträge](https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/CONTRIBUTING.md) und den [Verhaltenskodex](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md). Sicherheitsprobleme meldest du vertraulich, wie in der [Sicherheitsrichtlinie](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md) beschrieben.

## Lizenz

Veröffentlicht unter der MIT-Lizenz. Siehe [LICENSE](LICENSE).
