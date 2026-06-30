---
title: "Deutschtiger TDD Implementation Plan: Vocabulary Notes & Video Transcript"
description: "Phase-by-phase TDD plan for vocabulary API, notes, and video transcript features"
status: pending
priority: P1
effort: 16h
branch: kai/feat/vocab-notes-transcript
tags: [flutter, tdd, riverpod, supabase, api-integration]
created: 2026-06-30
---

# TDD Implementation Plan: Deutschtiger App

## Executive Summary

Implements vocabulary API integration, user notes, and video transcript features following Test-Driven Development. Four sequential phases with test-first approach: Red → Green → Refactor cycle.

**Tech Stack**: Flutter 3.12+ / Riverpod 3.x / Dio / Supabase backend / Freezed

---

## Phase Dependencies Graph

```
Phase 1 (Vocabulary API)
    │
    ├──────────────────────────────┐
    ▼                              ▼
Phase 2 (Vocab Notes)      Phase 3 (Video Notes)
    │                              │
    └──────────────┬───────────────┘
                   ▼
           Phase 4 (Transcript)
```

**Blocker Chain**:
- Phase 2 blocked by Phase 1 (needs API client ready)
- Phase 3 blocked by Phase 1 (needs repository pattern confirmed)
- Phase 4 blocked by Phase 3 (needs video_note model structure)

---

## Phase 1: Vocabulary API Connect

### 1.1 Current State Analysis

**File**: `lib/features/vocabulary_search/data/vocabulary_repository.dart:7-52`

Repository already uses `_apiClient` (dynamic type) with proper API endpoints. Current gaps:
- `_apiClient` typed as `dynamic` (should be `ApiClient`)
- No explicit error handling (relies on `ApiClient._transformError`)
- No loading states in repository layer (handled in providers)

### 1.2 Test Matrix

| Test File | Test Case | Type | API Mock |
|-----------|-----------|------|----------|
| `test/features/vocabulary/repository_test.dart` | `search()` returns `VocabSearchResult` | Unit | Mock Dio |
| `test/features/vocabulary/repository_test.dart` | `search()` throws `ApiException` on 500 | Unit | Mock Dio |
| `test/features/vocabulary/repository_test.dart` | `search()` throws `ApiException` on network error | Unit | Mock Dio |
| `test/features/vocabulary/repository_test.dart` | `getWord()` parses VocabWord correctly | Unit | Mock Dio |
| `test/features/vocabulary/repository_test.dart` | `markAsLearned()` calls correct endpoint | Unit | Mock Dio |
| `test/features/vocabulary/repository_test.dart` | `getLearnedWords()` parses list correctly | Unit | Mock Dio |
| `test/features/vocabulary/repository_test.dart` | `search()` with cefrLevel param | Unit | Mock Dio |
| `test/features/vocabulary/vocab_models_test.dart` | `VocabWord.fromJson()` all fields | Unit | None |
| `test/features/vocabulary/vocab_models_test.dart` | `VocabWord.fromJson()` with nulls | Unit | None |
| `test/features/vocabulary/vocab_models_test.dart` | `VocabSearchResult.fromJson()` | Unit | None |
| `test/features/vocabulary/provider_test.dart` | SearchProvider emits AsyncLoading then AsyncData | Integration | Mock Repo |

### 1.3 Implementation Tasks

#### Task 1.3.1: Fix Type Annotation
```dart
// vocabulary_repository.dart:8
- VocabularyRepository(this._apiClient);
- final dynamic _apiClient;
+ VocabularyRepository(this._apiClient);
+ final ApiClient _apiClient;
```

#### Task 1.3.2: Add Response DTOs
Create `lib/features/vocabulary_search/data/api_responses.dart`:
- `VocabSearchResponse` - wraps `VocabSearchResult`
- `VocabWordResponse` - single word wrapper

#### Task 1.3.3: Add Error Mapping (if needed)
Current `ApiClient._transformError` handles all Dio errors → `ApiException`. Repository rethrows. No extra error handling needed.

#### Task 1.3.4: Update Provider
File: `lib/features/vocabulary_search/presentation/vocab_search_provider.dart`

