<!-- i18n-source: README.md@21d649e6f03399b9ae6f8c248f63c32d4a134aab status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/banner-es-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/banner-es-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/banner-es-light.svg" alt="iOS Widget Development Kit: Vistas SwiftUI y utilidades de línea de tiempo para widgets de WidgetKit y Live Activities."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/actions/workflows/ci.yml/badge.svg" alt="Estado de CI"></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-platforms-light.svg" alt="Plataformas compatibles: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-language-light.svg" alt="Versión del lenguaje: Swift 6.0+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/badge-license-light.svg" alt="Licencia: MIT"></picture></a>
</p>

<p align="center">
<a href="#inicio-rápido"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-start-es-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-start-es-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-start-es-light.svg" alt="Empezar"></picture></a>
<a href="https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-docs-es-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-docs-es-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-docs-es-light.svg" alt="Documentación"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Widget-Development-Kit/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-examples-es-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-examples-es-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Widget-Development-Kit/main/.github/brand/button-examples-es-light.svg" alt="Ejemplos"></picture></a>
</p>

> Esta es una traducción del README en inglés. Si hay diferencias, la versión en inglés es la vigente.

<!-- brand:end -->

WidgetDevelopmentKit es un paquete Swift para quienes crean widgets para sus apps de iOS.
Incluye vistas SwiftUI listas para usar en widgets de la pantalla de inicio, la pantalla
bloqueada y StandBy, vistas de gráficos adaptadas al tamaño de un widget, utilidades para las
líneas de tiempo y para los datos que la app comparte con su widget, App Intents para los
botones de los widgets, y atributos y vistas de ActivityKit para Live Activities. La extensión
de widgets la sigues escribiendo tú; el paquete te ahorra las vistas y la lógica de fechas,
almacenamiento y reintentos que necesita cualquier widget.

## Lo más destacado

- **20 plantillas para la pantalla de inicio**: tiempo, estadísticas, finanzas, calendario,
  cuenta atrás, reloj, notas, citas, música, pódcast, noticias, anillos de actividad física,
  seguimiento de hábitos, tareas, agua, batería y más.
- **Pantalla bloqueada y StandBy**: 15 vistas accesorias (circular, rectangular, en línea) y 7
  vistas de StandBy.
- **Utilidades de línea de tiempo**: fechas de las entradas, políticas de recarga y un almacén
  de instantáneas con caducidad, para que el widget lea lo que la app guardó a través de un
  App Group.
- **Widgets interactivos**: 5 App Intents y 8 vistas con botones que los ejecutan.
- **Live Activities**: 10 tipos de `ActivityAttributes` con vistas para la pantalla bloqueada y
  la Dynamic Island compacta, y una máquina de estados que rechaza las actualizaciones que
  llegan desordenadas.
- **Lógica con pruebas**: el código de fechas, números y reintentos está cubierto por pruebas
  de Swift Testing, incluidos casos límite como `NaN`, objetivos de cero y los días de cambio
  de horario.

## Inicio rápido

**1. Añade el paquete**

Tu app necesita una extensión de widgets. Si todavía no tiene una, elige **File › New ›
Target…** en Xcode y selecciona **Widget Extension**. Después elige **File › Add Package
Dependencies…**, pega esta URL en el campo de búsqueda de la esquina superior derecha y pulsa
**Add Package**:

```text
https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git
```

En el siguiente cuadro de diálogo, en la columna **Add to Target** de `WidgetDevelopmentKit`
elige tu extensión de widgets y pulsa **Add Package**.

**2. Importa el módulo**

Al principio de un archivo Swift de la extensión de widgets:

```swift
import WidgetDevelopmentKit
```

**3. Úsalo**

Añade este widget a la extensión. Muestra una cuenta atrás hasta una fecha con la vista
`CountdownWidget` del paquete. Después incluye `LaunchCountdownWidget()` en el `WidgetBundle`
de la extensión, el tipo marcado con `@main`.

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

