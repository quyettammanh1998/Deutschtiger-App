# Web ↔ Flutter Feature Parity Matrix

Nguồn: audit 15/07/2026 — inventory web frontend (`thamkhao/deutschtiger-frontend`),
backend (`thamkhao/deutschtiger-backend`, 554 routes) và trạng thái Flutter app.
Mục tiêu: Flutter đạt đầy đủ tính năng như web hiện tại (trừ SEO/admin).

Trạng thái Flutter: `LIVE` = ApiClient contract thật; `MOCK-GATED` = màn có
nhưng data mock, chặn khỏi release bằng flag default-off; `PARTIAL` = một phần
live; `MISSING` = chưa có màn.

Owner viết tắt:
- **MASTER** = `plans/260710-1644-flutter-port-phase-0-to-8/` (phase số)
- **GĐ2** = `plans/260715-flutter-gd2-extended-coverage/` (phase số)
- **WAVE** = `plans/260715-2321-gd1-closeout-coding-wave/` (phase số)
- **PARITY** = `plans/260715-2333-flutter-full-parity-roadmap/` (plan mới, phase số)
- **UI-FIDELITY** = `plans/260716-2324-web-mobile-ui-100-fidelity/` (P1–P12, hoàn
  tất 17/07/2026 — rebuild toàn bộ UI cho khớp web; P12 wave B = deletion
  sweep + QA cuối, cập nhật hàng bên dưới theo kết quả thật)

## 1. Kiến trúc nền (web) cần biết khi port

- Supabase = auth + realtime channels (messages, presence, duel, call
  signaling, comments). Data đi qua Go API `/api/v1` bearer token.
- AI streaming = SSE (`/ai/chat`, `/ai/sprechen-partner`...), không WebSocket.
- Push web = VAPID web-push; backend CHƯA có FCM/APNs (GĐ2 P3 sẽ thêm).
- Payment = SePay VietQR duy nhất (poll status); mobile sẽ dùng IAP
  RevenueCat (MASTER P7), backend cần cột `source: sepay|apple|google`.
- TTS tự host tại `audio.deutschtiger.com`; STT: Soniox (default)/Azure/Groq;
  Azure Pronunciation Assessment cho chấm phát âm.
- UI web hardcode tiếng Việt; Flutter đã có ARB vi/en/de.

## 2. Ma trận theo domain

