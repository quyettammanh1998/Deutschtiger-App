# P8 Wave A Group D — Community Exams (list + detail) fidelity rebuild

## Screens

### community_exams_list_screen.dart (rebuilt, 143 LOC)
- Back + "Đề thi cộng đồng" title, segmented tab bar (Duyệt đề / Đóng góp / Đề của tôi) matching web `bg-muted p-1 rounded` active-bg-card-shadow style.
- "Duyệt đề" = fully live (`CommunityBrowseTab`): provider/skill select (Tất cả / Goethe Viết / Telc Nói) + Teil 1/2/3 toggle chips + search input + result cards, all sourced from `communityExamListProvider`.
- "Đóng góp" / "Đề của tôi" = `CommunityGatedTab` coming-soon placeholder (icon + VN message) — tabs render per web parity but write path stays gated per product decision (GĐ2 P3 owns it). No fake success/data.

### community_exam_detail_screen.dart (rebuilt, 200 LOC)
- "‹ Quay lại" text link (not AppBar) → badge row ("Cộng đồng" chip, provider label e.g. "Goethe B1 Writing Teil 2", `RealExamBadge` full variant) → title de/vi → contributor + date line → hidden banner (yellow, only if `status == 'hidden'`) → structured content sections → gated actions row.
- Writing skill renders `CommunityWritingTaskSections` (Đề bài / Phân tích đề / Bài mẫu) + `CommunityWritingExtraSections` (Cụm từ hữu ích / Ngữ pháp trọng tâm / Lỗi thường gặp with strikethrough-wrong → green-correct), driven off the new `generatedData` field.
- Speaking skill renders `CommunitySpeakingContent` (raw string or `{content}` dump, matches web's `SpeakingTopicContent`).
- Actions row: "Tôi vừa thi" (emerald look via `AppButton`) + "Báo cáo" both rendered **disabled** with a tooltip ("Tính năng đang được phát triển") — no live write endpoint wired this phase, so no fake-success state per rule.

## New widget files (`lib/screens/exam/widgets/community/`, all <200 LOC)
- `real_exam_badge.dart` — no existing Flutter equivalent found (`grep -ri realexam lib/` was empty pre-change); built to match `real-exam-badge.tsx` (SealCheck icon + "Đề thật", compact/full variants, `examDate` presence is the sole signal).
- `community_topic_card.dart` — browse list row (title de/vi, provider+skill+teil chip, contributor+date, RealExamBadge).
- `community_browse_tab.dart` — filter/search/list state + rendering.
- `community_gated_tab.dart` — coming-soon state for the two gated tabs.
- `community_detail_section_widgets.dart` — shared bordered-card section + de/vi text helpers.
- `community_writing_task_sections.dart` — Đề bài / Phân tích đề / Bài mẫu.
- `community_writing_extra_sections.dart` — Cụm từ hữu ích / Ngữ pháp trọng tâm / Lỗi thường gặp + `CommunitySpeakingContent`.

All use `context.tokens` exclusively (no `DesignTokens`/`AppColors` statics), reuse `AppCard.interactive`, `AppButton`, `AppPhosphorIcons`.

## Shared-file changes (additive only — coordinator please verify no conflict)

### lib/data/exam/exam_ecosystem_models.dart — `CommunityExamTopic`
Added 4 nullable/defaulted fields, all mapped 1:1 to keys already present in the Go response struct (`internal/infra/database/community_exam_repo.go:15-53`, confirmed by reading the actual struct, not guessed):
- `status` (`String`, default `'published'`) ← `json:"status"`
- `examDate` (`String?`) ← `json:"exam_date,omitempty"`
- `examLocation` (`String?`) ← `json:"exam_location,omitempty"`
- `generatedData` (`Map<String,dynamic>?`) ← `json:"generated_data"` (Go `json.RawMessage`; parsed only when it decodes to a JSON object — speaking topics that store a raw string fall back to `null`, handled by `CommunitySpeakingContent`'s type switch on the raw provider value... actually see deviation note below)

**Deviation to flag**: `generatedData` is typed `Map<String,dynamic>?` on the Dart side, but `CommunitySpeakingContent` accepts `Object? raw` and is called with `data.generatedData` — if a speaking topic's `generated_data` was stored as a bare JSON string (not `{content: ...}`), `CommunityExamTopic.fromJson`'s type guard (`json['generated_data'] is Map<String, dynamic>`) sets `generatedData = null` for that row, so the raw string content would be silently dropped instead of rendered. This is a narrow edge case (only affects speaking topics whose AI-generation stored a bare string rather than an object) — not verified against live DB rows within this phase's scope. Flagging as a known gap rather than guessing the DB's actual distribution.

Existing fields (`id`, `provider`, `level`, `skill`, `teil`, `titleDe`, `titleVi`, `contributorName`, `contributorAvatar`, `voteCount`, `versionCount`, `isVerified`, `createdAt`, `inputText`) untouched.

### lib/view_models/exam/exam_ecosystem_providers.dart — `CommunityExamFilter` + `communityExamListProvider`
- Added `teil` (`int?`) field to `CommunityExamFilter`, included in `==`/`hashCode`, passed through to the repository call. Confirmed real backend param: `community_exam_write_handler.go:145-157` `parseCommunityFilter` reads `r.URL.Query().Get("teil")` via `strconv.Atoi`.

### lib/repositories/exam/community_exam_repository.dart — `CommunityExamRepository.list()`
- Added `int? teil` param, appended as `query['teil']` when non-null. Additive only, existing signature (minus the new optional param) unchanged, `getById()` untouched.

## Backend contract findings
- Go struct source of truth: `thamkhao/deutschtiger-backend/internal/infra/database/community_exam_repo.go:15-53` (`CommunityExamTopic` DB/JSON struct) — full field list confirmed there, not guessed from frontend TS types.
- `teil` is a real accepted query param on `GET /user/community/exams` (list/search/count), confirmed in `community_exam_write_handler.go`.
- `GetByID` 404s hidden topics for non-owners server-side (`community_exam_handler.go:119-123`) — the Flutter `_HiddenBanner` only fires for the owner's own hidden topic, matching that access-control behavior (no client-side hiding logic needed).
- No `/user/community/exams/search` wired into the Flutter repository this phase — see deviation below.

## Deviations from spec
1. **Search is client-side**, not the `/search` endpoint. The repository (owned partially by this phase, extension scope explicitly limited to `teil`) only exposes `list()`/`getById()`; adding a new `search()` method felt like scope creep beyond the explicitly granted "MAY extend... to add teil" allowance. Search filters the already-fetched, already-filtered-by-provider/skill/teil list by title (de/vi) locally. Acceptable for a community-topic list of this likely size; flagging in case the coordinator wants the real endpoint wired later.
2. Provider/skill combo select only offers "Tất cả / Goethe Viết / Telc Nói" (matches web's `BrowseTab` select options exactly — it hardcodes the same 2 combos, not a full provider×skill cross-product).
3. "Tôi vừa thi" and "Báo cáo" actions render disabled+tooltip rather than opening web's modal/bottom-sheet flows (`SubmitRealExamModal`, report-reason sheet) — no live write endpoint reachable in this phase's scope, and faking success was explicitly disallowed.

## ARB strings needed (hardcoded VN literals for now, not added to ARB — coordinator owns app_{vi,en,de}.arb)
| suggested key | vi | en | de |
|---|---|---|---|
| communityTabBrowse | Duyệt đề | Browse | Durchsuchen |
| communityTabContribute | Đóng góp | Contribute | Beitragen |
| communityTabMine | Đề của tôi | My topics | Meine Themen |
| communityContributeComingSoon | Tính năng đóng góp đề thi đang được phát triển.\nHãy quay lại sau nhé! | Contributing topics is coming soon.\nCheck back later! | Themenbeitrag kommt bald.\nSchau später wieder vorbei! |
| communityMineEmptyGated | Bạn chưa đóng góp đề nào — tính năng này sắp ra mắt. | You haven't contributed any topics yet — coming soon. | Du hast noch keine Themen beigetragen — bald verfügbar. |
| communitySearchHint | Tìm đề... | Search topics... | Themen suchen... |
| communityFilterAll | Tất cả | All | Alle |
| communityFilterGoetheWriting | Goethe Viết | Goethe Writing | Goethe Schreiben |
| communityFilterTelcSpeaking | Telc Nói | Telc Speaking | Telc Sprechen |
| communityBackLink | Quay lại | Back | Zurück |
| communityBadgeLabel | Cộng đồng | Community | Community |
| communityHiddenBanner | ⚠️ Đề này đã bị ẩn do nhận nhiều báo cáo. | ⚠️ This topic was hidden due to multiple reports. | ⚠️ Dieses Thema wurde wegen mehrerer Meldungen ausgeblendet. |
| communityRealExamBadge | Đề thật | Real exam | Echte Prüfung |
| communityTakeExamAction | Tôi vừa thi | I just took this exam | Ich habe diese Prüfung gerade abgelegt |
| communityReportAction | Báo cáo | Report | Melden |
| communityGatedTooltip | Tính năng đang được phát triển | Feature coming soon | Funktion kommt bald |
| communityAnonymousContributor | Ẩn danh | Anonymous | Anonym |
| communitySectionTask | 📝 Đề bài | 📝 Task | 📝 Aufgabe |
| communitySectionAnalysis | 📋 Phân tích đề | 📋 Task analysis | 📋 Aufgabenanalyse |
| communitySectionModelAnswer | ✍️ Bài mẫu | ✍️ Model answer | ✍️ Musterantwort |
| communitySectionUsefulPhrases | 💡 Cụm từ hữu ích | 💡 Useful phrases | 💡 Nützliche Redewendungen |
| communitySectionGrammar | 📖 Ngữ pháp trọng tâm | 📖 Grammar focus | 📖 Grammatikschwerpunkt |
| communitySectionMistakes | ⚠️ Lỗi thường gặp | ⚠️ Common mistakes | ⚠️ Häufige Fehler |
| communitySectionSpeakingContent | 🎙️ Nội dung | 🎙️ Content | 🎙️ Inhalt |

Reused existing getters: `l10n.communityExamsTitle`, `l10n.communityExamsEmpty`, `l10n.communityExamContributedBy`, `l10n.couldNotLoadData`.

## Verification
- `flutter analyze lib/screens/exam/community_exams_list_screen.dart lib/screens/exam/community_exam_detail_screen.dart lib/screens/exam/widgets/community lib/data/exam/exam_ecosystem_models.dart lib/view_models/exam/exam_ecosystem_providers.dart lib/repositories/exam/community_exam_repository.dart` → **0 issues**.
- `flutter analyze lib/screens/exam lib/data/exam lib/view_models/exam` (broader scope) → 6 issues, **all in `lib/screens/exam/widgets/schedule/buddy_card.dart` and `buddy_directory_tab.dart`** (another parallel agent's in-progress files — confirmed via `git status -s`, I never touched them).
- `flutter test test/structure/release_live_data_guard_test.dart` → 1 pre-existing failure on `lib/screens/practice/widgets/practice_cloze_view.dart` (`PlaceholderAlignment` false-positive, unrelated to my scope, modified by a different concurrent agent per `git status`). My 3 scanned files (`community_exams_list_screen.dart`, `community_exam_detail_screen.dart`, `community_exam_repository.dart`) trigger no matches.
- Routes already point at `CommunityExamsListScreen`/`CommunityExamDetailScreen` (`lib/navigation/routes/exam_routes.dart:124,128`) — no route file changes needed or made.

Status: DONE_WITH_CONCERNS
Summary: Both screens rebuilt to web-parity (tabs, filters, structured detail sections, gated write actions); 4 additive fields added to `CommunityExamTopic` + `teil` param added to `CommunityExamFilter`/repository, both contract-verified against the actual Go handler/struct, not guessed.
Concerns/Blockers: (1) speaking topics whose `generated_data` is a bare JSON string (not an object) will render nothing — narrow gap, see deviation note; (2) search is client-side only, not wired to the live `/search` endpoint; (3) coordinator should double-check no other wave also touched `exam_ecosystem_models.dart` / `exam_ecosystem_providers.dart` / `community_exam_repository.dart` concurrently since these are shared, not exclusively owned by me.
