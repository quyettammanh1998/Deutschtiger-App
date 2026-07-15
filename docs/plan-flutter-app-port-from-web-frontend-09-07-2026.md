# Plan: Port giao diện Web → Flutter App Deutschtiger (khảo sát 09/07/2026)

> Nguồn tham chiếu chính: `thamkhao/deutschtiger-frontend/plans/260706-0232-flutter-app-port/plan.md`
> và 14 file phase (00–13). Repo Flutter mục tiêu: thư mục này (`/home/qtm/Desktop/Deutschtiger-App/`)
> – đã có sẵn 131 màn trong 29 thư mục `lib/screens/`.

## 1. Tóm tắt khảo sát repo

### 1.1 Frontend web (`thamkhao/deutschtiger-frontend`)

- React 19 + TS 5.9 + Vite 7 + Tailwind v4 + Supabase (auth only). **184 page files / ~150 màn user-facing / ~112 endpoint** qua 113 service.
- Plan Flutter port (`260706-0232`) do team soạn ngày 06/07 đã chốt: 2 giai đoạn, 14 phase, ~6–8 tuần GĐ1 + ~12–14 tuần GĐ2.
- Routing chính: 5 nhóm → mobile bottom nav **5 tab** (`Trang chủ / Thi / Học / AI / Thêm`) + sheet "Thêm" 4 cột 4 nhóm (Luyện thêm / Ngữ pháp & Kỹ năng / Cộng đồng & Tiến độ / Tài khoản & Khác) + Tiger AI FAB.
- Hai shell: `AppShell` (5 tab + sheet) và `MinimalShell` (player, exam, duel…).

### 1.2 Flutter app hiện tại (`/home/qtm/Desktop/Deutschtiger-App`)

- Flutter SDK 3.12.1, Riverpod 2.5, go_router 17.2, supabase_flutter 2.12, sign_in_with_apple 6.0, google_sign_in 6.2, just_audio 0.10, webview_flutter 4.13, youtube_player_iframe 6.0, firebase_core/messaging, flutter_local_notifications, flutter_svg, google_fonts.
- **131 màn .dart** trong 29 thư mục `lib/screens/*` + song song `lib/features/*` (~30 domain).
- **Bottom nav đang 4 tab** (Home / Ôn từ / Bài học / Hồ sơ) – KHÁC web (5 tab + sheet Thêm).
- `lib/widgets/common/app_shell.dart` dùng `StatefulShellRoute.indexedStack` 4 branch.
- `lib/core/design_tokens.dart` có sẵn (spacing, radius, light/dark color, gradient, Inter typography) – **cần bổ sung exam-tokens** (theo plan file 03) và chuẩn hoá theo token export từ web.
- Auth: Supabase email/password + Google + Apple sẵn (chưa verify Sign-in-with-Apple đã wire đúng flow Apple 4.8 compliance).
- `lib/navigation/app_router.dart` đã có redirect theo auth state + public/private routes.

### 1.3 Backend (`thamkhao/deutschtiger-backend`)

- Go + Chi + local Postgres (`deutsch_tiger`). Supabase chỉ auth.
- Đã có plan Flutter (260706-0232) liệt kê **các việc BE phát sinh** kèm evidence file:line:
  - `DELETE /api/v1/user/profile` – route label có, route/handler CHƯA có → **blocker Apple 5.1.1(v)**, việc BE GĐ1.
  - Trang web `/delete-account` cho Google Data Safety URL → việc web nhỏ làm cùng lúc.
  - Push pipeline: mới có VAPID, cần thêm FCM/APNs (GĐ2).
  - Report/block user UI (blocker Apple 1.2 UGC) cho GĐ2.
  - Device limit BE đã live (key = claim `session_id` JWT, newest-wins evict, cap 2).
  - IAP: cột `source: sepay|apple|google` chưa có trong `payments`/`user_purchases` (GĐ2).

## 2. Ma trận màn hình web → Flutter (đã hiện / thiếu / ngoài scope)

> Mã màn theo `plans/260706-0232-flutter-app-port/01-screen-inventory-coverage-matrix.md` (file 01).
> Cột Flutter = trạng thái tại 09/07/2026 trong `lib/screens/`.

### A. Auth & Onboarding — **GĐ1 bắt buộc**

