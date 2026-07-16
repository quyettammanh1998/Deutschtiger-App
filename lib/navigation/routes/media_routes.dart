// Owner: P11 (media-reading-news) — web-mobile UI fidelity plan.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/news/news_models.dart' show NewsDetailArgs;
import '../../data/reading/reading_models.dart' show ReadingDetailArgs;
import '../../screens/listening/listening_hub_screen.dart';
import '../../screens/listening/easy_german_podcast_page.dart';
import '../../screens/listening/easy_german_podcast_player_page.dart';
import '../../screens/listening/sprechen_b1_page.dart';
import '../../screens/listening/sprechen_b2_page.dart';
import '../../screens/youtube/youtube_tracker_screen.dart';
import '../../screens/youtube/youtube_watch_screen.dart';
import '../../screens/youtube/youtube_dictation_screen.dart';
import '../../screens/youtube/youtube_shadowing_screen.dart';
import '../../screens/video_library/video_library_tracker_screen.dart';
import '../../screens/video_library/video_library_watch_screen.dart';
import '../../screens/reading/reading_hub_screen.dart';
import '../../screens/reading/reading_detail_screen.dart';
import '../../screens/reading/reading_feed_screen.dart';
import '../../screens/news/news_list_screen.dart';
import '../../screens/news/news_detail_screen.dart';

final List<RouteBase> mediaRoutes = [
  GoRoute(
    path: '/listening',
    builder: (context, state) => const ListeningHubScreen(),
    routes: [
      GoRoute(
        path: 'easy-german',
        builder: (context, state) => const EasyGermanPodcastPage(),
        routes: [
          GoRoute(
            path: 'episode/:slug',
            builder: (context, state) {
              return EasyGermanPodcastPlayerPage(
                slug: state.pathParameters['slug'] ?? '',
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: 'sprechen-b1',
        builder: (context, state) => const SprechenB1Page(),
      ),
      GoRoute(
        path: 'sprechen-b2',
        builder: (context, state) => const SprechenB2Page(),
      ),
      // YouTube tracker: người dùng tự thêm video bằng URL (khác lộ trình tĩnh
      // của /learn/group — xem `lib/repositories/youtube/`).
      GoRoute(
        path: 'youtube',
        builder: (context, state) => const YouTubeTrackerScreen(),
      ),
      GoRoute(
        path: 'youtube/watch',
        builder: (context, state) {
          final extra = state.extra;
          if (extra is ({String videoId, String? title})) {
            return YouTubeWatchScreen(videoId: extra.videoId, title: extra.title);
          }
          final videoId = state.uri.queryParameters['v'] ?? '';
          return YouTubeWatchScreen(videoId: videoId);
        },
      ),
      // Dictation/shadowing: stub — ngoài scope wave này (xem ghi chú gap
      // trong report triển khai). Route giữ chỗ để không vỡ điều hướng.
      GoRoute(
        path: 'youtube/dictation',
        builder: (context, state) => const YouTubeDictationScreen(),
      ),
      GoRoute(
        path: 'youtube/shadowing',
        builder: (context, state) => const YouTubeShadowingScreen(),
      ),
    ],
  ),
  // Video library: bộ sưu tập video YouTube biên tập sẵn theo slug (vd
  // Sprechen B1/B2 trên web) — dùng chung backend tracker với
  // `/listening/youtube` nhưng scoped theo library_slug/group_id.
  GoRoute(
    path: '/library/:slug',
    builder: (context, state) =>
        VideoLibraryTrackerScreen(slug: state.pathParameters['slug']!),
  ),
  GoRoute(
    path: '/library/:slug/watch',
    builder: (context, state) => VideoLibraryWatchScreen(
      slug: state.pathParameters['slug']!,
      groupId: state.uri.queryParameters['groupId'] ?? '',
      initialVideoId: state.uri.queryParameters['videoId'] ?? '',
    ),
  ),
  GoRoute(
    path: '/reading',
    builder: (context, state) => const ReadingHubScreen(),
    routes: [
      GoRoute(
        path: 'detail',
        builder: (context, state) {
          final args = state.extra as ReadingDetailArgs?;
          if (args == null) {
            return const Scaffold(
              body: Center(child: Text('Bài đọc không tồn tại.')),
            );
          }
          return ReadingDetailScreen(
            level: args.level,
            slug: args.slug,
            title: args.title,
          );
        },
      ),
      GoRoute(
        path: 'feed',
        builder: (context, state) => const ReadingFeedScreen(),
      ),
    ],
  ),
  GoRoute(
    path: '/news',
    builder: (context, state) => const NewsListScreen(),
    routes: [
      GoRoute(
        path: ':slug',
        builder: (context, state) {
          final extra = state.extra;
          final slug = extra is NewsDetailArgs
              ? extra.slug
              : state.pathParameters['slug']!;
          final level = extra is NewsDetailArgs
              ? extra.level
              : state.uri.queryParameters['level'];
          return NewsDetailScreen(slug: slug, initialLevel: level);
        },
      ),
    ],
  ),
];
