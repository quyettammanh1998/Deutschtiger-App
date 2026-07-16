import 'package:deutschtiger/core/release/release_feature_flags.dart';
import 'package:deutschtiger/navigation/release_redirect.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('old easy-german podcast paths redirect to their renamed web paths', () {
    // P11 W1 renamed the podcast URLs to match web exactly. Old deep links
    // must still resolve — but the listening gate outranks the rename, so a
    // gated-off build never lands on the new screen either.
    if (ReleaseFeatureFlags.listening) {
      expect(
        resolveReleaseRedirect('/listening/easy-german'),
        '/listening/podcast/easy_german',
      );
      expect(
        resolveReleaseRedirect('/listening/easy-german/episode/1'),
        '/listening/podcast/easy_german/1',
      );
    } else {
      expect(resolveReleaseRedirect('/listening/easy-german'), '/learn');
      expect(
        resolveReleaseRedirect('/listening/easy-german/episode/1'),
        '/learn',
      );
    }
  });

  test('release redirects cover every feature-gated route family', () {
    final cases = <({String path, bool enabled, String redirect})>[
      (path: '/landing', enabled: false, redirect: '/welcome'),
      (path: '/welcome-full', enabled: false, redirect: '/welcome'),
      (
        path: '/grammar/topic-a1',
        enabled: ReleaseFeatureFlags.grammar,
        redirect: '/learn',
      ),
      (
        path: '/listening/podcast/easy_german/1',
        enabled: ReleaseFeatureFlags.listening,
        redirect: '/learn',
      ),
      (
        path: '/reading/detail',
        enabled: ReleaseFeatureFlags.reading,
        redirect: '/learn',
      ),
      (
        path: '/journey/roadmap',
        enabled: ReleaseFeatureFlags.journey,
        redirect: '/learn',
      ),
      (
        path: '/speaking/practice',
        enabled: ReleaseFeatureFlags.speaking,
        redirect: '/learn',
      ),
      (
        path: '/pronunciation',
        enabled: ReleaseFeatureFlags.pronunciation,
        redirect: '/learn',
      ),
      (
        path: '/games/matching',
        enabled: ReleaseFeatureFlags.practice,
        redirect: '/learn',
      ),
      (path: '/ai', enabled: ReleaseFeatureFlags.aiTutor, redirect: '/learn'),
      (
        path: '/ai-tutor/chat',
        enabled: ReleaseFeatureFlags.aiTutor,
        redirect: '/learn',
      ),
      (
        path: '/social/messages',
        enabled: ReleaseFeatureFlags.social,
        redirect: '/home',
      ),
      (
        path: '/stats/error-patterns',
        enabled: ReleaseFeatureFlags.stats,
        redirect: '/home',
      ),
      (
        path: '/affiliate/leaderboard',
        enabled: ReleaseFeatureFlags.affiliate,
        redirect: '/home',
      ),
      (
        path: '/settings/premium',
        enabled: ReleaseFeatureFlags.premium,
        redirect: '/settings',
      ),
      (
        path: '/exam/goethe-b1/writing-topics',
        enabled: ReleaseFeatureFlags.legacyGoetheB1,
        redirect: '/exam',
      ),
    ];

    for (final route in cases) {
      expect(
        resolveReleaseRedirect(route.path),
        route.enabled ? isNull : route.redirect,
        reason: 'Expected release gate for ${route.path}',
      );
    }
  });

  test('live and explicitly allowed routes are not redirected', () {
    expect(resolveReleaseRedirect('/vocabulary'), isNull);
    expect(resolveReleaseRedirect('/exam'), isNull);
    expect(resolveReleaseRedirect('/learn/session/today'), isNull);
  });

  test('old mission session path redirects to the web-parity path', () {
    expect(
      resolveReleaseRedirect('/journey/session'),
      '/learn/session/today',
    );
  });

  test('social sub-routes without a live contract stay gated independently', () {
    // Challenges/duels have no wired backend contract (challenges) or
    // realtime/moderation POC (duels) yet, so they redirect to Friends even
    // while the blanket `social` flag is on. Groups was deleted entirely
    // (P12 wave B) — web never had it — so it always redirects too.
    expect(ReleaseFeatureFlags.socialChallenges, isFalse);
    expect(ReleaseFeatureFlags.socialDuels, isFalse);
    expect(resolveReleaseRedirect('/social/groups'), '/social/friends');
    expect(resolveReleaseRedirect('/social/group/1'), '/social/friends');
    expect(resolveReleaseRedirect('/social/challenges'), '/social/friends');
    expect(resolveReleaseRedirect('/social/duel/lobby'), '/social/friends');
    // Bare hub, moments and announcements were deleted (P12 wave B) — deep
    // links fall back instead of 404ing.
    expect(resolveReleaseRedirect('/social'), '/social/friends');
    expect(resolveReleaseRedirect('/social/moments'), '/social/friends');
    expect(resolveReleaseRedirect('/social/announcements'), '/home');
    // Live social surfaces stay reachable.
    expect(resolveReleaseRedirect('/social/friends'), isNull);
    expect(resolveReleaseRedirect('/social/profile/user-1'), isNull);
  });

  test('achievements screen was deleted; deep links redirect to Stats', () {
    // `achievements_screen.dart` removed (P12 wave B) — its grid now lives
    // inside Stats. Unconditional, not flag-gated (no screen left to gate).
    expect(resolveReleaseRedirect('/achievements'), '/stats');
  });

  test(
    'web-canonical top-level social paths redirect to the /social/* prefix '
    'Flutter actually uses',
    () {
      // P12 wave B route-sweep gap fix — web's ROUTE_PATHS/ROUTE_PATTERNS use
      // top-level paths for these; Flutter kept a `/social/*` prefix (P12
      // wave A decision).
      expect(resolveReleaseRedirect('/friends'), '/social/friends');
      expect(resolveReleaseRedirect('/challenges'), '/social/challenges');
      expect(resolveReleaseRedirect('/messages'), '/social/messages');
      expect(
        resolveReleaseRedirect('/messages/friend-1'),
        '/social/chat/friend-1',
      );
      expect(
        resolveReleaseRedirect('/profile/user-1'),
        '/social/profile/user-1',
      );
      expect(resolveReleaseRedirect('/profile/edit'), '/settings');
      // roomId-based duel URLs have no Flutter equivalent — best-effort
      // fallback to the lobby (documented gap, not a 404).
      expect(resolveReleaseRedirect('/duel/room-1'), '/social/duel/lobby');
      expect(
        resolveReleaseRedirect('/duel/room-1/play'),
        '/social/duel/lobby',
      );
    },
  );

  test(
    'other web-canonical paths without a matching Flutter route redirect '
    'correctly (route-sweep QA gap fixes)',
    () {
      expect(resolveReleaseRedirect('/'), '/home');
      expect(resolveReleaseRedirect('/privacy'), '/privacy-policy');
      expect(resolveReleaseRedirect('/dieu-khoan'), '/terms-of-service');
      expect(resolveReleaseRedirect('/stats/errors'), '/stats/error-patterns');
      expect(
        resolveReleaseRedirect('/settings/learning'),
        '/settings/learning-preferences',
      );
      expect(resolveReleaseRedirect('/ai-chat'), '/ai');
      expect(
        resolveReleaseRedirect('/learn/capability-map'),
        '/learner-model',
      );
      expect(resolveReleaseRedirect('/exams'), '/exam');
    },
  );

  test('sentence builder is exempt from the blanket games gate', () {
    // Live backend contract (/sentence-builder/*), independent flag —
    // reachable even though the other mock game screens stay gated.
    expect(ReleaseFeatureFlags.sentenceBuilder, isTrue);
    expect(resolveReleaseRedirect('/games/sentence-builder'), isNull);
    expect(resolveReleaseRedirect('/games/sentence-builder/play'), isNull);
    // `/games/matching` (P4 practice-view route) is exempt from the blanket
    // `games` flag too — gated independently by `practice`.
    expect(
      resolveReleaseRedirect('/games/matching'),
      ReleaseFeatureFlags.practice ? isNull : '/learn',
    );
  });

  test('word sprint and typing sprint are exempt from the blanket games gate', () {
    // Live backend contracts (/vocabulary/learned, /user/typing/*),
    // independent flags — reachable even though the other mock games stay
    // gated behind the blanket `games` flag.
    expect(ReleaseFeatureFlags.wordSprint, isTrue);
    expect(ReleaseFeatureFlags.typingSprint, isTrue);
    expect(resolveReleaseRedirect('/games/word-sprint'), isNull);
    expect(resolveReleaseRedirect('/games/typing-sprint'), isNull);
  });

  test(
    'cases mastery and konjugation are exempt from the blanket games gate',
    () {
      // Live backend contracts (/user/cases/*, /user/conjugation/exercise),
      // independent flags — reachable even though the other mock games stay
      // gated behind the blanket `games` flag.
      expect(ReleaseFeatureFlags.casesMastery, isTrue);
      expect(ReleaseFeatureFlags.konjugation, isTrue);
      expect(resolveReleaseRedirect('/games/cases-mastery'), isNull);
      expect(resolveReleaseRedirect('/games/cases-akk-dat'), isNull);
      expect(resolveReleaseRedirect('/games/cases-verb-case'), isNull);
      expect(resolveReleaseRedirect('/games/konjugation'), isNull);
      // Old Flutter-only paths redirect to the web-identical rename.
      expect(resolveReleaseRedirect('/games/cases'), '/games/cases-mastery');
      expect(
        resolveReleaseRedirect('/games/cases/akk-dat'),
        '/games/cases-akk-dat',
      );
      expect(
        resolveReleaseRedirect('/games/cases/verb-case'),
        '/games/cases-verb-case',
      );
    },
  );

  test(
    'listening/runner games are exempt from the blanket '
    'games gate',
    () {
      // Live backend contracts (/vocabulary/learned, /ai/grade-sentence —
      // tái dùng existing repositories), independent flags — reachable even
      // though the other mock games stay gated behind the blanket `games`
      // flag.
      expect(ReleaseFeatureFlags.listeningGame, isTrue);
      expect(ReleaseFeatureFlags.runnerGame, isTrue);
      expect(resolveReleaseRedirect('/games/listening'), isNull);
      expect(resolveReleaseRedirect('/games/runner'), isNull);
      // `/listening` (the listening lesson hub) stays gated by its own flag,
      // unaffected by the `/games/listening` exemption above.
      expect(
        resolveReleaseRedirect('/listening/podcast/easy_german/1'),
        ReleaseFeatureFlags.listening ? isNull : '/learn',
      );
    },
  );

  test(
    'P4 practice-view routes (cloze/flashcards/matching/writing) are exempt '
    'from the blanket games gate, and old paths redirect to the renamed web '
    'paths',
    () {
      // Live backend contract (/user/learning-items/balanced +
      // deck/flashcard repos — tái dùng existing repositories), independent
      // `practice` flag — reachable even though the other mock games stay
      // gated behind the blanket `games` flag.
      expect(ReleaseFeatureFlags.practice, isTrue);
      expect(resolveReleaseRedirect('/games/cloze'), isNull);
      expect(resolveReleaseRedirect('/games/flashcards'), isNull);
      expect(resolveReleaseRedirect('/games/matching'), isNull);
      expect(resolveReleaseRedirect('/games/writing'), isNull);
      // Legacy paths (deleted screens) redirect to the web-parity rename.
      expect(resolveReleaseRedirect('/games/fill-blank'), '/games/cloze');
      expect(resolveReleaseRedirect('/games/flashcard'), '/games/flashcards');
    },
  );

  test(
    'article/word-order games are exempt from the blanket games gate',
    () {
      // Live backend contract (/user/learning-items/balanced, tái dùng
      // LearningItemRepository), independent flags — reachable even though
      // the other mock games stay gated behind the blanket `games` flag.
      expect(ReleaseFeatureFlags.articleGame, isTrue);
      expect(ReleaseFeatureFlags.wordOrderGame, isTrue);
      expect(resolveReleaseRedirect('/games/artikel'), isNull);
      expect(resolveReleaseRedirect('/games/wortstellung'), isNull);
      // Old Flutter-only paths redirect to the web-identical rename.
      expect(resolveReleaseRedirect('/games/article'), '/games/artikel');
      expect(resolveReleaseRedirect('/games/word-order'), '/games/wortstellung');
    },
  );
}
