import 'package:deutschtiger/data/listening/podcast_models.dart';
import 'package:deutschtiger/data/youtube/youtube_video.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/listening/listening_hub_screen.dart';
import 'package:deutschtiger/view_models/listening/easy_german_provider.dart';
import 'package:deutschtiger/view_models/listening/podcast_provider.dart';
import 'package:deutschtiger/view_models/youtube/youtube_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _levels = ['a1', 'a2', 'b1', 'b2', 'c1'];

List<Override> _easyGermanOverrides() => [
      for (final level in _levels)
        easyGermanIndexProvider(level).overrideWith((ref) async => const []),
    ];

void main() {
  // Tall viewport so every source card renders without needing to scroll —
  // avoids ListView virtualization flakiness in `find.text` assertions.
  setUp(() {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first.physicalSize = const Size(390, 3600);
    binding.platformDispatcher.views.first.devicePixelRatio = 1.0;
  });

  tearDown(() {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first.resetPhysicalSize();
    binding.platformDispatcher.views.first.resetDevicePixelRatio();
  });

  testWidgets('listening hub shows Easy German levels + other sources', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ..._easyGermanOverrides(),
          podcastIndexProvider.overrideWith(
            (ref) async => const [
              PodcastEpisode(slug: 'ep-1', title: 'Folge 1', duration: 120, segments: 5),
              PodcastEpisode(slug: 'ep-2', title: 'Folge 2', duration: 180, segments: 7),
            ],
          ),
          podcastCompletedIdsProvider.overrideWith((ref) async => ['ep-1']),
          pendingVideosProvider.overrideWith((ref) async => const []),
          completedVideosProvider.overrideWith((ref) async => const []),
        ],
        child: MaterialApp(
          locale: const Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const ListeningHubScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Easy German A1'), findsOneWidget);
    expect(find.text('Easy German C1'), findsOneWidget);
    expect(find.text('Sprechen B1'), findsOneWidget);
    expect(find.text('Sprechen B2'), findsOneWidget);
    expect(find.text('Podcast'), findsOneWidget);
    expect(find.text('YouTube'), findsOneWidget);
    expect(find.text('Audiobook'), findsOneWidget);
    expect(find.text('2 video'), findsOneWidget); // podcast trailing count
    expect(tester.takeException(), isNull);
  });

  testWidgets('listening hub tolerates empty indexes (no data yet)', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ..._easyGermanOverrides(),
          podcastIndexProvider.overrideWith((ref) async => const []),
          podcastCompletedIdsProvider.overrideWith((ref) async => const []),
          pendingVideosProvider.overrideWith((ref) async => const <YouTubeVideo>[]),
          completedVideosProvider.overrideWith((ref) async => const <YouTubeVideo>[]),
        ],
        child: MaterialApp(
          locale: const Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const ListeningHubScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nghe'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
