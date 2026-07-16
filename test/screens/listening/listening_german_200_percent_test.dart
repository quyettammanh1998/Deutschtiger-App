import 'package:deutschtiger/data/listening/easy_german_models.dart';
import 'package:deutschtiger/data/listening/podcast_models.dart';
import 'package:deutschtiger/data/youtube/youtube_video.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/previews/preview_auth_service.dart';
import 'package:deutschtiger/repositories/listening/podcast_repository.dart';
import 'package:deutschtiger/screens/listening/easy_german_level_page.dart';
import 'package:deutschtiger/screens/listening/easy_german_podcast_page.dart';
import 'package:deutschtiger/screens/listening/easy_german_podcast_player_page.dart';
import 'package:deutschtiger/screens/listening/listening_hub_screen.dart';
import 'package:deutschtiger/screens/listening/sprechen_b1_page.dart';
import 'package:deutschtiger/screens/listening/sprechen_b2_page.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:deutschtiger/view_models/listening/easy_german_provider.dart';
import 'package:deutschtiger/view_models/listening/podcast_provider.dart';
import 'package:deutschtiger/view_models/providers.dart';
import 'package:deutschtiger/view_models/youtube/youtube_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// German 200% text-scale reflow smoke test for the P11 W1 listening/podcast
/// screens — plan protocol requires new UI to not overflow at German 200%.
/// Mirrors `test/screens/journey/course_german_200_percent_test.dart`.
void main() {
  final testRepository = PodcastRepository(
    ApiClient(baseUrl: 'https://example.test/api/v1', tokenProvider: _NoTokenProvider()),
    'https://static.test',
  );

  Widget wrap(Widget child, List<Override> overrides) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        locale: const Locale('de'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: MediaQuery(
          data: const MediaQueryData(size: Size(390, 844), textScaler: TextScaler.linear(2)),
          child: child,
        ),
      ),
    );
  }

  void setPhysicalSize(WidgetTester tester) {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('listening hub reflows at German 200% without overflow', (tester) async {
    setPhysicalSize(tester);
    await tester.pumpWidget(wrap(const ListeningHubScreen(), [
      for (final level in const ['a1', 'a2', 'b1', 'b2', 'c1'])
        easyGermanIndexProvider(level).overrideWith((ref) async => const []),
      podcastIndexProvider.overrideWith((ref) async => const []),
      pendingVideosProvider.overrideWith((ref) async => const <YouTubeVideo>[]),
      completedVideosProvider.overrideWith((ref) async => const <YouTubeVideo>[]),
    ]));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('easy german level page reflows at German 200% without overflow', (tester) async {
    setPhysicalSize(tester);
    await tester.pumpWidget(wrap(const EasyGermanLevelPage(level: 'a1'), [
      authServiceProvider.overrideWithValue(PreviewAuthService()),
      easyGermanIndexProvider('a1').overrideWith(
        (ref) async => const [
          EasyGermanVideo(videoId: 'abc12345678', title: 'Ein Anruf bei der Bank in Berlin', segments: 40),
        ],
      ),
      pendingVideosProvider.overrideWith((ref) async => const []),
      completedVideosProvider.overrideWith((ref) async => const []),
    ]));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('podcast index page reflows at German 200% without overflow', (tester) async {
    setPhysicalSize(tester);
    await tester.pumpWidget(wrap(const EasyGermanPodcastPage(), [
      authServiceProvider.overrideWithValue(PreviewAuthService()),
      podcastIndexProvider.overrideWith(
        (ref) async => const [
          PodcastEpisode(slug: 'ep-1', title: 'Im Restaurant bestellen und bezahlen', duration: 610, segments: 12),
        ],
      ),
      podcastCompletedIdsProvider.overrideWith((ref) async => const []),
      podcastLeaderboardProvider.overrideWith((ref) async => const []),
      podcastUserRankProvider.overrideWith((ref) async => null),
    ]));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('podcast player page reflows at German 200% without overflow', (tester) async {
    setPhysicalSize(tester);
    await tester.pumpWidget(wrap(const EasyGermanPodcastPlayerPage(slug: 'ep-1'), [
      podcastRepositoryProvider.overrideWithValue(testRepository),
      podcastEpisodeProvider('ep-1').overrideWith(
        (ref) async => const PodcastEpisodeDetail(
          slug: 'ep-1',
          title: 'Im Restaurant bestellen und bezahlen',
          mp3Url: 'https://cdn.test/ep-1.mp3',
          duration: 90,
          sentences: [
            PodcastSentence(text: 'Guten Tag, ich möchte gerne bestellen!', textVi: 'Xin chào, tôi muốn gọi món!', start: 0, end: 1.2),
          ],
        ),
      ),
    ]));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('sprechen B1 reflows at German 200% without overflow', (tester) async {
    setPhysicalSize(tester);
    await tester.pumpWidget(wrap(const SprechenB1Page(), [
      authServiceProvider.overrideWithValue(PreviewAuthService()),
      pendingVideosProvider.overrideWith((ref) async => const []),
      completedVideosProvider.overrideWith((ref) async => const []),
    ]));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('sprechen B2 reflows at German 200% without overflow', (tester) async {
    setPhysicalSize(tester);
    await tester.pumpWidget(wrap(const SprechenB2Page(), [
      authServiceProvider.overrideWithValue(PreviewAuthService()),
      pendingVideosProvider.overrideWith((ref) async => const []),
      completedVideosProvider.overrideWith((ref) async => const []),
    ]));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}