| # | Màn | Web route | Flutter | Ghi chú Flutter |
|---|-----|-----------|---------|-----------------|
| A1 | Login | `/login` | ✅ `auth/login_screen.dart` | Cần verify fidelity + bổ sung SiA (R2) |
| A2 | Signup | `/signup` | ✅ `auth/signup_screen.dart` | OK |
| A3 | Forgot/Reset | `/forgot-password`, `/reset-password` | ✅ `auth/forgot_password_screen.dart` | Thiếu `/reset-password` |
| A4 | Onboarding 2-3 slide (mới) | — | ⚠️ `auth/welcome_screen.dart` (cũ) | **Cần xây onboarding mới** (file 04 plan onboarding v2 + plan 1111 placement test) |
| A5 | Device-kicked modal | global | ❌ | **THIẾU** – cần port từ web + xử lý 401 trong `api_client` |
| A6 | Xoá tài khoản (mới) | — | ❌ | **THIẾU** – blocker Apple 5.1.1(v), cần BE handler + UI app |

### B. Trang chủ & Học

| # | Màn | Flutter | GĐ |
|---|-----|---------|---|
| B1 | Dashboard | ✅ `home/home_screen.dart` + `home_screen_new.dart` (2 bản, cần chốt) | 1 |
| B2 | Learn hub "Phiên hôm nay" | ⚠️ `journey/journey_screen.dart` (gần đúng, cần xác minh) | 1 |
| B3 | Mission session | ⚠️ Cần check runner | 1 |
| B4 | Can-do practice | ❌ | 2 |
| B5 | Topics explore | ⚠️ Có thể trong journey | 2 |
| B6 | Focus session | ❌ | 2 |
| B7 | Learner model | ❌ | 2 |
| B8 | Daily quote | ❌ (`stats/daily_quote_page.dart` có, cần check) | 2 |

### C. Từ vựng & Flashcards (lõi GĐ1)

| # | Màn | Flutter | GĐ |
|---|-----|---------|---|
| C1 | Vocabulary hub | ✅ `vocabulary/presentation/vocabulary_screen.dart` | 1 |
| C2 | Vocabulary lesson | ❌ (cần port từ web `vocabulary-lesson-page.tsx` 821 LOC) | 1 |
| C3 | Vocabulary word | ❌ (cần port `word-page.tsx` 847 LOC) | 1 |
| C4 | Vocabulary detail | ❌ (cần port `detail-page.tsx` 1031 LOC – **TOP-2 phức tạp**) | 1 |
| C5 | Daily review (FSRS) | ✅ `daily_review/daily_review_screen.dart` | 1 |
| C6 | Sổ từ của tôi | ⚠️ `decks/deck_list_screen.dart` | 1 |
| C7 | Practice deck | ✅ `flashcard/flashcard_review_screen.dart` | 1 |

### D. Luyện thi (khó nhất, GĐ1 = Lesen+Hören)

| # | Màn | Flutter | GĐ |
|---|-----|---------|---|
| D1 | Exam landing | ✅ `exam/exam_hub_screen.dart` | 1 |
| D2 | Exam section per level | ⚠️ `exam/exam_list_page.dart` | 1 |
| D3 | Exam list per level | ✅ `exam/exam_list_page.dart` | 1 |
| D4 | **Exam player** (153 component web) | ✅ `exam/exam_practice_page.dart` (rất sơ khai) | 1 |
| D5 | Exam result | ✅ `exam/exam_result_page.dart` | 1 |
| D6 | Dictation | ✅ `listening/dictation_page.dart` | 2 |
| D7 | Community exams + detail | ❌ | 2 |
| D8 | Đề thi công khai | ❌ | 2 |
| D9 | Lịch thi + tìm bạn ôn | ❌ | 2 |
| D10 | Exam readiness | ❌ (`exam/widgets/exam_readiness_card.dart` có nhưng chưa phải trang đầy đủ) | 2 |

### E. Viết (GĐ2)

| # | Màn | Flutter | GĐ |
|---|-----|---------|---|
| E1 | Writing catalog + per-level | ✅ `exam/goethe_b1_writing_page.dart` (rất sơ) | 2 |
| E2 | Writing custom + AI | ✅ `ai/ai_writing_practice_page.dart` | 2 |
| E3 | Schreiben view (fullscreen) | ❌ | 2 |
| E4 | Goethe B1 writing detail | ✅ (sơ) | 2 |
| E5 | Writing sprint (27 component) | ❌ | 2 |
| E6 | Community writing topics | ❌ | 2 |
| E7 | My submissions | ❌ | 2 |

### F. Nói & Phát âm (GĐ2)

