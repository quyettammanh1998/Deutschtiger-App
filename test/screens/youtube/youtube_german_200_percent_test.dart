import 'package:deutschtiger/data/interview/transcript_models.dart';
import 'package:deutschtiger/data/youtube/youtube_video.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/youtube/youtube_dictation_screen.dart';
import 'package:deutschtiger/screens/youtube/youtube_shadowing_screen.dart';
import 'package:deutschtiger/screens/youtube/youtube_tracker_screen.dart';
import 'package:deutschtiger/screens/youtube/youtube_watch_screen.dart';
import 'package:deutschtiger/view_models/interview/transcript_provider.dart';
import 'package:deutschtiger/view_models/youtube/youtube_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webview_flutter/webview_flutter.dart' show WebViewPlatform;

import 'fake_webview_platform.dart';

/// German 200% text-scale reflow smoke test for the P11 W2 youtube screens —
/// plan protocol requires new UI to not overflow at German 200%. Mirrors
/// `test/screens/listening/listening_german_200_percent_test.dart`.
void main() {
  const segments = [
    TranscriptSegment(
      startMs: 0,
      endMs: 2000,
      textDe: 'Hallo Welt',
      textVi: 'Xin chào thế giới',
    ),
    TranscriptSegment(
      startMs: 2000,
      endMs: 4000,
      textDe: 'Wie geht es dir heute an diesem schönen Tag',
      textVi: 'Hôm nay bạn thế nào',
    ),
  ];

  setUpAll(() {
    WebViewPlatform.instance = FakeWebViewPlatform();
  });

  Widget wrap(Widget child, List<Override> overrides) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        locale: const Locale('de'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(390, 844),
            textScaler: TextScaler.linear(2),
          ),
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

  testWidgets(
    'youtube tracker screen reflows at German 200% without overflow',
    (tester) async {
      setPhysicalSize(tester);
      await tester.pumpWidget(
        wrap(const YouTubeTrackerScreen(), [
          pendingVideosProvider.overrideWith(
            (ref) async => const [
              YouTubeVideo(
                videoId: 'abc12345678',
                title: 'Ein sehr langer Videotitel zum Testen',
              ),
            ],
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
          youtubeStatsProvider.overrideWith(
            (ref) async => const YouTubeStats(),
          ),
        ]),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('youtube watch screen reflows at German 200% without overflow', (
    tester,
  ) async {
    setPhysicalSize(tester);
    await tester.pumpWidget(
      wrap(
        const YouTubeWatchScreen(
          videoId: 'abc12345678',
          title: 'Ein sehr langer Videotitel',
        ),
        [
          pendingVideosProvider.overrideWith((ref) async => const []),
          completedVideosProvider.overrideWith((ref) async => const []),
          transcriptProvider('abc12345678').overrideWith(
            (ref) async => const TranscriptResult(
              videoId: 'abc12345678',
              segments: segments,
            ),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'youtube dictation screen reflows at German 200% without overflow',
    (tester) async {
      setPhysicalSize(tester);
      await tester.pumpWidget(
        wrap(
          const YouTubeDictationScreen(
            videoId: 'abc12345678',
            title: 'Ein sehr langer Videotitel',
          ),
          [
            transcriptProvider('abc12345678').overrideWith(
              (ref) async => const TranscriptResult(
                videoId: 'abc12345678',
                segments: segments,
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'youtube shadowing screen reflows at German 200% without overflow',
    (tester) async {
      setPhysicalSize(tester);
      await tester.pumpWidget(
        wrap(
          const YouTubeShadowingScreen(
            videoId: 'abc12345678',
            title: 'Ein sehr langer Videotitel',
          ),
          [
            transcriptProvider('abc12345678').overrideWith(
              (ref) async => const TranscriptResult(
                videoId: 'abc12345678',
                segments: segments,
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
}
