import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/welcome_screen.dart';
import '../screens/ai_tutor/ai_tutor_screen.dart';
import '../screens/ai_tutor/widgets/ai_chat_screen.dart';
import '../screens/ai/ai_chat_page.dart';
import '../screens/ai/ai_writing_practice_page.dart';
import '../screens/ai/ai_settings_page.dart';
import '../screens/affiliate/affiliate_screen.dart';
import '../screens/affiliate/affiliate_page.dart';
import '../screens/affiliate/affiliate_leaderboard_page.dart';
import '../screens/exam/exam_screen.dart';
import '../screens/exam/goethe_b1_hub_page.dart';
import '../screens/exam/exam_list_page.dart';
import '../screens/exam/exam_practice_page.dart';
import '../screens/exam/goethe_b1_writing_page.dart';
import '../screens/exam/goethe_speaking_page.dart';
import '../screens/exam/exam_result_page.dart';
import '../screens/flashcard/flashcard_review_screen.dart';
import '../screens/journey/journey_screen.dart';
import '../screens/journey/journey_roadmap_screen.dart';
import '../screens/journey/learning_browser_screen.dart';
import '../screens/journey/widgets/chapter_detail_screen.dart';
import '../screens/listening/listening_hub_screen.dart';
import '../screens/listening/easy_german_podcast_page.dart';
import '../screens/listening/easy_german_podcast_player_page.dart';
import '../screens/listening/sprechen_b1_page.dart';
import '../screens/listening/sprechen_b2_page.dart';
import '../screens/listening/dictation_page.dart';
import '../../data/listening/podcast_models.dart';
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
import '../screens/games/article_game_screen.dart';
import '../screens/games/cases_mastery_game_screen.dart';
import '../screens/games/conversation_game_screen.dart';
import '../screens/games/fill_blank_game_screen.dart';
import '../screens/games/flashcard_game_screen.dart';
import '../screens/games/konjugation_game_screen.dart';
import '../screens/games/listening_game_screen.dart';
import '../screens/games/matching_game_screen.dart';
import '../screens/games/pronunciation_game_screen.dart';
import '../screens/games/runner_game_screen.dart';
import '../screens/games/speaking_game_screen.dart';
import '../screens/games/typing_sprint_game_screen.dart';
import '../screens/games/word_order_game_screen.dart';
import '../screens/games/word_sprint_game_screen.dart';
import '../screens/games/writing_sentence_game_screen.dart';
import '../screens/games/writing_word_game_screen.dart';
import '../screens/games/game_hub_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/interview/group_detail_screen.dart';
import '../screens/interview/interview_roadmap_screen.dart';
import '../screens/interview/video_player_screen.dart';
import '../screens/legal/privacy_policy_screen.dart';
import '../screens/legal/terms_of_service_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/settings/settings_screen.dart';
import 'package:deutschtiger/widgets/common/app_shell.dart';
import '../view_models/providers.dart';

final _rootKey = GlobalKey<NavigatorState>();

/// Router go_router với ShellRoute 4 tab + redirect theo auth state.
/// Chưa login → /welcome (giới thiệu) → /login|/signup. Đã login → /home.
final routerProvider = Provider<GoRouter>((ref) {
  final authService = ref.watch(authServiceProvider);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/home',
    // Rebuild redirect khi auth state đổi.
    refreshListenable: _GoRouterRefresh(authService.authStateChanges),
    redirect: (context, state) {
      final loggedIn = authService.isLoggedIn;
      const publicRoutes = {
        '/welcome',
        '/login',
        '/signup',
        '/forgot-password',
      };
      final atPublic = publicRoutes.contains(state.matchedLocation);
      // Chưa login: cho ở các màn public, mặc định đẩy về /welcome.
      if (!loggedIn) return atPublic ? null : '/welcome';
      // Đã login mà còn ở màn public → vào home.
      if (atPublic) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
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
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
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
        builder: (context, state) => const CasesMasteryGameScreen(),
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
                path: 'episode/:episodeId',
                builder: (context, state) {
                  final extra = state.extra as Map<String, dynamic>?;
                  return EasyGermanPodcastPlayerPage(
                    episode: extra?['episode'] as PodcastEpisode? ??
                        PodcastEpisode(
                          id: state.pathParameters['episodeId'] ?? '',
                          seriesId: 'easy-german',
                          episodeNumber: '1',
                          title: 'Episode',
                          titleVi: 'Tập',
                        ),
                    seriesId: extra?['seriesId'] as String? ?? 'easy-german',
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
          GoRoute(
            path: 'dictation/:dictationId',
            builder: (context, state) {
              final dictation = state.extra as Dictation? ??
                  const Dictation(
                    id: 'default',
                    title: 'Dictation',
                    titleVi: 'Nghe viết',
                    level: 'A1',
                    difficulty: 1,
                    totalSentences: 10,
                  );
              return DictationPage(dictation: dictation);
            },
          ),
        ],
      ),
      // Journey routes
      GoRoute(
        path: '/journey',
        builder: (context, state) => const JourneyScreen(),
        routes: [
          GoRoute(
            path: 'roadmap',
            builder: (context, state) => const JourneyRoadmapScreen(),
          ),
          GoRoute(
            path: 'browse',
            builder: (context, state) => const LearningBrowserScreen(),
          ),
          GoRoute(
            path: 'chapter/:chapterId',
            builder: (context, state) => ChapterDetailScreen(
              chapterId: state.pathParameters['chapterId']!,
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
            builder: (context, state) => GroupDetailPage(
              groupId: state.pathParameters['groupId']!,
            ),
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
            builder: (context, state) => DuelPlayPage(
              opponent: state.extra,
            ),
          ),
          GoRoute(
            path: 'messages',
            builder: (context, state) => const MessagesPage(),
          ),
          GoRoute(
            path: 'chat/:conversationId',
            builder: (context, state) => ChatPage(
              conversationId: state.pathParameters['conversationId']!,
            ),
          ),
          GoRoute(
            path: 'friends',
            builder: (context, state) => const FriendsPage(),
          ),
        ],
      ),
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
                builder: (context, state) => const GoetheB1WritingPage(),
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
            builder: (context, state) {
              final examId = state.pathParameters['examId']!;
              final timed = state.uri.queryParameters['timed'] == 'true';
              return ExamPracticePage(examId: examId, timed: timed);
            },
            routes: [
              GoRoute(
                path: 'sections',
                builder: (context, state) {
                  final examId = state.pathParameters['examId']!;
                  return ExamPracticePage(examId: examId, timed: true);
                },
              ),
            ],
          ),
          GoRoute(
            path: 'result/:examId',
            builder: (context, state) {
              final examId = state.pathParameters['examId']!;
              return ExamResultPage(examId: examId);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/ai-tutor',
        builder: (context, state) => const AITutorScreen(),
        routes: [
          GoRoute(
            path: 'chat',
            builder: (context, state) => const AIChatScreen(),
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/vocab',
                builder: (context, state) => const FlashcardReviewScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/lessons',
                builder: (context, state) => const InterviewRoadmapScreen(),
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
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
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
            ],
          ),
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
