import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/reset_password_screen.dart';
import '../screens/auth/onboarding_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/welcome_screen.dart';
import '../screens/ai/ai_chat_page.dart';
import '../screens/ai/ai_writing_practice_page.dart';
import '../screens/ai/ai_settings_page.dart';
import '../screens/affiliate/affiliate_screen.dart';
import '../screens/affiliate/affiliate_page.dart';
import '../screens/affiliate/affiliate_leaderboard_page.dart';
import '../screens/exam/exam_screen.dart';
import '../screens/exam/goethe_b1_hub_page.dart';
import '../screens/exam/exam_list_page.dart';
import '../features/exam/presentation/exam_practice_page.dart';
import '../features/exam/presentation/exam_player_provider.dart';
import '../features/exam/presentation/exam_result_page.dart';
import '../screens/exam/goethe_b1_writing_page.dart';
import '../screens/exam/goethe_speaking_page.dart';
import '../screens/exam/exam_readiness_screen.dart';
import '../screens/exam/exam_schedule_screen.dart';
import '../screens/exam/exam_dictation_picker_screen.dart';
import '../screens/exam/exam_dictation_screen.dart';
import '../screens/exam/community_exams_list_screen.dart';
import '../screens/exam/community_exam_detail_screen.dart';
import '../screens/exam/de_thi_list_screen.dart';
import '../screens/exam/de_thi_practice_screen.dart';
import '../screens/journey/journey_screen.dart';
import '../screens/journey/courses_hub_screen.dart';
import '../screens/journey/course_detail_screen.dart';
import '../screens/journey/course_lesson_screen.dart';
import '../screens/learn/can_do_practice_screen.dart';
import '../screens/learn/focus_session_screen.dart';
import '../screens/learn/learner_model_screen.dart';
import '../screens/learn/topic_explore_screen.dart';
import '../features/mission/presentation/mission_session_page.dart';
import '../screens/listening/listening_hub_screen.dart';
import '../screens/listening/easy_german_podcast_page.dart';
import '../screens/listening/easy_german_podcast_player_page.dart';
import '../screens/listening/sprechen_b1_page.dart';
import '../screens/listening/sprechen_b2_page.dart';
import '../screens/youtube/youtube_tracker_screen.dart';
import '../screens/youtube/youtube_watch_screen.dart';
import '../screens/youtube/youtube_dictation_screen.dart';
import '../screens/youtube/youtube_shadowing_screen.dart';
import '../screens/video_library/video_library_tracker_screen.dart';
import '../screens/video_library/video_library_watch_screen.dart';
import '../screens/social/social_screen.dart';
import '../screens/social/moments_page.dart';
import '../screens/social/groups_page.dart';
import '../screens/social/group_detail_page.dart';
import '../screens/social/challenges_page.dart';
import '../screens/social/duel_lobby_page.dart';
import '../screens/social/duel_play_page.dart';
import '../screens/social/messages_page.dart';
import '../screens/social/chat_page.dart';
import '../screens/social/friends_page.dart';
import '../screens/social/profile_page.dart';
import '../screens/social/announcements_page.dart';
import '../screens/reading/reading_hub_screen.dart';
import '../screens/reading/reading_detail_screen.dart';
import '../screens/reading/reading_feed_screen.dart';
import '../data/reading/reading_models.dart' show ReadingDetailArgs;
import '../screens/news/news_list_screen.dart';
import '../screens/news/news_detail_screen.dart';
import '../data/news/news_models.dart' show NewsDetailArgs;
import '../screens/speaking/speaking_screen.dart';
import '../screens/speaking/speaking_hub_screen.dart';
import '../screens/speaking/shadowing_page.dart';
import '../screens/speaking/umlaute_trainer_page.dart';
import '../screens/speaking/r_sound_trainer_page.dart';
import '../screens/speaking/ich_ach_trainer_page.dart';
import '../screens/speaking/sp_st_trainer_page.dart';
import '../screens/speaking/conversation_hub_page.dart';
import '../screens/speaking/conversation_scenario_page.dart';
import '../screens/stats/stats_screen.dart';
import '../screens/stats/error_patterns_page.dart';
import '../screens/stats/daily_quote_page.dart';
import '../screens/achievements/achievements_screen.dart';
import '../screens/leaderboard/leaderboard_screen.dart';
import '../screens/pronunciation/pronunciation_screen.dart';
import '../screens/games/article_game_screen.dart';
import '../screens/games/cases/case_cloze_quiz_screen.dart';
import '../screens/games/cases/cases_mastery_hub_screen.dart';
import '../screens/games/cases/verb_case_quiz_screen.dart';
import '../screens/games/conversation_game_screen.dart';
import '../screens/games/fill_blank_game_screen.dart';
import '../screens/games/flashcard_game_screen.dart';
import '../screens/games/konjugation_game_screen.dart';
import '../screens/games/listening_game_screen.dart';
import '../screens/games/matching_game_screen.dart';
import '../screens/games/pronunciation_game_screen.dart';
import '../screens/games/runner_game_screen.dart';
import '../screens/games/sentence_builder/sentence_builder_play_screen.dart';
import '../screens/games/sentence_builder/sentence_builder_topics_screen.dart';
import '../screens/games/speaking_game_screen.dart';
import '../screens/games/typing_sprint_game_screen.dart';
import '../screens/games/word_order_game_screen.dart';
import '../screens/games/word_sprint_game_screen.dart';
import '../screens/games/writing_sentence_game_screen.dart';
import '../screens/games/writing_word_game_screen.dart';
import '../screens/games/game_hub_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/interview/group_detail_screen.dart';
import '../screens/interview/video_player_screen.dart';
import '../screens/legal/privacy_policy_screen.dart';
import '../screens/legal/terms_of_service_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/notifications/notification_center_screen.dart';
import '../screens/settings/delete_account_screen.dart';
import '../screens/settings/learning_preferences_screen.dart';
import '../screens/settings/notification_preferences_screen.dart';
import '../screens/settings/security_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/daily_review/daily_review_screen.dart';
import '../screens/flashcard/flashcard_review_screen.dart';
import '../screens/decks/deck_list_screen.dart';
import '../screens/decks/deck_detail_screen.dart';
import '../screens/practice/practice_screen.dart';
import '../screens/vocab/subtitle_words_screen.dart';
import '../features/my_words/presentation/my_words_screen.dart';
import 'package:deutschtiger/widgets/common/app_shell.dart';
import '../view_models/providers.dart';
import 'router_keys.dart';
import 'auth_redirect.dart';
import 'release_redirect.dart';
import '../features/vocabulary/presentation/vocabulary_screen.dart';
import '../features/vocabulary/presentation/vocabulary_lesson_screen.dart';
import '../features/vocabulary/presentation/vocabulary_word_screen.dart';
import '../features/vocabulary/presentation/vocabulary_detail_screen.dart';
import '../features/grammar/presentation/grammar_screen.dart';
import '../features/grammar/presentation/grammar_lesson_detail_screen.dart';
import '../features/grammar/presentation/grammar_article_screen.dart';
import '../features/landing/presentation/landing_screen.dart' as landing;
import '../features/premium/presentation/premium_screen.dart';

