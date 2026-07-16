// Owner: P10 (speech-conversation-pronunciation) — web-mobile UI fidelity plan.

import 'package:go_router/go_router.dart';

import '../../screens/pronunciation/pronunciation_screen.dart';
import '../../screens/pronunciation/umlaute_trainer_page.dart';
import '../../screens/pronunciation/r_sound_trainer_page.dart';
import '../../screens/pronunciation/ich_ach_trainer_page.dart';
import '../../screens/pronunciation/sp_st_trainer_page.dart';
import '../../screens/pronunciation/minimal_pairs_page.dart';
import '../../screens/speaking/conversation_hub_page.dart';
import '../../screens/speaking/conversation_scenario_page.dart';
import '../../screens/conversation/conversation_history_detail_page.dart';
import '../../screens/conversation/interview_import_page.dart';
import '../../screens/exam/sprechen/goethe_sprechen_overview_page.dart';
import '../../screens/exam/sprechen/goethe_sprechen_topic_list_page.dart';
import '../../screens/exam/sprechen/goethe_sprechen_teil_study_page.dart';
import '../../screens/exam/sprechen/goethe_sprechen_teil_practice_page.dart';
import '../../screens/exam/sprechen/goethe_sprechen_exam_page.dart';
import '../../screens/exam/sprechen/goethe_sprechen_exam_set_overview_page.dart';
import '../../screens/exam/sprechen/sprechen_overview_page.dart';
import '../../screens/exam/sprechen/sprechen_topic_list_page.dart';
import '../../screens/exam/sprechen/sprechen_exam_page.dart';

/// `SprechenExamMode` pages read the exam-question uuid from a `contentId`
/// query param (`?contentId=`) rather than a path segment, since the public
/// `/sprechen/{teil}/topics` list (`SprechenTopic{slug,is_premium,order,tag}`)
/// does not expose the uuid `GET /exams/official/sprechen-content` needs —
/// no mounted endpoint resolves slug→uuid today. Callers (topic-list rows)
/// must pass it via `context.push(uri, extra: {...})`/query string once a
/// resolver exists; until then this falls back to `''`, which the pages
/// already render as a graceful "Không tải được đề" error state instead of
/// crashing. Documented as a follow-up contract gap in the phase report.
String _contentId(GoRouterState state) =>
    state.uri.queryParameters['contentId'] ?? '';

