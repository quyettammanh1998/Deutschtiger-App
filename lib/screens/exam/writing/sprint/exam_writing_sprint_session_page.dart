import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../features/writing/data/sprint/sprint_repository.dart';
import '../../../../features/writing/data/sprint/sr_queue_store.dart';
import '../../../../features/writing/domain/sprint/sr_card_queue.dart';
import '../../../../features/writing/domain/sprint/sprint_types.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../widgets/common/async_state_views.dart';
import 'widgets/sr_card.dart';

/// Sprint v2 SR card session page — cycles through the persisted SR queue.
/// Web parity `exam-writing-sprint-session-page.tsx`. Reloads the queue from
/// [SrQueueStore] on mount (mirrors web's `useSrSession` localStorage
/// reload-on-mount) — `SRCardState.due` being an absolute timestamp makes
/// this restart-safe with no background timer.
class ExamWritingSprintSessionPage extends ConsumerStatefulWidget {
  const ExamWritingSprintSessionPage({super.key});

  @override
  ConsumerState<ExamWritingSprintSessionPage> createState() => _ExamWritingSprintSessionPageState();
}

class _ExamWritingSprintSessionPageState extends ConsumerState<ExamWritingSprintSessionPage> {
  final _store = SrQueueStore();
  SRQueue? _queue;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final queue = await _store.load();
    if (!mounted) return;
    setState(() {
      _queue = queue;
      _loaded = true;
    });
    if (queue == null) {
      // No queue started yet — bounce back to the entry page.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/exam/goethe-b1/writing/sprint');
      });
    }
  }

  Future<void> _applyRating(String slug, SRRating rating) async {
    final queue = _queue;
    if (queue == null) return;
    final updated = rateCard(queue, slug, rating);
    setState(() => _queue = updated);
    await _store.save(updated);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final topicsAsync = ref.watch(sprintTopicsProvider);

    if (!_loaded || _queue == null) {
      return Scaffold(backgroundColor: tokens.background, body: const LoadingView());
    }

    final queue = _queue!;
    final stats = queueStats(queue);
    final currentCard = nextDueCard(queue);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: topicsAsync.when(
          loading: () => const LoadingView(),
          error: (_, _) => ErrorView(message: l10n.couldNotLoadData, onRetry: () => ref.invalidate(sprintTopicsProvider)),
          data: (topics) {
            final currentTopic = currentCard == null
                ? null
                : topics.where((t) => t.slug == currentCard.slug).firstOrNull;

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: tokens.background, border: Border(bottom: BorderSide(color: tokens.border))),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () => context.go('/exam/goethe-b1/writing/sprint'),
                        child: Text('← ${l10n.writingSprintTitle}', style: TextStyle(fontSize: 13, color: tokens.mutedForeground)),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                value: stats.total == 0 ? 0 : stats.seen / stats.total,
                                minHeight: 6,
                                backgroundColor: tokens.muted,
                                valueColor: AlwaysStoppedAnimation(tokens.primary),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text('${stats.seen}/${stats.total}', style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/exam/goethe-b1/writing/sprint/thi-thu'),
                        child: Text(l10n.writingSprintMockCta, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tokens.foreground)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: (currentCard != null && currentTopic != null)
                      ? SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: SrCard(
                            key: ValueKey(currentTopic.slug),
                            topic: currentTopic,
                            cardNum: stats.seen + 1,
                            total: stats.total,
                            mode: queue.mode,
                            onRate: (rating) => _applyRating(currentTopic.slug, rating),
                            onSkip: () => _applyRating(currentTopic.slug, SRRating.again),
                          ),
                        )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('🎉', style: TextStyle(fontSize: 48)),
                                const SizedBox(height: 12),
                                Text(l10n.writingSprintSessionDoneTitle, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: tokens.foreground)),
                                const SizedBox(height: 4),
                                Text(l10n.writingSprintSessionDoneBody(stats.seen), style: TextStyle(fontSize: 13, color: tokens.mutedForeground)),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => context.push('/exam/goethe-b1/writing/sprint/thi-thu'),
                                  style: ElevatedButton.styleFrom(backgroundColor: tokens.primary, foregroundColor: tokens.primaryForeground, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                  child: Text(l10n.writingSprintMockCta),
                                ),
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: () => context.go('/exam/goethe-b1/writing/sprint'),
                                  child: Text(l10n.writingSprintBackToSprint, style: TextStyle(color: tokens.mutedForeground)),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