Add debounce to search to prevent API spam:
```dart
// 300ms debounce before API call
```

### 1.4 Rollback Plan
- Revert type annotation to `dynamic`
- Repository still functional (dynamic dispatch works)
- No DB migration needed

### 1.5 Success Criteria
- [ ] All 11 tests pass
- [ ] `flutter analyze` returns no errors
- [ ] Repository builds with `ApiClient` import

---

## Phase 2: Vocabulary Notes

### 2.1 Design

**API Contract** (to confirm with backend team):
```
PUT /user/vocabulary/notes/{wordId}
Body: { "note": "string" }
Response: { "word_id": "string", "note": "string", "updated_at": "timestamp" }

GET /user/vocabulary/notes/{wordId}
Response: { "word_id": "string", "note": "string", "updated_at": "timestamp" }

GET /user/vocabulary/notes
Response: { "notes": [{ "word_id": "string", "note": "string", ... }] }
```

### 2.2 Model Changes

**File**: `lib/features/vocabulary_search/domain/vocab_models.dart`

Add `note` field to `VocabWord`:
```dart
// Line 2: Add import
import 'package:freezed_annotation/freezed_annotation.dart';

// Line 10: Add note field
@freezed  // Migrate from manual class to Freezed for immutability
abstract class VocabWord with _$VocabWord {
  const factory VocabWord({
    required String id,
    required String word,
    required String translation,
    String? pronunciation,
    String? audioUrl,
    String? example,
    String? exampleTranslation,
    String cefrLevel,
    List<String> tags,
    bool isLearned,
    String? note,  // NEW
  }) = _VocabWord;

  factory VocabWord.fromJson(Map<String, dynamic> json) =>
      _$VocabWordFromJson(json);
}
```

### 2.3 New Files

| File | Purpose |
|------|---------|
| `lib/features/vocabulary_search/data/notes_repository.dart` | CRUD for user notes |
| `lib/features/vocabulary_search/presentation/notes_provider.dart` | Riverpod state |
| `test/features/vocabulary/notes_repository_test.dart` | Repository unit tests |
| `test/features/vocabulary/notes_provider_test.dart` | Provider integration tests |

### 2.4 Test Matrix

| Test Case | Type | Mock |
|-----------|------|------|
| `NotesRepository.saveNote()` calls PUT endpoint | Unit | Mock Dio |
| `NotesRepository.saveNote()` on 401 → throws | Unit | Mock Dio |
| `NotesRepository.getNote()` calls GET endpoint | Unit | Mock Dio |
| `NotesRepository.getNote()` on 404 → returns null note | Unit | Mock Dio |
| `NotesRepository.getAllNotes()` parses list | Unit | Mock Dio |
| `NotesProvider` saves note → invalidates cache | Integration | Mock Repo |
| `NotesProvider` loads note → AsyncData | Integration | Mock Repo |
| `VocabWord` JSON roundtrip with note field | Unit | None |
| `VocabWord` JSON roundtrip without note (backward compat) | Unit | None |

### 2.5 UI Changes

**File**: `lib/features/vocabulary_search/presentation/vocab_search_screen.dart`

Add third tab "Ghi chú":
```dart
// Line 26: Change tab count
_tabController = TabController(length: 3, vsync: this);

// Line 104: Add third tab
Tab(text: 'Ghi chú'),

// Line 119: Add tab view
_NotesTab(),
```

New widget `_NotesTab`:
- ListView of saved notes
- Each item: word + truncated note + timestamp
- Tap to edit note

**File**: `lib/features/vocabulary_search/widgets/vocabulary_detail_panel.dart`

Add notes section at bottom:
```dart
// After _SaveToFlashcardButton (line 90-94)
if (_hasNote) _NotesSection(word: word),

// New widget
class _NotesSection extends ConsumerWidget {
  // TextField for note editing
  // Save button
  // Auto-save on blur
}
```

### 2.6 Rollback Plan
- Revert `VocabWord` to manual class (remove Freezed)
- Delete `notes_repository.dart`
- Revert UI changes
- Backward compat: existing `VocabWord` JSON without `note` field still works

