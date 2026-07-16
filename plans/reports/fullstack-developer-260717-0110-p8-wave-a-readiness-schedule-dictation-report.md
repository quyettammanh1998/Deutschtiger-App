# Wave A / Group B — Exam Readiness, Schedule, Dictation Web-Parity Rebuild

## Scope executed
Rebuilt 3 screens to match `deutschtiger-frontend` block order/structure, using `context.tokens` only (no `DesignTokens`/`AppColors` in new code) and Phase-1 primitives (`PageIntro`, `StickyCtaBar`). Split into `lib/screens/exam/widgets/{readiness,schedule,dictation}/`.

## exam_readiness_screen.dart — DONE
Files: `exam_readiness_screen.dart` + `widgets/readiness/{readiness_goal_header,readiness_band_card,readiness_stat_pills,readiness_score_trend,readiness_skill_bars,readiness_weakness_list,readiness_todo_card}.dart`.

Block order matches web: PageIntro → goal header (reused `learnGoalProvider` + existing `ExamGoalSetterSheet` built for the home dashboard, so goal cache/invalidation stays single-source) → colored readiness band (0/50/100 gradient bar) → 3 stat pills → score trend sparkline (`CustomPainter`) → skill bars with "Luyện {weakest}" CTA → grammar weakness list (sai→sửa examples + per-error-type practice route) → "Việc cần làm" (due-review link only).

**Deviation / gap:** web's "Từ thi sai" checklist (`fetchExamFailWords`/`addExamFailWordsToReview`, add-to-review CTA) has **no Flutter data source at all** — not even a read endpoint wired in `exam_readiness_repository.dart` or `exam_ecosystem_models.dart`. Per your instructions I omitted the section entirely rather than fake it. Coordinator/backend-agent: need `GET /exam-fail-words` + `POST /exam-fail-words/add-to-review` wired into `ExamReadinessRepository` + a provider before this can ship.

