# Pronunciation Trainer Cluster Rebuild — Phase 10 Report

Scope: `/pronunciation` hub + umlaute/ich-ach/r-sound/sp-st trainers +
`/pronunciation/minimal-pairs`, listen-only (no mic anywhere, matches web).

## Per-screen: done vs scout B.16–B.21

| # | Screen | Status | Notes |
|---|---|---|---|
| B.16 | Hub (`pronunciation_screen.dart`) | Done | Back → `/games`, blue info banner, 4-module grid, correct titles/order/emoji (violet Umlaute, blue/cyan Ich-Ach, emerald/teal R-Sound, amber/orange Sp/St). Removed orange AppBar + dead `onTap`. Minimal-pairs intentionally NOT linked (matches web). |
| B.17 | Umlaute (`umlaute_trainer_page.dart`) | Done | "Phát âm" drill + "Phân biệt" quiz via shared `MinimalPairQuizCard`. No recorder. |
| B.18 | Ich-/Ach-Laut (`ich_ach_trainer_page.dart`) | Done | Sound badge (blue/amber), "So sánh: `minimal_pair`" line, same quiz shape. |
| B.19 | R-Sound (`r_sound_trainer_page.dart`) | Done | Second tab is **overview** (4 position groups: initial/after-vowel/consonant-cluster/vocalic), not a quiz — matches web exactly, not the generic minimal-pair shape. |
| B.20 | Sp/St (`sp_st_trainer_page.dart`) | Done | Quiz contrasts two independent word pools (sp vs st) rather than a per-item `minimal_pair`, matching web's local `SpStMinimalPairQuiz`. |
| B.21 | Minimal pairs (`minimal_pairs_page.dart`) | Done | picker → drill → summary; no game wall (per web); header adapts back-button/subtitle/trailing "Kết thúc" per screen. |

## Deviation: live backend data, not static Dart content

The phase brief's escape hatch ("port static content as a Dart const file")
assumed web bundles this as static JSON. It doesn't — I read
`thamkhao/deutschtiger-frontend/src/lib/pronunciation/pronunciation-service.ts`
and `minimal-pairs-service.ts` directly: all 4 trainers hit real backend
endpoints (`GET /user/pronunciation/{umlaute|ich-ach-laut|r-sound|sp-st}`)
and minimal-pairs hits `GET /minimal-pairs/contrasts` + `GET /minimal-pairs`.
No `public/`/`src/data/` static file exists for any of this (verified via
`find`). Hardcoding a duplicate word list would violate the repo's "no fake
data" rule and would drift from the live corpus. I built a live repository
instead:

- `lib/data/pronunciation/pronunciation_models.dart` — DTOs (`UmlautItem`,
  `IchAchItem`, `RSoundItem`+`RPosition`, `SpStItem`, `MinimalPairContrast`,
  `MinimalPair`), mirrors `src/types/pronunciation-exercise.ts`.
- `lib/data/pronunciation/pronunciation_repository.dart` —
  `PronunciationRepository(ApiClient)`, same pattern as
  `LearningItemRepository`/`LearnGoalRepository`.
- `lib/data/pronunciation/pronunciation_providers.dart` — Riverpod
  providers, `Provider`+`FutureProvider.family<..., int sessionSeed>` (fresh
  word set per "Luyện lại", mirrors web's `Date.now()`-keyed react-query
  key). Watches `apiClientProvider` from `view_models/providers.dart` by
  **import only** — did not edit that file (coordinator-owned).
- `docs/flutter-api-contract-matrix.md` does not yet list these 4 pronunciation
  endpoints or the 2 minimal-pairs endpoints — flagging for the coordinator
  to add a row under the existing "Speech ecosystem (P10)" section; I did not
  edit that doc since it's outside my file-ownership list.

Contract test coverage:
`test/repositories/pronunciation/pronunciation_repository_contract_test.dart`
(mirrors `learning_item_repository_contract_test.dart`'s fake-Dio-adapter
pattern) — verifies path/query for all 6 endpoints + JSON field mapping,
7 tests, all green.

## XP / GameWallOverlay: deferred, not invented

- Web awards XP on completion (`useAwardXP`) and gates game-plays with
  `GameWallOverlay` on the 4 trainers (not minimal-pairs). Grepped Flutter —
  **no XP-award provider and no `GameWallOverlay` equivalent exist anywhere
  in `lib/`** (only unrelated `widgets/common/game_shell.dart`).
