# Đánh giá kiến trúc Flutter V1 — DeutschTiger

**Date:** 2026-06-03 | **Type:** architecture evaluation
**Method:** 2 workflow đa tầng, 22 agent đọc sâu codebase + adversarial verify (1.6M tokens)

---

## Câu hỏi: Kiến trúc V1 có hợp lý + hỗ trợ version sau (parity với web) không?

**Trả lời: CÓ — về cơ bản đúng, right-sized cho 50+ domain. Nhưng có 1 quyết định sai nghiêm trọng đã sửa (Firebase Auth → Supabase Auth).**

Scale web: 158 pages, 555 components, 232 lib services, 109 handlers, 72 migrations, 47 domain, 449 route registrations. V1 chỉ chạm ~15 endpoint → growth path rất dài, cấu trúc phải scale tốt.

---

## Verdict 2 assessor độc lập: `sound-with-changes`

### Strengths (verified)
- Feature-first `lib/{core, features/<name>/{data,domain,presentation}, shared}` + Riverpod → scale 50+ domain không rewrite. Mỗi web lib domain map 1:1 sang feature folder.
- Backend API-first thật sự: frontend không query Supabase REST trực tiếp; dio + JWT interceptor dùng đúng endpoint web SPA dùng.
- FSRS 100% server-side → Dart không reimplement thuật toán.
- `GET /user/dashboard-init` trả profile+gamification+missions+continue trong 1 call → Home ít chattiness.
- Data model nông, freezed-friendly. Design tokens semantic (CSS vars light/dark) map thẳng ThemeData.
- WebView bridge đã có precedent: `auth_bridge_handler.go` (one-time token, 5-min TTL).
- Storage proxy `storage_proxy_handler.go` ký URL bằng service key → KHÔNG phụ thuộc auth provider của client.

---

## CRITICAL risk đã sửa: Firebase Auth → Supabase Auth

**5/7 high-critical risks hội tụ về CÙNG 1 quyết định. Adversarial verify: CONFIRMED-REAL, severity nếu có là understated.**

Bằng chứng verified trong code:
- `migrations/002_profiles_gamification.sql:8` → `profiles.id TEXT PRIMARY KEY`. Lines 29/49/65 → user_gamification, user_preferences, xp_daily_log đều `REFERENCES profiles(id) ON DELETE CASCADE`. Toàn bộ data model key vào 1 id này.
- `profile_repo.go GetOrCreateProfile` → `INSERT INTO profiles (id) VALUES ($1)` với `$1 = sub` plumbed thẳng từ `auth.go:259` (`claims.GetSubject()` → UserIDKey). **Zero indirection.**
- `config.go:58` → 1 `JWKS_URL` env. `main.go:621` → 1 `NewJWKSCache`. Không có nguồn key thứ 2.

→ Firebase Auth = `sub` là Firebase UID ≠ Supabase UUID → cùng 1 người login web + mobile = **2 profiles tách biệt** (streak/XP/flashcard rời nhau). Phải làm thêm: dual-JWKS middleware + bảng auth_identities + account-merge migration + Firebase→Supabase token exchange cho WebView. Khi V2 có social/leaderboard → identity fragmentation thành thảm họa.

**Quyết định (user-locked): Supabase Auth cho tất cả. Firebase chỉ FCM push (không firebase_auth). → zero backend auth change.**

---

## Các risk khác (verified) + xử lý

| Risk | Verdict | Xử lý V1 |
|---|---|---|
| Audio/TTS 3-layer fallback under-specified | context-dependent (downgrade high→medium) | AudioService mỏng ở core: `play({audioUrl, text})` → just_audio; fallback POST `/user/tts/vocab-cache`. Vài giờ, không phải 1-2 ngày. |
| WebView lessons = logged-out website (4.2) | context-dependent | Native hóa cái đã có JSON-API (interview); WebView chỉ 3 route coupling/AI. |
| Premium reachable qua WebView (3.1.1) | medium | Ẩn mọi CTA mua trong WebView (UA suffix/query param). Premium read-only native. |
| Push permission timing + APNs | medium | Xin permission SAU khi vào Home (contextual). Cấu hình APNs. |
| Account Deletion + Privacy (5.1.1v) | medium | `DELETE /user/account` (cascade FK đã sẵn) + link trong Profile. |
| Offline/empty/error states | low | Hive/sqflite cache mỏng cho dashboard-init + due-cards. Loading/empty/error mỗi screen. KHÔNG full offline sync. |
| FSRS rating mismatch (word-reviews string vs srs int 1-4) | low | Chốt 1 endpoint + 1 grade-mapping module ở core. Cấm trộn. |

---

## Native readiness — ranked (workflow 2)

**Native dễ nhất → khó:** vocabulary browser (public API, no auth) > flashcard review > daily-review SRS (cùng họ endpoint) > interview videos (youtube_player_flutter).
**WebView (3 route):** reading (coupling exam UI), writing B1 (cần AI Qwen grading), grammar.
**Defer:** listening (kẹt YouTube/audio asset — backend chỉ có JSON transcript, không có mp3 standalone), AI grading, leaderboard, social, IAP, full exam.

---

## Khuyến nghị structural cho future-proof (đưa vào V1)

1. **Core seam layer** `lib/core/{network, auth, identity, audio, push, storage, webview, realtime-stub}` — feature KHÔNG import dio/supabase trực tiếp. Đây là điểm chèn cho domain khó V2+ (realtime/AI/payment) không sửa code feature.
2. **Identity model** resolve từ backend `/user/profile` (profiles.id), KHÔNG từ auth SDK — decouple feature khỏi auth provider.
3. **TokenProvider interface** — interceptor xử lý 401→refresh→retry tập trung, đổi nguồn token không chạm feature.
4. **WebView migration ladder** — mỗi route WebView có target version native-ize; backend API-first nên mọi route có path native rõ ràng cùng `/api/v1`.
5. **Document deferred-domain migration map** trong docs/ (realtime, audio streaming, AI, payment/IAP, offline) — V2+ implement sau interface V1.

---

## Backend changes V1 (tối thiểu)

| Change | Bắt buộc |
|---|---|
| `POST /user/fcm-token` + bảng `fcm_tokens` + Firebase Admin send | ✅ |
| `DELETE /user/account` (5.1.1v) | ✅ |
| WebView purchase-hide flag | ⚠️ nếu dùng WebView |
| Dual-JWKS / account-merge / token-bridge | ❌ loại bỏ nhờ chọn Supabase |

---

## Unresolved Questions

1. **Google/Apple Sign-In native** có cần V1 không, hay chỉ email/password? (supabase_flutter hỗ trợ cả 2; Apple Sign-In bắt buộc nếu có social login khác trên iOS).
2. **Backend production URL/HTTPS** cho app release — VPS đã có domain chưa?
3. **Firebase project** cho FCM — tạo mới hay đã có?
4. **Bug web hiện tại** (task.md nhắc) — ở backend hay frontend? Nếu backend, fix trước khi Flutter call API.
5. **Interview videos premium-gated** — V1 free users thấy gì? (gate server-side trả 403; cần UX cho non-premium).
