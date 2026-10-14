<!-- i18n-source: README.md@21d649e6f03399b9ae6f8c248f63c32d4a134aab status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/banner-pt-BR-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/banner-pt-BR-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/banner-pt-BR-light.svg" alt="iOS Widget Development Kit: Views SwiftUI e utilitários de timeline para widgets do WidgetKit e Live Activities."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/actions/workflows/ci.yml/badge.svg" alt="Status da CI"></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-platforms-light.svg" alt="Plataformas compatíveis: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-language-light.svg" alt="Versão da linguagem: Swift 6.0+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-license-light.svg" alt="Licença: MIT"></picture></a>
</p>

<p align="center">
<a href="#início-rápido"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-start-pt-BR-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-start-pt-BR-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-start-pt-BR-light.svg" alt="Começar"></picture></a>
<a href="https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-docs-pt-BR-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-docs-pt-BR-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-docs-pt-BR-light.svg" alt="Documentação"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-examples-pt-BR-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-examples-pt-BR-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-examples-pt-BR-light.svg" alt="Exemplos"></picture></a>
</p>

> Esta é uma tradução do README em inglês. Se houver diferença, vale a versão em inglês.

<!-- brand:end -->

WidgetDevelopmentKit é um pacote Swift para quem cria widgets para apps iOS. Ele traz views
SwiftUI prontas para widgets da Tela de Início, da Tela Bloqueada e do StandBy, views de
gráficos no tamanho de um widget, utilitários para timelines e para os dados que o app
compartilha com o widget, App Intents para os botões dos widgets, além de atributos e views do
ActivityKit para Live Activities. Você continua escrevendo a extensão de widget; o pacote
poupa o trabalho das views e da lógica de datas, armazenamento e novas tentativas de que todo
widget precisa.

## Destaques

- **20 modelos para a Tela de Início** — clima, estatísticas, finanças, calendário, contagem
  regressiva, relógio, notas, citação, música, podcast, notícias, anéis de atividade,
  acompanhamento de hábitos, tarefas, água, bateria e mais.
- **Tela Bloqueada e StandBy** — 15 views de acessório (circular, retangular, em linha) e 7
  views de StandBy.
- **Utilitários de timeline** — datas das entradas, políticas de recarga e um armazenamento de
  snapshots com validade, para que o widget leia o que o app salvou por meio de um App Group.
- **Widgets interativos** — 5 App Intents e 8 views com botões que os executam.
- **Live Activities** — 10 tipos de `ActivityAttributes` com views para a Tela Bloqueada e a
  Dynamic Island compacta, e uma máquina de estados que rejeita atualizações fora de ordem.
- **Lógica testada** — o código de datas, números e novas tentativas é coberto por testes do
  Swift Testing, incluindo casos extremos como `NaN`, metas iguais a zero e dias de mudança de
  horário de verão.

## Início rápido

**1. Adicione o pacote**

Seu app precisa de uma extensão de widget. Se ainda não tiver uma, escolha **File › New ›
Target…** no Xcode e selecione **Widget Extension**. Depois escolha **File › Add Package
Dependencies…**, cole esta URL no campo de busca no canto superior direito e clique em **Add
Package**:

```text
https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git
```

Na janela seguinte, defina **Add to Target** de `WidgetDevelopmentKit` como sua extensão de
widget e clique em **Add Package**.

**2. Importe o módulo**

No início de um arquivo Swift da extensão de widget:

```swift
import WidgetDevelopmentKit
```

**3. Use**

Adicione este widget à extensão. Ele faz uma contagem regressiva até uma data com a view
`CountdownWidget` do pacote. Em seguida, inclua `LaunchCountdownWidget()` no `WidgetBundle` da
extensão, o tipo marcado com `@main`.

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

Execute o app em um simulador de iPhone. Na Tela de Início, toque e segure uma área vazia,
toque em **Edit › Add Widget**, encontre seu app e adicione **Countdown**. O mesmo código está
em [`Examples/WidgetKitExample`](Examples/WidgetKitExample/Widgets/LaunchCountdownWidget.swift).

## Instalação

### Swift Package Manager

No Xcode, escolha **File › Add Package Dependencies…** e informe a URL do repositório:

```text
https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git
```

Ou adicione-o às `dependencies` do seu `Package.swift`:

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

A única tag, `v1.0.0`, é anterior ao código atual e não compila; use `main` até a próxima
versão com tag. O pacote não tem dependências de terceiros.

## Uso

Todos os exemplos em Swift desta seção vêm de
[`Examples/WidgetKitExample`](Examples/WidgetKitExample), que a CI compila, ou de
[`ReadmeExamplesTests.swift`](Tests/WidgetDevelopmentKitTests/ReadmeExamplesTests.swift), que é
compilado com os testes. Um teste falha se um bloco daqui deixar de corresponder a esse código.

### Ler dados compartilhados em um provedor de timeline

`TimelineSchedule` gera as datas das entradas, `TimelineBuilder` ordena as entradas e converte
uma `WidgetUpdatePolicy` na política de recarga do WidgetKit, e `WidgetSnapshotStore` lê o que
o app salvou no App Group compartilhado.

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

### Salvar dados no app

O app grava o valor com um prazo de validade e pede ao WidgetKit que recarregue o widget:

```swift
try store.save(steps, forKey: "steps", lifetime: 30 * 60)
WidgetCenter.shared.reloadTimelines(ofKind: "steps")
```

Adicione a capability **App Groups** ao app e à extensão com o mesmo identificador. O
armazenamento usa `UserDefaults`, que não é criptografado; não guarde segredos nele.

