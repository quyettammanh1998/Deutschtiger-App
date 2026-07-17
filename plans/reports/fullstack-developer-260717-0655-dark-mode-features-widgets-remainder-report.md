# Dark-mode migration — `lib/features/**` + `lib/widgets/**` remainder

Scope: shared widgets rendered by route screens (screens were migrated in a
prior pass; this pass covers the widgets underneath them, per user
assignment — sibling agent handles `lib/screens/**` concurrently).

## Before/after

Regex used:
`grep -rEl '(DesignTokens|AppColors)\.(primary|background|foreground|card|muted|border|success|warning|destructive|accent|secondary|brand|sidebar|ring|input|text|auth)' lib/features/ lib/widgets/`

Before: 14 files matched. After: 0 files have colour reads left unmigrated
(2 were false positives — see below — and stayed matched by regex only for
non-colour or intentionally-fixed tokens).

## Files migrated (12, real colour reads)

- `lib/features/games/widgets/game_base.dart` — `mutedForeground`(x3),
  `success`(x2), `foreground`, `border` → `context.tokens.*`. `AppColors.error`
  (not deprecated, distinct from `destructive`) and `AppColors.tigerOrange`
  (brand) left as-is.
- `lib/features/voice/presentation/widgets/record_button.dart` —
  `DesignTokens.muted`/`mutedForeground` (x3 pairs) → `context.tokens.*`.
  `DesignTokens.error`/`tigerOrange` left (not deprecated / brand).
- `lib/features/premium/presentation/premium_screen.dart` —
  `background`(x2), `foreground`(x2), `muted`, `mutedForeground`, `card`,
  `border` → `context.tokens.*`. `tigerOrange` left (brand).
- `lib/features/vocabulary/presentation/widgets/detail_widgets.dart` —
  `card`(x3, incl. FilledButton foreground), `mutedForeground`(x2), `border`
  → `context.tokens.*`. `rose600`, `orange50`, `tigerOrange` left (not
  deprecated / brand / distinct fixed accents, no `AppTokens` equivalent).
- `lib/widgets/dashboard/streak_claim_modal.dart` — `primary`(x5),
  `foreground`(x3) → `context.tokens.*`. `AppColors.cardBackground` left
  (not deprecated, distinct cream fixed color, no `AppTokens` member).
- `lib/widgets/common/async_state_views.dart` — `mutedForeground`(x2) →
  `context.tokens.mutedForeground`. `tigerOrange` left (brand).
- `lib/widgets/common/minimal_shell.dart` — `background`, `foreground`(x2)
  → `context.tokens.*`.
- `lib/widgets/vocab_search/vocabulary_detail_panel.dart` — `foreground`(x3),
  `mutedForeground`(x7), `primary` → `context.tokens.*`. `tigerOrange` left
  (brand).
- `lib/widgets/interview/video_notes_panel.dart` — `muted`, `destructive` →
  `context.tokens.*`. `tigerOrange`, `authBackground` left (brand / not
  deprecated fixed).
- `lib/widgets/interview/transcript_panel.dart` — `muted`(x3),
  `mutedForeground`(x5), `foreground`, `destructive`(x2) →
  `context.tokens.*`. `tigerOrange` left (brand).
- `lib/widgets/ai/chat_history_sidebar.dart` — `primary`(x6) →
  `context.tokens.primary`; dropped now-unused `app_colors.dart` import.
- `lib/widgets/speaking/pronunciation_practice_widget.dart` — `primary`(x2),
  `foreground`(x2) → `context.tokens.*`. `tigerOrange` left (brand).

## False positives (no colour, left untouched)

- `lib/features/exam/presentation/widgets/exam_provider_cards.dart` — only
  match was `DesignTokens.cardPadding` (spacing constant, substring "card"
  matched regex). File already fully theme-aware (`context.tokens` used
  throughout for real colours).
- `lib/widgets/common/gradient_button.dart` — only match was
  `AppColors.primaryGradient`, a fixed orange→rose gradient (not deprecated,
  not in `AppTokens`, intentionally not theme-dependent per web design).

## Deliberately left fixed (with reason)

- `AppColors.tigerOrange` / `tigerOrangeDark` — brand orange, correct fixed
  per task instructions.
- `AppColors.error` — distinct from `destructive`, not `@Deprecated`, no
  `AppTokens` member; left as-is (same as pre-existing convention elsewhere
  in the codebase).
- `AppColors.authBackground`, `AppColors.cardBackground`, `AppColors.rose600`,
  `AppColors.orange50` — not `@Deprecated` in `app_colors.dart`, no
  corresponding `AppTokens` member (verified via `Read` on
  `app_colors.dart`/`app_tokens.dart`) — these are intentionally-fixed
  utility colours outside the semantic token set, same category as
  `orange500/600`, `emerald*`, etc. documented in
  `docs/design-tokens-from-web.md`.

## Gaps / could-not-migrate (documented, not guessed)

None of the 12 real-migration files had colours read outside a `BuildContext`
(no static const / top-level map / model needing threading). However several
files in this scope still hardcode `Colors.white` / `Colors.grey.shade*` /
`Colors.black87` for panel backgrounds and text (not `DesignTokens`/`AppColors`
reads, so outside the regex-matched scope of this task):
`streak_claim_modal.dart`, `vocabulary_detail_panel.dart`,
`video_notes_panel.dart`, `transcript_panel.dart`, `chat_history_sidebar.dart`.
These will render a light-coloured panel background even in dark mode. Not
migrated here because (a) they don't match the deprecated-static-token regex
this task targets, and (b) swapping a hardcoded `Colors.white` panel
background for a token is a bigger visual-QA decision than a straight
static-token→token swap — flagged for a follow-up pass rather than guessed.

## Validation

- `flutter analyze` (whole repo): 0 errors, 33 info/warnings (baseline count
  unchanged from before this pass's edits; individual file checks after each
  edit batch all returned "No issues found").
- `flutter test`: 747/747 passed, unchanged from baseline.

## docs/design-tokens-from-web.md

Updated — added a new subsection after the existing 2026-07-17
static-token-migration note documenting this pass's before/after, false
positives, deliberately-fixed colours, and the `Colors.white`/`Colors.grey`
gap. Sibling's report
(`plans/reports/fullstack-developer-260717-0655-dark-mode-screens-remainder-report.md`)
did not exist at the time of writing — doc note says numbers for
`lib/screens/**` are pending; whoever finishes second should reconcile if
the combined picture needs a follow-up doc edit.

## Unresolved questions

1. Should the hardcoded `Colors.white`/`Colors.grey.shade*` panel
   backgrounds in the 5 files listed under "Gaps" get a follow-up pass? They
   are real dark-mode visual bugs but were out of this task's literal regex
   scope.
2. Sibling's screens-remainder report wasn't available at write time — if
   its numbers differ meaningfully from "0 remaining in lib/screens", the
   combined summary in `docs/design-tokens-from-web.md` may need one more
   edit pass once that report lands.

Status: DONE
Summary: Migrated 12 shared widget files (features/+widgets/) off deprecated static colour tokens to `context.tokens.*`; 2 grep matches were false positives (spacing constant / intentional fixed gradient) left untouched; brand orange and other non-deprecated fixed utility colours kept as-is with documented reasons. `flutter analyze` 0 errors / 33 info (baseline), `flutter test` 747/747 green.
Concerns/Blockers: 5 files in scope still hardcode `Colors.white`/`Colors.grey.shade*` panel backgrounds outside the regex-matched static-token scope — real dark-mode gap, documented but not fixed (see Gaps section). Sibling's screens-remainder report wasn't available yet when updating docs.
