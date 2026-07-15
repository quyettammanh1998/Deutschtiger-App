import 'package:deutschtiger/data/listening/podcast_models.dart';
import 'package:deutschtiger/screens/listening/listening_hub_screen.dart';
import 'package:deutschtiger/view_models/listening/podcast_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('listening hub shows podcast source card + live stats', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          podcastIndexProvider.overrideWith(
            (ref) async => const [
              PodcastEpisode(slug: 'ep-1', title: 'Folge 1', duration: 120, segments: 5),
              PodcastEpisode(slug: 'ep-2', title: 'Folge 2', duration: 180, segments: 7),
            ],
          ),
          podcastCompletedIdsProvider.overrideWith((ref) async => ['ep-1']),
        ],
        child: const MaterialApp(home: ListeningHubScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Easy German Podcast'), findsOneWidget);
    expect(find.text('2 tập'), findsOneWidget);
    expect(find.text('Sprechen B1'), findsOneWidget);
    expect(find.text('Sprechen B2'), findsOneWidget);
    // Stats strip: 1 completed / 2 total.
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('listening hub tolerates an empty index (no episodes yet)', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          podcastIndexProvider.overrideWith((ref) async => const []),
          podcastCompletedIdsProvider.overrideWith((ref) async => const []),
        ],
        child: const MaterialApp(home: ListeningHubScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Easy German Podcast'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
