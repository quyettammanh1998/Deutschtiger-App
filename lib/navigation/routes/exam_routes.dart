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
import '../../screens/exam/goethe_b1_writing_teil_pick_page.dart';
import '../../screens/exam/exam_list_page.dart';
import '../../screens/exam/exam_section_page.dart';
import '../../screens/exam/exam_skill_list_screen.dart';
import '../../features/exam/presentation/exam_practice_page.dart';
import '../../features/exam/presentation/exam_player_provider.dart';
import '../../features/exam/presentation/exam_result_page.dart';
import '../../screens/exam/writing/goethe_b1_community_writing_list_page.dart';
import '../../screens/exam/writing/goethe_b1_writing_detail_page.dart';
import '../../screens/exam/writing/goethe_b1_writing_practice_page.dart';
import '../../screens/exam/writing/goethe_b1_writing_topic_list_page.dart';
import '../../screens/exam/writing/sprint/exam_writing_sprint_cheatsheet_page.dart';
import '../../screens/exam/writing/sprint/exam_writing_sprint_mock_page.dart';
import '../../screens/exam/writing/sprint/exam_writing_sprint_page.dart';
import '../../screens/exam/writing/sprint/exam_writing_sprint_session_page.dart';
import '../../screens/exam/writing/writing_catalog_page.dart';
import '../../screens/exam/writing/writing_community_topic_page.dart';
import '../../screens/exam/writing/writing_custom_page.dart';
import '../../screens/exam/writing/writing_level_practice_page.dart';
import '../../screens/exam/writing/writing_level_topics_page.dart';
import '../../screens/exam/writing/writing_session_detail_page.dart';
import '../../screens/exam/sprechen/goethe_sprechen_overview_page.dart';
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

