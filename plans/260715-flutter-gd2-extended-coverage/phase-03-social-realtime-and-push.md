---
phase: 3
title: "Social Realtime and Push"
status: pending
priority: P0
effort: "2–3w"
dependencies: []
---

# Phase 3: Social Realtime and Push

## Overview

Deliver K1–K5, I5, D9 and N4 with an explicit UGC safety model. Social routes
exist in the Go backend, but message/user reporting and mobile FCM/APNs delivery
are not proven by the current web-push subscription routes.

## Requirements

- Ship block and report entry points in every Flutter user/message surface
  before enabling social creation/realtime.
- Realtime reconnects with bounded backoff and correct unread state; it never
  silently duplicates messages or exposes blocked users.
- Mobile push device tokens have a separate, authenticated lifecycle from web
  VAPID subscriptions, including refresh and logout revocation.

## Architecture

```text
SocialRepository ── REST bootstrap ── Go user/social routes
      │
      ├─ RealtimeTransport (POC-selected, reconnect/backoff/dedupe)
      ├─ ModerationActions (block, report user/message, rate limit)
      └─ MobilePushRegistration (FCM token + platform + revoke)
                 ↓
           backend sender → FCM HTTP v1 → APNs for iOS
```

## Related Code Files

- Modify: `lib/repositories/social/social_repository.dart`, `lib/screens/social/**`, `lib/view_models/social/**`
- Modify: `lib/services/notifications/{fcm_notification_service,notification_service}.dart`, `lib/screens/reminders/reminder_settings_screen.dart`
- Create: `lib/features/social_realtime/**`, `lib/features/notifications/**`, `test/features/social_realtime/**`
- Modify: `android/app/src/main/AndroidManifest.xml`, `ios/Runner/Info.plist`, Firebase platform config only when the sender path is live
- Modify: backend social/message/report/push handlers, migrations and sender in `thamkhao/deutschtiger-backend/`

## Implementation Steps

1. Perform a transport POC with the same auth, foreground/background and
   reconnect behavior needed by Flutter. Select one transport and document its
   ordering, dedupe key and backoff policy before adding chat UI state.
2. Add the UGC safety contract first: block UI in profiles/conversations,
   `report user/message` endpoint(s), reasons, rate limits, support contact and
   admin review trail. Filter blocked relationships server-side in lists,
   messages, realtime fanout and notifications.
3. Port profile/friends/conversations/messages/reactions using REST bootstrap
   plus realtime deltas. Make optimistic messages idempotent with a client
   request ID; reconcile server ack, retry and unread counts.
4. Implement duel lobby/play and study-buddy/exam-date flows only after user
   identity, block/report and reconnect behavior pass. LiveKit calling is a
   separate foreground-only POC; do not imply CallKit/ConnectionService support
   without native integration.
5. Add mobile push backend: device-token table with user/platform/token/revoked
   state, FCM HTTP v1 sender, preference gate, token refresh and logout revoke.
   Keep existing `/push-subscriptions` for web VAPID separate unless a versioned
   shared schema is designed.
6. Request notification permission from Settings after user intent, including
   Android 13 runtime behavior. Test foreground, terminated deep-link routing,
   blocked-user notification suppression and token rotation.

## Success Criteria

- [ ] A user can report and block another user/message from Flutter; server
  enforcement removes that actor from future REST, realtime and push results.
- [ ] Two devices exchange one chat message with one rendered copy, accurate
  unread counts and bounded recovery after network interruption.
- [ ] FCM token registration/refresh/logout revoke is authenticated and sends a
  test notification on Android and iOS only after the user opts in.
- [ ] Duel and call POCs state their supported foreground/notification behavior
  truthfully; no unsupported incoming-call promise is exposed.
- [ ] Data Safety/privacy labels include message, push-token and notification
  data in the release that enables these features.

## Risk Assessment

- Apple UGC review requires more than an endpoint: the visible report/block
  path and an actionable moderation process must be testable.
- Realtime ordering and duplicate delivery are normal failure modes; model them
  explicitly rather than relying on a widget stream's arrival order.
