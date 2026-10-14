# Contributing

Thanks for your interest in improving WidgetDevelopmentKit. This file has the steps that are
specific to this package; the general rules (code of conduct, security reports) are in
[muhittincamdali/.github](https://github.com/muhittincamdali/.github).

## Development setup

```sh
git clone https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git
cd iOS-Widget-Development-Kit
swift test
```

Open `Package.swift` in Xcode to work on the views. Lock Screen views and Live Activities
only compile for iOS, so also run the tests on a simulator before opening a pull request:

```sh
xcodebuild test -scheme WidgetDevelopmentKit \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

Build the example app and run SwiftLint as CI does:

```sh
xcodebuild build -project Examples/WidgetKitExample/WidgetKitExample.xcodeproj \
  -scheme WidgetKitExample -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO
swiftlint lint --strict
```

Local development uses Xcode 27; CI uses the default Xcode of GitHub's `macos-26` image.

## Guidelines

- Keep views thin. Put arithmetic and parsing in pure functions and add tests for them,
  including edge cases (zero, negative, `NaN`, empty collections, DST and locale differences).
- Inject dependencies such as `UserDefaults`, clocks and network transports so code can be
  tested without an App Group or a server.
- Document public API with DocC comments. `xcodebuild docbuild` should report no warnings.
- If you change a view shown in the README, regenerate the images with
  `scripts/render-screenshots.sh`.
- Swift code in README.md must come from `Examples/` or
  `Tests/WidgetDevelopmentKitTests/ReadmeExamplesTests.swift`; `ReadmeSyncTests` fails
  otherwise. Change the code there first, then copy it into the README.
- README.md is translated into nine languages. Each `README.<lang>.md` starts with
  `<!-- i18n-source: README.md@<sha> status=reviewed -->`, where `<sha>` is the output of
  `git hash-object README.md` for the English text it follows. After changing README.md,
  update the translations and that SHA; until then the translation check in `quality.yml`
  reports them as behind.
- Use [Conventional Commits](https://www.conventionalcommits.org/) (`feat:`, `fix:`, `docs:`,
  `test:`, `refactor:`, `ci:`, `chore:`).

## Pull requests

1. Create a branch from `main`.
2. Make the change with tests.
3. Make sure CI passes: the CI workflow (macOS tests, iOS builds and simulator tests),
   Documentation, Examples, Lint and Quality (links, wording, translations).
4. Describe what changed and why in the pull request.