/// Root navigator key — exposed để global code (vd. [ApiClient] khi gặp
/// device-kicked 401) có thể push dialog / navigate từ bất kỳ đâu mà không cần
/// BuildContext. Định nghĩa trong `router_keys.dart` để tránh import cycle.
final _rootKey = rootNavigatorKey;

/// Router go_router với ShellRoute 4 tab + redirect theo auth state.
/// Chưa login → /welcome (giới thiệu) → /login|/signup. Đã login → /home.
final routerProvider = Provider<GoRouter>((ref) {
  final authService = ref.watch(authServiceProvider);
  final onboardingCompleted =
      ref.watch(onboardingCompletedProvider).value ?? false;

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/home',
    // Rebuild redirect khi auth state đổi.
    refreshListenable: _GoRouterRefresh(authService.authStateChanges),
    redirect: (context, state) {
      final authRedirect = resolveAuthRedirect(
        loggedIn: authService.isLoggedIn,
        onboardingCompleted: onboardingCompleted,
        location: state.matchedLocation,
      );
      if (authRedirect != null || !authService.isLoggedIn) {
        return authRedirect;
      }
      return resolveReleaseRedirect(state.uri.path);
    },
    routes: [
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: '/landing',
        builder: (context, state) => const landing.LandingScreen(),
      ),
      GoRoute(
        path: '/welcome-full',
        builder: (context, state) => const landing.WelcomeScreen(),
      ),
      // De-thi public registry — deep-link SEO route, không cần đăng nhập
      // (xem `resolveAuthRedirect`/`publicAuthRoutePrefixes`).
      GoRoute(
        path: '/de-thi',
        builder: (context, state) => const DeThiListScreen(),
      ),
      GoRoute(
        path: '/de-thi/:code',
        builder: (context, state) =>
            DeThiPracticeScreen(code: state.pathParameters['code']!),
      ),
      GoRoute(
        path: '/vocabulary',
        builder: (context, state) => const VocabularyScreen(),
        routes: [
          GoRoute(
            path: 'lesson/:topicKey',
            builder: (context, state) => VocabularyLessonScreen(
              topicKey: state.pathParameters['topicKey']!,
              level: state.uri.queryParameters['level'],
            ),
          ),
          GoRoute(
            path: 'word/:itemId',
            builder: (context, state) => VocabularyWordRouteScreen(
              topicKey: state.uri.queryParameters['topicKey'] ?? '',
              itemId: state.pathParameters['itemId']!,
              level: state.uri.queryParameters['level'],
            ),
          ),
          GoRoute(
            path: 'detail/:topicKey',
            builder: (context, state) => VocabularyDetailScreen(
              topicKey: state.pathParameters['topicKey']!,
              itemId: state.uri.queryParameters['itemId'],
              level: state.uri.queryParameters['level'],
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/daily-review',
        builder: (context, state) => const DailyReviewScreen(),
      ),
      GoRoute(
        path: '/my-words',
        builder: (context, state) => const MyWordsScreen(),
      ),
      GoRoute(
        path: '/decks',
        builder: (context, state) => const DeckListScreen(),
        routes: [
          GoRoute(
            path: ':deckId',
            builder: (context, state) =>
                DeckDetailScreen(deckId: state.pathParameters['deckId']!),
            routes: [
              GoRoute(
                path: 'practice',
                builder: (context, state) =>
                    PracticeScreen(deckId: state.pathParameters['deckId']!),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/flashcard-review',
        builder: (context, state) =>
            FlashcardReviewScreen(deckId: state.uri.queryParameters['deckId']),
      ),
      GoRoute(
        path: '/subtitle-words',
        builder: (context, state) => const SubtitleWordsScreen(),
      ),
      GoRoute(
        // B3 — mission session runner (mirrors web `/learn/session/:id`).
        path: '/journey/session',
        builder: (context, state) => const MissionSessionPage(),
      ),
      GoRoute(
        path: '/grammar',
        builder: (context, state) {
          final level = state.uri.queryParameters['level'];
          return GrammarScreen(initialLevel: level);
        },
        routes: [
          GoRoute(
            path: 'articles/:level/:slug',
            builder: (context, state) => GrammarArticleScreen(
              level: state.pathParameters['level']!,
              slug: state.pathParameters['slug']!,
            ),
          ),
          GoRoute(
            path: ':level/:id',
            builder: (context, state) => GrammarLessonDetailScreen(
              level: state.pathParameters['level']!,
              id: state.pathParameters['id']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/pronunciation',
        builder: (context, state) => const PronunciationScreen(),
      ),
      GoRoute(
        path: '/achievements',
        builder: (context, state) => const AchievementsScreen(),
      ),
      GoRoute(
        path: '/leaderboard',
        builder: (context, state) => const LeaderboardScreen(),
      ),
      // Learn extensions (mirrors web `/learner-model`, `/focus-session`).
      GoRoute(
        path: '/learner-model',
        builder: (context, state) => const LearnerModelScreen(),
      ),
      GoRoute(
        path: '/focus-session',
        builder: (context, state) => const FocusSessionScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'security',
            builder: (context, state) => const SecurityScreen(),
          ),
          GoRoute(
            path: 'delete-account',
            builder: (context, state) => const DeleteAccountScreen(),
          ),
          GoRoute(
            path: 'premium',
            builder: (context, state) => const PremiumScreen(),
          ),
          GoRoute(
            path: 'notifications',
            builder: (context, state) => const NotificationPreferencesScreen(),
          ),
          GoRoute(
            path: 'learning-preferences',
            builder: (context, state) => const LearningPreferencesScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationCenterScreen(),
      ),
      GoRoute(
        path: '/privacy-policy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: '/terms-of-service',
        builder: (context, state) => const TermsOfServiceScreen(),
      ),
      // Game routes
      GoRoute(
        path: '/games',
        builder: (context, state) => const GameHubScreen(),
      ),
      GoRoute(
        path: '/games/article',
        builder: (context, state) => const ArticleGameScreen(),
      ),
      GoRoute(
        path: '/games/word-sprint',
        builder: (context, state) => const WordSprintGameScreen(),
      ),
      GoRoute(
        path: '/games/matching',
        builder: (context, state) => const MatchingGameScreen(),
      ),
      GoRoute(
        path: '/games/fill-blank',
        builder: (context, state) => const FillBlankGameScreen(),
      ),
      GoRoute(
        path: '/games/listening',
        builder: (context, state) => const ListeningGameScreen(),
      ),
      GoRoute(
        path: '/games/flashcard',
        builder: (context, state) => const FlashcardGameScreen(),
      ),
      GoRoute(
        path: '/games/runner',
        builder: (context, state) => const RunnerGameScreen(),
      ),
      GoRoute(
        path: '/games/typing-sprint',
        builder: (context, state) => const TypingSprintGameScreen(),
      ),
      GoRoute(
        path: '/games/writing',
        builder: (context, state) => const WritingWordGameScreen(),
      ),
      GoRoute(
        path: '/games/word-order',
        builder: (context, state) => const WordOrderGameScreen(),
      ),
      GoRoute(
        path: '/games/writing-sentence',
        builder: (context, state) => const WritingSentenceGameScreen(),
      ),
      GoRoute(
        path: '/games/speaking',
        builder: (context, state) => const SpeakingGameScreen(),
      ),
      GoRoute(
        path: '/games/cases',
        builder: (context, state) => const CasesMasteryHubScreen(),
      ),
      GoRoute(
        path: '/games/cases/akk-dat',
        builder: (context, state) => const CaseClozeQuizScreen(
          game: 'akk-dat',
          title: 'Akkusativ vs Dativ',
        ),
      ),
      GoRoute(
        path: '/games/cases/adjektiv',
        builder: (context, state) => const CaseClozeQuizScreen(
          game: 'adjektiv',
          title: 'Adjektivendungen',
        ),
      ),
      GoRoute(
        path: '/games/cases/wechselprep',
        builder: (context, state) => const CaseClozeQuizScreen(
          game: 'wechselprep',
          title: 'Wechselpräpositionen',
        ),
      ),
      GoRoute(
        path: '/games/cases/verb-case',
        builder: (context, state) => const VerbCaseQuizScreen(),
      ),
      GoRoute(
        path: '/games/konjugation',
        builder: (context, state) => const KonjugationGameScreen(),
      ),
      GoRoute(
        path: '/games/pronunciation',
        builder: (context, state) => const PronunciationGameScreen(),
      ),
      GoRoute(
        path: '/games/conversation',
        builder: (context, state) => const ConversationGameScreen(),
      ),
      GoRoute(
        path: '/games/sentence-builder',
        builder: (context, state) => const SentenceBuilderTopicsScreen(),
      ),
      GoRoute(
        path: '/games/sentence-builder/play',
        builder: (context, state) => SentenceBuilderPlayScreen(
          level: state.uri.queryParameters['level'] ?? 'A1',
          topicId: state.uri.queryParameters['topicId'],
        ),
      ),
      // Listening routes
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
          // YouTube tracker: người dùng tự thêm video bằng URL (khác lộ trình
          // tĩnh của /learn/group — xem `lib/repositories/youtube/`).
          GoRoute(
            path: 'youtube',
            builder: (context, state) => const YouTubeTrackerScreen(),
          ),
          GoRoute(
            path: 'youtube/watch',
            builder: (context, state) {
              final extra = state.extra;
              if (extra is ({String videoId, String? title})) {
                return YouTubeWatchScreen(
                  videoId: extra.videoId,
                  title: extra.title,
                );
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
      // Sprechen B1/B2 trên web) — dùng chung backend tracker với `/listening/youtube`
      // nhưng scoped theo library_slug/group_id.
      GoRoute(
        path: '/library/:slug',
        builder: (context, state) => VideoLibraryTrackerScreen(
          slug: state.pathParameters['slug']!,
        ),
      ),
      GoRoute(
        path: '/library/:slug/watch',
        builder: (context, state) => VideoLibraryWatchScreen(
          slug: state.pathParameters['slug']!,
          groupId: state.uri.queryParameters['groupId'] ?? '',
          initialVideoId: state.uri.queryParameters['videoId'] ?? '',
        ),
      ),
      // Journey routes (Learn hub + DW course catalog)
      GoRoute(
        path: '/journey',
        builder: (context, state) => const JourneyScreen(),
        routes: [
          GoRoute(
            path: 'courses',
            builder: (context, state) => const CoursesHubScreen(),
          ),
          GoRoute(
            path: 'courses/:slug',
            builder: (context, state) => CourseDetailScreen(
              slug: state.pathParameters['slug']!,
            ),
          ),
          GoRoute(
            path: 'courses/:slug/lessons/:num',
            builder: (context, state) => CourseLessonScreen(
              slug: state.pathParameters['slug']!,
              lessonNumber: int.tryParse(state.pathParameters['num'] ?? '') ?? 1,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/speaking',
        builder: (context, state) => const SpeakingScreen(),
        routes: [
          GoRoute(
            path: 'hub',
            builder: (context, state) => const SpeakingHubScreen(),
          ),
          GoRoute(
            path: 'shadowing',
            builder: (context, state) => const ShadowingPage(),
          ),
          GoRoute(
            path: 'umlaute',
            builder: (context, state) => const UmlauteTrainerPage(),
          ),
          GoRoute(
            path: 'r-sound',
            builder: (context, state) => const RSoundTrainerPage(),
          ),
          GoRoute(
            path: 'ich-ach',
            builder: (context, state) => const IchAchTrainerPage(),
          ),
          GoRoute(
            path: 'sp-st',
            builder: (context, state) => const SpStTrainerPage(),
          ),
          GoRoute(
            path: 'conversation-hub',
            builder: (context, state) => const ConversationHubPage(),
          ),
          GoRoute(
            path: 'conversation/:conversationId',
            builder: (context, state) => ConversationScenarioPage(
              conversationId: state.pathParameters['conversationId']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/social',
        builder: (context, state) => const SocialScreen(),
        routes: [
          GoRoute(
            path: 'moments',
            builder: (context, state) => const MomentsPage(),
          ),
          GoRoute(
            path: 'groups',
            builder: (context, state) => const GroupsPage(),
          ),
          GoRoute(
            path: 'group/:groupId',
            builder: (context, state) =>
                GroupDetailPage(groupId: state.pathParameters['groupId']!),
          ),
          GoRoute(
            path: 'challenges',
            builder: (context, state) => const ChallengesPage(),
          ),
          GoRoute(
            path: 'duel/lobby',
            builder: (context, state) => const DuelLobbyPage(),
          ),
          GoRoute(
            path: 'duel/play',
            builder: (context, state) => DuelPlayPage(opponent: state.extra),
          ),
          GoRoute(
            path: 'messages',
            builder: (context, state) => const MessagesPage(),
          ),
          GoRoute(
            path: 'chat/:friendId',
            builder: (context, state) => ChatPage(
              friendId: state.pathParameters['friendId']!,
            ),
          ),
          GoRoute(
            path: 'friends',
            builder: (context, state) => const FriendsPage(),
          ),
          GoRoute(
            path: 'profile/:userId',
            builder: (context, state) => ProfilePage(
              userId: state.pathParameters['userId']!,
            ),
          ),
          GoRoute(
            path: 'announcements',
            builder: (context, state) => const AnnouncementsPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/ai-tutor',
        // Canonical Tiger AI chat surface is `screens/ai/` (unified with the
        // former `screens/ai_tutor/` mock duplicate — see phase-01 plan).
        // `/ai-tutor` and its `chat`/`chat-new` sub-routes all resolve to the
        // same live streaming chat page to preserve existing deep links
        // (home/settings/more-sheet still push these paths).
        builder: (context, state) => const AIChatPage(),
        routes: [
          GoRoute(
            path: 'chat',
            builder: (context, state) => const AIChatPage(),
          ),
          GoRoute(
            path: 'chat-new',
            builder: (context, state) => const AIChatPage(),
          ),
          GoRoute(
            path: 'writing',
            builder: (context, state) => const AIWritingPracticePage(),
          ),
          GoRoute(
            path: 'settings',
            builder: (context, state) => const AISettingsPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/stats',
        builder: (context, state) => const StatsScreen(),
        routes: [
          GoRoute(
            path: 'error-patterns',
            builder: (context, state) => const ErrorPatternsPage(),
          ),
          GoRoute(
            path: 'daily-quote',
            builder: (context, state) => const DailyQuotePage(),
          ),
        ],
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
      GoRoute(
        path: '/affiliate',
        builder: (context, state) => const AffiliateScreen(),
        routes: [
          GoRoute(
            path: 'leaderboard',
            builder: (context, state) => const AffiliateLeaderboardPage(),
          ),
          GoRoute(
            path: 'detail',
            builder: (context, state) => const AffiliatePage(),
          ),
        ],
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
        routes: [
          GoRoute(
            path: 'edit',
            builder: (context, state) => const EditProfileScreen(),
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          // 0 — Trang chủ
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // 1 — Thi
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/exam',
                builder: (context, state) => const ExamScreen(),
                routes: [
                  GoRoute(
                    path: 'goethe-b1',
                    builder: (context, state) => const GoetheB1HubPage(),
                    routes: [
                      GoRoute(
                        path: 'reading',
                        builder: (context, state) => const GoetheB1HubPage(),
                      ),
                      GoRoute(
                        path: 'listening',
                        builder: (context, state) => const GoetheB1HubPage(),
                      ),
                      GoRoute(
                        path: 'writing',
                        builder: (context, state) => const GoetheB1HubPage(),
                      ),
                      GoRoute(
                        path: 'speaking',
                        builder: (context, state) => const GoetheB1HubPage(),
                      ),
                      GoRoute(
                        path: 'writing-topics',
                        builder: (context, state) =>
                            const GoetheB1WritingPage(),
                      ),
                      GoRoute(
                        path: 'speaking-topics',
                        builder: (context, state) => const GoetheSpeakingPage(),
                      ),
                      GoRoute(
                        path: 'exams',
                        builder: (context, state) => const ExamListPage(),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'practice/:examId',
                    parentNavigatorKey: _rootKey,
                    builder: (context, state) {
                      final examId = state.pathParameters['examId']!;
                      final timed =
                          state.uri.queryParameters['timed'] == 'true';
                      final mode = parseMode(state.uri.queryParameters['mode']);
                      return ExamPracticePage(
                        examId: examId,
                        timed: timed,
                        mode: mode,
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'sections',
                        builder: (context, state) {
                          final examId = state.pathParameters['examId']!;
                          final mode = parseMode(
                            state.uri.queryParameters['mode'],
                          );
                          return ExamPracticePage(
                            examId: examId,
                            timed: true,
                            mode: mode,
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'result/:examId',
                    parentNavigatorKey: _rootKey,
                    builder: (context, state) {
                      final examId = state.pathParameters['examId']!;
                      return ExamResultPage(examId: examId);
                    },
                  ),
                  // Vành đai Exam ecosystem (PARITY P3) — readiness, lịch thi
                  // + tìm bạn ôn thi, đề cộng đồng (read-only), dictation.
                  GoRoute(
                    path: 'readiness',
                    parentNavigatorKey: _rootKey,
                    builder: (context, state) => const ExamReadinessScreen(),
                  ),
                  GoRoute(
                    path: 'schedule',
                    parentNavigatorKey: _rootKey,
                    builder: (context, state) => const ExamScheduleScreen(),
                  ),
                  GoRoute(
                    path: 'community',
                    parentNavigatorKey: _rootKey,
                    builder: (context, state) =>
                        const CommunityExamsListScreen(),
                    routes: [
                      GoRoute(
                        path: ':topicId',
                        builder: (context, state) => CommunityExamDetailScreen(
                          topicId: state.pathParameters['topicId']!,
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'dictation',
                    parentNavigatorKey: _rootKey,
                    builder: (context, state) =>
                        const ExamDictationPickerScreen(),
                  ),
                  GoRoute(
                    path: 'dictation/:provider/:level/:slug',
                    parentNavigatorKey: _rootKey,
                    builder: (context, state) => ExamDictationScreen(
                      provider: state.pathParameters['provider']!,
                      level: state.pathParameters['level']!,
                      slug: state.pathParameters['slug']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // 2 — Học: B2 Learn Hub với phiên hôm nay từ backend.
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/learn',
                builder: (context, state) => const JourneyScreen(),
                routes: [
                  GoRoute(
                    path: 'group/:groupId',
                    builder: (context, state) => GroupDetailScreen(
                      groupId: state.pathParameters['groupId']!,
                    ),
                    routes: [
                      GoRoute(
                        path: 'watch/:videoId',
                        builder: (context, state) => VideoPlayerScreen(
                          groupId: state.pathParameters['groupId']!,
                          videoId: state.pathParameters['videoId']!,
                          title: state.extra as String? ?? '',
                        ),
                      ),
                    ],
                  ),
                  // Learn extensions (mirrors web `/learn/topics`,
                  // `/learn/can-do/:id/practice`) — mounts as root navigator
                  // routes vì cần fullscreen (không nằm trong shell tab bar).
                  GoRoute(
                    path: 'topics',
                    parentNavigatorKey: _rootKey,
                    builder: (context, state) => const TopicExploreScreen(),
                  ),
                  GoRoute(
                    path: 'can-do/:canDoId/practice',
                    parentNavigatorKey: _rootKey,
                    builder: (context, state) => CanDoPracticeScreen(
                      canDoId: Uri.decodeComponent(
                        state.pathParameters['canDoId']!,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // 3 — AI
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/ai',
                builder: (context, state) => const AIChatPage(),
              ),
            ],
          ),
          // Tab "Thêm" (index 4) KHÔNG có branch — AppShell tap thì
          // mở MoreFeaturesSheet thay vì navigate.
        ],
      ),
    ],
  );
});

/// Cầu nối Stream → Listenable cho go_router refreshListenable.
class _GoRouterRefresh extends ChangeNotifier {
  _GoRouterRefresh(Stream<dynamic> stream) {
    notifyListeners();
    _sub = stream.listen((_) => notifyListeners());
  }

  late final dynamic _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
