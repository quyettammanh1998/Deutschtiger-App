---
phase: 3
title: "GĐ1 Live Surfaces: Stats, Grammar, Reading, Listening"
status: pending
priority: P1
effort: "1.5–2 tuần"
dependencies: []
---

# Phase 3: GĐ1 Live Surfaces — Stats, Grammar, Reading, Listening

## Context

- 4 repo còn 100% mock nhưng backend ĐÃ mount route thật (554-route snapshot):
  - Stats: `GET /user/review-stats`, `/user/srs/stats/daily`,
    `/user/flashcard-reviews/stats`, `/user/flashcards/stats`
  - Grammar: `GET /grammar`, `/grammar/{level}/{id}`, `/user/grammar-progress`,
    `/user/grammar-map`, `/user/grammar-rank` (đã có
    `verification-2026-07-15-grammar-contract-probe.md`)
  - Reading: `GET /reading-feed`, `/user/reading-progress`, `/user/reading-rank`
  - Listening/Podcast: `GET/HEAD /listening/podcast/easy_german/audio/{slug}`,
    `/user/podcast-progress`, `/user/podcast-rank`
- Tất cả đang gated off qua `lib/core/release/release_feature_flags.dart`
  (default false) + `release_redirect.dart` + CI live-data guard.
- Social, speaking, journey, ai, ai_tutor, affiliate, legacy-goethe KHÔNG
  thuộc phase này — giữ gated cho GĐ2.

## Requirements (lặp cho từng surface, thứ tự: Grammar → Stats → Reading → Listening)

1. Contract trước code: ghi endpoint + response shape thực (probe bằng curl
   hoặc Go handler source) vào `docs/flutter-api-contract-matrix.md` +
   `docs/api-changelog.md`.
2. Thay mock repo bằng ApiClient implementation:
   - `lib/repositories/stats/stats_repository.dart`
   - (grammar hiện đọc từ đâu — kiểm tra `lib/screens/grammar/grammar_screen.dart`
     provider; tạo `lib/repositories/grammar/` nếu chưa có)
   - `lib/repositories/listening/podcast_repository.dart` (+ xoá
     `lib/repositories/listening/mock_data.dart` khi hết reference)
   - Reading providers trong `lib/screens/reading/`
   - DTO vào `lib/data/<domain>/` theo cấu trúc hiện tại, freezed nếu các model
     lân cận dùng freezed.
3. Empty/error/offline states thật (theo pattern ErrorView + connectivity
   banner hiện có), loading skeleton giữ nguyên.
4. L10n: string mới vào ARB vi/en/de; widget test German 200%.
5. Bật flag: đổi default flag của surface sang on cho release CHỈ sau khi
   contract test + live-data guard xanh; cập nhật
   `docs/flutter-live-data-inventory.md` phân loại route.
6. Audio podcast: stream qua ApiClient auth header; KHÔNG background playback
   (scope GĐ2 media plan).

## Per-surface acceptance

- [ ] Grammar live + flag on
- [ ] Stats live + flag on
- [ ] Reading live + flag on
- [ ] Listening/podcast live + flag on (foreground playback)

## Validation

- Contract test per repo (theo mẫu `test/repositories/phase_1_contract_test.dart`).
- `flutter test` + release live-data guard xanh sau khi flag on.
- Emulator smoke từng surface với backend local.

## Risks

- Response shape backend có thể khác giả định — probe trước, không code theo
  mock model.
- Nếu một surface thiếu endpoint (vd reading detail content), ghi vào
  api-changelog như gap và giữ flag off thay vì độn fixture.
