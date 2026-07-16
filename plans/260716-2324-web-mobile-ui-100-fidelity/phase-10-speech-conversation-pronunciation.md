# Phase 10 — Speech: sprechen, conversation, pronunciation

Scout: `scout-260716-2324-ui-fidelity-speech-conversation-report.md`.
13 MISSING, 6 prototype DIVERGENT. Nguyên tắc: dựng UI đúng web NGAY, phần
record/STT live gate flag voice (MASTER P8 wire sau) — không chờ voice mới làm UI.
**Supersede (v2):** MASTER P8 thu hẹp thành voice-wiring-only vào UI phase này
dựng (đã ghi plan.md); `features/voice/*` recording stack GIỮ để MASTER P8 tái
dùng — không xóa. Contract sprechen (topics/sessions — đã verify tồn tại backend)
theo rule contract-trước-code.

## Màn

| Web | Flutter | Việc |
|---|---|---|
| `goethe-sprechen-overview` (/exams/goethe/b1/sprechen) | mới | 3-Teil row card (amber/rose/blue tiles, progress bars) |
| `goethe-sprechen-topic-list` | mới | Tag-group accordions, lock/done icons, leaderboard |
| `goethe-sprechen-teil-study` | mới | Study cards + rubric sheet + fixed bottom "🎤 Luyện nói" CTA |
| `goethe-sprechen-teil-practice` + `-exam` + `-exam-set-overview` | mới | SprechenExamMode (chat + recorder + Bewertung) — component dùng chung |
| `sprechen-overview/-topic-list/-exam` (TELC /noi) | mới | Sky/rose/amber rows + search + community topics |
| `goethe-sprechen-from-exam(-teil)` | — | KHÔNG port (legacy, web chỉ redirect); thêm redirect router |
| `conversation-hub-page` (/conversation — bottom tab 4) | `screens/speaking/conversation_hub_page.dart` | Rebuild: tabs/hero/filters/grid/history; route `/conversation` |
| `conversation-scenario-page` | `conversation_scenario_page.dart` | Bỏ side-panel desktop; examiner sheet, voice panel, survey, done screen |
| `conversation-history-detail` | mới | Verdict card + transcript |
| `interview-import-page` | mới | Paste-doc → extract → edit flow |
| `pronunciation-hub` | `screens/pronunciation/pronunciation_screen.dart` | Card grid đúng titles/order, sửa dead onTap, bỏ AppBar cam |
| `umlaute/ich-ach/r-sound/sp-st` trainers | `screens/speaking/*_trainer_page.dart` | Theo template web: listen-only drill + quiz + game wall; tiếng Việt; routes `/pronunciation/*`; r-sound thêm overview 4-position |
| `minimal-pairs` | mới | Picker → drill → summary |

## Xóa

- `speaking_screen.dart` (/speaking), `speaking_hub_screen.dart`, `shadowing_page.dart`,
  `screens/exam/goethe_speaking_page.dart` (Teil A/B/C tự chế),
  `features/pronunciation/widgets/pronunciation_practice.dart`,
  `widgets/speaking/pronunciation_practice_widget.dart`.
- `features/voice/*`: GIỮ (MASTER P8 wiring dùng) — chỉ dọn phần chắc chắn chết
  sau khi MASTER P8 xác nhận.

## Validation

- Trainer listen-only chạy live TTS (`audio.deutschtiger.com`) — không cần mic.
- SprechenExamMode UI render + gate flag voice; analyze + tests + l10n.

## Risks

- Tab 4 bottom nav đổi thành /conversation ở P1 — phase này phải ship hub sớm
  để tab không trỏ placeholder (phối hợp thứ tự với P1: có thể giữ flag gate
  hub tới khi phase này xong).
