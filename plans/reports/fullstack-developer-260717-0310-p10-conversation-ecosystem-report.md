# P10 Conversation Ecosystem Rebuild — Report

Sub-task of Phase 10 (speech UI fidelity), `plans/260716-2324-web-mobile-ui-100-fidelity/`. Scope: Conversation (AI roleplay) hub, scenario chat, history detail, interview import. Parallel sub-tasks own sprechen-exam + pronunciation; routes/ARB/guard-test/providers.dart owned by coordinator.

## Status vs scout B.12–B.15

- **B.12 Conversation hub** (`conversation-hub-page.tsx`) — rebuilt at `lib/screens/speaking/conversation_hub_page.dart`. Tabs (Kịch bản/Lịch sử), hero search-first card (topic input + level select + submit + daily-limit row + quick-suggest chips), filter card (category pills + level pills), 2-col scenario grid, empty states (create-custom CTA / no-match). **Deviation:** `InterviewLibrarySection` (saved-interview shortcuts row above the hero) not built — not in the file list scope explicitly and the interview library repository call exists (`interviewScenariosProvider`) but no UI consumes it yet; flagged for a follow-up pass. Live data: `GET /user/conversation/scenarios`, `GET /user/conversation/daily-quota`.
- **B.13 Conversation scenario (chat)** (`conversation-scenario-page.tsx`) — rebuilt at `lib/screens/speaking/conversation_scenario_page.dart` + `lib/screens/speaking/widgets/conversation/*`. Header (title/ai_role, ⚖️ examiner button, red Thoát), context collapsible, chat body (bubbles + typing indicator + composer), Viết/Mic segmented composer, suggestions-bulb toggle, examiner bottom sheet, done screen with confetti, exit-confirm dialog. Live: `/turn`, `/opening` text-chat loop fully wired through `ConversationDialogController`. **Deviations (all traced to the documented contract boundary, not oversights):**
  - Per-turn scored feedback badges ("x/5 · phản hồi"), the suggestions-panel chip content, and the holistic "⚖️ Đánh giá tổng thể" verdict all depend on `/ai/sprechen-feedback`, `/ai/sprechen-suggestions`, `/ai/conversation-examiner` — **not** in this phase's documented Live/Review contract (`docs/flutter-api-contract-matrix.md` marks the sibling `sprechen_ai_repository.dart` as explicit MASTER P8 scope). Built the UI shells (bubble "Nghe" TTS button works; suggestions panel opens/closes with a pending note; examiner sheet shows the real `TurnResponse.coverage` checklist plus a pending verdict note; done screen shows a pending verdict card) instead of fabricating scores.
  - Voice mode: composer has a working Viết/Mic segmented toggle; Mic segment is `enabled: ReleaseFeatureFlags.speaking`. `ConversationVoiceMicPanel` renders the idle-state shell (reuses `features/voice/RecordButton` as the tap target, wrapped in `IgnorePointer` while the flag is off) with "Quay lại gõ". Waveform/recording/transcribing/review states and actual `RecordingService`/Azure STT wiring are MASTER P8, per task scope.
  - Desktop 2-column layout (`lg:` inline examiner panel) not ported — mobile-only per the plan's `<768px` scope note in the scout doc.
- **B.14 Conversation history detail** (`conversation-history-detail-page.tsx`) — new `lib/screens/conversation/conversation_history_detail_page.dart` + `widgets/conversation_transcript_view.dart`. Live: `GET /user/conversation/sessions/{id}`, read-only bubble transcript reusing `ConversationMessageBubble`. Verdict card shows pending/no-verdict text (verdict payload kept as raw JSON — see models note below) instead of fabricating an `ExaminerVerdict` render.
- **B.15 Interview import** (`interview-import-page.tsx`) — new `lib/screens/conversation/interview_import_page.dart` + `widgets/interview_import_input_step.dart` + `widgets/interview_import_edit_step.dart`. Input step (textarea, CEFR pills, extract button) → edit step (title, per-question DE/VI + hint DE/VI cards, add/remove, save). Live: `/interview/extract`, `/interview/scenarios` (POST). **Deviation:** file upload (`.md`/`.txt` picker) dropped — no `file_picker`/`file_selector` dependency exists in `pubspec.yaml`; adding one is out of this phase's scope. Paste-only still covers the full backend contract (`markdown` string). Documented in the file's doc comment for a follow-up if product wants upload back.

## Routes needed (coordinator wires into `speech_routes.dart` / a new `conversation_routes.dart`)

