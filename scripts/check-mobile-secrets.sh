#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
report_dir="${MOBILE_SECURITY_REPORT_DIR:-$root_dir/build/security}"
cd "$root_dir"

readonly forbidden_markers='DEEPL_API_KEY|api-free\.deepl\.com|DeepL-Auth-Key|OPENAI_API_KEY|SONIOX_API_KEY|AZURE_SPEECH_KEY|SUPABASE_SERVICE_ROLE|sk-[A-Za-z0-9_-]{20,}|AIza[0-9A-Za-z_-]{30,}'
# Compiled artifacts embed Skia engine symbols (sk-commandBuffer, sk-Subgroup*,
# sk-list*Syntax) that collide with the loose sk- OpenAI-key pattern. Drop that
# one alternative for binary scans; a real leaked OpenAI key is still caught in
# source by gitleaks and by the OPENAI_API_KEY marker above.
readonly artifact_forbidden_markers='DEEPL_API_KEY|api-free\.deepl\.com|DeepL-Auth-Key|OPENAI_API_KEY|SONIOX_API_KEY|AZURE_SPEECH_KEY|SUPABASE_SERVICE_ROLE|AIza[0-9A-Za-z_-]{30,}'
readonly source_paths=(lib android ios .env.example pubspec.yaml)

matches="$(grep -rlE --exclude-dir=.dart_tool --exclude-dir=build "$forbidden_markers" "${source_paths[@]}" 2>/dev/null || true)"
if [[ -n "$matches" ]]; then
  echo "Private-provider marker found in a mobile source file:" >&2
  printf '%s\n' "$matches" >&2
  exit 1
fi

mkdir -p "$report_dir"
dart pub deps --json > "$report_dir/dart-dependencies.json"
echo "Source marker scan passed. Dependency report: $report_dir/dart-dependencies.json"

if command -v gitleaks >/dev/null 2>&1; then
  # Git mode covers committed source/history without opening a local ignored
  # `.env` file that can hold developer credentials outside the release tree.
  gitleaks git --no-banner --redact "$root_dir"
else
  echo "WARNING: gitleaks is not installed; only the mobile marker scan ran." >&2
  if [[ "${MOBILE_REQUIRE_GITLEAKS:-0}" == "1" ]]; then
    echo "gitleaks is required for this scan." >&2
    exit 1
  fi
fi

for artifact in "$@"; do
  if [[ ! -f "$artifact" ]]; then
    echo "Artifact does not exist: $artifact" >&2
    exit 1
  fi

  artifact_data="$(mktemp)"
  trap 'rm -f "$artifact_data"' EXIT
  case "$artifact" in
    *.apk|*.aab|*.ipa) unzip -p "$artifact" > "$artifact_data" ;;
    *) cp "$artifact" "$artifact_data" ;;
  esac

  if strings "$artifact_data" | grep -qE "$artifact_forbidden_markers"; then
    echo "Private-provider marker found in artifact: $artifact" >&2
    exit 1
  fi
  rm -f "$artifact_data"
  trap - EXIT
  echo "Artifact marker scan passed: $artifact"
done
