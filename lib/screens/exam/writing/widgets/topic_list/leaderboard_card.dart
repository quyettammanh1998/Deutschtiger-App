import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/data/goethe_b1_writing_repository.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../view_models/providers.dart';

/// Topic-list sidebar leaderboard — web parity
/// `goethe-b1-writing-leaderboard.tsx`: top-10 + current-user row.
class WritingLeaderboardCard extends ConsumerWidget {
  const WritingLeaderboardCard({super.key, required this.teil, required this.totalTopics});

  final int teil;
  final int totalTopics;

  static const _rankEmoji = {1: '🥇', 2: '🥈', 3: '🥉'};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final entriesAsync = ref.watch(goetheB1WritingLeaderboardProvider(teil));
    final userId = ref.watch(authStateProvider).valueOrNull?.session?.user.id;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.border),
      ),
      child: entriesAsync.when(
        loading: () => const SizedBox(
          height: 80,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        error: (_, _) => const SizedBox.shrink(),
        data: (entries) {
          final top10 = entries.where((e) => e.rank <= 10).toList();
          final outsideCandidates =
              entries.where((e) => e.rank > 10 && e.userId == userId);
          final outsideUser = outsideCandidates.isEmpty ? null : outsideCandidates.first;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.emoji_events, size: 16, color: Color(0xFFF59E0B)),
                  const SizedBox(width: 6),
                  Text(
                    l10n.writingLeaderboardTitle(teil),
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: tokens.foreground),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (top10.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Text(
                      l10n.writingLeaderboardEmpty,
                      style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                    ),
                  ),
                )
              else
                for (final e in top10)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          child: Text(
                            _rankEmoji[e.rank] ?? '${e.rank}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                          ),
                        ),
                        const SizedBox(width: 6),
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: tokens.muted,
                          backgroundImage:
                              e.avatarUrl != null ? NetworkImage(e.avatarUrl!) : null,
                          child: e.avatarUrl == null
                              ? Text(
                                  e.displayName.isNotEmpty ? e.displayName[0].toUpperCase() : '?',
                                  style: const TextStyle(fontSize: 9),
                                )
                              : null,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            e.userId == userId ? '${e.displayName} (${l10n.writingLeaderboardYou})' : e.displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12, color: tokens.foreground),
                          ),
                        ),
                        Text(
                          totalTopics > 0 ? '${e.completedCount}/$totalTopics' : '${e.completedCount}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                        ),
                      ],
                    ),
                  ),
              if (outsideUser != null) ...[
                Divider(color: tokens.border, height: 16),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                      child: Text('${outsideUser.rank}', textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text('${outsideUser.displayName} (${l10n.writingLeaderboardYou})',
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tokens.foreground)),
                    ),
                    Text(
                      totalTopics > 0 ? '${outsideUser.completedCount}/$totalTopics' : '${outsideUser.completedCount}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                    ),
                  ],
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
