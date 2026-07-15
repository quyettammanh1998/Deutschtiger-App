---
phase: 6
title: "L10n Literal Cleanup + Screen-Reader Smoke"
status: pending
priority: P2
effort: "3–4d"
dependencies: [3]
---

# Phase 6: L10n Literal Cleanup + Screen-Reader Smoke

## Context

- ARB 3 locale (vi/en/de, 438 keys) đã live, các route chính đã migrate với
  German-200% coverage. Cross-cutting Phase 2 tự nhận "foundation, not
  complete": route enabled vẫn còn UI literal, và CHƯA có TalkBack/VoiceOver
  evidence trên thiết bị.

## Requirements

1. **Literal sweep**: viết một lần script/test
   (`test/l10n/no_hardcoded_ui_literals_test.dart` hoặc mở rộng test hiện có)
   quét Text()/label literal trong các screen thuộc release routes (dựa
   `docs/flutter-live-data-inventory.md`); migrate literal còn lại vào ARB
   vi/en/de. Surface mới bật ở Phase 3 nằm trong scope.
2. **Semantics pass** cho flow chính (home, review, exam player, settings):
   `Semantics` labels cho icon-only buttons, focus order hợp lý, announce cho
   state changes (timer, kết quả).
3. **Device smoke**: TalkBack (Android emulator hỗ trợ) đi qua: welcome →
   login → home → daily review 1 thẻ → settings. VoiceOver cần máy iOS thật —
   nếu chưa có, ghi rõ pending trong report thay vì bỏ qua im lặng.
4. Ghi verification report vào
   `plans/260715-flutter-cross-cutting-readiness/reports/` (đóng open item
   Phase 2 của plan đó).

## Validation

- Literal-sweep test xanh và chạy trong CI.
- 3 ARB files giữ key parity (tooling hiện có).
- TalkBack smoke có ghi chú từng bước + issue list.

## Risks

- Literal scan dễ false-positive (debug strings, semantic-only text) — cho
  phép allowlist có chú thích thay vì tắt rule.
