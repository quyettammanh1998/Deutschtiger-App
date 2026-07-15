# Social non-realtime → live (GĐ2 P3, phần non-realtime)

Spec: `plans/260715-flutter-gd2-extended-coverage/phase-03-social-realtime-and-push.md`.
Scope thực hiện: friends, public profile, moments (đọc+like), messages (poll), announcements, unread-counts.
KHÔNG làm: realtime transport, WebRTC calls, duels, comment/moment write UGC, challenges, push/FCM.

## Per-screen disposition (11 màn cũ → hiện trạng)

| Màn cũ | Disposition | Ghi chú |
|---|---|---|
| `friends_page.dart` | Live | Rewrite hoàn toàn: tabs Friends/Requests/Search, block/remove/accept/reject/send-request đều gọi `FriendRepository`. |
| `messages_page.dart` | Live | Conversations list, poll (mở màn + resume + pull-to-refresh), route param đổi `conversationId`→`friendId`. |
| `chat_page.dart` | Live | Thread theo `friendId`, gửi text, poll refresh (resume + pull), block/view-profile ở menu. |
| `moments_page.dart` | Live | Feed đọc + like/unlike optimistic; comment sheet READ-ONLY (không có ô nhập). |
| `social_screen.dart` (hub) | Live (thu hẹp) | Chỉ còn 2 tab Moments/Friends (bỏ Groups/Challenges khỏi hub); thêm icon Messages (badge unread) + Announcements ở AppBar. |
| `social_hub_screen.dart` | **Xoá** | Duplicate mock 4-tab, không được `app_router.dart` trỏ tới (dead code) — không phải feature đang chạy. |
| `challenges_page.dart` | Gated (giữ nguyên mock) | Ngoài scope (web cũng ẩn); chỉ đổi import sang `social_legacy_mock_models.dart`/`social_legacy_provider.dart`. Gate qua `DEUTSCHTIGER_ENABLE_SOCIAL_CHALLENGES` (default false), redirect `/social`. |
| `groups_page.dart`, `group_detail_page.dart` | Gated (giữ nguyên mock) | Ngoài scope — backend có `internal/feature/social/group` nhưng web KHÔNG có UI groups tương ứng. Gate qua `DEUTSCHTIGER_ENABLE_SOCIAL_GROUPS`. |
| `duel_lobby_page.dart`, `duel_play_page.dart` | Gated (giữ nguyên mock, DEFER) | Owner đã defer realtime/WebRTC calls; duels cần POC riêng GĐ2 P3 sau. Gate qua `DEUTSCHTIGER_ENABLE_SOCIAL_DUELS`. |

Mới tạo (ngoài 11 màn, do scope yêu cầu):
- `profile_page.dart` — public profile `/social/profile/:userId` (tương đương web `/u/:id`). Có nút add-friend/accept/block, chat, report (mailto).
- `announcements_page.dart` — list read-only, web hiện chỉ có banner component trên dashboard/exam-page; mobile tạo màn riêng để nằm trong file ownership `lib/screens/social/**`.

## Backend routes wired

- Friends: `GET /user/friends`, `/friends/pending`, `/friends/search?q=`, `/friends/status/{id}`; `POST /friends/request`, `/friends/block`; `PUT /friends/{id}/accept`; `DELETE /friends/{id}/reject`, `/friends/{friendshipId}`.
- Messages: `GET /user/messages/conversations`, `/messages/{friendId}`, `/messages/unread-count`; `POST /messages`; `PUT /messages/{senderId}/read`.
- Moments: `GET /moments/feed`, `/moments/{id}/comments`; `POST /user/moments/{id}/like`; `DELETE /user/moments/{id}/like`.
- Announcements: `GET /api/v1/announcements?public_only=true`.
- Public profile: `GET /api/v1/profiles/{userId}`.
- Unread badge: `GET /user/unread-counts`.

## Block / Report (UGC safety)