```
GET  /conversation                          → ConversationHubPage()
GET  /conversation/:id                      → ConversationScenarioPage(scenarioId: state.pathParameters['id'])
GET  /conversation/custom/:slug             → ConversationScenarioPage(
                                                 customSlug: state.pathParameters['slug'],
                                                 customTopic: (state.extra as Map?)?['topic'] as String?,
                                                 customLevel: (state.extra as Map?)?['level'] as String?,
                                               )
GET  /conversation/history/:id              → ConversationHistoryDetailPage(sessionId: state.pathParameters['id'])
GET  /conversation/interview/import         → InterviewImportPage()
GET  /conversation/interview/play/:id       → ConversationScenarioPage(interviewId: state.pathParameters['id'])
```

`lib/navigation/routes/speech_routes.dart` (off-limits, coordinator-owned) currently:
1. Imports `speaking_screen.dart`, `speaking_hub_screen.dart`, `shadowing_page.dart` — **all deleted this pass** (scout §C confirmed no web counterpart). Coordinator must drop those routes/imports.
2. Instantiates `ConversationHubPage()` (still compiles — no constructor change) at `/conversation` (`conversationShellRoutes`, already correct) and at `/speaking/conversation-hub` (now a duplicate/legacy path — recommend dropping, hub is web-parity top-level `/conversation` only).
3. Instantiates `ConversationScenarioPage(conversationId: ...)` at `/speaking/conversation/:conversationId` — **constructor changed** (no more `conversationId` named param; now `scenarioId`/`customSlug`/`customTopic`/`customLevel`/`interviewId`, all optional). This call site needs updating to the new routes above, or dropping.

## Flat ARB key list (vi | en | de placeholders below; coordinator merges into `app_vi.arb`/`app_en.arb`/`app_de.arb`)

Reused existing keys (no new ARB needed): `close`, `retry`.

New keys — `key: vi | en | de`:

