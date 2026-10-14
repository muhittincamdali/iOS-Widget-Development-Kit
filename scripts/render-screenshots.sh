#!/usr/bin/env bash
# Renders the README screenshots into docs/images/ by running the opt-in
# "README screenshots" test suite on an iOS simulator.
#
# Usage: scripts/render-screenshots.sh ["<simulator name>"]
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
simulator="${1:-iPhone 17 Pro}"
output_dir="$repo_root/docs/images"
derived_data="$(mktemp -d)"
trap 'rm -rf "$derived_data"' EXIT

mkdir -p "$output_dir"
cd "$repo_root"

# xcodebuild forwards TEST_RUNNER_-prefixed variables to the test process.
TEST_RUNNER_WDK_SCREENSHOT_DIR="$output_dir" xcodebuild test \
  -scheme WidgetDevelopmentKit \
  -destination "platform=iOS Simulator,name=$simulator" \
  -derivedDataPath "$derived_data" \
  -only-testing:WidgetDevelopmentKitTests/ScreenshotRenderer \
  -quiet

ls -1 "$output_dir"
