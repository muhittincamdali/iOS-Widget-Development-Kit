<!-- i18n-source: README.md@21d649e6f03399b9ae6f8c248f63c32d4a134aab status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/banner-tr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/banner-tr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/banner-tr-light.svg" alt="iOS Widget Development Kit: WidgetKit widget'ları ve Live Activities için SwiftUI görünümleri ve zaman çizelgesi yardımcıları."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/actions/workflows/ci.yml/badge.svg" alt="CI durumu"></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-platforms-light.svg" alt="Desteklenen platformlar: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-language-light.svg" alt="Dil sürümü: Swift 6.0+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-license-light.svg" alt="Lisans: MIT"></picture></a>
</p>

<p align="center">
<a href="#hızlı-başlangıç"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-start-tr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-start-tr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-start-tr-light.svg" alt="Başlayın"></picture></a>
<a href="https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-docs-tr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-docs-tr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-docs-tr-light.svg" alt="Dokümantasyon"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-examples-tr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-examples-tr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-examples-tr-light.svg" alt="Örnekler"></picture></a>
</p>

> Bu belge İngilizce README'nin çevirisidir. İkisi arasında fark varsa güncel olan İngilizce sürümdür.

<!-- brand:end -->

WidgetDevelopmentKit, iOS uygulamalarına widget geliştirenler için bir Swift paketidir. Ana
Ekran, Kilitli Ekran ve StandBy widget'ları için hazır SwiftUI görünümleri, widget boyutuna
uygun grafik görünümleri, zaman çizelgeleri ve uygulamanın widget'la paylaştığı veriler için
yardımcılar, widget düğmeleri için App Intents ve Live Activities için ActivityKit
öznitelikleri ile görünümleri içerir. Widget uzantısını yine siz yazarsınız; paket sizi
görünümlerle ve her widget'ın ihtiyaç duyduğu tarih, depolama ve yeniden deneme mantığıyla
uğraşmaktan kurtarır.

## Öne çıkanlar

- **20 Ana Ekran şablonu** — hava durumu, istatistik, finans, takvim, geri sayım, saat, not,
  alıntı, müzik, podcast, haber, fitness halkaları, alışkanlık takibi, yapılacaklar, su, pil
  ve daha fazlası.
- **Kilitli Ekran ve StandBy** — 15 aksesuar görünümü (dairesel, dikdörtgen, satır içi) ve 7
  StandBy görünümü.
- **Zaman çizelgesi yardımcıları** — giriş tarihleri, yeniden yükleme politikaları ve süresi
  dolan değerleri bilen bir anlık görüntü deposu; widget, uygulamanın App Group üzerinden
  kaydettiği veriyi okur.
- **Etkileşimli widget'lar** — 5 App Intent ve bunları çalıştıran düğmelere sahip 8 görünüm.
- **Live Activities** — Kilitli Ekran ve kompakt Dynamic Island görünümleriyle 10
  `ActivityAttributes` türü ve sırası karışmış güncellemeleri reddeden bir durum makinesi.
- **Test edilmiş mantık** — tarih, sayı ve yeniden deneme kodu Swift Testing testleriyle
  kapsanır; `NaN`, sıfır hedef ve yaz saati geçiş günleri gibi uç durumlar da dahil.

## Hızlı başlangıç

**1. Paketi ekleyin**

Uygulamanızın bir widget uzantısı olmalı. Henüz yoksa Xcode'da **File › New › Target…**
menüsünü seçin ve **Widget Extension**'ı seçin. Ardından **File › Add Package
Dependencies…** menüsünü seçin, bu adresi sağ üstteki arama alanına yapıştırın ve **Add
Package**'a tıklayın:

```text
https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git
```

Sonraki pencerede `WidgetDevelopmentKit` için **Add to Target** sütununu widget uzantınız
olarak ayarlayın ve **Add Package**'a tıklayın.

**2. Modülü içe aktarın**

Widget uzantısındaki bir Swift dosyasının en üstüne ekleyin:

```swift
import WidgetDevelopmentKit
```

**3. Kullanın**

Bu widget'ı uzantıya ekleyin. Paketin `CountdownWidget` görünümüyle bir tarihe geri sayım
yapar. Ardından `LaunchCountdownWidget()` satırını uzantının `WidgetBundle`'ına, yani
`@main` ile işaretli türe ekleyin.

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

