// Owner: P11 (media-reading-news) — web-mobile UI fidelity plan.

import 'package:go_router/go_router.dart';

import '../../data/news/news_models.dart' show NewsDetailArgs;
import '../../data/reading/reading_models.dart' show ReadingDetailArgs;
import '../../screens/listening/listening_hub_screen.dart';
import '../../screens/listening/easy_german_level_page.dart';
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
import '../../screens/interview/interview_roadmap_screen.dart';
import '../../screens/interview/video_player_screen.dart';
import '../../screens/reading/reading_hub_screen.dart';
import '../../screens/reading/reading_detail_screen.dart';
import '../../screens/reading/reading_feed_screen.dart';
import '../../screens/reading/read_listen_hub_screen.dart';
import '../../screens/news/news_list_screen.dart';
import '../../screens/news/news_detail_screen.dart';

final List<RouteBase> mediaRoutes = [
  GoRoute(
    path: '/listening',
    builder: (context, state) => const ListeningHubScreen(),
    routes: [
      // Web-aligned: `/listening/easy-german/:level` = level video collection
      // (was the old podcast URL, collided — podcast moved to
      // `/listening/podcast/easy_german`, see redirect in
      // `release_redirect.dart`).
      GoRoute(
        path: 'easy-german/:level',
        builder: (context, state) =>
            EasyGermanLevelPage(level: state.pathParameters['level'] ?? 'a1'),
      ),
      GoRoute(
        path: 'podcast/easy_german',
        builder: (context, state) => const EasyGermanPodcastPage(),
        routes: [
          GoRoute(
            path: ':slug',
            builder: (context, state) {
              return EasyGermanPodcastPlayerPage(slug: state.pathParameters['slug'] ?? '');
            },
          ),
        ],
      ),
      GoRoute(path: 'sprechen-b1', builder: (context, state) => const SprechenB1Page()),
      GoRoute(path: 'sprechen-b2', builder: (context, state) => const SprechenB2Page()),
      // YouTube tracker: người dùng tự thêm video bằng URL (khác lộ trình tĩnh
      // của /learn/group — xem `lib/repositories/youtube/`).
      GoRoute(path: 'youtube', builder: (context, state) => const YouTubeTrackerScreen()),
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
      // Dictation/shadowing: đầy đủ UI, record path gate flag `speaking`
      // (xem `youtube_shadowing_screen.dart`).
      GoRoute(
        path: 'youtube/dictation',
        builder: (context, state) {
          final extra = state.extra;
          if (extra is ({String videoId, String? title})) {
            return YouTubeDictationScreen(videoId: extra.videoId, title: extra.title);
          }
          return YouTubeDictationScreen(videoId: state.uri.queryParameters['v'] ?? '');
        },
      ),
      GoRoute(
        path: 'youtube/shadowing',
        builder: (context, state) {
          final extra = state.extra;
          if (extra is ({String videoId, String? title})) {
            return YouTubeShadowingScreen(videoId: extra.videoId, title: extra.title);
          }
          return YouTubeShadowingScreen(videoId: state.uri.queryParameters['v'] ?? '');
        },
      ),
    ],
  ),
  // Video library: bộ sưu tập video YouTube biên tập sẵn theo slug (vd
  // Sprechen B1/B2 trên web) — dùng chung backend tracker với
  // `/listening/youtube` nhưng scoped theo library_slug/group_id.
  GoRoute(
    path: '/library/:slug',
    builder: (context, state) => VideoLibraryTrackerScreen(slug: state.pathParameters['slug']!),
  ),
  GoRoute(
    path: '/library/:slug/watch',
    builder: (context, state) => VideoLibraryWatchScreen(
      slug: state.pathParameters['slug']!,
      groupId: state.uri.queryParameters['groupId'] ?? '',
      initialVideoId: state.uri.queryParameters['videoId'] ?? '',
    ),
  ),
  // Interview: lộ trình video phỏng vấn biên tập sẵn — web `/course/interview`
  // + `/interview/watch`. Web parity: `InterviewTrackerPage`/`InterviewWatchPage`
  // (PurchaseGate module 'interview' — xem `interview_roadmap_screen.dart`).
  GoRoute(path: '/course/interview', builder: (context, state) => const InterviewRoadmapScreen()),
  GoRoute(
    path: '/interview/watch',
    builder: (context, state) => VideoPlayerScreen(
      videoId: state.uri.queryParameters['v'] ?? '',
      groupId: state.uri.queryParameters['group'] ?? '',
    ),
  ),
  // Reading/News/Read-Listen (P11 W4). Web-aligned paths: `/reading/:level/
  // :slug` (was Flutter-only `/reading/detail?extra=`), `/reading-feed`
  // (was `/reading/feed`), `/doc-nghe` (new — tab shell wrapping reading
  // feed/listening hub/news, mirror `read-listen-hub-page.tsx`).
  GoRoute(
    path: '/reading',
    builder: (context, state) => const ReadingHubScreen(),
    routes: [
      GoRoute(
        path: ':level/:slug',
        builder: (context, state) {
          final level = state.pathParameters['level'] ?? '';
          final slug = state.pathParameters['slug'] ?? '';
          final args = state.extra as ReadingDetailArgs?;
          return ReadingDetailScreen(
            level: args?.level ?? level,
            slug: args?.slug ?? slug,
            title: args?.title,
          );
        },
      ),
    ],
  ),
  GoRoute(path: '/reading-feed', builder: (context, state) => const ReadingFeedScreen()),
  GoRoute(path: '/doc-nghe', builder: (context, state) => const ReadListenHubScreen()),
  GoRoute(
    path: '/news',
    builder: (context, state) => const NewsListScreen(),
    routes: [
      GoRoute(
        path: ':slug',
        builder: (context, state) {
          final extra = state.extra;
          final slug = extra is NewsDetailArgs ? extra.slug : state.pathParameters['slug']!;
          final level = extra is NewsDetailArgs ? extra.level : state.uri.queryParameters['level'];
          return NewsDetailScreen(slug: slug, initialLevel: level);
        },
      ),
    ],
  ),
];
