<!-- i18n-source: README.md@a6ec189434335e917ee452566170f8aecc856cd6 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/banner-fr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/banner-fr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/banner-fr-light.svg" alt="iOS Widget Development Kit: Vues SwiftUI et utilitaires de timeline pour les widgets WidgetKit et les Live Activities."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/actions/workflows/ci.yml/badge.svg" alt="État de la CI"></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-platforms-light.svg" alt="Plateformes prises en charge: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-language-light.svg" alt="Version du langage: Swift 6.0+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-license-light.svg" alt="Licence: MIT"></picture></a>
</p>

<p align="center">
<a href="#démarrage-rapide"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-start-fr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-start-fr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-start-fr-light.svg" alt="Commencer"></picture></a>
<a href="https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-docs-fr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-docs-fr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-docs-fr-light.svg" alt="Documentation"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-examples-fr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-examples-fr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-examples-fr-light.svg" alt="Exemples"></picture></a>
</p>

> Ceci est une traduction du README anglais. En cas de différence, la version anglaise fait foi.

<!-- brand:end -->

WidgetDevelopmentKit est un paquet Swift destiné aux développeurs qui créent des widgets pour
leurs apps iOS. Il contient des vues SwiftUI prêtes à l’emploi pour les widgets de l’écran
d’accueil, de l’écran verrouillé et de StandBy, des vues de graphiques adaptées à la taille
d’un widget, des utilitaires pour les timelines et pour les données que l’app partage avec son
widget, des App Intents pour les boutons des widgets, ainsi que des attributs et des vues
ActivityKit pour les Live Activities. Vous écrivez toujours l’extension de widget vous-même ;
le paquet vous épargne les vues et la logique de dates, de stockage et de nouvelles tentatives
dont tout widget a besoin.

## Points forts

- **20 modèles pour l’écran d’accueil** — météo, statistiques, finances, calendrier, compte à
  rebours, horloge, notes, citation, musique, podcast, actualités, anneaux d’activité, suivi
  d’habitudes, tâches, eau, batterie, etc.
- **Écran verrouillé et StandBy** — 15 vues accessoires (circulaire, rectangulaire, en ligne)
  et 7 vues StandBy.
- **Utilitaires de timeline** — dates des entrées, politiques de rechargement et un stockage
  d’instantanés avec expiration, pour que le widget lise ce que l’app a enregistré via un App
  Group.
- **Widgets interactifs** — 5 App Intents et 8 vues dont les boutons les exécutent.
- **Live Activities** — 10 types `ActivityAttributes` avec des vues pour l’écran verrouillé et
  la Dynamic Island compacte, et une machine à états qui rejette les mises à jour arrivées dans
  le désordre.
- **Logique testée** — le code des dates, des nombres et des nouvelles tentatives est couvert
  par des tests Swift Testing, y compris des cas limites comme `NaN`, un objectif nul et les
  jours de changement d’heure.

## Démarrage rapide

**1. Ajouter le paquet**

Votre app a besoin d’une extension de widget. Si elle n’en a pas encore, choisissez **File ›
New › Target…** dans Xcode, puis **Widget Extension**. Choisissez ensuite **File › Add Package
Dependencies…**, collez cette URL dans le champ de recherche en haut à droite et cliquez sur
**Add Package** :

```text
https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git
```

Dans la fenêtre suivante, réglez **Add to Target** de `WidgetDevelopmentKit` sur votre
extension de widget, puis cliquez sur **Add Package**.

**2. Importer le module**

En haut d’un fichier Swift de l’extension de widget :

```swift
import WidgetDevelopmentKit
```

**3. L’utiliser**

Ajoutez ce widget à l’extension. Il affiche un compte à rebours jusqu’à une date avec la vue
`CountdownWidget` du paquet. Ajoutez ensuite `LaunchCountdownWidget()` au `WidgetBundle` de
l’extension, le type marqué `@main`.

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