- `conversationHubTitle: Hội thoại (AI) | AI Conversation | KI-Gespräch`
- `conversationHubSubtitle: Alltagsdeutsch · Khám phá & luyện nói | Everyday German · Explore & practice speaking | Alltagsdeutsch · Entdecken & sprechen üben`
- `conversationHubLoadError: Không thể tải danh sách kịch bản. | Couldn't load the scenario list. | Szenarienliste konnte nicht geladen werden.`
- `conversationTabScenarios: Kịch bản | Scenarios | Szenarien`
- `conversationTabHistory: Lịch sử luyện tập | Practice history | Übungsverlauf`
- `conversationHeroBadge: AI tạo hội thoại tức thì | AI creates a conversation instantly | KI erstellt sofort ein Gespräch`
- `conversationHeroTitle: Bạn muốn luyện nói về điều gì hôm nay? | What do you want to practice speaking about today? | Worüber möchtest du heute sprechen üben?`
- `conversationHeroSearchHint: Gõ chủ đề bất kỳ hoặc tìm chủ đề có sẵn… | Type any topic or search existing ones… | Gib ein beliebiges Thema ein oder suche vorhandene…`
- `conversationHeroCreateNow: Tạo ngay | Create now | Jetzt erstellen`
- `conversationHeroUpgrade: Nâng Plus ✨ | Upgrade to Plus ✨ | Auf Plus upgraden ✨`
- `conversationHeroTryNow: Thử ngay: | Try now: | Jetzt ausprobieren:`
- `conversationQuotaFreeRemaining: {remaining, plural, =0{Đã dùng hết {max}/{max} bài hội thoại hôm nay} other{Còn {remaining}/{max} bài miễn phí hôm nay}} | Placeholder-style: pass (remaining,max) ints | same pattern EN/DE` *(implemented as a 2-arg method `conversationQuotaFreeRemaining(int remaining, int max)`)*
- `conversationQuotaWalled: {max, plural, other{Đã dùng hết {max}/{max} bài hội thoại hôm nay}} | You've used all {max}/{max} free conversations today | Du hast alle {max}/{max} kostenlosen Gespräche heute aufgebraucht` *(1-arg method `conversationQuotaWalled(int max)`)*
- `conversationQuotaUnlimited: Không giới hạn | Unlimited | Unbegrenzt`
- `conversationFilterLibraryTitle: Hoặc chọn từ thư viện | Or pick from the library | Oder aus der Bibliothek wählen`
- `conversationFilterResultCount: {count} chủ đề | {count} topics | {count} Themen` *(1-arg method, int)*
- `conversationFilterClear: Xoá lọc | Clear filters | Filter löschen`
- `conversationFilterCategory: Thể loại | Category | Kategorie`
- `conversationFilterLevel: Cấp độ | Level | Niveau`
- `conversationFilterAll: Tất cả | All | Alle`
- `conversationCreateCustomTitle: Tạo chủ đề riêng: „{topic}" | Create custom topic: "{topic}" | Eigenes Thema erstellen: „{topic}"` *(1-arg method, String)*
- `conversationCreateCustomHint: Không có sẵn — để AI soạn một hội thoại mới cho bạn | Not available — let AI draft a new conversation for you | Nicht verfügbar — lass die KI ein neues Gespräch für dich erstellen`
- `conversationEmptyNoResults: Không tìm thấy chủ đề | No topics found | Keine Themen gefunden`
- `conversationEmptyNoResultsHint: Thử gõ chủ đề riêng ở ô phía trên nhé! | Try typing your own topic above! | Versuche oben ein eigenes Thema einzugeben!`
- `conversationHistoryLoadError: Không thể tải lịch sử luyện tập. | Couldn't load practice history. | Übungsverlauf konnte nicht geladen werden.`
- `conversationHistoryEmpty: Chưa có bài luyện tập nào được lưu. | No saved practice sessions yet. | Noch keine gespeicherten Übungssitzungen.`
- `conversationHistoryEmptyHint: Hoàn thành một cuộc hội thoại để lưu lại đây. | Finish a conversation to save it here. | Beende ein Gespräch, um es hier zu speichern.`
- `conversationHistoryMeta: {level} · {turns} lượt · {date} | {level} · {turns} turns · {date} | {level} · {turns} Runden · {date}` *(3-arg method: String level, int turns, String date)*
- `conversationHistoryDelete: Xóa | Delete | Löschen`
- `conversationHistoryCancel: Hủy | Cancel | Abbrechen`
- `conversationHistoryDetailLoadError: Không tải được bài hội thoại đã lưu. | Couldn't load the saved conversation. | Das gespeicherte Gespräch konnte nicht geladen werden.`
- `conversationHistoryBackToList: Về danh sách | Back to list | Zurück zur Liste`
- `conversationLoadError: Không thể tải kịch bản. Vui lòng thử lại. | Couldn't load the scenario. Please try again. | Szenario konnte nicht geladen werden. Bitte erneut versuchen.`
- `conversationBack: Quay lại | Back | Zurück`
- `conversationContextLabel: Tình huống | Situation | Situation`
- `conversationYourRoleLabel: Vai bạn: | Your role: | Deine Rolle:`
- `conversationListen: Nghe | Listen | Anhören`
- `conversationExaminerButton: Giám khảo | Examiner | Prüfer`
- `conversationExaminerTitle: ⚖️ Giám khảo AI | ⚖️ AI Examiner | ⚖️ KI-Prüfer`
- `conversationExaminerCoverageTitle: Nội dung cần đề cập | Content to cover | Zu behandelnde Inhalte`
- `conversationExaminerVerdictPending: Đánh giá tổng thể đang được phát triển. | Overall assessment is coming soon. | Die Gesamtbewertung wird noch entwickelt.`
- `conversationExaminerNoVerdict: Chưa có đánh giá cho bài này. | No assessment for this session yet. | Für diese Sitzung liegt noch keine Bewertung vor.`
- `conversationExit: Thoát | Exit | Verlassen`
- `conversationExitConfirmTitle: Thoát hội thoại? | Exit the conversation? | Gespräch verlassen?`
- `conversationExitConfirmBody: Tiến trình hiện tại sẽ không được lưu. | Your current progress won't be saved. | Dein aktueller Fortschritt wird nicht gespeichert.`
- `conversationExitConfirmCta: Thoát | Exit | Verlassen`
- `conversationExitCancelCta: Tiếp tục | Continue | Weiter`
- `conversationComposerHint: Nhập hoặc nói tiếng Đức... | Type or speak German... | Deutsch eingeben oder sprechen...`
- `conversationComposerModeText: Viết | Type | Schreiben`
- `conversationComposerModeVoice: Mic | Mic | Mikrofon`
- `conversationSuggestionsTitle: Gợi ý | Suggestions | Vorschläge`
- `conversationSuggestionsPending: Gợi ý câu trả lời đang được phát triển. | Answer suggestions are coming soon. | Antwortvorschläge werden noch entwickelt.`
- `conversationVoiceTapToSpeak: Nhấn để nói | Tap to speak | Zum Sprechen tippen`
- `conversationVoiceComingSoon: Tính năng nói sẽ sớm ra mắt. | Voice input is coming soon. | Spracheingabe kommt bald.`
- `conversationVoiceBackToText: Quay lại gõ | Back to typing | Zurück zum Tippen`
- `conversationDoneTitle: Hoàn thành hội thoại! | Conversation complete! | Gespräch abgeschlossen!`
- `conversationDoneSubtitle: {title} · {turns} lượt hội thoại | {title} · {turns} conversation turns | {title} · {turns} Gesprächsrunden` *(2-arg method: String title, int turns)*
- `conversationDoneRestart: Thực hành lại | Practice again | Erneut üben`
- `conversationDoneChooseAnother: Chọn kịch bản khác | Choose another scenario | Anderes Szenario wählen`
- `interviewImportTitle: Luyện phỏng vấn từ tài liệu | Practice interviews from a document | Interviews aus einem Dokument üben`
- `interviewImportDesc: Dán tài liệu chuẩn bị → AI tạo buổi phỏng vấn; câu trả lời bạn soạn thành gợi ý. | Paste your prep doc → AI builds the interview; your answers become hints. | Vorbereitungsdokument einfügen → KI erstellt das Interview; deine Antworten werden zu Hinweisen.`
- `interviewImportBackToEdit: Sửa tài liệu | Edit document | Dokument bearbeiten`
- `interviewImportDocLabel: Tài liệu phỏng vấn | Interview document | Interviewdokument`
- `interviewImportDocHint: Dán câu hỏi + câu trả lời bạn đã chuẩn bị... | Paste the questions + answers you prepared... | Füge die vorbereiteten Fragen + Antworten ein...`
- `interviewImportLevelLabel: Trình độ (CEFR) | Level (CEFR) | Niveau (CEFR)`
- `interviewImportExtract: ✨ Trích xuất câu hỏi | ✨ Extract questions | ✨ Fragen extrahieren`
- `interviewImportExtracting: Đang trích xuất... | Extracting... | Wird extrahiert...`
- `interviewImportTitleLabel: Tên buổi phỏng vấn | Interview name | Name des Interviews`
- `interviewImportEditHint: Kiểm tra & sửa câu hỏi và gợi ý trước khi lưu. Gợi ý chỉ hiển thị cho bạn, AI không thấy. | Review & edit questions and hints before saving. Hints are visible to you only, not the AI. | Fragen und Hinweise vor dem Speichern prüfen & bearbeiten. Hinweise sind nur für dich sichtbar, nicht für die KI.`
- `interviewImportQuestionLabel: Câu {n} | Question {n} | Frage {n}` *(1-arg method, int)*
- `interviewImportQuestionDeHint: Câu hỏi phỏng vấn (tiếng Đức) | Interview question (German) | Interviewfrage (Deutsch)`
- `interviewImportQuestionViHint: Dịch nghĩa (tiếng Việt) | Translation (Vietnamese) | Übersetzung (Vietnamesisch)`
- `interviewImportHintDeHint: Gợi ý — câu trả lời bạn chuẩn bị (tiếng Đức) | Hint — your prepared answer (German) | Hinweis — deine vorbereitete Antwort (Deutsch)`
- `interviewImportHintViHint: Gợi ý (tiếng Việt) | Hint (Vietnamese) | Hinweis (Vietnamesisch)`
- `interviewImportAddQuestion: + Thêm câu hỏi | + Add question | + Frage hinzufügen`
- `interviewImportSave: Lưu & bắt đầu luyện | Save & start practicing | Speichern & üben beginnen`
- `interviewImportSaving: Đang lưu... | Saving... | Wird gespeichert...`

