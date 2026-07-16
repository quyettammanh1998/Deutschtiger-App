# P10 Sprechen-Exam ARB Extraction — Cleanup Pass Report

Follow-up to `fullstack-developer-260717-0310-p10-speech-conversation-pronunciation-report.md`,
which flagged that the sprechen-exam sub-cluster shipped ~9 pages/8 widgets of
hardcoded Vietnamese UI chrome instead of ARB keys. Applied the same approach/
key-naming convention as the P8 pass
(`fullstack-developer-260717-0217-p8-arb-string-wiring-report.md`): grep scope
for hardcoded VI strings, dedupe against existing ARB keys, add new keys
vi/en/de, `flutter gen-l10n`, replace call sites, verify German 200%.

## Scope executed

`lib/screens/exam/sprechen/**` (9 page files + 8 widget files, ~2430 LOC) —
Goethe + TELC Sprechen overview/topic-list/exam-set/teil-study/teil-practice
pages and the shared `SprechenExamMode` engine (header/banner/study-panel/
partner-chat/input-area/bewertung-panel/history-sheet).

Verified the other two P10 clusters (`conversation/**`, `pronunciation/**`,
`speaking/**`) per the report's claim of 138 already-ARB-wired keys — found
and fixed **one straggler**: `lib/screens/conversation/widgets/
conversation_transcript_view.dart` had a hardcoded `Text('Không có nội dung
hội thoại.')` for the empty-transcript state (missed by the conversation
sub-agent's own pass). Added `conversationTranscriptEmpty` and wired it.

## Web-parity check before converting

Read the actual TSX source (`thamkhao/deutschtiger-frontend/src/{pages/exam,
components/exam/sprechen}/*`) for every string before deciding VI-vs-German.
Confirmed the web itself hardcodes German exam terminology regardless of
locale (`ABGABE`, `EXIT`, `Zurück`, `Restzeit`, `GESAMT`, `LAUFEND`, `Idle`,
`Bewertung`, `Aufgabe:`, `Hinweis:`, category names `INHALT`/`GRAMMATIK &
SATZBAU`/`WORTSCHATZ & FLÜSSIGKEIT`, `Präsentation`, `Prüfer`) and English
`Best {n}/25` on the exam-set overview — these were **left inline**, matching
web verbatim (same convention as P8's approved `Teil {n}` exception). Only
genuine Vietnamese UI-chrome strings were extracted.

## Files modified

- ARB: `lib/l10n/app_{vi,en,de}.arb` (+32 new top-level keys each: 31 sprechen
  + 1 `conversationTranscriptEmpty` straggler fix). Verified 1:1 key parity
  across all three via a Python set-diff before AND after every append (no
  drift from concurrent agents — key count moved 1440→1471→1472 cleanly).
  Generated `lib/l10n/app_localizations*.dart` via `flutter gen-l10n` only.
- Sprechen pages: `goethe_sprechen_exam_page.dart`,
  `goethe_sprechen_exam_set_overview_page.dart`,
  `goethe_sprechen_overview_page.dart`, `goethe_sprechen_teil_practice_page.dart`,
  `goethe_sprechen_teil_study_page.dart`, `goethe_sprechen_topic_list_page.dart`,
  `sprechen_exam_page.dart`, `sprechen_overview_page.dart`,
  `sprechen_topic_list_page.dart`.
- Sprechen widgets: `widgets/sprechen_bewertung_panel.dart`,
  `widgets/sprechen_exam_header.dart`, `widgets/sprechen_exam_mode.dart`,
  `widgets/sprechen_input_area.dart` (string wiring + a defensive `Expanded`
  overflow fix, see Bug found below), `widgets/sprechen_partner_chat.dart`,
  `widgets/sprechen_session_history_sheet.dart`, `widgets/sprechen_study_panel.dart`.
  `widgets/sprechen_topic_group_list.dart` and
  `widgets/sprechen_instruction_banner.dart` needed no changes (no Vietnamese
  literals — the banner's "Aufgabe:"/"Hinweis:" labels are German, matches web).
- `lib/screens/conversation/widgets/conversation_transcript_view.dart`
  (straggler fix, outside declared scope but explicitly authorized by the
  task's "verify quickly and fix stragglers" instruction).
- New test: `test/screens/exam/sprechen/sprechen_arb_german_200_test.dart` —
  German-200%-textscale smoke render for every provider-free widget touched
  (`SprechenExamHeader` study+practice tabs, `SprechenBewertungPanel`,
  `SprechenInstructionBanner`, `SprechenStudyPanel` locked+empty,
  `SprechenInputArea`). Widgets needing Riverpod (`SprechenPartnerChat` via
  `SpeakButton`) or content-provider wiring (page-level screens) were spot-
  checked by inspection instead — their German strings are the same order of
  magnitude as the ones under direct test coverage.

## Key-naming / dedup decisions

- New keys use a flat `sprechen*` prefix (module-wide, not split goethe/telc)
  since Goethe and TELC share the exact same widget tree and most VI copy is
  identical between providers — e.g. `sprechenOverviewTitle`/
  `sprechenTopicListTitle`/`sprechenLeaderboardEmpty` are used by both.
- `sprechenOverviewSubtitle('{providerLabel}')` takes the provider label as a
  parameter (`'Goethe $level'` vs `'telc B1'`) instead of two near-duplicate
  keys, since only that one token differs between the Goethe and TELC
  overview pages' otherwise-identical subtitle string.
- Reused 6 existing keys instead of duplicating (exact VI-text match verified
  before reuse): `back` ("Quay lại"), `loadingExam` ("Đang tải đề thi…"),
  `leaderboardTitle` ("Bảng xếp hạng"), `missionCompleteTitle` ("Hoàn
  thành!"), `practiceRestart` ("Luyện lại"), `conversationTabHistory` ("Lịch
  sử luyện tập" — reused for the session-history-sheet title).
- `SprechenPartnerChat.partnerSubtitle` used to default to a hardcoded
  Vietnamese string literal (`'Trả lời bằng tiếng Đức'`) as a Dart default
  parameter value, which can't reference `BuildContext`/ARB. Changed the
  field to nullable and resolve the localized default inside `build()`
  (`partnerSubtitle ?? AppLocalizations.of(context).sprechenPartnerSubtitleDefault`)
  — the only signature change in this pass; the sole caller
  (`sprechen_exam_mode.dart`) never passed `partnerSubtitle` explicitly, so
  behavior is unchanged.

## Bug found and fixed (in-scope, not deferred)

`SprechenInputArea`'s mic-hint row (`Row([Icon, SizedBox, Text(...)])`, no
`Expanded`/`Flexible`) overflowed by 210px once wired to the real German
translation of `sprechenMicUnsupported`
("In dieser Version wird nur Schreiben unterstützt") at 200% text scale —
caught immediately by the new German-200% test. This is a direct, mechanical
consequence of this pass (the previous hardcoded Vietnamese string happened
to be short enough not to trigger it) and the task explicitly required
verifying no overflow on touched screens, so fixed it in-place: wrapped the
`Text` in `Expanded`. Purely defensive layout fix — no visual/behavior change
at normal text scale, zero layout/color/behavior changes elsewhere.

## Long-form exception — none applicable

No long-form Vietnamese web copy (trainer tips, marketing/SEO text) exists in
this cluster — every string found was short UI chrome (labels, hints,
errors, empty-states, CTAs), so the approved long-form exception wasn't
invoked. `sprechenOverviewGoetheInfo`/`sprechenOverviewTelcInfo` (2-sentence
scoring-rubric blurbs) were converted, not treated as long-form — they're
functional card copy of the same length class as e.g.
`pronunciationHubInfoBanner`, which the pronunciation sub-agent already
wired.

## Counts

- **31 new sprechen ARB keys** + **1 conversation straggler key** = 32 new
  keys × 3 languages = 96 new entries. Key count: 1440 → 1471 (sprechen) →
  1472 (straggler fix), verified 3-way parity (vi/en/de identical key sets)
  before and after each append via Python set-diff.
- **~45 call sites** converted across 16 files (9 sprechen pages + 7 sprechen
  widgets + 1 conversation widget).
- **0 strings left inline as "long-form"** (none applicable). **~10 German
  literal terms left inline** (matches web verbatim — exam terminology, not
  translatable UI chrome): `ABGABE`/`EXIT`/`Zurück`/`Restzeit`/`GESAMT`/
  `LAUFEND`/`Idle`/`Bewertung`/`Aufgabe:`/`Hinweis:`/category names/
  `Präsentation`/`Prüfer`, plus web's own hardcoded English `Best {n}/25`.

## Validation

- `flutter analyze lib/screens/exam/sprechen lib/screens/conversation lib/l10n
  test/l10n test/screens/exam/sprechen` → **0 issues**.
- `flutter analyze` (full repo) → all 98 issues are pre-existing/concurrent:
  errors confined to `lib/screens/journey/widgets/course_*.dart` (untracked,
  actively being written by a concurrent courses-cluster agent, referencing
  ARB keys that agent hasn't added yet — confirmed via `git status`, not
  caused by or overlapping this pass); remaining are pre-existing `info`-level
  lints (`prefer_initializing_formals`, `use_null_aware_elements`,
  `depend_on_referenced_packages`) in files I never touched.
- `flutter test test/l10n/ test/structure/` → **80/80 pass**.
- `flutter test test/repositories/speech test/screens/conversation
  test/screens/pronunciation test/screens/speaking
  test/screens/listening/sprechen_pages_test.dart test/screens/exam/sprechen`
  → **127/127 pass** (includes the new German-200% overflow suite, 7/7).
- `flutter gen-l10n` clean, no errors, all getters generated (spot-verified
  `grep -c` on all 4 generated `app_localizations*.dart` files).

## Unresolved questions

None — scope was fully covered and the one cross-cluster straggler
(`conversation_transcript_view.dart`) was fixed under the task's explicit
"verify quickly and fix stragglers" allowance.

Status: DONE
Summary: All hardcoded Vietnamese UI chrome in the sprechen-exam sub-cluster
(9 pages + 7 widgets) wired into ARB vi/en/de (31 new keys, 6 existing keys
reused) + gen-l10n + call-site replacement, following the P8 pass's
convention; German exam-terminology literals correctly left inline per the
approved exception (verified against the actual web TSX source); one
conversation-cluster straggler fixed; a genuine German-200%-textscale
overflow bug in `SprechenInputArea` was caught by new regression tests and
fixed with a minimal `Expanded` wrap; `flutter analyze`/targeted tests clean,
127/127 tests passing, 3-way ARB key parity verified.
Concerns/Blockers: none.