Lancez l’app dans un simulateur d’iPhone. Sur l’écran d’accueil, maintenez le doigt sur une
zone vide, touchez **Edit › Add Widget**, cherchez votre app et ajoutez **Countdown**. Le même
code se trouve dans
[`Examples/WidgetKitExample`](Examples/WidgetKitExample/Widgets/LaunchCountdownWidget.swift).

## Installation

### Swift Package Manager

Dans Xcode, choisissez **File › Add Package Dependencies…** et saisissez l’URL du dépôt :

```text
https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git
```

Ou ajoutez-le aux `dependencies` de votre `Package.swift` :

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

Les versions commencent à 2.0.0 ; l’ancien tag `v1.0.0` est antérieur au code actuel et
ne compile pas. Le paquet n’a aucune dépendance tierce.

## Utilisation

Chaque exemple Swift de cette section provient de
[`Examples/WidgetKitExample`](Examples/WidgetKitExample), que la CI compile, ou de
[`ReadmeExamplesTests.swift`](Tests/WidgetDevelopmentKitTests/ReadmeExamplesTests.swift),
compilé avec les tests. Un test échoue si un bloc de cette page ne correspond plus à ce code.

### Lire des données partagées dans un fournisseur de timeline

`TimelineSchedule` produit les dates des entrées, `TimelineBuilder` trie les entrées et
convertit une `WidgetUpdatePolicy` en politique de rechargement de WidgetKit, et
`WidgetSnapshotStore` lit ce que l’app a enregistré dans l’App Group partagé.

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

### Enregistrer des données dans l’app

L’app écrit la valeur avec une durée de validité et demande à WidgetKit de recharger le
widget :

```swift
try store.save(steps, forKey: "steps", lifetime: 30 * 60)
WidgetCenter.shared.reloadTimelines(ofKind: "steps")
```

Ajoutez la capacité **App Groups** à l’app et à l’extension avec le même identifiant. Le
stockage utilise `UserDefaults`, qui n’est pas chiffré : n’y mettez aucun secret.

### Afficher une entrée

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

Les vues qui affichent des valeurs dépendant du temps (`CountdownWidget`,
`StandByCountdownWidget`, `LockScreenCountdownWidget`) prennent un `referenceDate` ; passez
`entry.date` pour que chaque entrée affiche son propre instant.

### Ajouter un bouton à un widget

```swift
struct WaterButton: View {
    var body: some View {
        Button(intent: IncrementIntent(counterId: "water", amount: 250)) {
            Label("+250 ml", systemImage: "drop.fill")
        }
    }
}
```

Les intents s’exécutent dans l’extension de widget et écrivent dans `WidgetStateStore.shared`,
qui utilise l’App Group indiqué par la clé `WidgetDevelopmentKitAppGroup` de l’Info.plist.
Ajoutez la clé à l’app et à l’extension, et enregistrez les intents du paquet :

```swift
struct AppIntentsRoot: AppIntentsPackage {
    static var includedPackages: [any AppIntentsPackage.Type] {
        [WidgetDevelopmentKitIntents.self]
    }
}
```

### Charger des données depuis un serveur

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

`WidgetDataLoader` utilise une session éphémère avec des délais d’attente courts, qui n’attend
pas la connexion. Il relance les réponses 5xx et 408, les délais dépassés et les erreurs hors
ligne (une fois par défaut ; modifiable avec une `RetryPolicy`), mais pas les réponses 4xx ni
les erreurs de décodage.

## Démo

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/images/home-screen-dark.png">
  <img src="docs/images/home-screen-light.png" alt="Widgets météo, eau, activité physique, compte à rebours, citation et habitudes dessinés avec le paquet" width="404">
</picture>
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/images/charts-dark.png">
  <img src="docs/images/charts-light.png" alt="Vues statistiques avec sparkline, anneau de progression, graphique en courbes et graphique en barres" width="404">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/images/lock-screen-dark.png">
  <img src="docs/images/lock-screen-light.png" alt="Widgets de l’écran verrouillé : batterie, anneaux d’activité, compte à rebours, météo et statistiques" width="304">
