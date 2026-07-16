// Owner: P8 (exam-core-community) — web-mobile UI fidelity plan.
// `writing-topics`/`speaking-topics` (nested under `goethe-b1`) are P9's
// (exam-writing) — kept in this same file since they are nested inside the
// `/exam/goethe-b1` sub-tree owned structurally by P8; coordinate with P9
// before editing those two sub-routes.
//
// `/de-thi` public registry (top-level, no auth) + the full `/exam` shell
// branch (branch 1 of the StatefulShellRoute in `app_router.dart`).

import 'package:go_router/go_router.dart';

import '../../screens/exam/exam_screen.dart';
import '../../screens/exam/goethe_b1_hub_page.dart';
import '../../screens/exam/exam_list_page.dart';
import '../../features/exam/presentation/exam_practice_page.dart';
import '../../features/exam/presentation/exam_player_provider.dart';
import '../../features/exam/presentation/exam_result_page.dart';
import '../../screens/exam/goethe_b1_writing_page.dart';
import '../../screens/exam/goethe_speaking_page.dart';
import '../../screens/exam/exam_readiness_screen.dart';
import '../../screens/exam/exam_schedule_screen.dart';
import '../../screens/exam/exam_dictation_picker_screen.dart';
import '../../screens/exam/exam_dictation_screen.dart';
import '../../screens/exam/community_exams_list_screen.dart';
import '../../screens/exam/community_exam_detail_screen.dart';
import '../../screens/exam/de_thi_list_screen.dart';
import '../../screens/exam/de_thi_practice_screen.dart';
import '../router_keys.dart';

/// De-thi public registry — deep-link SEO route, không cần đăng nhập (xem
/// `resolveAuthRedirect`/`publicAuthRoutePrefixes`).
final List<RouteBase> deThiRoutes = [
  GoRoute(path: '/de-thi', builder: (context, state) => const DeThiListScreen()),
  GoRoute(
    path: '/de-thi/:code',
    builder: (context, state) =>
        DeThiPracticeScreen(code: state.pathParameters['code']!),
  ),
];

/// Shell branch 1 ("Thi") routes.
final List<RouteBase> examShellRoutes = [
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
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final examId = state.pathParameters['examId']!;
          final timed = state.uri.queryParameters['timed'] == 'true';
          final mode = parseMode(state.uri.queryParameters['mode']);
          return ExamPracticePage(examId: examId, timed: timed, mode: mode);
        },
        routes: [
          GoRoute(
            path: 'sections',
            builder: (context, state) {
              final examId = state.pathParameters['examId']!;
              final mode = parseMode(state.uri.queryParameters['mode']);
              return ExamPracticePage(examId: examId, timed: true, mode: mode);
            },
          ),
        ],
      ),
      GoRoute(
        path: 'result/:examId',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final examId = state.pathParameters['examId']!;
          return ExamResultPage(examId: examId);
        },
      ),
      // Vành đai Exam ecosystem (PARITY P3) — readiness, lịch thi + tìm bạn
      // ôn thi, đề cộng đồng (read-only), dictation.
      GoRoute(
        path: 'readiness',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ExamReadinessScreen(),
      ),
      GoRoute(
        path: 'schedule',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ExamScheduleScreen(),
      ),
      GoRoute(
        path: 'community',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const CommunityExamsListScreen(),
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
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ExamDictationPickerScreen(),
      ),
      GoRoute(
        path: 'dictation/:provider/:level/:slug',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => ExamDictationScreen(
          provider: state.pathParameters['provider']!,
          level: state.pathParameters['level']!,
          slug: state.pathParameters['slug']!,
        ),
      ),
    ],
  ),
];