| # | Màn | Flutter | GĐ |
|---|-----|---------|---|
| F1 | Sprechen TELC | ✅ `exam/goethe_speaking_page.dart` (sơ) | 2 |
| F2 | Goethe Sprechen | ✅ (sơ) | 2 |
| F3 | Sprechen hubs | ✅ `speaking/speaking_hub_screen.dart` | 2 |
| F4 | Pronunciation hub | ✅ `pronunciation/pronunciation_screen.dart` + `speaking/umlaute/r-sound/ich-ach/sp-st trainer` | 2 |
| F5 | Speaking practice game | ✅ `games/speaking_game_screen.dart` | 2 |
| F6 | Konjugation trainer | ✅ `games/konjugation_game_screen.dart` | 2 |

### G. Nghe & Video (GĐ2)

| # | Màn | Flutter | GĐ |
|---|-----|---------|---|
| G1 | Listening hub | ✅ `listening/listening_hub_new_screen.dart` | 2 |
| G2 | Sprechen-b1/b2, easy-german, podcast | ✅ (sơ) | 2 |
| G3 | YouTube (767 LOC web) | ✅ `interview/video_player_screen.dart` (dùng `youtube_player_iframe`) | 2 |
| G4 | Video library | ✅ `interview/*` | 2 |
| G5 | Interview | ✅ `interview/interview_roadmap_screen.dart` | 2 |
| G6 | Read-listen hub | ❌ | 2 |

### H. Đọc & Ngữ pháp & Tin

| # | Màn | Flutter | GĐ |
|---|-----|---------|---|
| H1 | Reading hub + detail | ❌ | 1 |
| H2 | Reading feed | ❌ | 2 |
| H3 | Grammar hub + article + lesson | ✅ `grammar/grammar_screen.dart` (sơ) | 1 |
| H4 | Cases hub | ✅ `games/cases_mastery_game_screen.dart` | 2 |
| H5 | News list + detail | ❌ | 2 |

### I. Games

| # | Màn | Flutter | GĐ |
|---|-----|---------|---|
| I1 | Game hub | ✅ `games/game_hub_screen.dart` + `_new` | 1 |
| I2 | Word sprint | ✅ `games/word_sprint_game_screen.dart` | 1 |
| I3 | Typing, listening-quiz, artikel, wortstellung, matching, writing-game, cloze, sentence-builder, flashcards-game | ✅ (gần đủ) | 2 |
| I4 | Deutsch Runner | ✅ `games/runner_game_screen.dart` | 2 |
| I5 | Duel lobby + play | ✅ `social/duel_lobby_page.dart`, `duel_play_page.dart` | 2 |

### J. AI & Hội thoại

| # | Màn | Flutter | GĐ |
|---|-----|---------|---|
| J1 | Conversation hub | ✅ `speaking/conversation_hub_page.dart` | 1 |
| J2 | AI chat (text) | ✅ `ai_tutor/ai_tutor_chat_screen.dart` + `ai/ai_chat_page.dart` | 1 |
| J3 | Conversation scenario (voice AI) | ✅ `speaking/conversation_scenario_page.dart` | 2 |
| J4 | Custom / history / interview-import | ❌ | 2 |
| J5 | Tiger AI FAB + drawer (global) | ❌ | 2 |

### K. Cộng đồng & Xã hội (GĐ2)

| # | Màn | Flutter | GĐ |
|---|-----|---------|---|
| K1 | Profile | ✅ `profile/profile_screen.dart` | 2 |
| K2 | Friends | ✅ `social/friends_page.dart` | 2 |
| K3 | Messages + chat | ✅ `social/chat_page.dart`, `messages_page.dart` | 2 |
| K4 | Leaderboard | ✅ `leaderboard/leaderboard_screen.dart` | 1 |
| K5 | Call overlay / LiveKit | ❌ | 2 |

### L. Khoá học (GĐ2)

| # | Màn | Flutter | GĐ |
|---|-----|---------|---|
| L1 | Course hub + detail | ✅ `journey/courses_hub_screen.dart` | 2 |
| L2 | Course lesson (784 LOC web) | ❌ | 2 |

### M. Thống kê

| # | Màn | Flutter | GĐ |
|---|-----|---------|---|
| M1 | Stats | ✅ `stats/stats_screen.dart` | 1 |
| M2 | Error patterns | ✅ `stats/error_patterns_page.dart` | 2 |

### N. Settings & Tài khoản

