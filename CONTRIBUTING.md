# Contributing

Thanks for your interest in improving WidgetDevelopmentKit.

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

## Guidelines

- Keep views thin. Put arithmetic and parsing in pure functions and add tests for them,
  including edge cases (zero, negative, `NaN`, empty collections, DST and locale differences).
- Inject dependencies such as `UserDefaults`, clocks and network transports so code can be
  tested without an App Group or a server.
- Document public API with DocC comments. `xcodebuild docbuild` should report no warnings.
- If you change a view shown in the README, regenerate the images with
  `scripts/render-screenshots.sh`.
- Use [Conventional Commits](https://www.conventionalcommits.org/) (`feat:`, `fix:`, `docs:`,
  `test:`, `refactor:`, `ci:`, `chore:`).

## Pull requests

1. Create a branch from `main`.
2. Make the change with tests.
3. Make sure CI passes (macOS tests, iOS simulator tests and the documentation build).
4. Describe what changed and why in the pull request.
