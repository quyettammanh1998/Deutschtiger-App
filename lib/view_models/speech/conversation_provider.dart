import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/view_models/providers.dart' show apiClientProvider;

import '../../data/speech/conversation_models.dart';
import '../../data/speech/conversation_session_models.dart';
import '../../repositories/speech/conversation_repository.dart';
import '../../repositories/speech/conversation_session_repository.dart';
import '../../repositories/speech/interview_repository.dart';
import 'conversation_dialog_controller.dart';

// ── Repository providers ────────────────────────────────────────────────

final conversationRepositoryProvider = Provider<ConversationRepository>(
  (ref) => ConversationRepository(ref.watch(apiClientProvider)),
);

final conversationSessionRepositoryProvider =
    Provider<ConversationSessionRepository>(
      (ref) => ConversationSessionRepository(ref.watch(apiClientProvider)),
    );

final interviewRepositoryProvider = Provider<InterviewRepository>(
  (ref) => InterviewRepository(ref.watch(apiClientProvider)),
);

// ── Hub data ─────────────────────────────────────────────────────────────

/// `GET /user/conversation/scenarios` — hub tile list.
final conversationScenariosProvider = FutureProvider<List<ScenarioMeta>>(
  (ref) => ref.watch(conversationRepositoryProvider).fetchScenarios(),
);

/// `GET /user/conversation/scenario/{id}` — full scenario for a catalog
/// (non-custom, non-interview) topic.
final conversationScenarioProvider = FutureProvider.family<Scenario, String>(
  (ref, id) => ref.watch(conversationRepositoryProvider).fetchScenario(id),
);

/// `GET /user/conversation/interview/scenarios/{id}` — saved interview
/// scenario, routable straight into the turn loop.
final interviewScenarioProvider = FutureProvider.family<Scenario, String>(
  (ref, id) =>
      ref.watch(interviewRepositoryProvider).getInterviewScenario(id),
);

// ── Daily quota (free-tier session wall) ────────────────────────────────

final conversationDailyQuotaProvider =
    FutureProvider.autoDispose<ConversationDailyQuota?>(
      (ref) => ref.watch(conversationSessionRepositoryProvider).fetchDailyQuota(),
    );

// ── History ──────────────────────────────────────────────────────────────

final conversationSessionsProvider =
    FutureProvider.autoDispose<List<ConversationSessionSummary>>(
      (ref) => ref.watch(conversationSessionRepositoryProvider).fetchSessions(),
    );

final conversationSessionDetailProvider =
    FutureProvider.autoDispose.family<ConversationSessionDetail, String>(
      (ref, id) => ref.watch(conversationSessionRepositoryProvider).fetchSession(id),
    );

// ── Interview library ───────────────────────────────────────────────────

final interviewScenariosProvider =
    FutureProvider.autoDispose<List<InterviewScenarioSummary>>(
      (ref) => ref.watch(interviewRepositoryProvider).listInterviewScenarios(),
    );

// ── Live dialog controller (per scenario-page mount) ────────────────────

final conversationDialogControllerProvider = StateNotifierProvider.autoDispose
    .family<ConversationDialogController, ConversationDialogState, ConversationDialogArgs>(
      (ref, args) => ConversationDialogController(
        repository: ref.watch(conversationRepositoryProvider),
        sessionRepository: ref.watch(conversationSessionRepositoryProvider),
        args: args,
      ),
    );
