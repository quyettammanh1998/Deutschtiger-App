# Plan Review — Web-Mobile UI 100% Fidelity: Technical Feasibility & Internal Consistency

Plan: `plans/260716-2324-web-mobile-ui-100-fidelity/` (plan.md + phase-01..12)
Reviewer scope: dependency graph, file-ownership overlap, Flutter feasibility, phase sizing, hotfix verification, token blast radius vs tests.
All evidence grep/read-verified against `lib/`, `test/`, `pubspec.yaml`, `thamkhao/deutschtiger-frontend/src`.

## Findings

### [CRITICAL] "P2–P11 parallel-safe, ARB là điểm chạm chung duy nhất" is false — 3 more shared mutation points

Evidence:
- `lib/navigation/app_router.dart` = **987 lines, single file**. Route renames/redirects are explicitly required by P2 (xóa `/landing`), P3 (`/learn/session/:id` + redirect), P4 (`/games/cloze`, `/vocabulary/topic-{key}`), P5 (`/decks/*`→`/notes/*`), P7 (3 route renames), P8 ("redirect map đầy đủ trong `app_router.dart`"), P9, P10 (`/conversation`, `/pronunciation/*`), P11 (`/listening/podcast/...`, `/course/*`). 9 phases mutate one file; plan.md declares only "ARB files là điểm chạm chung".
- `test/structure/release_live_data_guard_test.dart` hardcodes a path allowlist and does `File(sourcePath).readAsStringSync()` per entry (line 176). Files slated for deletion are listed: `lib/screens/social/moments_page.dart` (line 135, P12), `lib/screens/flashcard/flashcard_review_screen.dart` (line 15, P5), `lib/screens/games/fill_blank_game_screen.dart` (line 160, P4), `lib/screens/youtube/youtube_shadowing_screen.dart` (line 76, replaced P11), `moments_feed.dart`/`moments_provider.dart` (P12). Deleting any → FileSystemException → guard suite crashes. Plan mandates "release-live-data guard phải pass" but never mentions the allowlist must be edited — so nearly every phase edits this one test file too. Same for `test/navigation/release_redirect_test.dart` (asserts `/social/groups`, `/social/moments` behavior) and `test/structure/view_models_layer_test.dart` (references `moments_provider.dart`).
- Generated l10n is git-tracked (`git check-ignore lib/l10n/app_localizations.dart` → tracked). Every phase adds ARB strings + runs `flutter gen-l10n` → parallel branches conflict across 4 generated dart files + 3 ARBs. "Merge tuần tự" resolves ordering but the plan states no protocol (namespaced keys, regenerate-after-merge, never hand-merge generated output).

Recommendation: (a) P1 splits `app_router.dart` into per-domain route files (P1 already owns shell/nav; this makes the parallel claim true); (b) plan.md lists the guard/redirect/view-model structure tests as serialized touchpoints and requires each deleting phase to update allowlists in the same commit; (c) add explicit l10n protocol: phase branches edit ARB only with per-phase key prefix, gen-l10n re-run at merge, generated files never hand-merged.

### [CRITICAL] DesignTokens migration prescription is technically infeasible as written; blast radius understated

Evidence: P1 Risks: "làm adapter giữ tên cũ (`DesignTokens.primary` → deprecated getter đọc theme)". `DesignTokens.primary` is `static const Color` (`lib/core/design_tokens.dart:50`, currently pink `0xFFFF8FA3`); a static getter has **no BuildContext** and cannot read `Theme.of(context)`. The only ways to make a context-free static "read the theme" are a global brightness singleton (fragile, breaks per-BuildContext theming and widget tests) — or the adapter stays a static light-only constant, which means every screen still referencing it renders light tokens in dark mode.
Blast radius: 129 files reference `DesignTokens`, 142 reference `AppColors`, out of 503 dart files in `lib/`. Plan acceptance says "Dark mode hoạt động ... trên mọi màn mới" (fine) but P12 QA asserts "không còn static light token" — that requires migrating **all ~271 files** within this plan, including kept screens (settings, notification center, onboarding) that no phase rebuilds. This effort is not budgeted anywhere.

Recommendation: P1 must specify the real mechanism: `ThemeExtension<AppTokens>` + `context.tokens` for all new/rebuilt code; `DesignTokens` statics updated to the new light palette and frozen as deprecated (no theme reads). Then either (a) scope P12's "no static light token" to release-visible screens with an explicit migration checklist, or (b) add a dedicated migration sub-phase. As written, P1's risk note and P12's acceptance contradict each other.

### [IMPORTANT] Hidden inter-phase dependencies contradict the "P2–P11 độc lập lẫn nhau" claim

