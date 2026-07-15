import 'package:deutschtiger/data/listening/podcast_models.dart';
import 'package:deutschtiger/screens/listening/easy_german_podcast_page.dart';
import 'package:deutschtiger/view_models/listening/podcast_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('podcast list renders episodes + completed badge', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          podcastIndexProvider.overrideWith(
            (ref) async => const [
              PodcastEpisode(slug: 'ep-1', title: 'Im Restaurant', duration: 65, segments: 4),
              PodcastEpisode(slug: 'ep-2', title: 'Am Bahnhof', duration: 610, segments: 12),
            ],
          ),
          podcastCompletedIdsProvider.overrideWith((ref) async => ['ep-1']),
        ],
        child: const MaterialApp(home: EasyGermanPodcastPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Im Restaurant'), findsOneWidget);
    expect(find.text('Am Bahnhof'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('podcast list shows empty state when search matches nothing', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          podcastIndexProvider.overrideWith(
            (ref) async => const [
              PodcastEpisode(slug: 'ep-1', title: 'Im Restaurant', duration: 65, segments: 4),
            ],
          ),
          podcastCompletedIdsProvider.overrideWith((ref) async => const []),
        ],
        child: const MaterialApp(home: EasyGermanPodcastPage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'zzz-no-match');
    await tester.pumpAndSettle();

    expect(find.text('Không tìm thấy tập nào'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('podcast list shows error view + retry when index fails', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          podcastIndexProvider.overrideWith((ref) async => throw Exception('boom')),
          podcastCompletedIdsProvider.overrideWith((ref) async => const []),
        ],
        child: const MaterialApp(home: EasyGermanPodcastPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Không thể tải danh sách tập. Vui lòng thử lại sau.'),
      findsOneWidget,
    );
    expect(find.text('Thử lại'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