final List<RouteBase> speechRoutes = [
  GoRoute(
    path: '/pronunciation',
    builder: (context, state) => const PronunciationScreen(),
    routes: [
      GoRoute(
        path: 'umlaute',
        builder: (context, state) => const UmlauteTrainerPage(),
      ),
      GoRoute(
        path: 'r-sound',
        builder: (context, state) => const RSoundTrainerPage(),
      ),
      GoRoute(
        path: 'ich-ach-laut',
        builder: (context, state) => const IchAchTrainerPage(),
      ),
      GoRoute(
        path: 'sp-st',
        builder: (context, state) => const SpStTrainerPage(),
      ),
      GoRoute(
        path: 'minimal-pairs',
        builder: (context, state) => const MinimalPairsPage(),
      ),
    ],
  ),

  // Goethe Sprechen — `/exams/goethe/:level/sprechen(/:teil(/:slug(/practice)))`.
  // `from-exam` is registered before the generic `:teil` sibling so it wins
  // the literal match (legacy deep links only — no UI port, scout §B.7/8).
  GoRoute(
    path: '/exams/goethe/:level/sprechen',
    builder: (context, state) => GoetheSprechenOverviewPage(
      level: state.pathParameters['level']!,
    ),
    routes: [
      GoRoute(
        path: 'from-exam/:slug',
        redirect: (context, state) =>
            '/exams/goethe/${state.pathParameters['level']}/sprechen',
      ),
      GoRoute(
        path: 'from-exam/:slug/:n',
        redirect: (context, state) =>
            '/exams/goethe/${state.pathParameters['level']}/sprechen',
      ),
      GoRoute(
        path: ':teil',
        builder: (context, state) => GoetheSprechenTopicListPage(
          level: state.pathParameters['level']!,
          teil: state.pathParameters['teil']!,
        ),
        routes: [
          GoRoute(
            path: ':slug',
            builder: (context, state) => GoetheSprechenExamPage(
              level: state.pathParameters['level']!,
              teil: state.pathParameters['teil']!,
              slug: state.pathParameters['slug']!,
              contentId: _contentId(state),
            ),
            routes: [
              GoRoute(
                path: 'practice',
                builder: (context, state) => GoetheSprechenExamPage(
                  level: state.pathParameters['level']!,
                  teil: state.pathParameters['teil']!,
                  slug: state.pathParameters['slug']!,
                  contentId: _contentId(state),
                  startInPractice: true,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  ),

  // TELC Sprechen ("Nói") — `/exams/telc-b1/noi` + `/exams/telc/b1/noi(/:teil(/:slug(/practice)))`.
  GoRoute(
    path: '/exams/telc-b1/noi',
    builder: (context, state) => const SprechenOverviewPage(),
  ),
  GoRoute(
    path: '/exams/telc/b1/noi',
    builder: (context, state) => const SprechenOverviewPage(),
    routes: [
      GoRoute(
        path: ':teil',
        builder: (context, state) => SprechenTopicListPage(
          teil: state.pathParameters['teil']!,
        ),
        routes: [
          GoRoute(
            path: ':slug',
            builder: (context, state) => SprechenExamPage(
              teil: state.pathParameters['teil']!,
              slug: state.pathParameters['slug']!,
              contentId: _contentId(state),
            ),
            routes: [
              GoRoute(
                path: 'practice',
                builder: (context, state) => SprechenExamPage(
                  teil: state.pathParameters['teil']!,
                  slug: state.pathParameters['slug']!,
                  contentId: _contentId(state),
                  startInPractice: true,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  ),

  // Per-exam Sprechen study/practice + exam-set overview —
  // `/exams/:providerLevel/:examSlug/sprechen(/:teilSegment(/practice))`.
  // `providerLevel`/`examSlug` are compound slugs (e.g. `goethe-b1-03-2024`),
  // never the bare literal `goethe`/`telc` matched above, so there is no
  // runtime ambiguity between this generic family and the two static ones.
  GoRoute(
    path: '/exams/:providerLevel/:examSlug/sprechen',
    builder: (context, state) => GoetheSprechenExamSetOverviewPage(
      providerLevel: state.pathParameters['providerLevel']!,
      slug: state.pathParameters['examSlug']!,
      examTitle: state.uri.queryParameters['title'] ??
          state.pathParameters['examSlug']!,
    ),
    routes: [
      GoRoute(
        path: ':teilSegment',
        builder: (context, state) => GoetheSprechenTeilStudyPage(
          providerLevel: state.pathParameters['providerLevel']!,
          slug: state.pathParameters['examSlug']!,
          teilSegment: state.pathParameters['teilSegment']!,
          contentId: _contentId(state),
        ),
        routes: [
          GoRoute(
            path: 'practice',
            builder: (context, state) => GoetheSprechenTeilPracticePage(
              teilSegment: state.pathParameters['teilSegment']!,
              slug: state.pathParameters['examSlug']!,
              contentId: _contentId(state),
            ),
          ),
        ],
      ),
    ],
  ),

  GoRoute(
    path: '/conversation/history/:id',
    builder: (context, state) => ConversationHistoryDetailPage(
      sessionId: state.pathParameters['id']!,
    ),
  ),
  GoRoute(
    path: '/conversation/interview/import',
    builder: (context, state) => const InterviewImportPage(),
  ),
  GoRoute(
    path: '/conversation/interview/play/:id',
    builder: (context, state) => ConversationScenarioPage(
      interviewId: state.pathParameters['id']!,
    ),
  ),
  GoRoute(
    path: '/conversation/custom/:slug',
    builder: (context, state) {
      final extra = state.extra as Map<Object?, Object?>?;
      return ConversationScenarioPage(
        customSlug: state.pathParameters['slug']!,
        customTopic: extra?['topic'] as String?,
        customLevel: extra?['level'] as String?,
      );
    },
  ),
  GoRoute(
    path: '/conversation/:id',
    builder: (context, state) => ConversationScenarioPage(
      scenarioId: state.pathParameters['id']!,
    ),
  ),
];

/// Shell branch 3 ("Hội thoại") — the web-parity replacement for the AI tab
/// in slot 4 of the bottom nav, active only once
/// `ReleaseFeatureFlags.speaking` (P10 conversation hub) ships. Until then
/// `app_router.dart` wires branch 3 to `aiShellRoutes` instead — see the
/// tab-4 release-gate comment there and in `widgets/common/app_shell.dart`.
final List<RouteBase> conversationShellRoutes = [
  GoRoute(
    path: '/conversation',
    builder: (context, state) => const ConversationHubPage(),
  ),
];
