# Brainstorm Summary: Vocabulary + Notes + YouTube Features

**Date:** 2026-06-30
**Project:** Deutschtiger-App (Flutter) ← Sync from DeutschTiger (Web)

---

## Problem Statement

The Flutter app needs to sync 3 key features from the web app:
1. **Vocabulary Search** - Connect mock UI to real backend API + add vocabulary notes
2. **Video Notes** - Personal notes per YouTube video in Interview feature
3. **YouTube Extended** - Transcript panel for video learning

---

## Agreed Solution

### 1. Vocabulary Search + Notes (Approach B: Connect + Basic Notes)

**Files to modify:**
- `lib/features/vocabulary_search/data/vocabulary_repository.dart` - Connect to real API
- `lib/features/vocabulary_search/domain/vocab_models.dart` - Add `note` field
- `lib/features/vocabulary_search/presentation/vocab_search_screen.dart` - Add notes tab/UI
- `lib/features/vocabulary_search/widgets/vocabulary_detail_panel.dart` - Add notes editing

**API Endpoints:**
- `GET /api/v1/vocabulary/search?q={query}&page=&pageSize=&cefr_level=` - Search
- `GET /api/v1/vocabulary/{id}` - Get word detail
- `GET /user/vocabulary/notes` - Get user's notes for all words
- `PUT /user/vocabulary/notes/{wordId}` - Save/update note

**Data Model:**
```dart
class VocabWord {
  String id;
  String contentDe;
  String contentVi;
  String? level; // A1, A2, B1, B2, C1, C2
  String? pronunciation;
  String? note; // NEW: user note for this word
  // ... existing fields
}
```

---

### 2. Video Notes (Approach B: Notes + Transcript)

**Files to create:**
- `lib/features/interview/domain/video_note.dart` - Model
- `lib/features/interview/data/video_note_repository.dart` - Repository
- `lib/features/interview/presentation/video_note_provider.dart` - Riverpod providers
- Modify: `lib/features/interview/presentation/video_player_screen.dart` - Add notes panel

**API Endpoints:**
- `GET /user/youtube/notes` - Get all video notes
- `GET /user/youtube/notes/{videoId}` - Get note for specific video
- `PUT /user/youtube/notes/{videoId}` - Create/update note

**UI Design:**
- Expandable notes section below video player
- Simple TextField for markdown-style notes
- Auto-save on blur/change
- Sync indicator

---

### 3. YouTube Extended (Approach A: Transcript Panel Only)

**Files to create:**
- `lib/features/interview/widgets/transcript_panel.dart` - Scrollable transcript
- `lib/features/interview/data/transcript_service.dart` - Fetch from API

**API Endpoint:**
- `GET /api/v1/youtube/transcript?video_id={videoId}` - Get transcript with timestamps

**UI Design:**
- Expandable panel below video
- Transcript lines with timestamps
- Tap to seek to that timestamp
- Tap to save line to flashcards (optional)

---

## Implementation Order

1. **Vocabulary API Connect** - Quick win, validates backend
2. **Vocabulary Notes** - Simple addition
3. **Video Notes (basic)** - Independent feature
4. **Transcript Panel** - Uses existing Interview infrastructure

---

## Risks & Mitigation

| Risk | Mitigation |
|------|------------|
| API response shape differs | Add defensive parsing with fallback |
| Offline usage | Cache transcripts locally |
| Long transcripts performance | Virtual scrolling |

---

## Success Metrics

- [ ] Vocabulary search returns real results in <500ms
- [ ] User can add/view notes on vocabulary words
- [ ] User can add/view notes on video content
- [ ] Transcript panel shows with seek functionality
- [ ] All features work offline with cached data

---

## Next Steps

1. Create implementation plan with `/ck:plan`
2. Backend team confirms API endpoint shapes
3. Implement in phases