### 2.7 Success Criteria
- [ ] All 9 tests pass
- [ ] User can add/edit/delete notes on any vocab word
- [ ] Notes persist across app restarts
- [ ] Empty state shown when no notes saved

---

## Phase 3: Video Notes

### 3.1 New Feature Files

| File | Purpose |
|------|---------|
| `lib/features/interview/domain/video_note.dart` | Model for video notes |
| `lib/features/interview/data/video_note_repository.dart` | API CRUD |
| `lib/features/interview/presentation/video_note_provider.dart` | Riverpod state |
| `lib/features/interview/widgets/video_notes_panel.dart` | Reusable panel widget |
| `test/features/interview/video_note_repository_test.dart` | Repository tests |
| `test/features/interview/video_note_provider_test.dart` | Provider tests |

### 3.2 Model Design

**File**: `lib/features/interview/domain/video_note.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_note.freezed.dart';
part 'video_note.g.dart';

@freezed
abstract class VideoNote with _$VideoNote {
  const factory VideoNote({
    @Default('') String id,
    @JsonKey(name: 'video_id') @Default('') String videoId,
    @Default('') String note,
    @JsonKey(name: 'video_timestamp_seconds') int? videoTimestampSeconds,
    @Default(0) int createdAt,
    @Default(0) int updatedAt,
  }) = _VideoNote;

  factory VideoNote.fromJson(Map<String, dynamic> json) =>
      _$VideoNoteFromJson(json);
}
```

### 3.3 API Contract

```
POST /user/interview/notes
Body: { "video_id": "string", "note": "string", "video_timestamp_seconds": 120 }
Response: { "id": "string", ... }

GET /user/interview/notes?video_id={videoId}
Response: { "notes": [...] }

PUT /user/interview/notes/{id}
Body: { "note": "string", "video_timestamp_seconds": 120 }
Response: { "id": "string", ... }

DELETE /user/interview/notes/{id}
Response: { "status": "ok" }
```

### 3.4 Test Matrix

| Test Case | Type | Mock |
|-----------|------|------|
| `VideoNoteRepository.createNote()` POST correct body | Unit | Mock Dio |
| `VideoNoteRepository.getNotesByVideo()` GET with query param | Unit | Mock Dio |
| `VideoNoteRepository.updateNote()` PUT with id | Unit | Mock Dio |
| `VideoNoteRepository.deleteNote()` DELETE | Unit | Mock Dio |
| `VideoNoteRepository` on 401 → throws ApiException | Unit | Mock Dio |
| `VideoNoteProvider` creates note → list updates | Integration | Mock Repo |
| `VideoNoteProvider` deletes note → list updates | Integration | Mock Repo |
| `VideoNote.fromJson()` full roundtrip | Unit | None |
| `VideoNote.fromJson()` with null timestamp | Unit | None |

### 3.5 UI Changes

**File**: `lib/features/interview/presentation/video_player_screen.dart`

Add notes panel below video:

```dart
// Line 130: After Expanded body, before closing Column
// Replace SingleChildScrollView content
children: [
  // Existing title + completion button
  // NEW: VideoNotesPanel(videoId: widget.videoId)
]
```

**New Widget**: `video_notes_panel.dart`

```dart
class VideoNotesPanel extends ConsumerWidget {
  final String videoId;

  // Expandable panel with:
  // - List of notes sorted by timestamp
  // - FAB to add new note
  // - Each note: timestamp chip + text + edit/delete actions
  // - Tap timestamp chip → seek video to that position
}
```

**Integration with video player**:
```dart
// Pass VideoPlayerController seek method to panel
// On timestamp tap: _controller.seekTo(Duration(seconds: timestamp))
```

### 3.6 Rollback Plan
- Delete `video_note.dart`, `video_note_repository.dart`, `video_note_provider.dart`
- Delete `video_notes_panel.dart`
- Revert `video_player_screen.dart` to original
- No DB migration needed (notes are user-scoped)

