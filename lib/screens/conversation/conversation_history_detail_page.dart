import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../view_models/speech/conversation_provider.dart';
import 'widgets/conversation_transcript_view.dart';

/// `/conversation/history/:id` — read-only review of a saved conversation
/// practice session (full transcript, no audio). Web parity:
/// `conversation-history-detail-page.tsx`.
///
/// The holistic verdict shown on web (`ExaminerVerdict`, from
/// `/ai/conversation-examiner`) is outside this phase's documented contract
/// (MASTER P8) — this renders the transcript live but shows a pending note
/// where the verdict card would be, per the session's `verdict` payload
/// shape (kept as raw JSON, not bound to a typed schema yet).
class ConversationHistoryDetailPage extends ConsumerWidget {
  const ConversationHistoryDetailPage({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(conversationSessionDetailProvider(sessionId));

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, st) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.conversationHistoryDetailLoadError, style: TextStyle(color: tokens.mutedForeground)),
                const SizedBox(height: 8),
                TextButton(onPressed: () => context.go('/conversation'), child: Text(l10n.conversationHistoryBackToList)),
              ],
            ),
          ),
          data: (session) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => context.canPop() ? context.pop() : context.go('/conversation'),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(session.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: tokens.foreground)),
                          Text(
                            l10n.conversationHistoryMeta(session.level, session.userTurns, session.createdAt),
                            style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: tokens.card, border: Border.all(color: tokens.border), borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.conversationExaminerTitle, style: TextStyle(fontWeight: FontWeight.w700, color: tokens.foreground)),
                      const SizedBox(height: 4),
                      Text(
                        session.verdict != null
                            ? l10n.conversationExaminerVerdictPending
                            : l10n.conversationExaminerNoVerdict,
                        style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ConversationTranscriptView(messages: session.messages),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