Ejecuta la app en un simulador de iPhone. En la pantalla de inicio, mantén pulsada una zona
vacía, toca **Edit › Add Widget**, busca tu app y añade **Countdown**. El mismo código está en
[`Examples/WidgetKitExample`](Examples/WidgetKitExample/Widgets/LaunchCountdownWidget.swift).

## Instalación

### Swift Package Manager

En Xcode, elige **File › Add Package Dependencies…** e introduce la URL del repositorio:

```text
https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git
```

O añádelo a las `dependencies` de tu `Package.swift`:

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

La única etiqueta, `v1.0.0`, es anterior al código actual y no compila; usa `main` hasta la
próxima versión etiquetada. El paquete no tiene dependencias de terceros.

## Uso

Todos los ejemplos de Swift de esta sección salen de
[`Examples/WidgetKitExample`](Examples/WidgetKitExample), que CI compila, o de
[`ReadmeExamplesTests.swift`](Tests/WidgetDevelopmentKitTests/ReadmeExamplesTests.swift), que
se compila con las pruebas. Si un bloque de aquí deja de coincidir con ese código, falla una
prueba.

### Leer datos compartidos en un proveedor de línea de tiempo

`TimelineSchedule` genera las fechas de las entradas, `TimelineBuilder` ordena las entradas y
convierte una `WidgetUpdatePolicy` en la política de recarga de WidgetKit, y
`WidgetSnapshotStore` lee lo que la app guardó en el App Group compartido.

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

### Guardar datos en la app

La app escribe el valor con un tiempo de validez y pide a WidgetKit que recargue el widget:

```swift
try store.save(steps, forKey: "steps", lifetime: 30 * 60)
WidgetCenter.shared.reloadTimelines(ofKind: "steps")
```

Añade la capacidad **App Groups** a la app y a la extensión con el mismo identificador. El
almacén usa `UserDefaults`, que no está cifrado, así que no guardes en él datos secretos.

### Mostrar una entrada

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

Las vistas que muestran valores que dependen del tiempo (`CountdownWidget`,
`StandByCountdownWidget`, `LockScreenCountdownWidget`) reciben un `referenceDate`; pasa
`entry.date` para que cada entrada muestre su propio momento.

### Añadir un botón a un widget

```swift
struct WaterButton: View {
    var body: some View {
        Button(intent: IncrementIntent(counterId: "water", amount: 250)) {
            Label("+250 ml", systemImage: "drop.fill")
        }
    }
}
```

Los intents se ejecutan en la extensión de widgets y escriben en `WidgetStateStore.shared`,
que usa el App Group indicado en la clave `WidgetDevelopmentKitAppGroup` de Info.plist. Añade
la clave tanto a la app como a la extensión y registra los intents del paquete:

```swift
struct AppIntentsRoot: AppIntentsPackage {
    static var includedPackages: [any AppIntentsPackage.Type] {
        [WidgetDevelopmentKitIntents.self]
    }
}
```

### Cargar datos de un servidor

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

`WidgetDataLoader` usa una sesión efímera con tiempos de espera cortos que no espera a que haya
conexión. Reintenta las respuestas 5xx y 408, los tiempos de espera agotados y los errores sin
conexión (una vez por defecto; configura una `RetryPolicy` para cambiarlo), pero no las
respuestas 4xx ni los errores de decodificación.

## Demo

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/images/home-screen-dark.png">
  <img src="docs/images/home-screen-light.png" alt="Widgets de tiempo, agua, actividad física, cuenta atrás, cita y hábitos dibujados con el paquete" width="404">
</picture>
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/images/charts-dark.png">
  <img src="docs/images/charts-light.png" alt="Vistas de estadísticas con minigráfico, anillo de progreso, gráfico de líneas y gráfico de barras" width="404">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/images/lock-screen-dark.png">
  <img src="docs/images/lock-screen-light.png" alt="Widgets de la pantalla bloqueada de batería, anillos de actividad, cuenta atrás, tiempo y estadísticas" width="304">