Evidence (all from phase files vs plan.md dependency table):
- P3 → P4: P3 Ghi chú: "Mission runner tái dùng các game view của practice (P4) ... hoặc chạy P4 trước P3-runner". Table says P3 depends only on P1.
- P5 → P4: P5 guided lesson "tái dùng practice views P4". Table: P5 depends P1 only.
- P9 → P4: P9 step 1: "umlaut bar (tái dùng P4)"; P4 Risks confirms "Umlaut bar + diff ... dùng chung với P9 → đặt ở `lib/widgets/common/`". Table lists P9 deps as "P1, P8" only.
- P11 → P6: P6 "renderer đặt `lib/widgets/common/` vì grammar + reading + news dùng chung"; P11 (reading/news detail) never declares P6 dependency — parallel execution risks two competing markdown renderers.
- P1 ↔ P10 (tab 4 → `/conversation`): coordination note exists in both phases with flag-gate fallback — adequate, no action.
- P9 SSE claim verified OK: `lib/services/api/sse_client.dart` exists.

Recommendation: fix the plan.md table (P3→P4-rounds, P5→P4, P9→P4, P11→P6) **or** hoist umlaut-bar/diff and the markdown renderer into P1 primitives alongside GameShell — that restores true parallelism with one blocking phase.

### [IMPORTANT] Icon system underscoped by ~6x; misses the obvious package

Evidence: plan treats `src/lib/shared/feature-icons.tsx` as the icon source — it is 78 lines, ~20 icons. But the web imports `@phosphor-icons/react` (package.json line 40) in **205 source files** using **~125 distinct icons** (regex-counted across src). P1 requires only "toàn bộ icon shell + FEATURE_ICONS". With 10 parallel phases, every implementer will improvise Material lookalikes for the other ~125 glyphs — the plan-wide acceptance "icon đúng web" becomes unachievable, and "Icon sai hệ" (systemic gap #3) is only ~15% addressed.

Recommendation: add `phosphor_flutter` (official Phosphor Flutter port, icon-font, no SVG runtime cost) to pubspec in P1 for the standard set; hand-port only the ~20 custom feature-icons.tsx paths; publish a lucide/phosphor→AppIcons mapping note in P1 so phases stay consistent.

### [IMPORTANT] Phase sizing: P8, P9, P11, P12 each exceed one implementer pass

Evidence:
- P11: ~22 screens in the table **plus** Quyết định #8 mandates full interactive scope (youtube dictation/shadowing engines, cinema mode, course lesson video, podcast word-level highlight player) — this is by LOC the largest phase, and its file has no split note.
- P9: 16 screens + WritingPracticePanel + SM-2 sprint port; file self-acknowledges ("có thể tách wave nhỏ") — good, make the split normative, not optional.
- P8: 13 screens + "Player rebuild lớn nhất plan" (own risk note); web spec = 6 mobile player components (`src/components/exam/mobile/`, verified) + exam-practice-page.
- P12: ~17 settings/social/stats screens + deletion sweep + full QA — the sweep/QA serializes behind P2–P11 while the screens don't need to.

Recommendation: split P11 → (a) listening/podcast+player, (b) youtube suite, (c) video-library/interview/course, (d) reading/news; split P8 → IA/list/result screens vs player rebuild; split P12 → screens (parallel-safe after P1) vs sweep+QA (last). P9 keep its proposed waves as mandatory.

### [MODERATE] Wrong file paths in plan will misdirect implementers

Evidence:
- P1 Files: "Modify: `lib/core/app_theme.dart`" — does not exist; actual `lib/core/theme/app_theme.dart` (AppColors at `lib/core/theme/app_colors.dart`).
- P9: "WritingPracticePanel dùng chung (web `src/components/ai-writing-practice/`)" — that dir contains only `index.ts`, `submission-list-item.tsx`, `submissions-filter-bar.tsx`; the panel is at `src/components/writing/writing-practice-panel.tsx` (verified).

Recommendation: correct both; plan's own rule "implementer PHẢI đọc TSX gốc" makes path accuracy load-bearing.

### [MODERATE] P1 blocking phase has an external SSH dependency (quotes assets)

Evidence: `public/images/quotes/` absent from the synced repo (verified: `ls` → No such file); P1 requires fetching 20 webp from `deutschtiger:~/dist/images/quotes/` at implementation time. P1 blocks everything; only P2 (daily quote) consumes these.

Recommendation: pre-fetch before starting P1, or move quotes assets into P2 so a server hiccup can't block the foundation phase. Game assets verified present in repo (7 tiger frames, 9 obstacle files incl. `game-bg.webp` — plan's "9" counts the bg, fine).

### [MODERATE] Guard-test regex will bite rebuilt screens

