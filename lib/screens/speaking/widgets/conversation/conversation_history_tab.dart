import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../view_models/speech/conversation_provider.dart';

/// "Lịch sử luyện tập" tab — saved conversation sessions list with inline
/// delete confirm. Web parity: `conversation-history-list.tsx`.
class ConversationHistoryTab extends ConsumerStatefulWidget {
  const ConversationHistoryTab({super.key});

  @override
  ConsumerState<ConversationHistoryTab> createState() => _ConversationHistoryTabState();
}

class _ConversationHistoryTabState extends ConsumerState<ConversationHistoryTab> {
  String? _pendingDeleteId;
  bool _deleting = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final sessionsAsync = ref.watch(conversationSessionsProvider);

    return sessionsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, st) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            Text(l10n.conversationHistoryLoadError, style: TextStyle(color: tokens.mutedForeground)),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => ref.invalidate(conversationSessionsProvider),
              child: Text(l10n.retry),
            ),
          ],
        ),
      ),
      data: (sessions) {
        if (sessions.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 56),
            child: Column(
              children: [
                Icon(PhosphorIcons.chatCircleDots, size: 40, color: tokens.mutedForeground.withValues(alpha: 0.5)),
                const SizedBox(height: 8),
                Text(l10n.conversationHistoryEmpty, style: TextStyle(color: tokens.mutedForeground)),
                const SizedBox(height: 2),
                Text(l10n.conversationHistoryEmptyHint, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
              ],
            ),
          );
        }
        return Column(
          children: sessions
              .map(
                (s) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Material(
                    color: tokens.card,
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => context.push('/conversation/history/${s.id}'),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [tokens.primary, tokens.primary.withValues(alpha: 0.75)]),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(PhosphorIcons.chatCircleDotsFill, color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(s.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w700, color: tokens.foreground)),
                                  Text(
                                    l10n.conversationHistoryMeta(s.level, s.userTurns, _formatDate(s.createdAt)),
                                    style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                                  ),
                                ],
                              ),
                            ),
                            if (_pendingDeleteId == s.id)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: _deleting
                                        ? null
                                        : () async {
                                            setState(() => _deleting = true);
                                            await ref.read(conversationSessionRepositoryProvider).deleteSession(s.id);
                                            ref.invalidate(conversationSessionsProvider);
                                            if (mounted) setState(() { _deleting = false; _pendingDeleteId = null; });
                                          },
                                    child: Text(l10n.conversationHistoryDelete, style: const TextStyle(color: Colors.red)),
                                  ),
                                  TextButton(
                                    onPressed: () => setState(() => _pendingDeleteId = null),
                                    child: Text(l10n.conversationHistoryCancel),
                                  ),
                                ],
                              )
                            else
                              IconButton(
                                icon: const Icon(PhosphorIcons.trash, size: 18),
                                color: tokens.mutedForeground,
                                onPressed: () => setState(() => _pendingDeleteId = s.id),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  String _formatDate(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}