| Web domain | Tính năng chính | Flutter status | Owner |
|---|---|---|---|
| auth | Google OAuth, magic link, signup/forgot/reset | LIVE | MASTER P2 (đã code) |
| dashboard | streak, XP, missions, activity widgets | LIVE | done |
| vocabulary | topics, word detail+TTS, lesson, daily review SRS, subtitle words | LIVE (16/07: subtitle words live) | done |
| flashcard | decks/folders, SRS, cloze, speak-to-notes | LIVE (speak-to-notes MISSING — cần voice) | done / PARITY P4 |
| practice | deck runner: cloze, listening, matching, writing | LIVE (16/07) | done |
| learn | learn hub, mission session | LIVE | done |
| learn (mở rộng) | can-do practice, topic explore, focus session, learner model | LIVE (16/07; focus session = action dashboard theo web thật) | done |
| grammar | list, lesson, article, drills | LIVE (16/07; leaderboard/rank/drill-results để sau) | done |
| game | hub + minigames, cases trainers, sentence builder, Deutsch Runner | LIVE 13 game (16/07: sentence builder, word/typing sprint, cases hub 4 sub-game, konjugation, flashcard, writing word/sentence, listening, runner, artikel, wortstellung, fill-blank — flag riêng từng game); còn 3 game voice = blocked-by-voice (MASTER P8) | done (trừ voice) |
| pronunciation | hub + 5 trainer (Umlaute, Ich/Ach, R, Sp/St, minimal pairs), Azure PA | PARTIAL (1 màn) | MASTER P8 (cần voice) |
| conversation | AI sprechen partner (SSE + Soniox), scenario, history, interview import | MOCK-GATED (speaking/ 9 màn) | MASTER P8 (cần voice; SSE infra đã có) |
| ai | AI chat SSE, sessions, memory, profile (+quota banner) | LIVE (17/07, UI-FIDELITY P12a — markdown render, feature-action chips, limit cards, history full-panel; image attach/voice mic/SpecialCharBar vẫn thiếu — cần UI mới + flag) | done (gaps) / UI-FIDELITY P12a |
| listening | hub, Sprechen B1/B2, Easy German podcast + player | LIVE podcast (16/07); Sprechen B1/B2 coming-soon (video list web-hardcode); audiobook/dictation mock tự chế đã xoá | done / GĐ2 P1 note |
| youtube | tracker, watch (transcript sync + word lookup), dictation, shadowing | LIVE tracker+watch (16/07); dictation/shadowing stub + gap | done (stub note) |
| video-library | curated video tracker + watch | LIVE (16/07; chưa có entry link + flag gate cho /library) | done (follow-up) |
| interview | interview-prep tracker + watch + notes | LIVE (16/07: transcript có tap-word lookup) | done |
| course | course hub, detail, lesson + progress/notes | LIVE (17/07, UI-FIDELITY P11 W3 — routes moved to `/course/*`, search/stats/level pills/premium locks on hub, score%/status pills + numbered pagination on detail, lesson video playback (mp4 via WebView, no `video_player` dep) + transcript + paginated vocab audio + notes + comments; DW exercises engine still a gap — web itself has it commented out; course/detail leaderboard also deferred, same shared-widget gap P11 W2 flagged) | done (gaps) |
| reading | list, detail, feed, read-listen hub | LIVE (17/07, UI-FIDELITY P11 W4 — level cards+ring grid, tab shell, leaderboard, save-words CTA; topic-accordion + exercises quiz KHÔNG có contract/data nguồn, xem `api-changelog.md`) | done |
| news | list + detail + progress + week stats + quiz | LIVE (17/07, UI-FIDELITY P11 W4 — tab shell, leaderboard wired, weekly ring moved below list, save-words CTA, level-tip box; quiz vẫn chấm client-side) | done |
| exam core | landing/section/list, player Lesen+Hören, result, best scores, drafts | LIVE (draft live-evidence pending) | WAVE P1 |
| exam Schreiben | Goethe B1 writing suite, writing catalog/community, writing sprint | LIVE (17/07, UI-FIDELITY P9 4-wave — hub/panel, topic-list/detail/practice, `/luyen-viet` generic suite, sprint SR mode) | done / UI-FIDELITY P9 |
| exam Sprechen | TELC/Goethe sprechen study+practice, AI graded | UI DONE, gated (17/07, UI-FIDELITY P10 — full TELC+Goethe sprechen exam UI shell; `ReleaseFeatureFlags.speaking` off tới khi voice/AI-grading live-wired) | MASTER P8 (cần voice wiring) |
| exam mở rộng | dictation cloze, readiness, schedule+registration, buddy finder, de-thi public | LIVE (16/07; buddy read-only, community write để GĐ2 P3) | done |
| community | community exams list/detail, comments | LIVE read-only (16/07; comment-write chờ moderation GĐ2 P3) | done (read-only) |
| social | profile công khai, friends, messages/chat (poll) | LIVE non-realtime (17/07, UI-FIDELITY P12a+P12 wave B — profile cover/stats/journey/achievements/timeline rebuild; block wire mọi surface; report = mailto, chờ backend endpoint). **Moments/announcements-page/bare `/social` hub bị XOÁ** (P12 wave B) — web không có 3 tính năng này (moments không tồn tại trên web; announcements chuyển thành `AnnouncementBanner` inline trên dashboard+exam) | done / UI-FIDELITY P12a+12b |
| social realtime | duels 1v1, challenges, presence, WebRTC calls | Duel: UI shell rebuilt (17/07, UI-FIDELITY P12a — room-code lobby/timer/overlays, mock matchmaking removed, không viết mock mới), flag off chờ GĐ2 P3 wire live loop. Challenges: gated, mock UI chưa restyle (web cũng ẩn route). **Groups (study-groups) bị XOÁ hẳn** (P12 wave B) — web chưa từng có tính năng này. Calls: DEFERRED | GĐ2 P3 |
| leaderboard | global/friends XP | LIVE (17/07, UI-FIDELITY P12b — podium+crown, hall of fame, countdown, rank delta, breakdown chips/detail sheet; `weekly_score ?? weekly_xp ?? total_xp ?? xp` composite field; friends tab endpoint chưa mount server-side, fail-open như web) | done / UI-FIDELITY P12b |
| stats | analytics dashboard, error patterns, daily quote | LIVE (17/07, UI-FIDELITY P12b — đủ 13 block web kể cả achievements grid (client-computed) + leaderboard table; near-achievements + time-by-feature không có contract → bỏ) | done / UI-FIDELITY P12b |
| quotes | daily quote | LIVE (16/07, `/quotes/daily`) | done |
| settings | security, notification prefs, AI memory, learning prefs, appearance, app-update check | LIVE (17/07, UI-FIDELITY P12c — profile-edit card on root, password-change card, `/settings/appearance` + `/settings/app-update` new pages, `/settings/ai-memory` route, learning-goal chips+XP calc, review-display toggles) | done / UI-FIDELITY P12c |
| notifications | in-app notification center + unread badge; push FCM | Center LIVE (16/07, refresh on resume); FCM push chờ backend | done / GĐ2 P3 (push) |
| payment | SePay VietQR checkout + result pages | MISSING (premium/ RevenueCat skeleton; web's `/payment/success\|error\|cancel` post-checkout pages have no Flutter/IAP equivalent yet — flagged 17/07 by UI-FIDELITY P12 wave-B route sweep, needs an IAP-flow UX decision, not a redirect) | MASTER P7 (IAP thay SePay) |
| affiliate | dashboard + leaderboard referral | Màn có; leaderboard LIVE, dashboard mock | ⚠️ DECISION (xem §4) |
| legal | privacy, terms, delete account | LIVE (delete = placeholder) | WAVE P2 |
| account | deletion + data export | MISSING (placeholder) | WAVE P2 |
| PWA/SEO/admin | service worker, 26 SEO pages, admin console | — | Web-only, không port |

## 3. Backend gaps (code backend trước khi Flutter dùng)

1. Account deletion + export endpoints — chưa mount (WAVE P2).
2. FCM/APNs native push + bảng push-token — chỉ có VAPID web-push (GĐ2 P3).
3. Cột `source: sepay|apple|google` + RevenueCat webhook (MASTER P7).
4. Report user/message cho UGC — block có, report chưa (GĐ2 P3, Apple blocker).
5. Exam draft P1 fixes: idempotency retry, null map, no-op PATCH (WAVE P1).

## 4. Quyết định — trạng thái

**DEFERRED 15/07/2026 (owner chọn tạm bỏ qua, không làm trong mọi plan):**

1. **Affiliate trên mobile** — giữ nguyên hiện trạng (leaderboard live,
   dashboard mock-gated off), không code thêm cho đến khi owner mở lại.
2. **WebRTC calls** — không port; GĐ2 P3 loại calls khỏi scope, chỉ làm
   messages/friends/moments/duel/push.
3. **SePay trên Android** — không port SePay QR; mobile đi IAP-only theo
   MASTER P7.

**Còn mở (chặn WAVE P2):** 3 quyết định account deletion (grace period,
anonymize community content, payment retention) — đã liệt kê ở WAVE plan.

## 5. Thứ tự khuyến nghị đến full parity

1. WAVE P1–P6 (GĐ1 close-out: evidence, deletion/export, live surfaces, tests, CI).
2. MASTER P9 store submission GĐ1.
3. MASTER P10 IAP + P11 Voice (mở khóa mọi feature voice/AI-speaking).
4. PARITY P1 (AI chat SSE) — có thể song song với 3.
5. GĐ2 P1 media → P2 schreiben → P3 social/push (xen PARITY P2–P3).
6. PARITY P4 residual + GĐ2 P4–P5 sweep + stability.

Chi tiết phase mới: `plans/260715-2333-flutter-full-parity-roadmap/`.
