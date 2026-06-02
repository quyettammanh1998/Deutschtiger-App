# V1 Config & API Map

## Config đã chốt

| Key | Value |
|---|---|
| Supabase URL | `https://hslfnxxcpgormeyvqswa.supabase.co` |
| Supabase anon key | `sb_publishable_RFn6ulgqEgl0boUfRU3YLw_fydwRZnk` (publishable, an toàn ở client) |
| API base URL (prod) | `https://deutschtiger.com/api/v1` |
| Bundle ID / App ID | `com.deutschtiger.app` |
| Firebase (FCM) | Tạo mới ở P5 |
| WebView domain | `https://deutschtiger.com` |

`.env` Flutter (flutter_dotenv):
```
SUPABASE_URL=https://hslfnxxcpgormeyvqswa.supabase.co
SUPABASE_ANON_KEY=sb_publishable_RFn6ulgqEgl0boUfRU3YLw_fydwRZnk
API_BASE_URL=https://deutschtiger.com/api/v1
WEBVIEW_BASE_URL=https://deutschtiger.com
```

## API endpoint map cho V1 (verified từ backend routes)

### Auth (Supabase SDK, không qua Go backend)
- login / signup / forgot / logout → `supabase_flutter`
- token → `Authorization: Bearer <supabase_access_token>` cho mọi call dưới

### Profile (P1/P5)
- `GET /api/v1/user/profile` — profile + premium status (read-only)
- `DELETE /api/v1/user/account` — **CẦN THÊM** (App Store 5.1.1v)

### Home (P2)
- `GET /api/v1/user/dashboard-init` — profile + gamification + missions + continue-learning (1 round-trip)
- `GET /api/v1/user/gamification` — XP/level/streak (fallback nếu cần riêng)
- `GET /api/v1/user/missions/today` — daily missions
- `POST /api/v1/user/missions/record-actions` — claim/progress

### Vocabulary browser (P3 — PUBLIC, no auth)
- `GET /api/v1/vocabulary/topics`
- `GET /api/v1/vocabulary/topic-level-counts`
- `GET /api/v1/vocabulary/by-topic-level?topic={key}&level={lvl}&page=&pageSize=&search=&shuffle=`
- `GET /api/v1/vocabulary/collections` + `/collections/{slug}` + `/collections/{id}/items`
- `GET /api/v1/vocabulary/items-by-level/{level}`
- `GET /api/v1/vocabulary/search?q=`
- `GET /api/v1/vocabulary-page-data`

### Flashcard + SRS review (P3 — auth)
- `GET /api/v1/user/flashcard-decks` + `/{id}` + `/{deckId}/cards`
- `GET /api/v1/user/default-deck`
- `GET /api/v1/user/word-reviews/due?limit=20&source=` — due cards
- `GET /api/v1/user/word-reviews/due-count?source=` — cho mission + push payload
- `POST /api/v1/user/word-reviews/rate` — rating (1-4 hoặc string), FSRS server-side
- `POST /api/v1/user/word-reviews/record-served`
- `GET /api/v1/user/srs/queue?limit=50` — SRS queue (FSRS v3)
- `POST /api/v1/user/srs/review` — rating 1-4
- `POST /api/v1/user/tts/speak` hoặc tts vocab-cache — audio layer 2

### Interview videos (P4 — auth, premium-gated)
- `GET /api/v1/user/interview/videos?group_id=X`
- `PUT /api/v1/user/interview/videos/{id}/complete`
- `PUT /api/v1/user/interview/videos/{id}/rewatch`
- `GET /api/v1/user/interview/group-progress`
- `GET /api/v1/user/interview/stats`
- static: `GET /data/youtube/phong_van/learning-path.json`

### Push (P5 — CẦN THÊM)
- `POST /api/v1/user/fcm-token` — **CẦN THÊM** + bảng `fcm_tokens` + Firebase Admin send path
- Web push VAPID (`/push-subscriptions`) giữ nguyên cho web

### WebView routes (P4)
- `https://deutschtiger.com/reading`
- `https://deutschtiger.com/exams/goethe-b1/writing`
- `https://deutschtiger.com/grammar`
- Auth bridge: precedent `auth_bridge_handler.go` (one-time token 5-min TTL)

## Backend changes cần làm (tổng kết)
1. ✅ `POST /api/v1/user/fcm-token` + bảng `fcm_tokens` + Firebase Admin send
2. ✅ `DELETE /api/v1/user/account` (cascade FK đã sẵn)
3. ⚠️ WebView purchase-hide flag (detect app qua custom User-Agent / query param)