### 3.7 Success Criteria
- [ ] All 9 tests pass
- [ ] User can add timestamped notes while watching video
- [ ] Tap timestamp → video seeks to that position
- [ ] Notes persist across sessions

---

## Phase 4: Transcript Panel

### 4.1 New Feature Files

| File | Purpose |
|------|---------|
| `lib/features/interview/data/transcript_service.dart` | Fetch/transcribe YouTube captions |
| `lib/features/interview/widgets/transcript_panel.dart` | Scrollable transcript UI |
| `test/features/interview/transcript_service_test.dart` | Service tests |
| `test/features/interview/transcript_panel_test.dart` | Widget tests |

### 4.2 Architecture

**Transcript Source Options** (in order of preference):
1. Backend API: `GET /user/interview/transcript/{videoId}` (server fetches from YouTube)
2. YouTube oEmbed: `https://www.youtube.com/oembed?url=https://youtu.be/{id}&format=json`
3. YouTube Caption Download (no auth) - fallback

**Recommended**: Option 1 (backend fetches and caches). For MVP, implement option 2.

### 4.3 Model

**File**: `lib/features/interview/domain/video_note.dart`

Add Transcript model alongside VideoNote:

```dart
@freezed
abstract class TranscriptSegment with _$TranscriptSegment {
  const factory TranscriptSegment({
    required int startMs,
    required int endMs,
    required String text,
  }) = _TranscriptSegment;

  factory TranscriptSegment.fromJson(Map<String, dynamic> json) =>
      _$TranscriptSegmentFromJson(json);
}

typedef Transcript = List<TranscriptSegment>;
```

### 4.4 Service Design

**File**: `lib/features/interview/data/transcript_service.dart`

```dart
class TranscriptService {
  TranscriptService(this._api);
  final ApiClient _api;

  /// Fetch transcript from backend (server fetches from YouTube)
  Future<Transcript> getTranscript(String videoId) async {
    try {
      final response = await _api.get<List<dynamic>>(
        '/user/interview/transcript/$videoId',
      );
      return response
          .map((e) => TranscriptSegment.fromJson(e as Map<String, dynamic>))
          .toList();
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        // No transcript available
        return const [];
      }
      rethrow;
    }
  }
}
```

### 4.5 Test Matrix

| Test Case | Type | Mock |
|-----------|------|------|
| `TranscriptService.getTranscript()` parses segments | Unit | Mock Dio |
| `TranscriptService.getTranscript()` on 404 → empty list | Unit | Mock Dio |
| `TranscriptService.getTranscript()` on 500 → throws | Unit | Mock Dio |
| `TranscriptSegment.fromJson()` full roundtrip | Unit | None |
| `TranscriptPanel` renders empty state | Widget | None |
| `TranscriptPanel` renders segments | Widget | Mock Provider |
| `TranscriptPanel` tap segment → callback fires | Widget | Mock Controller |

### 4.6 UI: TranscriptPanel

**File**: `lib/features/interview/widgets/transcript_panel.dart`

```dart
class TranscriptPanel extends ConsumerWidget {
  final String videoId;
  final void Function(int timestampMs)? onSeek;

  // States:
  // - loading: CircularProgressIndicator
  // - error: ErrorView with retry
  // - empty: "No transcript available" message
  // - data: ListView.builder with TranscriptSegment tiles
  //   - Each tile: timestamp + text
  //   - Tap → onSeek?.call(segment.startMs)
  //   - Auto-scroll to current playback position (optional enhancement)
}
```

**Integration with VideoPlayerScreen**:

```dart
// In VideoPlayerScreen._VideoPlayerScreenState
void _onTranscriptSeek(int ms) {
  _controller.seekTo(Duration(milliseconds: ms));
}

// Pass to panel
VideoNotesPanel(
  videoId: widget.videoId,
  onSeek: _onTranscriptSeek,  // NEW
)
```

### 4.7 Rollback Plan
- Delete all 4 Phase 4 files
- Revert `video_player_screen.dart`
- No breaking changes