Uygulamayı bir iPhone simülatöründe çalıştırın. Ana Ekran'da boş bir alana basılı tutun,
**Edit › Add Widget**'a dokunun, uygulamanızı bulun ve **Countdown**'ı ekleyin. Aynı kod
[`Examples/WidgetKitExample`](Examples/WidgetKitExample/Widgets/LaunchCountdownWidget.swift)
içinde de var.

## Kurulum

### Swift Package Manager

Xcode'da **File › Add Package Dependencies…** menüsünü seçin ve depo adresini girin:

```text
https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git
```

Ya da `Package.swift` dosyanızdaki `dependencies` listesine ekleyin:

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

Tek etiket olan `v1.0.0` güncel koddan eskidir ve derlenmez; bir sonraki etiketli sürüme
kadar `main` dalını kullanın. Paketin üçüncü taraf bağımlılığı yoktur.

## Kullanım

Bu bölümdeki her Swift örneği, CI'ın derlediği
[`Examples/WidgetKitExample`](Examples/WidgetKitExample) projesinden ya da testlerle birlikte
derlenen
[`ReadmeExamplesTests.swift`](Tests/WidgetDevelopmentKitTests/ReadmeExamplesTests.swift)
dosyasından alınmıştır. Buradaki bir blok o kodla artık eşleşmezse bir test başarısız olur.

### Zaman çizelgesi sağlayıcısında paylaşılan veriyi okuyun

`TimelineSchedule` giriş tarihlerini üretir, `TimelineBuilder` girişleri sıralar ve bir
`WidgetUpdatePolicy` değerini WidgetKit'in yeniden yükleme politikasına çevirir,
`WidgetSnapshotStore` ise uygulamanın paylaşılan App Group'a kaydettiklerini okur.

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

### Uygulamada veriyi kaydedin

Uygulama değeri bir geçerlilik süresiyle yazar ve WidgetKit'ten widget'ı yeniden yüklemesini
ister:

```swift
try store.save(steps, forKey: "steps", lifetime: 30 * 60)
WidgetCenter.shared.reloadTimelines(ofKind: "steps")
```

Uygulamaya ve uzantıya aynı tanımlayıcıyla **App Groups** yeteneğini ekleyin. Depo
şifrelenmeyen `UserDefaults` kullanır; gizli bilgileri burada tutmayın.

### Bir girişi gösterin

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

Zamana bağlı değer gösteren görünümler (`CountdownWidget`, `StandByCountdownWidget`,
`LockScreenCountdownWidget`) bir `referenceDate` alır; her giriş kendi anını göstersin diye
`entry.date` değerini verin.

### Widget'a düğme ekleyin

```swift
struct WaterButton: View {
    var body: some View {
        Button(intent: IncrementIntent(counterId: "water", amount: 250)) {
            Label("+250 ml", systemImage: "drop.fill")
        }
    }
}
```

Intent'ler widget uzantısında çalışır ve `WidgetStateStore.shared`'a yazar. Bu depo,
Info.plist'teki `WidgetDevelopmentKitAppGroup` anahtarında adı verilen App Group'u kullanır.
Anahtarı hem uygulamaya hem uzantıya ekleyin ve paketin intent'lerini kaydedin:

```swift
struct AppIntentsRoot: AppIntentsPackage {
    static var includedPackages: [any AppIntentsPackage.Type] {
        [WidgetDevelopmentKitIntents.self]
    }
}
```

### Sunucudan veri yükleyin

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

`WidgetDataLoader`, bağlantıyı beklemeyen ve kısa zaman aşımları olan geçici (ephemeral) bir
oturum kullanır. 5xx ve 408 yanıtlarını, zaman aşımlarını ve çevrimdışı hatalarını yeniden
dener (varsayılan olarak bir kez; değiştirmek için bir `RetryPolicy` verin), ancak 4xx
yanıtlarını ve çözümleme (decoding) hatalarını denemez.

## Demo

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/images/home-screen-dark.png">
  <img src="docs/images/home-screen-light.png" alt="Paketten çizilen hava durumu, su, fitness, geri sayım, alıntı ve alışkanlık widget'ları" width="404">
</picture>
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/images/charts-dark.png">
  <img src="docs/images/charts-light.png" alt="İstatistik çizgisi, ilerleme halkası, çizgi grafik ve çubuk grafik görünümleri" width="404">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/images/lock-screen-dark.png">
  <img src="docs/images/lock-screen-light.png" alt="Kilitli Ekran pil, aktivite halkaları, geri sayım, hava durumu ve istatistik widget'ları" width="304">
