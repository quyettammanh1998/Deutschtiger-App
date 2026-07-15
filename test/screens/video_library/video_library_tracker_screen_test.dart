import 'package:deutschtiger/data/youtube/video_library.dart';
import 'package:deutschtiger/screens/video_library/video_library_tracker_screen.dart';
import 'package:deutschtiger/view_models/youtube/youtube_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const slug = 'sprechen-b1';

  testWidgets('renders group list with progress', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          videoLibraryConfigProvider(slug).overrideWith(
            (ref) async => const VideoLibraryConfig(
              slug: slug,
              title: 'Sprechen B1',
              description: 'Luyện nói B1',
            ),
          ),
          videoLibraryLearningPathProvider(slug).overrideWith(
            (ref) async => const [
              VideoLibraryGroup(
                order: 1,
                groupId: 'g1',
                nameVi: 'Nhóm 1',
                nameDe: 'Gruppe 1',
                level: 'B1',
                videoCount: 2,
                videos: [
                  VideoLibraryPathVideo(videoId: 'abc12345678', title: 'Video 1'),
                ],
              ),
            ],
          ),
          videoLibraryGroupProgressProvider(slug).overrideWith(
            (ref) async => {
              'g1': const LibraryGroupProgress(
                groupId: 'g1',
                total: 2,
                completed: 1,
                percentage: 50,
              ),
            },
          ),
        ],
        child: const MaterialApp(home: VideoLibraryTrackerScreen(slug: slug)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Gruppe 1'), findsOneWidget);
    expect(find.text('Nhóm 1 · 2 video'), findsOneWidget);
    expect(find.text('1/2'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows empty state when the library has no groups', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          videoLibraryConfigProvider(slug).overrideWith(
            (ref) async => const VideoLibraryConfig(slug: slug, title: 'Sprechen B1'),
          ),
          videoLibraryLearningPathProvider(slug).overrideWith(
            (ref) async => const [],
          ),
          videoLibraryGroupProgressProvider(slug).overrideWith(
            (ref) async => const {},
          ),
        ],
        child: const MaterialApp(home: VideoLibraryTrackerScreen(slug: slug)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Thư viện này chưa có video nào.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