Route CTAs wired (routes I verified exist, did not create): `/reading`, `/listening`, `/speaking`, `/grammar`, `/focus-session`, `/games/konjugation`, `/games/cases/akk-dat`, `/games/word-order`, `/games/cases/wechselprep`, `/games/article`. `schreiben` skill has no dedicated catalog route → falls back to `/exam` (matches web's own fallback pattern).

## exam_schedule_screen.dart — DONE
Files: `exam_schedule_screen.dart` + `widgets/schedule/{schedule_pill_tabs,buddy_count_strip,buddy_card,buddy_directory_tab,my_registrations_tab,registration_form_sheet}.dart`.

Pill tabs (list/mine, active = solid primary) → BuddyCountStrip → status tabs (upcoming/past) + search + type/level filters + paginated buddy cards (skill icon chips, days-until badge) → "mine" tab keeps the existing registration CRUD (moved into `registration_form_sheet.dart`) plus a folded-in privacy note (web's `PrivacyNote`/`MyPlanCard` aside).

**Deviation:** web's `ExamBuddyAside` desktop rail and `ExamBuddyTrust` (FAQ + testimonials + founder story + "học thử miễn phí" CTA) are anonymous-visitor / desktop-only concerns — this app is always-logged-in, mobile-only, so both are intentionally dropped (documented in the screen's doc comment) rather than ported as dead UI. Contact-reveal / messaging still omitted — pre-existing backend gap noted in `exam_registration_repository.dart` (report/block missing).

Month/location filters from web (`uniqueMonths`/`uniqueLocations`) trimmed to type+level+search for scope — noted as a minor gap, not data-blocking.

## exam_dictation_screen.dart + exam_dictation_picker_screen.dart — DONE (picker unchanged)
Files: `exam_dictation_screen.dart` + `widgets/dictation/{dictation_activity_menu,word_selection_panel,word_selection_clip_card,dictation_cue,dictation_diff,sentence_gap_text,cloze_practice_card,cloze_practice_view,cloze_mistake_list,dictation_end_screen,full_practice_sentence_card,full_practice_view,full_dictation_diff_text,timed_clip,clip_tab_bar,karaoke_view,karaoke_sentence_list}.dart`.

**Constructor signature unchanged** — still `ExamDictationScreen({provider, level, slug})`. No route changes needed; the picker screen (`exam_dictation_picker_screen.dart`) is untouched and still works as today's entry point (route `dictation` with no params still valid, `dictation/:provider/:level/:slug` unchanged).

Implemented the full 3-activity web flow using `just_audio` directly (not the simpler `ExamAudioPlayer` widget — word-timed auto-pause needs raw seek/position-stream control that widget doesn't expose):
- **Menu**: 3 activity cards (cloze / full dictation / karaoke), matches web icons/copy.
- **Cloze (điền từ)**: prep phase = tap-to-select collapsible Teil transcript + sticky bottom CTA (`StickyCtaBar`) showing "Bắt đầu luyện nghe — N từ"; practice phase = sequential single-word-gap quiz — plays audio, auto-pauses at the cued word, learner types the answer, check/skip/reveal/replay, progress bar, first-letter hint after 1 wrong attempt, end screen with mistake recap.
- **Full dictation (chép chính tả)**: per-clip, per-sentence — play sentence, type it back, word-level diff coloring (correct=green, wrong=red strikethrough+underline), next/result screen, clip tab bar to jump between Teile.
- **Karaoke (nghe & đọc theo)**: per-clip play/pause, sentence list highlights the currently-playing sentence, tap any sentence to seek there, prev/next clip nav.

**Deviations (documented in-code, not silently dropped):**
1. **No SRS/FSRS push.** Web calls `srsService.recordPractice(...)` after every session (cloze + full dictation) to feed spaced repetition. The Flutter app has no equivalent `srsService`/endpoint wired anywhere I could find (`grep`'d for `recordPractice`/`/srs/` — nothing). Omitted entirely rather than faking a POST. **Backend/coordinator: need to confirm whether such an endpoint exists server-side and, if so, wire a repository method + call site.**
2. **Word-level diff is positional, not Levenshtein-aligned.** Web's `sentence-diff.ts` source wasn't read (out of my file scope to fetch beyond the components list given); I implemented a straightforward index-by-index token comparison (`dictation_diff.dart`). Functionally correct for the common case (typed sentence same length as expected) but won't re-align on insertions/deletions the way a real diff would. Flagged as a follow-up if a tester finds edge-case wrongness.
3. **Karaoke highlight is sentence-granularity, not per-word tap-to-translate.** No shared word-highlight transcript widget exists in the Flutter app (`lib/widgets/interview/transcript_panel.dart` is interview-specific, not reusable). `KaraokeSentenceList` highlights + seeks by sentence only.
4. **Cloze "pick" mode (multiple-choice alternative to typing) and the 1×/0.75× playback-speed toggle were trimmed** for scope — type-only input, 1× speed only. Core flow (play→pause→type→check) is intact.
5. **Replay-sentence in cloze practice** re-seeks to sentence start and lets the existing auto-pause-at-cue-start listener stop it again (approximation of web's exact-stop-at-sentence-end via a temporary listener swap) — behaviorally very close but not a byte-identical port.

## LOC follow-up (not blocking, noted per dev-rules "consider modularizing")
After `dart format` expanded line-wrapping, a few files exceeded the 200-LOC guideline: `buddy_directory_tab.dart` (258), `my_registrations_tab.dart` (238), `cloze_practice_view.dart` (227), `karaoke_view.dart` (227), `full_practice_view.dart` (208), `buddy_card.dart` (202). All are single-purpose (one screen tab / one activity state machine) so further splitting has diminishing returns, but flagging for a follow-up pass if the coordinator wants strict compliance.

## New ARB strings needed (all currently hardcoded Vietnamese literals in the new widgets — none touch the ARB files per your instructions)
| Suggested key | vi | en | de |
|---|---|---|---|
| examReadinessGoalHeaderLabel | Đang luyện cho | Practicing for | Übe für |
| examReadinessGoalDaysLeft | ngày đến kỳ thi | days until the exam | Tage bis zur Prüfung |
| examReadinessGoalTodayLabel | Hôm nay là ngày thi! | Today is exam day! | Heute ist Prüfungstag! |
| examReadinessGoalSetDate | Đặt ngày thi | Set exam date | Prüfungsdatum festlegen |
| examReadinessRecentAvgLabel | Điểm TB gần đây | Recent avg. score | Ø-Punktzahl (kürzlich) |
| examReadinessScoreTrendLabel | Xu hướng điểm | Score trend | Punktetrend |
| examReadinessScoreTrendRecent | lần gần nhất | most recent | zuletzt |
| examReadinessScoreTrendLatest | Gần nhất | Latest | Neuester |
| examReadinessSkillPracticeCta | Luyện {skill} | Practice {skill} | {skill} üben |
| examReadinessWeaknessPracticeCta | Luyện điểm yếu | Practice weak points | Schwächen üben |
| examReadinessWeaknessDrillCta | Luyện → | Practice → | Üben → |
| examReadinessTodoTitle | Việc cần làm | To do | Zu erledigen |
| examReadinessTodoDueReviews | Bạn có {n} từ tới hạn ôn | You have {n} words due for review | Sie haben {n} fällige Wörter |
| scheduleBuddyCountFire | 🔥 {n} bạn còn hạn lịch thi | 🔥 {n} buddies still have an upcoming exam | 🔥 {n} Lernpartner mit anstehender Prüfung |
| scheduleBuddyCountSoon | · {n} người thi trong 30 ngày tới | · {n} exam within 30 days | · {n} Prüfung in 30 Tagen |
| scheduleBuddyCountPast | · {n} đã thi | · {n} already took it | · {n} bereits geprüft |
| scheduleStatusUpcoming | Còn hạn | Upcoming | Bevorstehend |
| scheduleStatusPast | Đã thi | Past | Vergangen |
| scheduleSearchHint | Tìm theo tên / loại thi... | Search by name / exam type... | Suche nach Name/Prüfungstyp... |
| scheduleFilterAllExamTypes | Tất cả kì thi | All exam types | Alle Prüfungstypen |
| scheduleFilterAllLevels | Tất cả trình độ | All levels | Alle Niveaus |
| scheduleEmptyUpcoming | Không có ai còn hạn lịch thi khớp bộ lọc này. | No one matches these filters yet. | Niemand entspricht diesen Filtern. |
| scheduleMyPlansCount | {n} lịch thi · gần ngày thi nhất xếp trước | {n} plans · soonest first | {n} Termine · nächster zuerst |
| scheduleMyPlansEmpty | Bạn chưa đăng ký lịch thi nào | You haven't registered an exam plan yet | Sie haben noch keinen Prüfungstermin |
| schedulePrivacyNote | 🔒 Liên hệ của bạn (SĐT, email, Facebook) ẩn mặc định — chỉ thành viên đã đăng ký mới xem được. | 🔒 Your contact info is hidden by default — only registered members can see it. | 🔒 Ihre Kontaktdaten sind standardmäßig verborgen. |
| dictationActivityMenuPrompt | Chọn hoạt động luyện nghe: | Choose a listening activity: | Wähle eine Hörübung: |
| dictationActivityClozeTitle | Điền từ vào chỗ trống | Fill in the blank | Lücke ausfüllen |
| dictationActivityClozeDesc | Nghe và gõ từ còn thiếu | Listen and type the missing word | Hören und fehlendes Wort eingeben |
| dictationActivityFullTitle | Nghe chép chính tả | Full sentence dictation | Diktat |
| dictationActivityFullDesc | Nghe từng câu và gõ lại cả câu | Listen to each sentence and type it back | Jeden Satz anhören und abtippen |
| dictationActivityKaraokeTitle | Nghe & đọc theo | Listen & follow along | Zuhören & Mitlesen |
| dictationActivityKaraokeDesc | Phụ đề chạy theo audio, chạm từ để tra nghĩa | Subtitles follow the audio | Untertitel folgen dem Audio |
| dictationWordSelectHint | Chạm vào những từ gạch chân trong bài để chọn từ muốn luyện, rồi bấm Bắt đầu. | Tap the underlined words to select them, then press Start. | Tippe auf die unterstrichenen Wörter, dann auf Start. |
| dictationWordSelectCtaEmpty | Chọn ít nhất 1 từ để bắt đầu | Select at least 1 word to start | Wähle mind. 1 Wort aus |
| dictationWordSelectCta | Bắt đầu luyện nghe — {n} từ | Start practice — {n} words | Übung starten — {n} Wörter |
| dictationClozeCheck | Kiểm tra | Check | Prüfen |
| dictationClozeSkip | Bỏ qua | Skip | Überspringen |
| dictationClozeReveal | Xem đáp án | Show answer | Antwort zeigen |
| dictationClozeMistakesTitle | Từ cần ôn lại | Words to review | Zu wiederholende Wörter |
| dictationEndRetry | Luyện lại | Practice again | Nochmal üben |
| dictationFullDone | Kết quả chép chính tả | Dictation result | Diktat-Ergebnis |
| dictationFullNextClip | Bài tiếp theo → | Next clip → | Nächster Clip → |
| dictationKaraokeBackToMenu | ← Chọn hoạt động | ← Choose activity | ← Aktivität wählen |
| dictationKaraokeHint | Bấm ▶ để nghe — phụ đề tự chạy theo audio. | Press ▶ to listen — subtitles follow along. | Drücke ▶ zum Anhören. |
| dictationKaraokeUntimed | (không có phụ đề đồng bộ) | (no synced subtitles) | (keine synchronen Untertitel) |
| dictationKaraokePrev | ◀ Bài trước | ◀ Previous | ◀ Vorheriger |
| dictationKaraokeNext | Bài sau ▶ | Next ▶ | Nächster ▶ |

## Build check
`flutter analyze lib/screens/exam` → clean (0 errors/warnings in owned files; 3 pre-existing infos in `exam_skill_list_screen.dart`, not mine). Full-repo `flutter analyze` shows only pre-existing issues in other agents' files (`welcome_hero_section.dart`, `home_screen.dart`, some test files) — none introduced by this phase.

**Pre-existing tests now stale (not mine to edit, flagging for coordinator/tester):** `test/screens/exam/exam_readiness_screen_test.dart` and `test/screens/exam/exam_dictation_screen_test.dart` assert against the old flat UI (specific text like "85", "TEIL 1", key `dictation-field-*`) and now fail — expected given the structural rebuild. They need a rewrite matching the new widget tree; I did not touch them per file-ownership (tests weren't listed in my ownership either, and instructions said not to run the full suite / fix broadly).

## Constructor signatures (for coordinator's routing reference — unchanged, confirming no action needed)
- `ExamReadinessScreen()` — no args, unchanged.
- `ExamScheduleScreen()` — no args, unchanged.
- `ExamDictationScreen({required provider, required level, required slug})` — unchanged.
- `ExamDictationPickerScreen()` — untouched, still works as today.

Status: DONE_WITH_CONCERNS
Summary: All 3 screens rebuilt to web block-order/structure using context.tokens + Phase-1 primitives, split into <260-LOC widget files; dictation ships all 3 web activities (cloze/full/karaoke) via just_audio. Concerns: no fail-words data source (omitted, not faked), no SRS push endpoint found (omitted), 2 pre-existing widget tests now stale from the structural rebuild (need coordinator/tester follow-up), 6 files exceed 200-LOC guideline after formatting.
Concerns/Blockers: (1) fail-words endpoints missing entirely in Flutter repo layer — needs backend confirmation + repository/provider before that readiness section can ship; (2) SRS record-practice endpoint existence unconfirmed for the app; (3) stale widget tests need a rewrite pass.