</picture>

Las imágenes se dibujan a partir de las vistas del paquete con `ImageRenderer` mediante
[`scripts/render-screenshots.sh`](scripts/render-screenshots.sh). Como se dibujan fuera de
WidgetKit, el marco del widget, la vibrancia de la pantalla bloqueada y el modo nocturno de
StandBy son una aproximación y no los genera el sistema.

Para probar los widgets, abre
[`Examples/WidgetKitExample/WidgetKitExample.xcodeproj`](Examples/WidgetKitExample) y ejecuta
el esquema **WidgetKitExample** en un simulador de iPhone;
[`Examples/README.md`](Examples/README.md) explica los tres widgets y cómo añadirlos a la
pantalla de inicio.

## Documentación

Referencia de la API y artículos:

- [Referencia de la API](https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/)
  en GitHub Pages, generada a partir de los comentarios DocC del código.
- En Xcode: **Product › Build Documentation**, o
  `xcodebuild docbuild -scheme WidgetDevelopmentKit -destination 'generic/platform=iOS Simulator'`.

## Guías

- [Getting Started](https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/gettingstarted):
  añadir una extensión de widgets y el paquete, compartir datos mediante un App Group, crear la
  línea de tiempo y dibujar una entrada.
- [Interactive Widgets](https://muhittincamdali.github.io/iOS-Widget-Development-Kit/documentation/widgetdevelopmentkit/interactivewidgets):
  configurar el App Group, registrar los intents, añadir botones y leer su estado en el
  proveedor y en la app.

## Requisitos

| Plataforma   | Versión mínima |
| ------------ | -------------- |
| iOS          | 17.0           |
| macOS        | 14.0           |
| Herramientas | Swift 6.0      |

Las vistas de la pantalla bloqueada y las Live Activities solo existen en iOS. El destino de
macOS está para que el código independiente de la plataforma y sus pruebas se ejecuten con
`swift test`. CI compila con el Xcode predeterminado de la imagen `macos-26` de GitHub; el
desarrollo local usa Xcode 27. No se han probado versiones anteriores de Xcode.

## Arquitectura

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

Las vistas son finas: los cálculos que pueden fallar con datos reales (objetivos de cero,
`NaN`, rangos de fechas invertidos, días de cambio de horario) están en `Core` y `Timeline` como
funciones puras con pruebas unitarias. Los tipos que acceden al almacenamiento o a la red
reciben sus dependencias (`UserDefaults`, reloj, transporte, espera) como parámetros, así que se
pueden probar sin un App Group ni un servidor. Los cuerpos de las vistas SwiftUI no tienen
pruebas de instantáneas.

Ejecuta las pruebas en macOS y en un simulador de iOS:

```sh
swift test
xcodebuild test -scheme WidgetDevelopmentKit -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

Tres pruebas de iOS se omiten a propósito: dibujan las imágenes del README y solo se ejecutan
mediante `scripts/render-screenshots.sh`.

## Hoja de ruta

- Etiquetar una versión que corresponda al código actual, para poder añadir el paquete por
  versión.
- Pruebas de instantáneas para los cuerpos de las vistas.
- Una Live Activity de ejemplo en la app de ejemplo.

El [CHANGELOG](CHANGELOG.md) recoge los cambios hasta ahora, incluido cómo se restauró el
paquete en octubre de 2026 después de comprobar que el código de `v1.0.0` no compilaba.

## Contribuir

Las contribuciones son bienvenidas. Lee la [guía de contribución](https://github.com/muhittincamdali/iOS-Widget-Development-Kit/blob/main/CONTRIBUTING.md) y el [código de conducta](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md) antes de abrir una pull request. Informa de los problemas de seguridad de forma privada, como se describe en la [política de seguridad](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md).

## Licencia

Publicado bajo la licencia MIT. Consulta [LICENSE](LICENSE).
