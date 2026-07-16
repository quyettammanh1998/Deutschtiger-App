# Plan Completeness Review — 260716-2324 Web-Mobile UI 100% Fidelity

Reviewer: code-reviewer · 2026-07-16 · Scope: coverage of plan.md + phase-01..12 vs 9 scout reports (`scout-260716-2324-ui-fidelity-*`). All claims below grep-verified against `thamkhao/deutschtiger-frontend/src` and `lib/navigation/app_router.dart`.

## Findings

### IMPORTANT

1. **[IMPORTANT] Sprint cheatsheet page has no owning phase** — Web route is LIVE: `routes.tsx:521` `{ path: ROUTE_PATHS.examWritingSprintCheatsheet, element: <ExamWritingSprintCheatsheetPage /> }`; scout exam-writing:135 flags it "(Also live but out of scope: exam-writing-sprint-cheatsheet-page.tsx — printable Redemittel cheatsheet, 85 L)". Phase-09 step 4 builds only sprint #14–16 yet its own mode-picker spec includes the link "`Cheatsheet Redemittel` primary text link" (phase-09:124-quote via scout #14) → rebuilt sprint picker will link to a nonexistent screen. **Fix:** add cheatsheet page (or explicit redirect/deferral) to phase-09.

2. **[IMPORTANT] Own-profile surface `/profile` is orphaned by the plan** — `app_router.dart:764-769` routes `ProfileScreen` + `EditProfileScreen` (`lib/screens/profile/`). Scout social-ai:126: "Own-profile tab ... has no dedicated web page ... its header/stat styling should adopt the same card language." It is in no phase table, not in Quyết định #3's keep list (a–d), and not in the P12 deletion sweep. In a plan whose acceptance is "Không còn màn Flutter-only ngoài danh sách 'giữ lại' đã chốt" (plan.md:87), this screen fails the sweep with no instruction. **Fix:** add to P12 (restyle with web card language + keep) or to decision #3 keep list.

3. **[IMPORTANT] Old routed game screens: replacement/deletion unowned + P4/P7 ownership collision** — Router still mounts `fill_blank_game_screen.dart`, `flashcard_game_screen.dart`, `matching_game_screen.dart` (`app_router.dart:92-96`), `writing_word_game_screen.dart` (`/games/writing`, :401) and `writing_sentence_game_screen.dart` (`/games/writing-sentence`, :409). Phase-04 rebuilds the four web practice pages targeting `practice_*_view.dart` + "mới", phase-07 owns `lib/screens/games/`; **neither phase lists these five screens for deletion**. `/games/writing-sentence` has no web counterpart (web = one page, `/games/writing?type=word|sentence`, per games scout row) and appears in no deletion list. Also a parallel-run hazard: plan.md:67 says P2–P11 parallel by file-ownership, but P4 and P7 both touch `/games/*` routes in `app_router.dart` and the games dir. **Fix:** assign the 5 screens + `/games/writing-sentence` redirect explicitly (suggest P4 since it owns those web pages) and note the router merge point.

4. **[IMPORTANT] Two web assets missing from phase-01 asset sync** —
   - `public/icons/bulb.webp`: used by `components/conversation/dialog-runner.tsx:616,732,821` and `components/exam/sprechen/sprechen-input-area.tsx:403` (suggestion-lightbulb in every composer P10 builds). Scout speech §D lists it; P1 §8 omits it.
   - `public/images/game/game-icon.webp`: used by `components/game/deutsch-runner.tsx:331` (runner HUD). P1 §8 copies only `tiger-frames/*` (7) + `obstacles/*` (9). (`tiger-mascot.webp` confirmed unused — correctly omitted.)
   **Fix:** add both to P1 §8.

### MODERATE

5. **[MODERATE] Two home-scout unresolved questions orphaned** — home-settings scout Q5 "weekly_score composite vs weekly_xp in Flutter leaderboard rows — confirm backend field" and Q4 "Leaderboard 'Bạn bè' tab depends on social flag — build tab now or gate?" are answered nowhere: not in plan.md Quyết định #1–8, not in P2 (compact leaderboard residuals) nor P12 (leaderboard row lists "tabs Toàn cầu/Bạn bè ... breakdown chips" with no field/gating note). **Fix:** one line each in P12.

6. **[MODERATE] Exam player rebuild scope leaves scout Q2 half-answered** — exam-core scout Q2 asks: "full section-screen mode + highlight/word-lookup/reader-settings, or visual-shell parity first?" P8 row 5 specs header/whole-Teil scroll/footer/nav-sheet/dark mode but never mentions the scout's named missing features "pace dot [covered], reader settings/guide buttons, highlight toolbar, word-lookup, 'Dịch đoạn văn', locked audio player (test mode), comment section per question (review)" (exam-core scout §5.6). Given Quyết định #8 mandates full scope only for youtube/course/cinema, the player's interactive extras are neither in nor out. **Fix:** state explicitly in P8 (in-scope or deferred).

