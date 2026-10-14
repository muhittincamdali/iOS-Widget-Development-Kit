# Examples

## WidgetKitExample

An iOS app with a widget extension that uses the package from this repository (a local
package reference to `../..`, so it always builds against the code next to it).

| Part                                                                                          | What it shows                                                                              |
| --------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| [`Widgets/LaunchCountdownWidget.swift`](WidgetKitExample/Widgets/LaunchCountdownWidget.swift) | The smallest widget: `TimelineSchedule` for the entry dates and the `CountdownWidget` view |
| [`Shared/Steps.swift`](WidgetKitExample/Shared/Steps.swift)                                   | A provider that reads `WidgetSnapshotStore` and builds the timeline with `TimelineBuilder` |
| [`Widgets/WaterWidget.swift`](WidgetKitExample/Widgets/WaterWidget.swift)                     | An interactive widget: `InteractiveWaterWidget` and `IncrementIntent`                      |
| [`App/ContentView.swift`](WidgetKitExample/App/ContentView.swift)                             | The app saves data for the widgets and previews the timeline with `WidgetTimelineScrubber` |

### Run it

1. Open `Examples/WidgetKitExample/WidgetKitExample.xcodeproj` in Xcode.
2. Choose the **WidgetKitExample** scheme and an iPhone simulator, then **Product › Run**.
3. On the simulator's Home Screen, touch and hold an empty area, tap **Edit › Add Widget**,
   search for "Widget Kit Example" and add the Countdown, Steps or Water widget.

From the command line:

```sh
xcodebuild build -project Examples/WidgetKitExample/WidgetKitExample.xcodeproj \
  -scheme WidgetKitExample -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO
```

The project is signed to run locally, which is enough for the simulator. To run it on a
device, set your team in **Signing & Capabilities** for both targets and replace the App
Group `group.com.example.widgets` with one your team owns, in the entitlements, in the
`WidgetDevelopmentKitAppGroup` key of both Info.plist files, and in `Steps.swift` and
`ContentView.swift`.

The project is generated from [`project.yml`](WidgetKitExample/project.yml) with
[XcodeGen](https://github.com/yonaskolb/XcodeGen); run `xcodegen generate` in
`Examples/WidgetKitExample` after changing it.