Evidence: `release_live_data_guard_test.dart` fails any release-visible screen containing the words `mock|fixture|placeholder` (case-insensitive regex, line 167). Rebuilt screens routinely name things `placeholder` (input hints, shimmer placeholders). Plan mandates the guard passes but doesn't warn implementers about the identifier ban.

Recommendation: add one line to plan Nguyên tắc chung: avoid `mock/fixture/placeholder` identifiers in release-visible screens (use `hint`, `skeleton`, `shimmer`).

### [MODERATE] Plan starts from a dirty uncommitted tree on `main`

Evidence: `git status` shows ~20 modified + ~20 untracked files (home, exam, l10n, providers, new widgets). Plan front-matter: `branch: main`. Phase verdicts ("report rebuild 0256 là baseline", P2 home residuals) are measured against this uncommitted WIP; parallelizing branches from it is undefined.

Recommendation: commit/land the WIP baseline before P1, and have each phase branch from that commit.

## Verified-OK items (risk calibration)

- **Hotfix claim TRUE, P1 placement right**: `lib/screens/journey/widgets/journey_daily_plan_section.dart:10` imports `journey_daily_plan_step_row.dart`; file absent from `lib/screens/journey/widgets/` → compile break. Correctly the first P1 item.
- **Token values TRUE**: web `src/index.css` `:root --primary: hsl(32,93%,54%)` (line 68), `.dark --primary: hsl(200,85%,65%)` (line 108); Flutter `DesignTokens.primary = 0xFFFF8FA3` pink (design_tokens.dart:50, with a stale "orange-500" comment at line 263 confirming drift).
- **Pink→orange test risk LOW**: `test/core/design_tokens_test.dart` asserts existence/type only, no hue values; `test/structure/shared_widgets_test.dart` token check is soft-WARN (print, no expect); **zero golden tests** (`matchesGoldenFile` count = 0). Only 2 test files reference DesignTokens at all.
- **Fonts feasible as prescribed**: web ships woff2 only (`public/fonts/`: inter-400-700.woff2 [variable], grandstander-700 latin+vietnamese, fredoka-one-400). Flutter needs TTF/OTF; plan's "Google Fonts static TTF subset hoặc convert woff2" is correct — prefer static TTF download over instancing the variable Inter.
- **Deps mostly present**: `flutter_svg ^2.3.0`, `youtube_player_iframe ^6.0.2` (limitation note in P11 is accurate and honest), `shared_preferences` (P9 sprint persistence — no Hive in pubspec; plan says "Hive/prefs", prefs is the existing option). Markdown package correctly planned as new in P6. `google_fonts` is in pubspec but unused in lib (0 `GoogleFonts` refs) — "app render Roboto" claim true; dropping it is trivial.
- **Confetti**: no package, but `lib/shared/widgets/confetti_overlay.dart` + `game_completion_screen.dart` exist — P1 GameShell should reuse, consistent with "check module hiện có trước".
- **Feasible prescriptions**: particle canvas via CustomPainter (P2), vertical-snap PageView (`scrollDirection: Axis.vertical`, P2 daily quote), per-char typing surface (P7) — all standard Flutter, no red flags.
- **Web spec files exist**: `src/components/exam/mobile/` (6 components + index), `bottom-nav.tsx`, `more-features-sheet.tsx`, `feature-icons.tsx`, `writing-practice-panel.tsx` (wrong dir in plan, see MODERATE), `landing_screen` target dir exists.

## Recommended actions (priority order)

1. P1: split `app_router.dart` per-domain + declare guard/structure tests and generated l10n as serialized merge points with an explicit protocol.
2. Rewrite P1 token-adapter mechanism (ThemeExtension + frozen static light consts); reconcile with P12 "no static light token" acceptance or budget the 271-file migration.
3. Fix dependency table: P3→P4, P5→P4, P9→P4, P11→P6 — or hoist umlaut-bar/diff + markdown renderer into P1.
4. Add `phosphor_flutter` + icon mapping doc to P1.
5. Make P9 waves mandatory; split P11 (4 waves), P8 (2), P12 (screens vs sweep/QA).
6. Fix plan paths (`lib/core/theme/app_theme.dart`, `src/components/writing/writing-practice-panel.tsx`); pre-fetch quotes assets; commit WIP baseline before P1.

## Unresolved questions

1. Is parallel execution planned as separate git branches/worktrees or sequential waves in one tree? The l10n/router collision severity depends on this — plan should state it.
2. P12 "không còn static light token" — is full-app dark mode (incl. kept legacy screens) truly in scope for this plan, or only rebuilt screens? Owner decision #2 says "làm ngay tại P1" but the migration budget is unstated.