</picture>

Les images sont dessinées à partir des vues du paquet avec `ImageRenderer` par
[`scripts/render-screenshots.sh`](scripts/render-screenshots.sh). Comme elles sont dessinées en
dehors de WidgetKit, le cadre du widget, la vibrance de l’écran verrouillé et le mode nuit de
StandBy sont approximés et non produits par le système.

Pour essayer les widgets vous-même, ouvrez
[`Examples/WidgetKitExample/WidgetKitExample.xcodeproj`](Examples/WidgetKitExample) et lancez
le schéma **WidgetKitExample** dans un simulateur d’iPhone ;
[`Examples/README.md`](Examples/README.md) présente les trois widgets et explique comment les
ajouter à l’écran d’accueil.

## Documentation

Référence de l’API et articles :

- [Référence de l’API](https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/)
  sur GitHub Pages, générée à partir des commentaires DocC du code source.
- Dans Xcode : **Product › Build Documentation**, ou
  `xcodebuild docbuild -scheme WidgetDevelopmentKit -destination 'generic/platform=iOS Simulator'`.

## Guides

- [Getting Started](https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/gettingstarted) :
  ajouter une extension de widget et le paquet, partager des données via un App Group,
  construire la timeline et afficher une entrée.
- [Interactive Widgets](https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/interactivewidgets) :
  configurer l’App Group, enregistrer les intents, ajouter des boutons et lire leur état dans
  le fournisseur et dans l’app.

## Prérequis

| Plateforme      | Version minimale |
| --------------- | ---------------- |
| iOS             | 17.0             |
| macOS           | 14.0             |
| Chaîne d’outils | Swift 6.0        |

Les vues de l’écran verrouillé et les Live Activities n’existent que sur iOS. La cible macOS
permet d’exécuter le code indépendant de la plateforme et ses tests avec `swift test`. La CI
compile avec le Xcode par défaut de l’image `macos-26` de GitHub ; le développement local
utilise Xcode 27. Les versions plus anciennes de Xcode n’ont pas été essayées.

## Architecture

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

Les vues restent légères : les calculs qui peuvent mal tourner avec des données réelles
(objectifs nuls, `NaN`, plages de dates inversées, jours de changement d’heure) se trouvent dans
`Core` et `Timeline` sous forme de fonctions pures testées. Les types qui touchent au stockage
ou au réseau reçoivent leurs dépendances (`UserDefaults`, horloge, transport, attente) en
paramètres, ce qui permet de les tester sans App Group ni serveur. Les corps des vues SwiftUI
n’ont pas de tests d’instantanés.

Lancez les tests sur macOS et dans un simulateur iOS :

```sh
swift test
xcodebuild test -scheme WidgetDevelopmentKit -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

Trois tests iOS sont ignorés volontairement : ils dessinent les images du README et ne
s’exécutent que via `scripts/render-screenshots.sh`.

## Feuille de route

- Taguer une version qui correspond au code actuel, pour pouvoir ajouter le paquet par
  version.
- Des tests d’instantanés pour les corps des vues.
- Une Live Activity d’exemple dans l’app d’exemple.

Le [CHANGELOG](CHANGELOG.md) consigne les changements jusqu’ici, y compris la façon dont le
paquet a été restauré en octobre 2026 après avoir constaté que le code de `v1.0.0` ne compilait
pas.

## Contribuer

Les contributions sont les bienvenues. Lisez le [guide de contribution](https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/CONTRIBUTING.md) et le [code de conduite](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md) avant d’ouvrir une pull request. Signalez les problèmes de sécurité en privé, comme indiqué dans la [politique de sécurité](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md).

## Licence

Publié sous licence MIT. Voir [LICENSE](LICENSE).
