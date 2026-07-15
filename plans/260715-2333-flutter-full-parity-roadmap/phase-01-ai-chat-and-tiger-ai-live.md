---
phase: 1
title: "AI Chat + Tiger AI Live (SSE)"
status: done-with-concerns
priority: P1
effort: "1–1.5 tuần"
dependencies: []
---

> Implementation report: `reports/dev-260716-ai-chat-sse-live-report.md`. Chat/
> sessions/memory/profile live; image input and writing-practice grading are
> documented gaps (see `docs/api-changelog.md`).

# Phase 1: AI Chat + Tiger AI Live (SSE)

## Context

- Web: AI chat streaming SSE với image input, sessions, memory, profile.
  Endpoints: `/ai/chat` (SSE), `/ai/chat-status`, `/ai/sessions`, `/ai/memory`,
  `/ai/profile`. Backend gateway LLM (CLI proxy → DeepSeek fallback), ~28
  route `/api/v1/ai/*` đã mount.
- Flutter: `lib/repositories/ai/ai_repository.dart` + `ai_tutor_repository.dart`
  100% mock, màn `lib/screens/ai/` (3) + `ai_tutor/` gated off
  (`aiTutor` flag). Web coi Tiger AI FAB là thành phần shell chính.

## Requirements

1. **SSE streaming client dùng chung** — `lib/services/api/sse_client.dart`:
   parse `text/event-stream` qua Dio/http streaming, bearer auth từ ApiClient,
   cancel + reconnect, backpressure cho UI token-by-token. Đây là hạ tầng cho
   cả sprechen-partner (MASTER P8) và grading (GĐ2 P2) — viết một lần.
2. **AI chat live**: thay mock `ai_repository` — gửi message (text + image
   attachment nếu backend hỗ trợ multipart), stream response, list/resume
   sessions, error/rate-limit states. Probe schema `/ai/chat` request/response
   trước (web `src/pages/ai/` + `hooks` là spec hành vi).
3. **Memory + profile**: màn AI settings đọc/ghi `/ai/memory`, `/ai/profile`
   (web Settings → AI Memory là spec); wire vào `lib/screens/ai/ai_settings_page.dart`.
4. **Hợp nhất ai vs ai_tutor**: hiện có 2 nhóm màn (`screens/ai/`,
   `screens/ai_tutor/`) cùng mục đích. Chọn một surface theo web (Tiger AI
   chat), migrate màn còn dùng, xoá nhóm thừa — tránh 2 mock repo song song.
5. Bật `aiTutor`/`ai` flag default-on sau khi contract test + live-data guard
   xanh; cập nhật live-data inventory + parity matrix.

## Files

- Create: `lib/services/api/sse_client.dart`, `lib/repositories/ai/` live impl,
  DTO `lib/data/ai/`.
- Modify: `lib/screens/ai/ai_chat_page.dart`, `ai_settings_page.dart`,
  `lib/core/release/release_feature_flags.dart`, router redirect list.
- Delete (sau migrate): mock `lib/repositories/ai/mock_data.dart`,
  `ai_tutor` trùng lặp.

## Validation

- Unit test SSE parser (chunk split giữa event, reconnect, cancel).
- Contract test repo; widget test chat states (streaming, error, retry).
- Emulator smoke với backend local + LLM gateway; nếu gateway không có local,
  ghi evidence bằng staging và note rate limit.

## Risks

- SSE qua proxy/mobile network có thể bị buffer — test với response dài;
  fallback poll `/ai/chat-status` như web.
- Image input: xác nhận backend nhận multipart hay base64 trước khi code UI.
