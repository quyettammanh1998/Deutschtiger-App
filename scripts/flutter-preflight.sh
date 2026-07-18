#!/usr/bin/env bash
# Local pre-PR quality gate. Mirrors .github/workflows/flutter-ci.yml "quality"
# job so a PR passes CI on the first push. Run from a worktree before shipping.
#
# Usage: scripts/flutter-preflight.sh [base-ref]
#   base-ref  Ref to diff against for "changed Dart files" (default: origin/main)
#
# Skips the heavy `flutter build apk` (CI covers it) to respect local RAM/disk.
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root_dir"

base_ref="${1:-origin/main}"

step() { printf '\n\033[1;34m▶ %s\033[0m\n' "$1"; }

step "flutter pub get"
flutter pub get

step "flutter gen-l10n (verify lib/l10n committed)"
flutter gen-l10n
if ! git diff --quiet -- lib/l10n; then
  echo "✗ Generated l10n differs from committed copy." >&2
  echo "  Regenerated files are on disk — stage & commit them, then re-run:" >&2
  git --no-pager diff --stat -- lib/l10n >&2
  exit 1
fi

step "dart format (changed .dart files)"
# Diff against the merge-base with base_ref; only changed, still-present files.
mapfile -t changed_dart < <(git diff --name-only --diff-filter=d "${base_ref}...HEAD" -- '*.dart' 2>/dev/null || true)
if [[ ${#changed_dart[@]} -gt 0 ]]; then
  dart format --set-exit-if-changed "${changed_dart[@]}"
else
  echo "(no changed .dart files vs ${base_ref})"
fi

step "flutter analyze"
flutter analyze

step "flutter test"
flutter test

printf '\n\033[1;32m✓ preflight passed — safe to push & open PR\033[0m\n'