| # | Màn | Flutter | GĐ |
|---|-----|---------|---|
| N1 | Settings main | ✅ `settings/settings_screen.dart` | 1 |
| N2 | Security + device mgmt | ❌ (chưa tách) | 1 |
| N3 | Appearance (dark mode) | ⚠️ trong settings? | 1 |
| N4 | Notifications | ⚠️ `reminders/reminder_settings_screen.dart` | 2 |
| N5 | AI memory, Learning, App update | ❌ | 2 |
| N6 | Feedback sheet | ❌ | 1 |

### O. Premium & Thanh toán (GĐ2)

| # | Màn | Flutter | GĐ |
|---|-----|---------|---|
| O1 | Premium + plan selector | ❌ | 2 |
| O3 | Gate, free-limit overlay, banner | ⚠️ `interview/widgets/premium_required_view.dart` (sơ) | 1 (gate trung tính) |

### P. Shared components

| # | Component | Flutter | GĐ |
|---|-----------|---------|---|
| P1 | WordLookupSheet + TappableSentence | ❌ | 1 |
| P2 | SaveCardButton + deck menu | ❌ | 1 |
| P3 | BottomSheet base | ❌ | 1 |
| P4 | SpeakButton + audio chain | ⚠️ `screens/speaking/widgets/*` + `just_audio` | 1 |
| P5 | GameCompletionScreen / EndScreen | ❌ | 1 |
| P6 | Skeleton, error boundary, offline banner, confirm dialog, confetti | ❌ | 1 |
| P7 | LevelBadge, PremiumCrown, BackButton, PageIntro | ❌ | 1 |
| P8 | PronunciationPracticePanel | ❌ | 2 |

## 3. Tổng kết trạng thái port

| Mức | Số màn | Ghi chú |
|------|--------|---------|
| ✅ Đã có Flutter (cần refine fidelity) | ~85 | 131 files thực tế; tỉ lệ trùng ~70% |
| ⚠️ Có nhưng sơ khai / đúng tên sai nội dung | ~25 | Cần review lại logic + UI |
| ❌ CHƯA CÓ (GĐ1 bắt buộc) | ~15 | Theo plan 01: A4, A5, A6, C2–C4, D4 nâng cấp, H1, N2, P1–P7 |
| ❌ CHƯA CÓ (GĐ2) | ~50 | Theo plan 01: toàn bộ mục E, F, G, H2, H5, I3 (phần cloze/sentence-builder), J4, J5, K5, L2, M2, N4, N5, O1 |

**GĐ1 theo plan 260706-0232 = ~35 màn** (file 01). Đã có khoảng **22/35 màn GĐ1** (mức file tồn tại); thiếu khoảng **13 màn lõi GĐ1** + **8 shared component** + **2 màn mới** (onboarding v2, xoá tài khoản). Tổng GĐ1 còn lại ước **~6–8 tuần công** đúng theo plan 260706-0232.

## 4. Plan triển khai

### Nguyên tắc
1. **Tái sử dụng tối đa code đã có** trong `lib/screens/*` – không viết lại từ đầu những file đã port, mà **refactor + bổ sung** cho khớp web (naming, logic, fidelity).
2. **Theo sát plan 260706-0232** – coi đó là kim chỉ nam GĐ1/GĐ2 đã chốt.
3. **Theo sát plan 260706-1111 (onboarding v2 + placement)** – sẽ tích hợp khi build A4 mới.
4. **Theo sát plan 260706-1118 (PWA offline)** – nếu làm A2HS/offline cho Flutter, cần khảo sát cẩn thận (sẽ KHÔNG làm trong GĐ1, tránh cãi với plan Flutter).
5. **Áp dụng plan 260706-1151 (golden-moment + nav reshuffle)** – chú ý **reshuffle nav**: khi build, đặt nav theo đúng **5 tab + sheet Thêm** (KHÔNG phải 4 tab hiện tại). Có thể gated theo plan này (Phase 3 GATED).
6. **Compliance Apple/Google first** – tất cả màn premium/payment KHÔNG để lộ giá/web-payment ở GĐ1 (file 02). Nút report AI = bắt buộc trong AI chat GĐ1 (R7).
7. **Fidelity** – áp dụng 4 tầng từ plan 03: tokens → contracts → screenshot diff → golden.

### Phase đề xuất (kế thừa + điều chỉnh từ plan 260706-0232)

