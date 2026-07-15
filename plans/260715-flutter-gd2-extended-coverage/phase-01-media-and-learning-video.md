---
phase: 1
title: "Media and Learning Video"
status: pending
priority: P1
effort: "2–3w"
dependencies: []
---

# Phase 1: Media and Learning Video

## Overview

Deliver G1–G6, L1–L2, C9 and D6 with one reusable media foundation. Existing
interview/listening screens and `youtube_player_iframe` are an inventory, not a
complete learning-video experience.

## Requirements

- YouTube watch supports synchronized transcript, word lookup, bilingual
  subtitles, saved notes and progress without background playback or player
  overlays that violate YouTube policy.
- Self-hosted podcasts support foreground/background audio with notification
  controls; YouTube never uses that background-audio path.
- Course lessons persist progress and notes through authenticated backend
  endpoints; dictation/shadowing use the voice capability only after permission
  is available.

## Architecture

```text
MediaSessionCoordinator
├── YouTubeSession: iframe player + transcript clock + progress/notes
├── HostedAudioSession: just_audio + audio_session + background controls
├── TranscriptSurface: TappableSentence → WordLookupSheet → SaveCardButton
└── CourseProgressRepository: lesson progress + notes + resume state
```

Only one audio owner may play or record at once. `AppShell` owns any permitted
mini-player; `MinimalShell` player routes remain fullscreen and explicit.

## Related Code Files

- Modify: `lib/screens/interview/video_player_screen.dart`, `lib/widgets/interview/transcript_panel.dart`, `lib/widgets/interview/video_notes_panel.dart`
- Modify: `lib/screens/listening/*`, `lib/repositories/interview/*`, `lib/repositories/listening/podcast_repository.dart`, `lib/screens/journey/courses_hub_screen.dart`
- Create: `lib/features/media/{data,domain,presentation}/**` and focused tests under `test/features/media/`
- Modify: `lib/services/audio_service.dart`, `pubspec.yaml`, Android/iOS audio configuration only if background hosted audio is enabled
- Verify contracts in: `thamkhao/deutschtiger-backend/cmd/server/routes_youtube.go`, `routes_user_media.go`, `routes_user.go`, `routes_public.go`

## Implementation Steps

1. Freeze API mapping for public YouTube/course content and authenticated video
   tracking, notes, progress and podcast completion. Add client contract tests
   before replacing static/mock repositories.
2. Extract a `MediaSessionCoordinator` with app lifecycle, interruption,
   buffering, speed, seek and a single-active-source rule. Test Bluetooth/headset
   and recording hand-off with `audio_session`; do not start a second player.
3. Rebuild the YouTube watch surface around `youtube_player_iframe`: stable
   player mount, transcript time index, draggable bilingual subtitles, cinema
   layout, text-size settings, tap-word lookup, saved sentence/note and
   continue-watching. POC mini-player navigation early; remove it if its iframe
   lifecycle is unstable rather than faking persistent playback.
4. Implement hosted podcast/listening hub with the self-hosted audio endpoint,
   episode resume/completion and notification controls. Keep the YouTube path
   foreground-only. Add offline/error states but do not advertise downloads
   unless a licensed cache policy exists.
5. Port course catalog/detail/lesson with mixed-content renderer, notes and
   server-backed progress. Add read-listen hub, subtitle-word learning,
   dictation and shadowing reuse; gate recording steps behind Phase 8 voice
   permission and cleanup.
6. Run real content fixtures for a YouTube video, self-hosted podcast and
   course lesson; compare progress/notes with the web account.

## Success Criteria

- [ ] A YouTube lesson syncs subtitles/transcript, supports word lookup and
  saves/reloads progress and notes after navigation.
- [ ] YouTube has no background playback; a self-hosted podcast resumes through
  an audio interruption and controls remain correct.
- [ ] Course progress and notes round-trip with the same authenticated web user.
- [ ] Dictation/shadowing gracefully hide or explain recording actions when mic
  permission is unavailable.
- [ ] Android and iOS device tests cover seek, background/foreground, headset
  interruption, player disposal and low-network retry.

## Risk Assessment

- Iframe lifecycle is a device-specific risk. A clean full-screen player is a
  valid fallback; no mini-player is better than duplicate or orphaned playback.
- Do not apply a generic audio cache to YouTube URLs. Rights and terms differ
  from hosted podcasts.