### 4.8 Success Criteria
- [ ] All 7 tests pass
- [ ] Transcript panel shows below video
- [ ] Tap segment → video seeks to timestamp
- [ ] Graceful degradation if no transcript

---

## Shared Concerns

### A. Error Handling Strategy

All phases use same error handling pattern:

```dart
try {
  final result = await _repo.someMethod();
  // success
} on ApiException catch (e) {
  // handle: show snackbar, log, retry
  switch (e.statusCode) {
    case 401 => _handleUnauthorized();
    case 404 => _handleNotFound();
    default  => _handleGenericError(e.message);
  }
} catch (e, st) {
  // Unexpected: log to crash reporting
  _handleUnexpected(e, st);
}
```

### B. Offline Behavior

Per `lib/core/offline/offline_service.dart` pattern:
- Notes: Cache locally with `Hive` or `sqflite`
- On reconnect: Sync with server
- Conflict resolution: Server wins (last-write-wins)

### C. Loading States

All providers follow Riverpod `AsyncValue` pattern:
```dart
final myProvider = FutureProvider<Type>((ref) async {
  return ref.read(repo).fetch();
});
```

UI:
```dart
ref.watch(myProvider).when(
  loading: () => CircularProgressIndicator(),
  error: (e, _) => ErrorView(e),
  data: (data) => ContentView(data),
)
```

---

## Implementation Order

| Phase | Files to Create/Modify | Est. Time |
|-------|----------------------|-----------|
| 1 | 1 modified, 0 new | 2h |
| 2 | 4 new, 2 modified | 5h |
| 3 | 4 new, 1 modified | 5h |
| 4 | 2 new, 1 modified | 4h |
| **Total** | | **16h** |

---

## Unresolved Questions

~~1. **Phase 2**: Does backend `PUT /user/vocabulary/notes/{wordId}` create or update? (Upsert vs update)~~ → Use web app pattern
~~2. **Phase 3**: Is `video_timestamp_seconds` in seconds or milliseconds?~~ → **Milliseconds** (user confirmed)
3. **Phase 4**: Does backend provide transcript API? → Use web app endpoints:
   - `POST /user/youtube/transcript` - Extract and translate transcript
   - `GET /user/youtube/transcript/progress/{videoId}` - Get processing progress
   - `GET /youtube/auto/{videoId}` - Get existing transcript
4. **Phase 4**: Should transcript auto-scroll? → **Yes** (user confirmed)

---

## Exact API Endpoints (from web app)

### Video Notes API
```
GET  /user/youtube/notes?limit={limit}         → List all notes
GET  /user/youtube/notes/{videoId}             → Get note for video (404 if none)
PUT  /user/youtube/notes/{videoId}              → Upsert note { content: string }
```

### Transcript API
```
POST /user/youtube/transcript                  → { youtube_url, force?, lang? }
GET  /user/youtube/transcript/progress/{videoId} → TranscriptProgress
GET  /youtube/auto/{videoId}                   → Get auto-generated transcript
```

### Transcript Models (from web)
```typescript
interface TranscriptSubtitle {
  start_time: string  // ISO duration or seconds
  end_time: string
  text_de: string
  text_vi: string
}

interface TranscriptResult {
  video_id: string
  title: string
  subtitles: TranscriptSubtitle[]
}

interface TranscriptProgress {
  status: 'idle' | 'queued' | 'fetching' | 'segmenting' | 'translating' | 'done' | 'error' | 'temporarily_unavailable'
  progress: number
  error?: string
}
```

---

## Appendix: File Ownership

| File | Phase Owner | Prevents |
|------|-------------|----------|
| `lib/features/vocabulary_search/data/vocabulary_repository.dart` | Phase 1 | Concurrent edits |
| `lib/features/vocabulary_search/domain/vocab_models.dart` | Phase 2 | Freezed conflicts |
| `lib/features/vocabulary_search/presentation/vocab_search_screen.dart` | Phase 2 | UI conflicts |
| `lib/features/interview/presentation/video_player_screen.dart` | Phase 3 | UI conflicts |
| `lib/features/interview/domain/video_note.dart` | Phase 3 | Model conflicts |