#### Phase 0 (3–4 ngày) — Nền móng (làm TRƯỚC mọi thứ)
- Dọn thiết kế hiện tại: thống kê files 2 bản (`*_screen.dart` vs `*_screen_new.dart`), chốt 1 bản duy nhất, xoá file rác.
- Tổ chức lại cây thư mục theo chuẩn web (file 01): `lib/features/<domain>/{data,domain,presentation}` thay vì `lib/screens/* + lib/features/*` chồng chéo.
- Export design tokens từ web `thamkhao/deutschtiger-frontend/scripts/` (nếu chưa có) → sinh `lib/core/design_tokens.dart` chuẩn (đã có sẵn – bổ sung `exam-tokens` + dark mode đầy đủ).
- Quy ước API additive-only + viết `docs/api-changelog.md` (file 00 §3).
- Tạo 2 test account (reviewer + fidelity seed) trên BE.
- 2 tài khoản developer (Apple $99 + Google $25) – đăng ký NGAY tuần 1.

#### Phase 1 (1 tuần) — Shell + 2 nav mới + shared widgets
- Refactor `lib/widgets/common/app_shell.dart`: chuyển sang **5 tab + sheet "Thêm"** (Trang chủ / Thi / Học / AI / Thêm), đồng bộ với web.
- `lib/navigation/app_router.dart`: thêm branch "Thêm" mở BottomSheet grid 4 cột 4 nhóm; đổi route con trong mỗi branch theo coverage matrix.
- `MinimalShell` cho player (exam, duel, game runner, writing sprint, speaking scenario).
- Build 8 shared component (P1–P7) trong `lib/shared/widgets/` (theo file 01 bảng P): WordLookupSheet, TappableSentence, SaveCardButton, BottomSheet base, SpeakButton (audio chain), GameCompletionScreen, Skeleton/ErrorBoundary/OfflineBanner/ConfirmDialog/Confetti, LevelBadge/PremiumCrown/BackButton/PageIntro.
- `api_client.dart` (Dio) + auth interceptor + device-kicked handling + X-App-Version header + Crashlytics init.
- `flutter_native_splash` + icon + fonts (Inter/Fredoka One/Grandstander copy từ web).
- `usesCleartextTraffic=false` + secret-scan CI + `--obfuscate --split-debug-info` (file 04 §4).
- Lint custom: cấm hardcode màu/spacing (chỉ dùng `DesignTokens`).

#### Phase 2 (1 tuần) — Auth + device + xoá tài khoản
- supabase_flutter đã có sẵn – verify secure-storage backing (Keychain/EncryptedSharedPreferences-Keystore).
- Verify & wire Sign-in-with-Apple (R2) – chỉ hiện trên iOS.
- Deep link: `app links` (Android) + `universal links` (iOS) cho reset-password + magic link + OAuth callback (cần AASA + assetlinks.json trên nginx).
- Onboarding 2-3 slide (A4) – kết hợp plan 260706-1111 placement test (nếu chốt làm placement ngay, ghép thành onboarding v2).
- **Device-kicked modal (A5)**: port logic từ web `device-kicked-modal.tsx` + xử lý 401 trong Dio interceptor.
- **Xoá tài khoản (A6) – BLOCKER APPLE**: cần BE handler trước, sau đó UI 2 bước trong Settings → Security. Đồng thời làm trang web `/delete-account` (blocker Google Data Safety).
- Auth-gate router (chưa login → /welcome-onboarding; đã login → /home) + bootstrapping skeleton 4s.
- Force-update path từ GĐ1 (BE config + màn chặn).

#### Phase 3 (2.5 tuần) — Lõi học (vocab + review + flashcard + learn + dashboard)
- **SpeakButton + audio chain (P4)**: dùng `just_audio`, fallback chain 3 tầng (recorded → cached TTS → `flutter_tts`).
- **WordLookupSheet + TappableSentence (P1)** – dùng ở mọi màn đọc/nghe/thi.
- **Vocabulary (C1–C4)**: refactor `vocabulary_screen.dart` đã có; port chi tiết từ web `vocabulary-lesson-page.tsx` (821 LOC), `word-page.tsx` (847 LOC), `detail-page.tsx` (1031 LOC). Chia sub-view thành widget file nhỏ.
- **FSRS Daily review (C5)**: đã có `daily_review/daily_review_screen.dart` – verify round-trip với BE (review trên app → due đúng trên web). Timezone sync như `srs-service.ts` web.
- **Sổ từ của tôi + Practice deck (C6–C7)**: refactor `decks/deck_list_screen.dart` + `flashcard/flashcard_review_screen.dart`.
- **Learn hub + Mission (B2–B3)**: refactor `journey/journey_screen.dart`, port mission runner state machine.
- **Dashboard (B1)**: chốt 1 bản giữa `home_screen.dart` và `home_screen_new.dart` (xoá 1 cái); port 23 widget từ `components/dashboard/*` web; ẩn widget GĐ2 theo flag; streak claim modal + heartbeat timer nền.
- **Báo cáo AI (R7 – Google Play)**: nút report trong AI chat GĐ1 + áp dụng pattern `ReportContentButton` web.

