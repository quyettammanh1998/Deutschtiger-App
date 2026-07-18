#!/usr/bin/env bash
# Run the Android integration test(s) locally against a connected device,
# replacing the slow emulator job that CI now runs only on pull requests.
#
# Auto-detects the first ready device (real phone via USB/Tailscale-adb, or a
# running emulator) so you don't hardcode a serial that changes each restart.
#
# Usage:
#   scripts/flutter-integration-local.sh [test-target] [-- extra flutter args]
#     test-target  Integration test file/dir (default: integration_test/)
#
# Examples:
#   scripts/flutter-integration-local.sh
#   scripts/flutter-integration-local.sh integration_test/welcome_flow_test.dart
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root_dir"

target="${1:-integration_test/}"
[[ $# -gt 0 ]] && shift || true
# Anything after `--` is forwarded verbatim to `flutter test`.
extra_args=()
if [[ "${1:-}" == "--" ]]; then
  shift
  extra_args=("$@")
fi

step() { printf '\n\033[1;34m▶ %s\033[0m\n' "$1"; }
fail() { printf '\033[1;31m✗ %s\033[0m\n' "$1" >&2; exit 1; }

command -v flutter >/dev/null || fail "flutter not on PATH"
command -v adb >/dev/null || fail "adb not on PATH (install Android platform-tools)"

step "Detecting a connected Android device"
# Android-only on purpose: this is an Android integration test, so we detect via
# adb (real phone or emulator) and never fall back to desktop/web Flutter devices
# — which the app's mobile-only plugins can't build for anyway.
# Pick the first serial in 'device' state; skips 'offline'/'unauthorized'.
device="$(adb devices | awk 'NR>1 && $2=="device" {print $1; exit}')"

if [[ -z "$device" ]]; then
  fail "No ready Android device found.
  - USB: plug the phone in and enable USB debugging.
  - Wireless (Redmi via Tailscale): connect adb first, e.g. run the '/dev' helper,
    then re-run this script.
  - Check state with: adb devices"
fi
echo "Using device: $device"

step "flutter pub get"
flutter pub get

step "flutter test $target -d $device"
flutter test "$target" -d "$device" -r compact "${extra_args[@]}"

printf '\n\033[1;32m✓ integration test passed on %s\033[0m\n' "$device"