### Mostrar uma entrada

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

Views que mostram valores que dependem do tempo (`CountdownWidget`, `StandByCountdownWidget`,
`LockScreenCountdownWidget`) recebem um `referenceDate`; passe `entry.date` para que cada
entrada mostre o próprio momento.

### Adicionar um botão a um widget

```swift
struct WaterButton: View {
    var body: some View {
        Button(intent: IncrementIntent(counterId: "water", amount: 250)) {
            Label("+250 ml", systemImage: "drop.fill")
        }
    }
}
```

Os intents rodam na extensão de widget e gravam em `WidgetStateStore.shared`, que usa o App
Group indicado na chave `WidgetDevelopmentKitAppGroup` do Info.plist. Adicione a chave ao app e
à extensão e registre os intents do pacote:

```swift
struct AppIntentsRoot: AppIntentsPackage {
    static var includedPackages: [any AppIntentsPackage.Type] {
        [WidgetDevelopmentKitIntents.self]
    }
}
```

### Carregar dados de um servidor

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

`WidgetDataLoader` usa uma sessão efêmera com tempos limite curtos, que não espera haver
conexão. Ele tenta de novo respostas 5xx e 408, tempos limite esgotados e erros de falta de
conexão (uma vez por padrão; defina uma `RetryPolicy` para mudar isso), mas não respostas 4xx
nem erros de decodificação.

## Demonstração

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/images/home-screen-dark.png">
  <img src="docs/images/home-screen-light.png" alt="Widgets de clima, água, atividade física, contagem regressiva, citação e hábitos desenhados com o pacote" width="404">
</picture>
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/images/charts-dark.png">
  <img src="docs/images/charts-light.png" alt="Views de estatísticas com minigráfico, anel de progresso, gráfico de linhas e gráfico de barras" width="404">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/images/lock-screen-dark.png">
  <img src="docs/images/lock-screen-light.png" alt="Widgets da Tela Bloqueada de bateria, anéis de atividade, contagem regressiva, clima e estatísticas" width="304">
</picture>

As imagens são desenhadas a partir das views do pacote com `ImageRenderer` por
[`scripts/render-screenshots.sh`](scripts/render-screenshots.sh). Como são desenhadas fora do
WidgetKit, a moldura do widget, a vibrância da Tela Bloqueada e o modo noturno do StandBy são
aproximações, e não produzidos pelo sistema.

Para testar os widgets, abra
[`Examples/WidgetKitExample/WidgetKitExample.xcodeproj`](Examples/WidgetKitExample) e execute
o esquema **WidgetKitExample** em um simulador de iPhone;
[`Examples/README.md`](Examples/README.md) explica os três widgets e como adicioná-los à Tela
de Início.

## Documentação

Referência da API e artigos:

- [Referência da API](https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/)
  no GitHub Pages, gerada a partir dos comentários DocC do código-fonte.
- No Xcode: **Product › Build Documentation**, ou
  `xcodebuild docbuild -scheme WidgetDevelopmentKit -destination 'generic/platform=iOS Simulator'`.

## Guias

- [Getting Started](https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/gettingstarted):
  adicionar uma extensão de widget e o pacote, compartilhar dados por um App Group, montar a
  timeline e desenhar uma entrada.
- [Interactive Widgets](https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/interactivewidgets):
  configurar o App Group, registrar os intents, adicionar botões e ler o estado deles no
  provedor e no app.

## Requisitos

| Plataforma  | Versão mínima |
| ----------- | ------------- |
| iOS         | 17.0          |
| macOS       | 14.0          |
| Ferramentas | Swift 6.0     |

As views da Tela Bloqueada e as Live Activities existem apenas no iOS. O alvo macOS existe
para que o código independente de plataforma e seus testes rodem com `swift test`. A CI compila
com o Xcode padrão da imagem `macos-26` do GitHub; o desenvolvimento local usa o Xcode 27.
Versões mais antigas do Xcode não foram testadas.

## Arquitetura

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

As views são enxutas: cálculos que podem dar errado com dados reais (metas iguais a zero,
`NaN`, intervalos de datas invertidos, dias de mudança de horário de verão) ficam em `Core` e
`Timeline` como funções puras com testes unitários. Tipos que acessam armazenamento ou rede
recebem suas dependências (`UserDefaults`, relógio, transporte, espera) como parâmetros, então
podem ser testados sem um App Group ou um servidor. Os corpos das views SwiftUI não têm testes
de snapshot.

Execute os testes no macOS e em um simulador iOS:

```sh
swift test
xcodebuild test -scheme WidgetDevelopmentKit -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

Três testes de iOS são pulados de propósito: eles desenham as imagens do README e só rodam por
meio de `scripts/render-screenshots.sh`.

## Roteiro

- Criar a tag de uma versão que corresponda ao código atual, para que o pacote possa ser
  adicionado por versão.
- Testes de snapshot para os corpos das views.
- Uma Live Activity de exemplo no app de exemplo.

O [CHANGELOG](CHANGELOG.md) registra o que mudou até agora, incluindo como o pacote foi
restaurado em outubro de 2026, depois que se descobriu que o código da `v1.0.0` não compilava.

## Como contribuir

Contribuições são bem-vindas. Leia o [guia de contribuição](https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/CONTRIBUTING.md) e o [código de conduta](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md) antes de abrir um pull request. Relate problemas de segurança de forma privada, como descrito na [política de segurança](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md).

## Licença

Publicado sob a licença MIT. Veja [LICENSE](LICENSE).
