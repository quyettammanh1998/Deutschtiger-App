import 'package:deutschtiger/services/api_client.dart';

/// Award-XP call for the YouTube dictation practice loop — web parity
/// `useAwardXP().mutate({xp:1})` in `youtube-dictation-page.tsx`. Reuses the
/// existing generic `/user/gamification/award-xp` endpoint (see
/// `docs/flutter-api-contract-matrix.md` §Generic XP award); no `source` tag
/// so this does not feed the weekly composite ranking, matching web.
class DictationXpRepository {
  DictationXpRepository(this._api);

  final ApiClient _api;

  /// Fire-and-forget, same as web's non-blocking mutation — caller does not
  /// need to await/handle failures (best-effort XP credit only).
  Future<void> awardSentenceXp() async {
    try {
      await _api.post<dynamic>('/user/gamification/award-xp', body: {'amount': 1});
    } catch (_) {
      // Best-effort — never blocks the dictation flow on XP failure.
    }
  }
}
