#!/usr/bin/env bash
# Renders the README screenshots into docs/images/ by running the opt-in
# "README screenshots" test suite on an iOS simulator.
#
# Usage: scripts/render-screenshots.sh ["<simulator name>" | <simulator UDID>]
#        DESTINATION='platform=iOS Simulator,id=...' scripts/render-screenshots.sh
#
# If more than one simulator has the same name, xcodebuild refuses to pick one; pass the
# UDID instead (see `xcrun simctl list devices available`).
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
simulator="${1:-iPhone 17 Pro}"
udid_pattern='^[0-9A-Fa-f]{8}-([0-9A-Fa-f]{4}-){3}[0-9A-Fa-f]{12}$'
if [[ -n "${DESTINATION:-}" ]]; then
  destination="$DESTINATION"
elif [[ "$simulator" =~ $udid_pattern ]]; then
  destination="platform=iOS Simulator,id=$simulator"
else
  destination="platform=iOS Simulator,name=$simulator"
fi
output_dir="$repo_root/docs/images"
derived_data="$(mktemp -d)"
trap 'rm -rf "$derived_data"' EXIT

mkdir -p "$output_dir"
cd "$repo_root"

# xcodebuild forwards TEST_RUNNER_-prefixed variables to the test process.
TEST_RUNNER_WDK_SCREENSHOT_DIR="$output_dir" xcodebuild test \
  -scheme WidgetDevelopmentKit \
  -destination "$destination" \
  -derivedDataPath "$derived_data" \
  -only-testing:WidgetDevelopmentKitTests/ScreenshotRenderer \
  -quiet

ls -1 "$output_dir"