7. **[MODERATE] More-features sheet: decision #1 contradicts P1 spec** — Quyết định #1: "AI vào sheet 'Thêm'"; P1 §7: "catalog nhóm/mục giống `more-features-sheet.tsx`". Grep of `components/dashboard/more-features-sheet.tsx` finds **no AI item** (scout shell §1 catalog confirms: 4 groups, no AI chat). Implementer following P1 literally drops AI entirely; following #1 deviates from "giống web". **Fix:** one line in P1 §7: add AI tile to group 4 as app-only extra (or wherever owner wants).

8. **[MODERATE] P5 deck-list spec omits `MyNotesSection compact`** — web `flashcard-deck-list.tsx:182` renders `<MyNotesSection compact />` (YouTube video-notes row); scout flashcard §1.1 lists it in block order ("`MyNotesSection compact` (YouTube video notes row)"). P5 row 1 lists "Folders, starred, default-star, mastery bar, PageIntro, sprint widget, bottom action sheet" — notes row absent. **Fix:** add to P5.

9. **[MODERATE] P8 mislabeled decision cross-reference** — P8 de-thi row cites "(Quyết định #8/unresolved #4 — mặc định port đủ)" but Quyết định #8 concerns youtube-dictation/course-video/cinema interactive modes, not de-thi FAQ/testimonials. Intent ("port đủ") is stated so impact is low, but the pointer is wrong. **Fix:** drop the "#8" reference or add the de-thi trust-block decision to plan.md's chốt list.

### LOW

10. **[LOW] `lib/screens/exam/widgets/exam_hub_card.dart` not in P8 deletion list** — exam-core scout table: "Only used by dead exam_hub_screen (verify) — likely delete." P8 deletes `exam_hub_screen.dart` but not its widget; P12's catch-all ("cùng mọi file các phase trước đánh dấu") only works if a phase marks it.
11. **[LOW] Empty dir `lib/features/auth/presentation/`** (shell scout §6) not in P12 sweep (sweep lists only `features/{social,ai,ai_tutor}` empty dirs).
12. **[LOW] Home header badge target** — home scout Q6 (badge deep-link once center removed) is moot since decision #3d keeps the notification center, but note web badge sits on the **Messages** icon counting notifications+messages; P2 home residuals don't include this diff.

## Areas verified COMPLETE

- **Screen coverage:** every page/verdict in all 9 scout reports has an owning phase (P2 entry/home/quote · P3 learn · P4 vocab/practice · P5 decks · P6 grammar · P7 games · P8 exam core · P9 writing (minus finding #1) · P10 speech · P11 media · P12 social/settings). No web page other than the cheatsheet (#1) is unowned; out-of-scope exclusions (SEO, admin, PWA, SePay, WebRTC) match plan.md:93-97.
- **Unresolved questions:** 30 of 34 scout questions are answered by Quyết định #1–8, phase text, or explicit defer (e.g. legal email → "hỏi owner nếu lệch" P2; grammar-articles entry → verify-first P6; schreiben-view convergence → P9 step 5; topic slug probe → P4). Orphans are only findings #5, #6, #12.
- **Deletion lists vs router (grep-verified):** `exam_hub_screen.dart`, `screens/exam/exam_result_page.dart`, `progress_analytics_screen.dart`, `reminder_settings_screen.dart`, `screens/grammar/grammar_screen.dart` — zero inbound references, safe deletes as claimed. `lib/screens/quiz/*` is not routed/imported anywhere → P7 delete needs no redirects. `/landing`, `/welcome-full` routed (app_router.dart:194-199) → P2 correctly pairs delete with redirects. Nothing wrongly slated: every deletion candidate cross-checked against router; kept items (#3a–d) all excluded from sweeps.
- **Assets:** P1 covers premium-banner (already in repo), tiger-icon/logo SVGs, anh1.webp, tiger-frames (7 files confirmed on disk), obstacles (9 confirmed incl. game-bg.webp), quotes-from-server (confirmed absent from synced `public/` — server-fetch instruction correct), fonts (all 4 woff2 present in `public/fonts/`). Gaps = finding #4 only.
- **Spot-checked plan claims (5/5 accurate):** light `--primary: hsl(32,93%,54%)` (`index.css:68`) + dark `hsl(200,85%,65%)` (`index.css:108`) ✓; bottom nav `h-16 border-t bg-background/95 backdrop-blur-sm` + tab 4 "Hội thoại" + per-tab amber/indigo/emerald/teal pastel pills (`bottom-nav.tsx:36-55,84`) ✓; button primitive h-10 (40px) `rounded-lg` (`ui/button.tsx:17,22`) ✓; writing routes live in `routes.tsx` incl. sprint session/mock + telc `a-rap/schreiben/:slug` ✓; `delete-account-page.tsx` absent from web (plan Ghi chú sự cố accurate) ✓.

## Recommended actions (priority order)

1. P9: add sprint cheatsheet page or explicit deferral+redirect (#1).
2. P12/decision #3: own the `/profile` + `edit_profile` surface (#2).
3. P4: list the 5 legacy game screens + `/games/writing-sentence` redirect; note P4↔P7 router merge point (#3).
4. P1 §8: add `icons/bulb.webp` + `images/game/game-icon.webp` (#4).
5. One-liners for #5–#9 in the respective phase files.

## Unresolved questions

- Owner call needed on finding #6 (player interactive extras in/out) and #7 (AI tile placement in Thêm sheet) — both are product decisions, not derivable from repo.