- Block wired at every user-user surface: friend card menu, chat menu, profile menu → `POST /user/friends/block`. Backend has **no unblock/list-blocked endpoint** — documented gap in `docs/api-changelog.md`; blocked users simply disappear from friends/requests lists client-side.
- Report has **no backend endpoint at all**. Per decision, profile menu opens a pre-filled `mailto:support@deutschtiger.com` instead of a silent no-op or hidden action. Flagged as an Apple UGC-review store blocker (visible report path exists, but no moderation trail) in `docs/api-changelog.md` — does not block this code change.
- Web itself has `useBlockUser`/`blockUser` service code but **no UI wired to it anywhere** (`grep` confirmed dead capability on web too) — mobile wiring block everywhere is a deliberate product decision from the task spec, not web parity.

## Files

Data (new, plain Dart, no freezed): `lib/data/social/{friend_models,message_models,moment_models,announcement_model,public_profile_model,unread_counts_model,social_legacy_mock_models}.dart`. Deleted: `social_models.dart` + `.freezed.dart`/`.g.dart`.

Repositories (new, one per boundary): `lib/repositories/social/{friend_repository,message_repository,moment_repository,announcement_repository,public_profile_repository,unread_counts_repository,social_legacy_mock_repository}.dart`. Deleted: `social_repository.dart` (100% mock).

View-models: `lib/view_models/social/{social_repository_providers,friends_provider,messages_provider,moments_provider,announcements_provider,public_profile_provider,social_legacy_provider}.dart`. Deleted: `social_provider.dart`.

Screens: rewrote `friends_page.dart`, `messages_page.dart`, `chat_page.dart`, `moments_page.dart`, `social_screen.dart`, `widgets/friends_list.dart`, `widgets/moments_feed.dart`; created `profile_page.dart`, `announcements_page.dart`; import-only fix on `challenges_page.dart`, `groups_page.dart`, `widgets/challenges_list.dart`, `widgets/study_groups_list.dart`; deleted `social_hub_screen.dart`.

Router (`lib/navigation/app_router.dart`): added `/social/profile/:userId`, `/social/announcements`; renamed `chat/:conversationId` → `chat/:friendId`.

Flags (`lib/core/release/release_feature_flags.dart`): `social` default → `true`. Added `socialGroups`/`socialChallenges`/`socialDuels` (all default `false`). `lib/navigation/release_redirect.dart`: added independent redirects for `/social/groups`, `/social/group`, `/social/challenges`, `/social/duel` → `/social`.

Tests: `test/repositories/social/{friend,message,moment}_repository_test.dart` (18 contract tests), `test/screens/social/{friends_page,moments_page,chat_page}_test.dart` (8 widget tests incl. block flow, like toggle, send+poll-refetch). Updated `test/navigation/release_redirect_test.dart` (new sub-route cases), `test/structure/view_models_layer_test.dart` (path list), `test/structure/release_live_data_guard_test.dart` (whitelisted new live files).

Docs: `docs/flutter-live-data-inventory.md` (`/social/**` row split Live vs Blocked-gated), `docs/api-changelog.md` (gap entry, GĐ2 P3).

## Verification

- `flutter analyze`: 0 errors (5 pre-existing info/warning unrelated to this change).
- `flutter gen-l10n` + 3 ARB files updated (en/vi/de) with `social*` keys.
- `flutter test`: 497 tests, all green (one transient failure on an earlier run under concurrent-agent file contention did not reproduce on rerun — final run is clean).

Status: DONE
Summary: Social friends/messages/moments/profile/announcements chuyển sang live qua backend Go thật; block wired everywhere, report → mailto (backend chưa có endpoint); groups/challenges/duels giữ mock, gate riêng độc lập với cờ `social` chính (giờ default true).
Concerns/Blockers: Report có visible UI nhưng không có backend moderation trail thật — Apple Store review có thể vẫn cần thêm trước khi ship; không có unblock endpoint (UX một chiều); nếu 1 trong 3 agent song song sau này sửa `challenges_page.dart`/`groups_page.dart` xin giữ nguyên phần import mới (`social_legacy_mock_models.dart`/`social_legacy_provider.dart`).
