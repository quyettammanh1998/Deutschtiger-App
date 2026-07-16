import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/speech/sprechen_session_models.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../view_models/speech/sprechen_session_provider.dart';

/// Web parity: `sprechen-session-history-sheet.tsx` — bottom sheet listing
/// past practice sessions for this teil/topic (`GET
/// /user/sprechen-sessions`), opened from the study-tab "Lịch sử" header
/// button.
class SprechenSessionHistorySheet extends ConsumerWidget {
  const SprechenSessionHistorySheet({super.key, required this.teil});

  final String teil;

  static Future<void> show(BuildContext context, {required String teil}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => SprechenSessionHistorySheet(teil: teil),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final repo = ref.watch(sprechenSessionRepositoryProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return FutureBuilder<List<SprechenSession>>(
          future: repo.fetchSessions(),
          builder: (context, snapshot) {
            final sessions = (snapshot.data ?? const [])
                .where((s) => s.teil == teil)
                .toList();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    l10n.conversationTabHistory,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: tokens.foreground,
                    ),
                  ),
                ),
                Expanded(
                  child: snapshot.connectionState != ConnectionState.done
                      ? const Center(child: CircularProgressIndicator())
                      : sessions.isEmpty
                      ? Center(
                          child: Text(
                            l10n.sprechenSessionHistoryEmpty,
                            style: TextStyle(color: tokens.mutedForeground),
                          ),
                        )
                      : ListView.separated(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: sessions.length,
                          separatorBuilder: (_, _) => Divider(
                            height: 1,
                            color: tokens.border,
                          ),
                          itemBuilder: (context, index) {
                            final session = sessions[index];
                            return ListTile(
                              title: Text(session.topic),
                              subtitle: Text(session.id),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
