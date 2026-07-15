# Verification — 2026-07-15 — supply-chain CI gates

## Summary

Added two Phase 4 gates:

- the Flutter quality workflow emits a source SPDX JSON SBOM after the debug
  APK and mobile marker/history scan; and
- the separate OSV workflow blocks new dependency vulnerabilities on PRs and
  full known vulnerabilities on `main` pushes and a weekly schedule.

The Flutter workflow stays read-only. The OSV workflow has only the additional
`security-events: write` permission needed to upload SARIF findings.

## Verification log

| Test | Expected | Actual | Status |
|---|---|---|---|
| `actionlint` for both workflows | valid GitHub Actions syntax and expressions | passed | ✅ |
| OSV source scan of `pubspec.lock` | detect Flutter/Dart lockfile and report known advisories | 221 packages scanned; `No issues found` | ✅ |
| Syft SPDX generation on repository | recognize Dart pub dependencies for SBOM | 222 `pkg:pub/` components found | ✅ |
| `git diff --check` | no whitespace errors | passed | ✅ |

## Findings

OSV officially supports Dart `pubspec.lock`, and the local scanner confirms the
repository lockfile is detected. Syft likewise emits Dart pub components, so
the Anchore action can produce a dependency-bearing SPDX artifact rather than
an empty source inventory.

Hosted GitHub Actions has not run these uncommitted workflows. The SBOM is a
source/dependency artifact; signed AAB/IPA scanning, provenance, and protected
release signing remain separate release gates.

## Unresolved questions

- None for local workflow syntax or lockfile coverage.