#### Phase 4 (3 tuần) — Exam player Lesen+Hören (màn khó nhất)
- Mục tiêu: practice/test/review mode cho Lesen + Hören. Schreiben/Sprechen → GĐ2. Edit mode = web-only.
- **Exam landing (D1) + section per level (D2) + list (D3)**: refactor `exam_hub_screen.dart` + `exam_list_page.dart`.
- **Exam player (D4)**: refactor `exam_practice_page.dart` (153 component web → kiểm kê renderer Lesen/Hören ≈ 60%, chỉ port phần đó).
- Question types GĐ1: MC, matching, richtig/falsch, sprachbausteine, anzeigen cards (fix Teil3 anzeigen[] shape, `correct_answer` = 0-based index theo `exam-scoring.ts:17`).
- Hören: audio player với `max_plays/audio_plays` enforcement (port đúng hành vi web).
- Timer + autosave attempt + resume + abandoned-attempt semantics.
- Review mode: highlight (web dùng CSS Custom Highlight API → Flutter `TextSpan` + `TextPainter`).
- Kết quả: điểm theo provider (telc 225/75, ≥135∧≥45 calibration).
- **Exam result (D5)**: refactor `exam_result_page.dart`.
- 1 question-type = 1 widget module + 1 fixture JSON thật (lấy từ PG projection) + golden test.
- Player state machine (Riverpod notifier) port từ hooks exam.

#### Phase 5 (2 tuần, song song Phase 4) — Màn GĐ1 còn lại
- **Reading (H1)**: hub + detail + TappableSentence/WordLookupSheet.
- **Grammar (H3)**: hub + article + lesson (483 LOC web) – refactor `grammar/grammar_screen.dart` (sơ khai).
- **Games (I1–I2)**: game hub + word sprint trọn vẹn (timer, streak, end screen).
- **AI chat (J1–J2)**: refactor `ai_tutor/ai_tutor_chat_screen.dart` + `ai/ai_chat_page.dart`; streaming nếu web streaming; ảnh upload GĐ2; quota free-user như web; **nút report AI bắt buộc**.
- **Leaderboard (K4)** + **Stats (M1)**: refactor `leaderboard/leaderboard_screen.dart` + `stats/stats_screen.dart`; dùng `fl_chart` cho sparkline/bar khớp web.
- **Settings (N1–N3, N6)**: refactor `settings_screen.dart` – tách Security, Appearance, Feedback sheet.
- **Premium gate GĐ1 (O3)**: gate trung tính "Sắp ra mắt trên app" – KHÔNG giá, KHÔNG link web. Audit toàn bundle grep "premium"/"79k"/"pricing" = 0.

#### Phase 6 (1 tuần + 2-3 tuần chờ) — Submission GĐ1
- ⚠️ **Closed testing Google bắt đầu NGAY từ build alpha cuối Phase 3** (14 ngày + 12 tester) – chạy song song build Phase 4/5.
- Tuyển 20 tester từ user DeutschTiger (R5): banner web UA-Android + bài fanpage + top leaderboard; incentive 1 tháng premium (admin grant pattern sẵn); Google Group làm tester list.
- Store listing: tên, mô tả VI, screenshots (dùng ảnh fidelity pipeline), feature graphic, icon 1024, privacy policy URL.
- Data Safety form + Privacy Nutrition Labels (mic = KHÔNG ở GĐ1, AI disclosure theo R7).
- Launch-day config: `DEVICE_SESSION_LIMIT=3` (R3, env clamp 1-10, restart là xong).
- App Review Notes: demo account + mô tả app KHÔNG có purchase + flow chính.
- Crashlytics + Sentry-of-choice + crash-free ≥99.5% closed testing.
- Test thiết bị thật: 1 Android giá rẻ + 1 iPhone cũ (iOS 15-16) + 1 iPhone mới.
- iOS TestFlight internal → external beta → App Store submit.
- Android closed → production staged 20→50→100%.

#### Phase 7-12 (GĐ2, ~12-14 tuần) — Hoàn thiện 100%
- 07 IAP RevenueCat + entitlement hợp nhất (SePay↔store). Lưu ý: submit riêng thành 1 bản update, đừng gộp với feature lớn khác.
- 08 Ghi âm + Sprechen + Pronunciation + voice AI.
- 09 YouTube + Listening + Course video.
- 10 Viết + AI grading + Writing sprint.
- 11 Social + Realtime + Duel + Push (FCM/APNs) + report/block UGC.
- 12 Quét sạch 100% matrix (games, misc, learner model, error patterns, news, daily quote).

