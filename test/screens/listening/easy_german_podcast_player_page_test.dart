import 'package:deutschtiger/data/listening/podcast_models.dart';
import 'package:deutschtiger/repositories/listening/podcast_repository.dart';
import 'package:deutschtiger/screens/listening/easy_german_podcast_player_page.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:deutschtiger/view_models/listening/podcast_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // `just_audio` has no platform-channel implementation under `flutter test`;
  // `setUrl` throws and the widget catches it (shows a snackbar) instead of
  // crashing — these tests assert the transcript/controls still render.
  final testRepository = PodcastRepository(
    ApiClient(baseUrl: 'https://example.test/api/v1', tokenProvider: _NoTokenProvider()),
    'https://static.test',
  );

  testWidgets('player renders transcript sentences + controls', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          podcastRepositoryProvider.overrideWithValue(testRepository),
          podcastEpisodeProvider('ep-1').overrideWith(
            (ref) async => const PodcastEpisodeDetail(
              slug: 'ep-1',
              title: 'Im Restaurant',
              mp3Url: 'https://cdn.test/ep-1.mp3',
              duration: 90,
              sentences: [
                PodcastSentence(
                  text: 'Guten Tag!',
                  textVi: 'Xin chào!',
                  start: 0,
                  end: 1.2,
                ),
              ],
            ),
          ),
        ],
        child: const MaterialApp(
          home: EasyGermanPodcastPlayerPage(slug: 'ep-1'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Im Restaurant'), findsOneWidget);
    expect(find.text('Guten Tag!'), findsOneWidget);
    expect(find.text('Xin chào!'), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('player shows error view when episode fails to load', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          podcastRepositoryProvider.overrideWithValue(testRepository),
          podcastEpisodeProvider('ep-404').overrideWith(
            (ref) async => throw Exception('not found'),
          ),
        ],
        child: const MaterialApp(
          home: EasyGermanPodcastPlayerPage(slug: 'ep-404'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Không thể tải tập podcast.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}
