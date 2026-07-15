---
phase: 5
title: "Release CI: Signing, iOS Lane, Fidelity Baseline"
status: pending
priority: P1
effort: "1 tuần"
dependencies: []
---

# Phase 5: Release CI — Signing, iOS Lane, Fidelity Baseline

## Context

- PR CI đã tốt (gen-l10n, format, analyze, tests, debug APK, Gitleaks, SBOM,
  OSV). Release Gradle fail-closed không keystore (verified local).
- CHƯA có: signed AAB/IPA job, artifact secret scan trên bản signed, iOS lane,
  fidelity/golden pipeline. Chưa có green signed build nào tồn tại.

## Requirements

1. **Signed Android release job** (`.github/workflows/`, workflow riêng
   `android-release.yml`, trigger tag/manual):
   - Keystore + credentials qua GitHub protected environment secrets (owner
     cung cấp); KHÔNG commit keystore.
   - Build `flutter build appbundle --release`; giữ fail-closed khi thiếu secret.
   - Chạy `scripts/check-mobile-secrets.sh` + marker scan trên artifact signed
     (đóng gap "signed-artifact secret scan" của cross-cutting Phase 1).
   - Upload artifact + checksum/provenance (SLSA attestation nếu sẵn có).
2. **iOS lane tối thiểu** (macos runner): `flutter build ios --release
   --no-codesign` + analyze/test — chứng minh compile iOS trong CI trước, ký
   thật để sau khi có cert (ghi Unresolved ở plan.md).
3. **Fidelity/golden baseline**:
   - Bắt đầu bằng Flutter golden tests (`test/goldens/`) cho các widget release
     chính: home dashboard, deck card, exam question chrome, flashcard, error
     view — chuẩn hoá font/kích thước để deterministic.
   - CI gate so golden; script update golden có chủ đích
     (`scripts/update-goldens.sh`).
   - Pipeline Playwright-web → Flutter capture → odiff so với web reference:
     dựng khung `tools/fidelity/` + 3 màn đầu (home, deck, exam) làm mẫu; mở
     rộng ở GĐ2 plan phase 4.

## Validation

- Một signed AAB xanh từ CI với secret scan pass — ghi verification report vào
  cross-cutting reports/.
- iOS no-codesign build xanh trên CI.
- Golden gate chạy trong PR CI, fail khi diff không chủ đích.

## Risks

- Golden tests dễ flake theo font/platform — pin fonts, chạy trên cùng runner
  image; nếu flake >2 lần, chuyển golden sang tolerance-based diff.
- macOS runner tốn phút CI — giới hạn iOS lane ở main/tag.