/// `writing-catalog` (`/luyen-viet`) unified writing hub + `writing-custom`
/// (`/luyen-viet/tu-nhap`) + `writing-session-detail`
/// (`/writing-practice/:id`) — P9 W3 top-level routes, deep-link SEO-free
/// (auth required, unlike `deThiRoutes`). Web parity `routes.tsx`
/// `luyenViet`/`writingCustom`/`writingPracticeHub`/`writingSession` paths.
final List<RouteBase> luyenVietRoutes = [
  GoRoute(
    path: '/luyen-viet',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) => const WritingCatalogPage(),
  ),
  GoRoute(
    path: '/luyen-viet/tu-nhap',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) {
      final q = state.uri.queryParameters;
      final teilStr = q['teil'];
      return WritingCustomPage(
        prefillTaskPrompt: q['taskPrompt'],
        prefillProvider: q['provider'],
        prefillLevel: q['level'],
        prefillTeil: teilStr == null ? null : int.tryParse(teilStr),
      );
    },
  ),
  // Web: `/writing-practice` (no id) redirects to `/luyen-viet?tab=my`.
  GoRoute(
    path: '/writing-practice',
    parentNavigatorKey: rootNavigatorKey,
    redirect: (context, state) => '/luyen-viet',
  ),
  GoRoute(
    path: '/writing-practice/:id',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) =>
        WritingSessionDetailPage(submissionId: state.pathParameters['id']!),
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
          // P9 W1: real teil-pick screen (was a hub placeholder). P9 W2 adds
          // the nested topic-list/detail/practice/community routes below.
          GoRoute(
            path: 'writing',
            builder: (context, state) => const GoetheB1WritingTeilPickPage(),
            routes: [
              // P9 W4: Sprint v2 (SR mode picker + session + mock +
              // Redemittel cheatsheet). Static `sprint` segment must be
              // declared before the `:teilNum` catch-all sibling below (same
              // "static wins" precedent as `a-rap`/`writing` elsewhere in
              // this file) so it isn't swallowed as a bogus Teil number.
              GoRoute(
                path: 'sprint',
                builder: (context, state) => const ExamWritingSprintPage(),
                routes: [
                  GoRoute(
                    path: 'session',
                    builder: (context, state) => const ExamWritingSprintSessionPage(),
                  ),
                  GoRoute(
                    path: 'thi-thu',
                    builder: (context, state) => const ExamWritingSprintMockPage(),
                  ),
                  GoRoute(
                    path: 'cheatsheet',
                    builder: (context, state) => const ExamWritingSprintCheatsheetPage(),
                  ),
                ],
              ),
              GoRoute(
                path: 'community/:teilNum',
                builder: (context, state) => GoetheB1CommunityWritingListPage(
                  teil: int.tryParse(state.pathParameters['teilNum'] ?? '') ?? 1,
                ),
              ),
              GoRoute(
                path: ':teilNum',
                builder: (context, state) => GoetheB1WritingTopicListPage(
                  teil: int.tryParse(state.pathParameters['teilNum'] ?? '') ?? 1,
                ),
                routes: [
                  GoRoute(
                    path: ':slug/practice',
                    builder: (context, state) => GoetheB1WritingPracticePage(
                      teil: int.tryParse(state.pathParameters['teilNum'] ?? '') ?? 1,
                      slug: state.pathParameters['slug']!,
                    ),
                  ),
                  GoRoute(
                    path: ':slug',
                    builder: (context, state) => GoetheB1WritingDetailPage(
                      teil: int.tryParse(state.pathParameters['teilNum'] ?? '') ?? 1,
                      slug: state.pathParameters['slug']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: 'speaking',
            builder: (context, state) => const GoetheB1HubPage(),
          ),
          // P9 W4: `goethe_b1_writing_page.dart` (mock English-topic prototype,
          // no web counterpart) deleted per the plan's "Xóa" cleanup —
          // redirect stale deep-links to the real, live-data teil-pick flow.
          GoRoute(
            path: 'writing-topics',
            redirect: (context, state) => '/exam/goethe-b1/writing',
          ),
          GoRoute(
            path: 'speaking-topics',
            // P10 deleted the dead Teil A/B/C `GoetheSpeakingPage` prototype
            // (scout §C — no web counterpart); this whole `/exam/goethe-b1`
            // sub-tree is legacy and gated off by default
            // (`ReleaseFeatureFlags.legacyGoetheB1`), so pointing this stop-gap
            // at the new web-parity B1 Sprechen overview keeps the route
            // compiling without inventing new content. P9 owns this file.
            builder: (context, state) =>
                const GoetheSprechenOverviewPage(level: 'b1'),
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
      // Web-parity IA (P8 wave A): landing → section → list/set-detail →
      // skill-list. `goethe-b1` keeps its dedicated hub above (existing
      // flow shared with P9's writing/speaking sub-routes) — this generic
      // branch covers every OTHER provider-level combo (telc-b1, telc-b2,
      // goethe-a1/a2/b2/c1, osd-b2, …).
      GoRoute(
        path: ':providerLevel',
        builder: (context, state) => ExamSectionPage(
          providerLevel: state.pathParameters['providerLevel']!,
        ),
        routes: [
          // TELC B1 bundle chooser special-case: "a-rap" = flat list of all
          // TELC B1 sets (web: `exam-list-page.tsx` comment "A-RAP = all
          // TELC B1 exams"). Static path wins over the `:slug` sibling.
          GoRoute(
            path: 'a-rap',
            builder: (context, state) => const ExamArapListPage(),
            routes: [
              // P9 W4 §5: telc legacy `schreiben-view` (web
              // `/exams/telc/b1/a-rap/schreiben/:slug`) converges onto W1's
              // `WritingPracticePanel` rather than being ported as a
              // standalone reader — its content was static JSON bundled only
              // in web's `public/data/...`, never backed by a live backend
              // endpoint (confirmed: no matching handler in
              // `thamkhao/deutschtiger-backend`), so porting it verbatim
              // would mean hardcoding exam content on a release screen.
              // Redirect keeps old deep-links alive by landing on the
              // equivalent live-data generic writing-practice flow for the
              // same slug (falls back to its own graceful "not found" state
              // if the slug isn't in the official telc-b1 topic set).
              GoRoute(
                path: 'schreiben/:slug',
                redirect: (context, state) =>
                    '/exam/telc-b1/writing/${state.pathParameters['slug']}/practice',
              ),
            ],
          ),
          // P9 W3: generic `writing-level-topics`/`writing-level-practice`/
          // `writing-community-topic` — static `writing` segment wins over
          // the `:slug` sibling below, same pattern as `a-rap`.
          GoRoute(
            path: 'writing',
            builder: (context, state) => WritingLevelTopicsPage(
              providerLevel: state.pathParameters['providerLevel']!,
            ),
            routes: [
              GoRoute(
                path: 'community/:teilNum/:slug',
                builder: (context, state) => WritingCommunityTopicPage(
                  providerLevel: state.pathParameters['providerLevel']!,
                  teil: int.tryParse(state.pathParameters['teilNum'] ?? '') ?? 0,
                  slug: state.pathParameters['slug']!,
                ),
              ),
              GoRoute(
                path: ':slug/practice',
                builder: (context, state) => WritingLevelPracticePage(
                  providerLevel: state.pathParameters['providerLevel']!,
                  slug: state.pathParameters['slug']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'skills/:skill',
            builder: (context, state) {
              final providerLevel = state.pathParameters['providerLevel']!;
              final parts = providerLevel.split('-');
              return ExamSkillListScreen(
                provider: parts.isNotEmpty ? parts.first : 'telc',
                level: parts.length > 1 ? parts.sublist(1).join('-') : 'b1',
                skill: state.pathParameters['skill']!,
              );
            },
          ),
          GoRoute(
            path: ':slug',
            builder: (context, state) {
              final providerLevel = state.pathParameters['providerLevel']!;
              final parts = providerLevel.split('-');
              return ExamListPage(
                provider: parts.isNotEmpty ? parts.first : 'telc',
                level: parts.length > 1 ? parts.sublist(1).join('-') : 'b1',
                slug: state.pathParameters['slug'],
                parentPath: '/exam/$providerLevel',
              );
            },
          ),
        ],
      ),
    ],
  ),
];