#### Phase 13 (xuyên suốt) — Crash/ổn định + release ops
- Crashlytics từ build đầu, alert <99.5% crash-free.
- Checklist code review từng phase (file 04 §13.3): mounted guard, permission check, audio session, JSON parse, kill-app resume, isolate cho JSON to, safe-area, locale/timezone.
- Force-update từ GĐ1.
- Secret-scan `gitleaks` mỗi release.
- `--obfuscate --split-debug-info` cho release.
- API additive-only + api-changelog (lưới an toàn khi BE thêm field).

## 5. Việc backend / web phát sinh (đồng bộ)

| # | Việc | Phụ thuộc | GĐ | Plan |
|---|------|-----------|----|------|
| BE-1 | `DELETE /api/v1/user/profile` handler (xoá data + Supabase admin delete + revoke sessions) | — | 1 | 260706-0232 phase-02 §6 |
| BE-2 | Đăng ký route DELETE /profile (label đã có) | BE-1 | 1 | 260706-0232 phase-02 §6 |
| BE-3 | AASA (iOS) + assetlinks.json (Android) trên nginx deutschtiger.com | — | 1 | 260706-0232 phase-02 §2 |
| WEB-1 | Trang web `/delete-account` (Google Data Safety URL) | BE-1 | 1 | 260706-0232 phase-02 §8 |
| BE-4 | Force-update config (min-version) | — | 1 | 260706-0232 phase-13 |
| BE-5 | API additive-only + `docs/api-changelog.md` | — | 0 | 260706-0232 phase-00 |
| BE-6 | Dọn `VITE_AZURE_SPEECH_KEY` thừa khỏi .env FE | — | 0 | 260706-0232 phase-00 |
| BE-7 | Cột `source: sepay|apple|google` cho `payments`/`user_purchases` + webhook RevenueCat | — | 2 | 260706-0232 phase-07 |
| BE-8 | FCM/APNs + bảng push token | — | 2 | 260706-0232 phase-11 |
| BE-9 | Report/block user API + UI | — | 2 | 260706-0232 phase-11 |
| BE-10 | Audit CF-worker-bảng-chết trước (push token) | — | 2 | 260706-0232 phase-11 |
| BE-11 | API placement test + claim-on-signup + seed knowledge state | — | 1 (nếu ghép onboarding v2) | 260706-1111 |

## 6. Rủi ro & đối sách

| # | Rủi ro | Xác suất | Tác động | Đối sách |
|---|--------|----------|----------|----------|
| 1 | Apple reject vòng 1 (account mới + Education) | ~30-40% | +5-7 ngày | Chuẩn bị sẵn demo account, review notes kỹ, smoke test thiết bị thật, Crashlytics ổn trước khi submit |
| 2 | Google closed testing 14 ngày critical path | 100% nếu mới | 14 ngày | Bắt đầu NGAY từ build alpha cuối Phase 3, song song Phase 4/5 |
| 3 | Exam player fidelity chưa đạt 2% pixel diff | Cao | +1-2 tuần | Theo file 03: tokens → contracts → screenshot diff → sửa theo heatmap → golden test |
| 4 | API breaking change BE làm crash app đã phát hành | Trung bình | Thảm hoạ | API additive-only (phase 0) + force-update path + ci guard api-changelog |
| 5 | Tài nguyên hạn chế khi song song 2 plan lớn (Flutter + Onboarding v2) | Trung bình | Chậm tiến độ | Dùng worktree/agent song song theo file ownership rõ ràng (theo từng plan) |
| 6 | File 2 bản trùng tên (`*_screen.dart` vs `*_screen_new.dart`) | — | Bảo trì khó | Phase 0 dọn ngay, chốt 1 bản duy nhất |
| 7 | Nav 4 tab hiện tại KHÁC web 5 tab + sheet | — | UX lệch | Phase 1 refactor ngay |
| 8 | Designer không tồn tại / design tokens Flutter sơ khai | Trung bình | Pixel lệch | Phase 0 export token từ web, tự host font woff2→ttf, dùng `flutter_svg` với SVG gốc web |
| 9 | Xung đột với plan `260706-1118-pwa-offline-review` (đang GĐ1 web song song) | Thấp | Trùng endpoint | Flutter KHÔNG đụng PWA; PWA plan ở worktree `work/t4` riêng |
| 10 | Xung đột với plan `260706-1111-onboarding-placement-test` (BE+FE) | Trung bình | Overlap A4 | Phase 2 A4 dùng luôn endpoint placement từ plan 1111 nếu kịp, fallback onboarding đơn giản nếu chưa |