- Per the phase brief ("if genuinely absent, skip that specific gate rather
  than inventing a new paywall mechanism"), I skipped both: completion
  screens show score/accuracy/confetti with no "+XP" chip (fabricating an XP
  number with no backend award call would be fake data), and no wall renders
  before a trainer starts. **Deferred, not implemented** — flag for a future
  phase once gamification/premium-gate infra ships for this cluster.

## Shared widgets (`lib/screens/pronunciation/widgets/`)

- `pronunciation_mode_toggle.dart` — 2-tab segmented control.
- `pronunciation_word_drill_card.dart` — "Phát âm" drill card (word/IPA/
  meaning, amber hint, gradient play button that calls `audioServiceProvider`
  directly — reuses the app's existing TTS pipeline, not `SpeakButton`
  itself since the play control needed a custom gradient CTA shape;
  `SpeakButton`'s own `AudioService.play` call is what's reused).
- `minimal_pair_quiz.dart` — `MinimalPairQuizCard`, the ONE shared
  two-choice-listen-and-pick widget powering umlaute/ich-ach/sp-st "Phân
  biệt" mode AND the minimal-pairs drill round (per brief instruction). Also
  exports `playPronunciationWord`/`playPronunciationAudio` helpers.
- `pronunciation_quiz_rounds.dart` — generic `buildTtsQuizRounds<T>()` shared
  by umlaute + ich-ach (sp-st needs its own two-pool builder, kept local).
- `pronunciation_completion_card.dart` — confetti (reuses
  `shared/widgets/confetti_overlay.dart`) + accuracy% + score + 2 CTAs.
- `pronunciation_status_views.dart` — shared error/empty states.
- `pronunciation_trainer_header.dart` — back button + title/subtitle/trailing
  row.

## Deletions

- `lib/features/pronunciation/widgets/pronunciation_practice.dart` —
  confirmed zero references anywhere (`grep -rl` empty before delete).
  Deleted; the now-empty `lib/features/pronunciation/` dir was removed too.
- `lib/screens/speaking/{umlaute,ich_ach,r_sound,sp_st}_trainer_page.dart` —
  deleted after porting. Only remaining referrer was
  `lib/navigation/routes/speech_routes.dart` (coordinator-owned, will be
  broken until routes are repointed — see below).
- **NOT deleted:** `lib/widgets/speaking/pronunciation_practice_widget.dart`
  (the recorder widget). It's still referenced by
  `lib/screens/speaking/shadowing_page.dart`, which is outside my file
  ownership (scout flags it as dead too, but deleting it isn't in my scope).
  Deleting the widget now would break that file's compile. Flag for
  whoever owns `shadowing_page.dart`'s eventual deletion (scout §C) to also
  delete `pronunciation_practice_widget.dart` at that time.

## Route changes needed (coordinator — `lib/navigation/routes/speech_routes.dart`)

- `/speaking/umlaute` → `/pronunciation/umlaute` (`UmlauteTrainerPage` now
  lives in `lib/screens/pronunciation/umlaute_trainer_page.dart`)
- `/speaking/r-sound` → `/pronunciation/r-sound`
  (`lib/screens/pronunciation/r_sound_trainer_page.dart`)
- `/speaking/ich-ach` → `/pronunciation/ich-ach-laut`
  (`lib/screens/pronunciation/ich_ach_trainer_page.dart`)
- `/speaking/sp-st` → `/pronunciation/sp-st`
  (`lib/screens/pronunciation/sp_st_trainer_page.dart`)
- New: `/pronunciation/minimal-pairs` → `MinimalPairsPage`
  (`lib/screens/pronunciation/minimal_pairs_page.dart`)
- `/pronunciation` hub route unchanged, now serves the rebuilt
  `lib/screens/pronunciation/pronunciation_screen.dart` (same file path as
  before, content replaced).
- `speech_routes.dart` currently `import`s the 4 deleted
  `screens/speaking/*_trainer_page.dart` files — these imports must be
  repointed to `screens/pronunciation/*_trainer_page.dart` or the file won't
  compile.

## Flat ARB key list (do not hand-edit — for coordinator merge)

Format: `key: vi | en | de`. Methods take positional params as named in
call sites (`{score}`/`{total}`/`{count}`/`{word}`/`{correct}`).

```
pronunciationHubTitle: Luyện Phát Âm Tiếng Đức | German Pronunciation Practice | Deutsche Aussprache üben
pronunciationHubInfoBanner: Phát âm đúng từ đầu giúp bạn tự tin hơn khi nói và tránh hiểu nhầm. Mỗi mô-đun tập trung vào một nhóm âm khó — luyện từng bước, nghe và bắt chước. | Correct pronunciation from the start builds confidence and avoids misunderstandings. Each module focuses on one tricky sound group — practice step by step, listen and imitate. | Richtige Aussprache von Anfang an gibt dir mehr Selbstvertrauen und vermeidet Missverständnisse. Jedes Modul konzentriert sich auf eine schwierige Lautgruppe — Schritt für Schritt üben, hören und nachahmen.
pronunciationHubUmlauteTitle: Umlaute (ä, ö, ü) | Umlauts (ä, ö, ü) | Umlaute (ä, ö, ü)
pronunciationHubUmlauteDesc: Phân biệt và luyện 3 nguyên âm biến thể đặc trưng của tiếng Đức | Distinguish and practice Germany's 3 characteristic umlaut vowels | Die drei charakteristischen deutschen Umlaute unterscheiden und üben
pronunciationHubIchAchTitle: Ich-laut / Ach-laut | Ich-laut / Ach-laut | Ich-laut / Ach-laut
pronunciationHubIchAchDesc: Phân biệt ch sau nguyên âm trước và sau | Distinguish 'ch' after front vs. back vowels | Unterscheide 'ch' nach vorderen und hinteren Vokalen
pronunciationHubRSoundTitle: R-Sound | R-Sound | R-Sound
pronunciationHubRSoundDesc: Âm r cổ họng đặc trưng của tiếng Đức | Germany's characteristic guttural R sound | Der charakteristische deutsche Kehlkopf-R-Laut
pronunciationHubSpStTitle: Sp / St Ban đầu | Initial Sp / St | Anfangs-Sp / St
pronunciationHubSpStDesc: sp → shp, st → sht ở đầu từ và vần | sp → shp, st → sht at the start of words and syllables | sp → schp, st → scht am Wort-/Silbenanfang
pronunciationLoadError: Không thể tải dữ liệu. Vui lòng thử lại. | Couldn't load data. Please try again. | Daten konnten nicht geladen werden. Bitte erneut versuchen.
pronunciationRetry: Thử lại | Retry | Erneut versuchen
pronunciationNoData: Chưa có dữ liệu luyện tập. | No practice data yet. | Noch keine Übungsdaten.
pronunciationCompletedTitle: Hoàn thành! | Completed! | Abgeschlossen!
pronunciationScoreCorrect(score, total): {score} / {total} đúng | {score} / {total} correct | {score} / {total} richtig
pronunciationRetryCta: Luyện lại | Practice again | Nochmal üben
pronunciationBackCta: Quay lại | Back | Zurück
pronunciationHintLabel: Mẹo phát âm: | Pronunciation tip: | Aussprachetipp:
pronunciationPlayCta: Nghe phát âm | Listen | Anhören
pronunciationNextCta: Tôi đã đọc → | I've heard it → | Gehört →
pronunciationDoneCta: Hoàn thành | Done | Fertig
pronunciationModePronounce: Phát âm | Pronounce | Aussprache
pronunciationModeDistinguish: Phân biệt | Distinguish | Unterscheiden
pronunciationModeDistinguishSpSt: Phân biệt sp/st | Distinguish sp/st | sp/st unterscheiden
pronunciationModeCategorize: Phân loại | Categorize | Kategorisieren
pronunciationUmlauteTitle: Luyện Umlaute | Umlaut Practice | Umlaute üben
pronunciationIchAchTitle: Ich-laut / Ach-laut | Ich-laut / Ach-laut | Ich-laut / Ach-laut
pronunciationRSoundTitle: R-Sound Tiếng Đức | German R-Sound | Deutscher R-Laut
pronunciationSpStTitle: Sp / St Ban đầu | Initial Sp / St | Anfangs-Sp / St
pronunciationIchLautBadge: Ich-laut [ç] | Ich-laut [ç] | Ich-laut [ç]
pronunciationAchLautBadge: Ach-laut [x] | Ach-laut [x] | Ach-laut [x]
pronunciationCompareLabel: So sánh: | Compare: | Vergleich:
pronunciationROverviewInfo: Âm R tiếng Đức có 4 biến thể tùy vị trí. Bảng dưới giúp bạn nhớ nhanh quy tắc. | The German R sound has 4 variants depending on position. The list below helps you remember the rule quickly. | Der deutsche R-Laut hat je nach Position 4 Varianten. Die Liste unten hilft dir, die Regel schnell zu merken.
pronunciationRPositionInitial: Đầu từ [ʁ] | Word-initial [ʁ] | Wortanfang [ʁ]
pronunciationRPositionAfterVowel: Sau nguyên âm [ɐ] | After vowel [ɐ] | Nach Vokal [ɐ]
pronunciationRPositionCluster: Cụm phụ âm [ʁ] | Consonant cluster [ʁ] | Konsonantencluster [ʁ]
pronunciationRPositionVocalic: Cuối từ -er [ɐ] | Word-final -er [ɐ] | Wortende -er [ɐ]
pronunciationQuizPrompt: Nghe và chọn từ bạn vừa nghe: | Listen and pick the word you just heard: | Hör zu und wähle das Wort, das du gerade gehört hast:
pronunciationQuizReplayHint: Nhấn để nghe lại | Tap to replay | Tippen zum erneuten Abspielen
pronunciationQuizScore(count): {count} đúng | {count} correct | {count} richtig
pronunciationStreak(count): 🔥 {count} liên tiếp! | 🔥 {count} in a row! | 🔥 {count} in Folge!
pronunciationQuizCorrect: ✓ Đúng rồi! | ✓ Correct! | ✓ Richtig!
pronunciationQuizWrong: ✗ Chưa đúng | ✗ Not quite | ✗ Nicht ganz
pronunciationQuizHeardLabel: Từ vừa nghe: | Word you heard: | Gehörtes Wort:
pronunciationQuizComparing: Đang phát cả hai để so sánh... | Playing both to compare... | Beide werden zum Vergleich abgespielt...
pronunciationQuizSeeResult: Xem kết quả | See result | Ergebnis ansehen
pronunciationQuizInsufficientData: Không đủ dữ liệu để tạo bài kiểm tra. | Not enough data to build a quiz. | Nicht genug Daten für ein Quiz.
pronunciationMinimalPairsTitle: Luyện nghe cặp tối thiểu | Minimal Pairs Listening | Minimalpaar-Hörtraining
pronunciationMinimalPairsPickerHint: Chọn cặp âm bạn muốn luyện nghe phân biệt: | Choose a sound pair to practice distinguishing: | Wähle ein Lautpaar zum Unterscheiden üben:
pronunciationMinimalPairsCount(count): {count} cặp từ | {count} word pairs | {count} Wortpaare
pronunciationMinimalPairsEmpty: Chưa có dữ liệu cặp âm. Vui lòng thử lại sau. | No sound-pair data yet. Please try again later. | Noch keine Lautpaar-Daten. Bitte später erneut versuchen.
pronunciationMinimalPairsPracticing: Đang luyện: | Practicing: | Übung:
pronunciationMinimalPairsPrompt: Bạn vừa nghe từ nào? | Which word did you just hear? | Welches Wort hast du gerade gehört?
pronunciationMinimalPairsCorrectOf(correct, total): Đúng {correct}/{total} | {correct}/{total} correct | {correct}/{total} richtig
pronunciationMinimalPairsCorrectLabel: Chính xác! | Correct! | Richtig!
pronunciationMinimalPairsWrongLabel(word): Sai rồi — đáp án đúng: {word} | Wrong — correct answer: {word} | Falsch — richtige Antwort: {word}
pronunciationEndCta: Kết thúc | End | Beenden
pronunciationMinimalPairsResultTitle: Kết quả luyện nghe | Listening result | Hörergebnis
pronunciationMinimalPairsScoreLabel(correct, total): {correct} / {total} câu đúng | {correct} / {total} correct | {correct} / {total} richtig
pronunciationMinimalPairsLowScoreHint: Hãy nghe lại nhiều lần — tai bạn sẽ quen dần với sự khác biệt! | Listen again a few more times — your ear will adjust to the difference! | Hör dir das noch ein paar Mal an — dein Ohr gewöhnt sich an den Unterschied!
pronunciationChangePairCta: Đổi cặp âm | Change pair | Paar wechseln
```

## Validation

- `flutter analyze lib/screens/pronunciation lib/data/pronunciation`: 128
  errors, **all** `undefined_getter`/`undefined_method` for the 58 new
  `AppLocalizations` keys above (expected/pending ARB merge) — confirmed via
  grep that zero other error/warning categories exist. Fixed 2 unrelated
  `unintended_html_in_doc_comment` info lints (angle-bracket doc comments →
  backticks).
- `flutter analyze lib/screens/speaking lib/features`: 91 pre-existing
  errors, all `conversation*` ARB keys from the parallel conversation
  sub-task — unrelated to my changes, confirmed no dangling references to
  deleted files (`grep -rl` for the 4 deleted trainer files + deleted
  `pronunciation_practice.dart` → only hit is
  `lib/navigation/routes/speech_routes.dart`, coordinator-owned).
- Tests: `test/screens/pronunciation/pronunciation_quiz_rounds_test.dart`,
  `test/screens/pronunciation/pronunciation_models_test.dart`,
  `test/repositories/pronunciation/pronunciation_repository_contract_test.dart`
  — 18/18 green (`flutter test` run). Repository test placed under
  `test/repositories/pronunciation/` (mirrors existing
  `test/repositories/games/` convention) rather than literally under
  `test/screens/pronunciation/` — minor deviation from the brief's literal
  path, flagging for visibility.
- Widget-level smoke tests for the 6 screens themselves are blocked until
  the ARB keys exist (the generated `AppLocalizations` getters don't compile
  yet) — cannot "confirm green" for those until the coordinator merges the
  key list above and regenerates l10n.

## Files touched

Created:
- `lib/data/pronunciation/pronunciation_models.dart`
- `lib/data/pronunciation/pronunciation_repository.dart`
- `lib/data/pronunciation/pronunciation_providers.dart`
- `lib/screens/pronunciation/pronunciation_screen.dart` (rebuilt in place)
- `lib/screens/pronunciation/umlaute_trainer_page.dart`
- `lib/screens/pronunciation/ich_ach_trainer_page.dart`
- `lib/screens/pronunciation/r_sound_trainer_page.dart`
- `lib/screens/pronunciation/sp_st_trainer_page.dart`
- `lib/screens/pronunciation/minimal_pairs_page.dart`
- `lib/screens/pronunciation/widgets/pronunciation_mode_toggle.dart`
- `lib/screens/pronunciation/widgets/pronunciation_word_drill_card.dart`
- `lib/screens/pronunciation/widgets/minimal_pair_quiz.dart`
- `lib/screens/pronunciation/widgets/pronunciation_quiz_rounds.dart`
- `lib/screens/pronunciation/widgets/pronunciation_completion_card.dart`
- `lib/screens/pronunciation/widgets/pronunciation_status_views.dart`
- `lib/screens/pronunciation/widgets/pronunciation_trainer_header.dart`
- `test/repositories/pronunciation/pronunciation_repository_contract_test.dart`
- `test/screens/pronunciation/pronunciation_quiz_rounds_test.dart`
- `test/screens/pronunciation/pronunciation_models_test.dart`

Deleted:
- `lib/screens/speaking/umlaute_trainer_page.dart`
- `lib/screens/speaking/ich_ach_trainer_page.dart`
- `lib/screens/speaking/r_sound_trainer_page.dart`
- `lib/screens/speaking/sp_st_trainer_page.dart`
- `lib/features/pronunciation/widgets/pronunciation_practice.dart` (+ empty
  parent dirs)

Not touched (per instructions): `lib/navigation/**`, `lib/l10n/**`,
`test/structure/release_live_data_guard_test.dart`,
`lib/view_models/providers.dart`, `docs/flutter-api-contract-matrix.md`
(flagged above, not edited).

Status: DONE_WITH_CONCERNS
Summary: All 6 screens rebuilt to web parity with live backend data (not
static, since web itself hits real endpoints); shared quiz/drill/completion
widgets built once. GameWallOverlay and XP-award both genuinely absent from
Flutter — skipped/deferred per instructions rather than invented.
Concerns/Blockers: (1) ARB keys pending coordinator merge — 128 expected
compile errors in my files until then; widget smoke tests can't run green
yet. (2) `speech_routes.dart` needs repointing to the new file paths +
adding `/pronunciation/minimal-pairs` (coordinator-owned). (3)
`pronunciation_practice_widget.dart` left in place — still used by
`shadowing_page.dart`, outside my ownership. (4)
`docs/flutter-api-contract-matrix.md` needs a new row for the 6
pronunciation/minimal-pairs endpoints — outside my ownership, flagged above.