</picture>

Görseller paketin görünümlerinden
[`scripts/render-screenshots.sh`](scripts/render-screenshots.sh) ile `ImageRenderer`
kullanılarak çizilir. WidgetKit dışında çizildikleri için widget çerçevesi, Kilitli Ekran
canlılığı (vibrancy) ve StandBy gece modu sistem tarafından üretilmez, yaklaşık olarak
gösterilir.

Widget'ları kendiniz denemek için
[`Examples/WidgetKitExample/WidgetKitExample.xcodeproj`](Examples/WidgetKitExample) projesini
açın ve **WidgetKitExample** şemasını bir iPhone simülatöründe çalıştırın;
[`Examples/README.md`](Examples/README.md) üç widget'ı ve bunları Ana Ekran'a nasıl
ekleyeceğinizi anlatır.

## Dokümantasyon

API başvuru belgeleri ve makaleler:

- GitHub Pages'te
  [API başvuru belgeleri](https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/);
  kaynak koddaki DocC yorumlarından üretilir.
- Xcode'da: **Product › Build Documentation** ya da
  `xcodebuild docbuild -scheme WidgetDevelopmentKit -destination 'generic/platform=iOS Simulator'`.

## Rehberler

- [Getting Started](https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/gettingstarted):
  widget uzantısını ve paketi ekleme, veriyi App Group üzerinden paylaşma, zaman çizelgesini
  oluşturma ve bir girişi çizme.
- [Interactive Widgets](https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/interactivewidgets):
  App Group'u yapılandırma, intent'leri kaydetme, düğme ekleme ve bunların durumunu
  sağlayıcıda ve uygulamada okuma.

## Gereksinimler

| Platform     | En düşük sürüm |
| ------------ | -------------- |
| iOS          | 17.0           |
| macOS        | 14.0           |
| Araç zinciri | Swift 6.0      |

Kilitli Ekran görünümleri ve Live Activities yalnızca iOS'ta vardır. macOS hedefi, platformdan
bağımsız kod ve testleri `swift test` ile çalışabilsin diye bulunur. CI, GitHub'ın `macos-26`
imajındaki varsayılan Xcode ile derler; yerel geliştirmede Xcode 27 kullanılır. Daha eski Xcode
sürümleri denenmedi.

## Mimari

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

Görünümler ince tutulur: gerçek veriyle yanlış gidebilecek hesaplar (sıfır hedefler, `NaN`,
ters tarih aralıkları, yaz saati geçiş günleri) `Core` ve `Timeline` içinde birim testli saf
fonksiyonlar olarak durur. Depolamaya ya da ağa dokunan türler bağımlılıklarını
(`UserDefaults`, saat, taşıma katmanı, bekleme) parametre olarak alır; böylece App Group ya da
sunucu olmadan test edilebilirler. SwiftUI görünüm gövdeleri için snapshot testi yoktur.

Testleri macOS'ta ve bir iOS simülatöründe çalıştırın:

```sh
swift test
xcodebuild test -scheme WidgetDevelopmentKit -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

Üç iOS testi bilerek atlanır: README görsellerini çizerler ve yalnızca
`scripts/render-screenshots.sh` ile çalışırlar.

## Yol haritası

- Paket sürüm numarasıyla eklenebilsin diye güncel koda karşılık gelen bir sürüm etiketlemek.
- Görünüm gövdeleri için snapshot testleri.
- Örnek uygulamaya bir Live Activity örneği.

[CHANGELOG](CHANGELOG.md) şimdiye kadarki değişiklikleri kaydeder; `v1.0.0` kodunun
derlenmediği anlaşıldıktan sonra paketin Ekim 2026'da nasıl geri getirildiği de buna dahildir.

## Katkıda bulunma

Katkılarınızı bekliyoruz. Pull request açmadan önce [katkı rehberini](https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/CONTRIBUTING.md) ve [davranış kurallarını](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md) okuyun. Güvenlik açıklarını [güvenlik politikasında](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md) anlatıldığı gibi gizli olarak bildirin.

## Lisans

MIT lisansıyla yayımlanmıştır. Ayrıntılar için [LICENSE](LICENSE) dosyasına bakın.
