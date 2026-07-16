import 'package:deutschtiger/data/youtube/youtube_video.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/youtube/youtube_tracker_screen.dart';
import 'package:deutschtiger/view_models/youtube/youtube_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders pending + completed videos with status filter', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          pendingVideosProvider.overrideWith(
            (ref) async => const [YouTubeVideo(videoId: 'abc12345678', title: 'Folge 1')],
          ),
          completedVideosProvider.overrideWith(
            (ref) async => const [
              YouTubeVideo(
                id: 'v2',
                videoId: 'def12345678',
                title: 'Folge 2',
                status: 'completed',
                watchCount: 2,
              ),
            ],
          ),
          popularVideosProvider.overrideWith((ref) async => const []),
          youtubeStatsProvider.overrideWith((ref) async => const YouTubeStats(totalCompleted: 5)),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: YouTubeTrackerScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Folge 1'), findsOneWidget);
    // "Folge 2" is completed, so it renders both in the "Xem tiếp" strip
    // (recently-watched proxy for web's ContinueWatching) and the thumbnail
    // grid below.
    expect(find.text('Folge 2'), findsNWidgets(2));
    expect(find.text('Đã xem ×2'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows empty state when no videos are tracked', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          pendingVideosProvider.overrideWith((ref) async => const []),
          completedVideosProvider.overrideWith((ref) async => const []),
          popularVideosProvider.overrideWith((ref) async => const []),
          youtubeStatsProvider.overrideWith((ref) async => const YouTubeStats()),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: YouTubeTrackerScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Chưa có video nào. Dán URL YouTube ở trên để bắt đầu.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows error view + retry when pending videos fail to load', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          pendingVideosProvider.overrideWith((ref) async => throw Exception('boom')),
          completedVideosProvider.overrideWith((ref) async => const []),
          popularVideosProvider.overrideWith((ref) async => const []),
          youtubeStatsProvider.overrideWith((ref) async => const YouTubeStats()),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('vi'),
          home: YouTubeTrackerScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Không tải được danh sách video.'), findsOneWidget);
    expect(find.text('Thử lại'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
