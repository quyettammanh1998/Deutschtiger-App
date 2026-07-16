# Phase 11 — Media: listening, youtube, video library, interview, course, reading, news

Scout: `scout-260716-2324-ui-fidelity-media-reading-news-report.md`.
**Supersede (v2):** phase này sở hữu UI media, thay scope UI GĐ2 P1; giữ 2 điều
kiện GĐ2 P1: (a) shadowing/dictation record-path gate flag voice — UI đầy đủ,
mic chưa live; (b) tuân thủ YouTube ToS notes của GĐ2 P1 (không tải/cache video,
dùng player chính thức).

**Chạy 4 wave BẮT BUỘC (v2 — 22 màn):** W1 listening+podcast (6), W2 youtube+
video-library+interview (8), W3 course (3), W4 reading+news+read-listen shell (5).

## Màn & việc chính

| Web | Flutter | Việc |
|---|---|---|
| `listening-hub-page` | `listening_hub_screen.dart` | 10 thumbnail source cards (Easy German A1–C1, YouTube, Audiobook...), PageIntro — bỏ 3 gradient rows |
| `easy-german-page` (:level) | mới | Tách route khỏi podcast (URL collision hiện tại) |
| `easy-german-podcast-page` | `easy_german_podcast_page.dart` | Theme tím, duration-bucket chips, stats strip, pagination, leaderboard |
| `easy-german-podcast-player-page` | `easy_german_podcast_player_page.dart` | Bottom sticky player bar, word-level purple highlight, settings dialog, word lookup, auto-scroll |
| `sprechen-b1/b2-page` | `sprechen_b1_page.dart`/`b2` | Rebuild từ coming-soon → collections 145/79 video, tabs, progress, leaderboard |
| `youtube-tracker-page` | `youtube_tracker_screen.dart` | Breadcrumb+header card, ContinueWatching, thumbnail grid, pagination; bỏ stats row tự chế |
| `youtube-watch-page` | `youtube_watch_screen.dart` | Cinema mode, floating subtitle, practice buttons, transcript inline dưới info |
| `youtube-dictation-page` | `youtube_dictation_screen.dart` | DictationPanel đầy đủ (sentence/word/cloze, settings, XP) — hiện stub |
| `youtube-shadowing-page` | `youtube_shadowing_screen.dart` | Shadowing mode + player slot — hiện stub |
| `video-library-tracker/-watch` | `video_library_*.dart` | Motivation line, level pill xanh, amber started, zero-padded circles; sticky player, transcript inline, comments, playlist thumbnails |
| `interview-tracker/-watch` | `interview_roadmap_screen.dart`, `video_player_screen.dart` | PurchaseGate (flag premium), progress+motivation, leaderboard; watch: transcript toggle, playlist card, comments |
| `course-hub/-detail/-lesson` | `journey/courses_*.dart` | Search, stats bar, level pills, premium locks, poster cards; detail: score %/status pills, pagination; lesson: video playback + lesson strip + transcript + vocab audio + comments |
| `reading-page` | `reading_hub_screen.dart` | 2-col gradient level cards + progress rings + tab shell + topic accordion + C2 |
| `reading-detail-page` | `reading_detail_screen.dart` | Exercises quiz (completion gate), save-words CTA, selection lookup; bỏ stats header |
| `reading-feed-page` | `reading_feed_screen.dart` | Thumbnails, chip styling, empty-state CTA card |
| `read-listen-hub-page` | mới | Tab shell Đọc/Nghe/Tin tức bọc reading/listening/news |
| `news-page` | `news_list_screen.dart` | Tab shell + NewsLeaderboard; weekly ring xuống dưới list |
| `news-detail-page` | `news_detail_screen.dart` | Level-tip box, save-words CTA, selection lookup, image sizing |

## Xóa

- `listening_coming_soon.dart`, stats strip listening-hub, `_StatsRow` youtube
  tracker, `ReadingHeader` reading-detail (Flutter-only extras).

## Ghi chú kỹ thuật

- Video: `youtube_player_iframe` không thể copy 100% chrome custom của web
  (`YouTubeEmbeddedPlayer`) — chấp nhận deviation: controls native player, nút
  "hoàn thành" đặt dưới player như web (ghi rõ trong report khi ship).
- Route align: `/listening/podcast/easy-german`, `/reading/:level/:slug`,
  `/course/*` + redirects.
- Selection lookup + save-words CTA + markdown renderer: lấy từ P1 primitives
  (đã hoist, v2) — không tự dựng.

## Validation

- Player flows chạy data live; dictation/shadowing XP ghi nhận đúng contract.
- analyze + tests listening/youtube/reading/news pass; l10n đủ.