## Deletions confirmed (scout §C, no web counterpart)

- `lib/screens/speaking/speaking_screen.dart`
- `lib/screens/speaking/speaking_hub_screen.dart`
- `lib/screens/speaking/shadowing_page.dart`
- `lib/screens/speaking/widgets/ai_conversation_card.dart` (only referenced by `speaking_screen.dart`, now deleted)
- `lib/screens/speaking/widgets/shadowing_session_card.dart` (only referenced by `shadowing_page.dart`, now deleted)

**Only remaining referencer of all 5 deleted files was `lib/navigation/routes/speech_routes.dart`** (off-limits, coordinator-owned) — it will fail to compile until the coordinator drops those imports/routes per the "Routes needed" section above. Confirmed via `grep -rln` before deleting; no other file in `lib/` imported them.

## Voice-mic-panel UI shell — exact gating for MASTER P8

- `lib/screens/speaking/widgets/conversation/conversation_composer.dart`: Viết/Mic `SegmentedButton`, Mic segment `enabled: ReleaseFeatureFlags.speaking`.
- `lib/screens/speaking/widgets/conversation/conversation_voice_mic_panel.dart`: renders when Mic mode is selected. Wraps `features/voice/RecordButton` (idle mic-icon circle) in `IgnorePointer(ignoring: !ReleaseFeatureFlags.speaking)` + `Opacity(0.5)` when the flag is off. `RecordButton(onRecordingComplete: (_) {})` — no-op callback today; MASTER P8 replaces this with the real transcript → composer hookup (the button itself already drives `features/voice/domain/voice_providers.dart`'s `recordingProvider` when tapped and the flag is on — no shell rebuild needed, just wire `onRecordingComplete`).
- `features/voice/*` (record_button, recording_service, voice_providers) untouched — reused, not modified, per instructions.

## Files created/modified

**Repositories/models/provider (owned):**
- `lib/data/speech/conversation_models.dart`, `conversation_display.dart`, `conversation_session_models.dart`
- `lib/repositories/speech/conversation_repository.dart`, `conversation_session_repository.dart`, `interview_repository.dart`
- `lib/view_models/speech/conversation_provider.dart`, `conversation_dialog_controller.dart`

**Screens (rebuilt in place / new):**
- `lib/screens/speaking/conversation_hub_page.dart`, `conversation_scenario_page.dart` (rebuilt, same class names/routes as before)
- `lib/screens/speaking/widgets/conversation/{conversation_topic_icon,tailwind_gradient,scenario_card,conversation_hero,conversation_filter_pills,conversation_scenario_grid,conversation_history_tab,conversation_context_collapsible,conversation_message_bubble,conversation_composer,conversation_voice_mic_panel,conversation_suggestions_panel,conversation_examiner_sheet,conversation_dialog_body,conversation_done_screen}.dart` (new, each <200 LOC)
- `lib/screens/conversation/conversation_history_detail_page.dart`, `interview_import_page.dart` (new)
- `lib/screens/conversation/widgets/{conversation_transcript_view,interview_import_input_step,interview_import_edit_step}.dart` (new)

**Tests (owned):**
- `test/screens/speaking/conversation_display_test.dart` (10 tests — slug/level/scenario-display helpers)
- `test/screens/speaking/conversation_repository_test.dart` (4 tests — scenarios/scenario/turn/opening, Dio adapter fake)
- `test/screens/conversation/conversation_session_repository_test.dart` (4 tests — quota/sessions/save, incl. graceful-null-on-failure)

**Deleted:** the 5 files listed above.

## Validation

- `flutter analyze lib/repositories/speech lib/data/speech lib/view_models/speech lib/screens/speaking lib/screens/conversation` → 92 issues: 89 `undefined_getter`/`undefined_method` errors, **all** `for the type 'AppLocalizations'`, i.e. exactly the expected pending-ARB-merge set (verified via grep — zero non-AppLocalizations errors); 3 `info` (2× `prefer_initializing_formals`, 1× `use_null_aware_elements`), 0 warnings.
- `flutter test test/screens/speaking/ test/screens/conversation/` → 18/18 pass.

## Unresolved questions

1. `InterviewLibrarySection` (saved-interview quick-access row on the hub) not built this pass — should it land now or with a follow-up once `interviewScenariosProvider` has a consumer, or is the import flow (`/conversation/interview/import`) sufficient entry for GĐ1?
2. Should `/speaking/conversation-hub` / `/speaking/conversation/:conversationId` (legacy Flutter-only paths) be dropped entirely from `speech_routes.dart`, or kept as redirects to `/conversation` / `/conversation/:id` for any existing deep links?
3. File-upload in interview import (web has `.md`/`.txt` picker) was dropped for lack of a `file_picker` dependency — confirm this is acceptable for GĐ1, or should the dependency be added in a follow-up phase?

Status: DONE_WITH_CONCERNS
Summary: Conversation hub/scenario/history/interview rebuilt with live scenarios/turn/opening/survey/sessions/quota/interview wiring; AI-graded features (feedback score, suggestions, holistic verdict) built as UI shells pending MASTER P8 per documented contract boundary; 5 orphaned Flutter-only screens deleted (only referencer was the coordinator-owned `speech_routes.dart`, which needs updating); analyze/tests clean modulo expected pending ARB keys.
Concerns/Blockers: `speech_routes.dart` will not compile until coordinator applies the route changes listed above (new `ConversationScenarioPage` constructor shape + dropped imports for deleted screens) — this is expected hand-off work, not a defect in this phase's files.