## 7. Câu hỏi cần user chốt trước khi vào code

> Tôi đã tham chiếu đầy đủ các plan hiện có. Một số quyết định đã được team chốt từ trước (R1–R8 trong file 05), nhưng có **5 câu hỏi nghiệp vụ** cần bạn quyết trước khi tôi bắt đầu code:

1. **R3 device limit**: nâng `DEVICE_SESSION_LIMIT` từ 2 → 3 ngay ngày launch app, hay giữ 2 (theo chốt R3)? → Ảnh hưởng 1 dòng env BE + risk user bị kick khi mở app.
2. **R6 giá IAP (GĐ2)**: phương án A gross-up **99/349/449k** (net sau 15% ≈ 84/297/382k) hay phương án B đồng giá web 79/279/349k (chấp nhận net thấp hơn)? → Quyết trước phase-07.
3. **Nav 4 tab → 5 tab + sheet Thêm** (theo plan 260706-1151 nav reshuffle gated): làm NGAY Phase 1 (rủi ro: chưa có dữ liệu 7 ngày Umami theo plan 1151), hay chờ data rồi mới reshuffle?
4. **Plan 260706-1111 (onboarding v2 + placement test)**: ghép ngay vào Phase 2 A4 (cần BE placement + UI test adaptive), hay làm A4 đơn giản trước rồi ghép sau?
5. **Plan 260706-1118 (PWA offline review)**: Flutter app có nên hỗ trợ offline (xem plan 1118) không? Mặc định: KHÔNG – plan 1118 chỉ cho web trong lúc chờ Flutter. Nếu muốn offline cho Flutter cũng, sẽ tốn thêm ~1-2 tuần GĐ1 (dùng `sqflite` + sync queue, pattern tương tự plan 1118).

## 8. Kế hoạch làm việc đề xuất (khi bạn duyệt)

Tuần 1: Phase 0 (nền móng) + đăng ký 2 dev account + dọn file 2 bản trùng tên.
Tuần 2: Phase 1 (shell + shared widgets) bắt đầu song song với thiết kế token export.
Tuần 3-4: Phase 2 (auth + xoá tài khoản – cần BE handler làm trước).
Tuần 4-6: Phase 3 (lõi học: vocab + review + dashboard) + **bắt đầu closed testing Google từ build alpha cuối tuần 6**.
Tuần 5-8: Phase 4 (exam player) + Phase 5 (màn GĐ1 còn lại) song song 2 worktree/2 agent.
Tuần 9: Phase 6 submission.
Tuần 10-12: chờ review (Google closed testing kết thúc + 2 store review).
Tuần 13+: GĐ2 theo 260706-0232 phase 07→13.

---

**Tài liệu tham chiếu chính:**
- `thamkhao/deutschtiger-frontend/plans/260706-0232-flutter-app-port/plan.md` (kim chỉ nam GĐ1/GĐ2)
- `thamkhao/deutschtiger-frontend/plans/260706-0232-flutter-app-port/01-screen-inventory-coverage-matrix.md` (nguồn sự thật 100% màn)
- `thamkhao/deutschtiger-frontend/plans/260706-0232-flutter-app-port/02-store-review-compliance-decisions.md` (compliance)
- `thamkhao/deutschtiger-frontend/plans/260706-0232-flutter-app-port/03-pixel-fidelity-verification-pipeline.md` (4 tầng verify pixel)
- `thamkhao/deutschtiger-frontend/plans/260706-0232-flutter-app-port/04-security-auth-api-keys-ai-architecture.md` (bảo mật)
- `thamkhao/deutschtiger-frontend/plans/260706-0232-flutter-app-port/05-open-decisions-resolved.md` (R1–R8 đã chốt)
- `thamkhao/deutschtiger-frontend/plans/260706-1111-onboarding-placement-test/plan.md`
- `thamkhao/deutschtiger-frontend/plans/260706-1118-pwa-offline-review/plan.md`
- `thamkhao/deutschtiger-frontend/plans/260706-1151-golden-moment-links-nav-usage-fix/plan.md`
- `thamkhao/deutschtiger-frontend/plans/260706-1112-paid-funnel-conversion-analytics/plan.md`
