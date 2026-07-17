# Hardcoded colors dark-mode fix — 5 shared widgets

## Scope
Exactly the 5 files named in the task. No other files touched except the new
test and the doc update.

## Per-file changes

### `lib/widgets/dashboard/streak_claim_modal.dart`
- Modal panel bg: `AppColors.cardBackground` (white literal) → `context.tokens.card`.
- Close button circle fill: `Colors.grey.shade300` → `context.tokens.muted`; its
  icon: `Colors.white` → `context.tokens.mutedForeground` (icon on a muted
  fill, not text on a colored brand fill).
- Week-calendar container bg: `Colors.grey.shade100` → `context.tokens.muted`.
- Claimed-state button bg: `Colors.grey.shade400` → `context.tokens.muted`.
- Inactive day border: `Colors.grey.shade300` → `context.tokens.border`.
- Day label/date text (non-today): `Colors.grey.shade500` / `.shade400` →
  `context.tokens.mutedForeground`.
- Removed now-unused `app_colors.dart` import.
- **KEPT**: reward-status box (amber/green tint for "not enough time"/"claimed")
  — semantic status tint, not a plain panel bg; AppTokens has no
  light/dark-aware warning/success *background tint*, only solid `warning`/
  `success` colors, so a naive swap would change the visual language. Left a
  comment explaining this. Also kept: `Colors.green.shade400/100/50` day-active
  markers (same semantic-status reasoning), `Colors.white` text/icons drawn on
  colored fills (close-button was addressed above but claim-button label and
  streak-count icon backgrounds keep white-on-color), `Colors.black.withValues`
  scrim/backdrop dimming (theme-independent overlay).

### `lib/widgets/vocab_search/vocabulary_detail_panel.dart`
- `_TypeBadge` bg: `Colors.grey.shade100` → `context.tokens.muted`.
- `_MeaningSection` / `_ExamplesSection` bg+border: `Colors.grey.shade50` /
  `Colors.grey.shade200` → `context.tokens.muted` / `context.tokens.border`.
- `_TagsSection` chip bg: `Colors.grey.shade100` → `context.tokens.muted`.
- **KEPT**: CEFR level badge colors (green/lightGreen/orange/deepOrange/red/
  purple) and gender badge colors (blue/pink/green) — semantic/grammatical
  category colors, same in both themes by design (mirrors web). `Colors.white`
  text on those colored badge fills, and on the save-to-flashcard button
  (orange/green fill) — text-on-color, correct as-is. `AppColors.tigerOrange`
  icon accent — brand color, identical hex in light/dark tokens already.

### `lib/widgets/interview/video_notes_panel.dart`
No changes — already fully theme-aware (`tokens.card`, `tokens.muted`,
`tokens.destructive`); confirmed via grep for `Colors.(white|black|grey)`
before editing, zero hits. Listed in the original gap by mistake or already
fixed in an earlier pass.

### `lib/widgets/interview/transcript_panel.dart`
- Outer panel bg: `Colors.white` → `context.tokens.card`.
- **KEPT**: `AppColors.tigerOrange` icon/spinner accents (brand color, same
  both themes), `Colors.transparent` (non-active row fill).

### `lib/widgets/ai/chat_history_sidebar.dart`
- Sidebar container bg: `Colors.white` → `context.tokens.card`.
- Header bottom border: `Colors.grey[200]` → `context.tokens.border`.
- Empty-state icon/text: `Colors.grey[300]/[600]/[400]` → all
  `context.tokens.mutedForeground` (AppTokens has one muted-text tier, so the
  three grey shades collapse to one token — acceptable, still theme-correct).
- List divider: `Colors.grey[200]` → `context.tokens.border`.
- History item title (unselected): `Colors.black87` → `context.tokens.foreground`.
- Message-count icon/text, timestamp text: `Colors.grey[500]/[400]` →
  `context.tokens.mutedForeground`.
- **KEPT**: `Colors.black.withValues(alpha: 0.1)` drop shadow — generic
  theme-independent elevation shadow, not a surface/text color.

## Tests
Added `test/widgets/dark_mode_surface_colors_test.dart` — renders
`StreakClaimModal` and `VocabularyDetailPanel` under `AppTheme.dark` and
asserts their panel surface decoration color equals `AppTokens.dark.card` /
`AppTokens.dark.muted` respectively (and is NOT the old white/grey.shade50
literal). Pattern copied from `test/widgets/common/app_card_test.dart`
(light-vs-dark decoration assertions). `ChatHistorySidebar` was excluded from
the widget test — its `initState` fires a real `loadSessions()` network call
via `aiChatNotifierProvider` with no mockable seam in this scope, which threw
unrelated socket exceptions under `flutter test`; its 2 color fixes are
still verified by `flutter analyze` + manual review.

## Validation
- `flutter analyze`: 0 errors (33 pre-existing info/1 unrelated warning in
  untouched test file, same baseline as before this change).
- `flutter test test/widgets/dark_mode_surface_colors_test.dart`: 2/2 pass.
- `flutter test` (full suite): **749/749 passed** (747 baseline + 2 new dark-
  mode surface tests). Confirmed via background run, `All tests passed!`.
- Docs: `docs/design-tokens-from-web.md` "Còn nợ" section updated — gap
  closed, links to this report and the new test.

## Unresolved questions
- None blocking. Note the amber/green semantic status-tint boxes in
  `streak_claim_modal.dart` are a *different* category of gap (no
  light/dark-aware tint token exists yet in `AppTokens`) — flagged in-code but
  intentionally left as a possible follow-up, not part of this task's scope
  (panel bg / primary text / muted text / borders only).

Status: DONE
Summary: Migrated hardcoded panel/text `Colors.*` literals to `context.tokens` across 4 of the 5 target files (`video_notes_panel.dart` was already theme-aware); added 2 dark-theme widget tests, `flutter analyze` 0 errors, full suite 749/749 green, closed the doc's "Còn nợ" gap.
Concerns/Blockers: none.
