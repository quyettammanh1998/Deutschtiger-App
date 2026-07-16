import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_tokens.dart';
import '../../features/vocabulary/domain/vocabulary_models.dart';
import '../../features/vocabulary/presentation/vocabulary_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../view_models/learn/learn_provider.dart';
import '../../widgets/common/async_state_views.dart';
import 'widgets/topic_group_card.dart';
import 'widgets/topic_steering_card.dart';

/// "Khám phá theo chủ đề" — duyệt catalog chủ đề từ vựng thật + ghim ⭐ để lái
/// hướng học (priority_topics). `GET /user/preferences`,
/// `PUT /user/preferences`. Danh mục chủ đề tái dùng
/// [vocabularyTopicsProvider]/[topicLevelCountsProvider] đã live sẵn trong
/// domain vocabulary (tránh gọi trùng contract). Mirrors web
/// `topic-explore-page.tsx` — no AppBar, h1+subtitle header, gradient
/// steering card, gradient-icon topic group cards.
class TopicExploreScreen extends ConsumerStatefulWidget {
  const TopicExploreScreen({super.key});

  @override
  ConsumerState<TopicExploreScreen> createState() =>
      _TopicExploreScreenState();
}

class _TopicExploreScreenState extends ConsumerState<TopicExploreScreen> {
  Set<String>? _optimisticPinned;
  bool _saving = false;

  Future<void> _togglePin(String topicKey, Set<String> current) async {
    if (_saving) return;
    final next = {...current};
    if (next.contains(topicKey)) {
      next.remove(topicKey);
    } else {
      next.add(topicKey);
    }
    setState(() {
      _optimisticPinned = next;
      _saving = true;
    });
    try {
      await ref
          .read(learnRepositoryProvider)
          .updatePriorityTopics(next.toList(growable: false));
      ref.invalidate(learnPreferencesProvider);
    } catch (_) {
      // Revert lạc quan khi lưu thất bại — không giữ trạng thái sai lệch.
      setState(() => _optimisticPinned = null);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final topicsAsync = ref.watch(vocabularyTopicsProvider);
    final levelCountsAsync = ref.watch(topicLevelCountsProvider);
    final prefsAsync = ref.watch(learnPreferencesProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: topicsAsync.when(
          loading: () => const LoadingView(),
          error: (_, _) => ErrorView(
            onRetry: () => ref.invalidate(vocabularyTopicsProvider),
          ),
          data: (topics) {
            final mainTopics = topics.where((t) => t.parentId == null).toList();
            final subtopicsByParent = <String, List<VocabularyTopic>>{};
            final topicByKey = <String, VocabularyTopic>{};
            for (final t in topics) {
              topicByKey[t.key] = t;
              if (t.parentId != null) {
                (subtopicsByParent[t.parentId!] ??= []).add(t);
              }
            }
            final levelCounts = levelCountsAsync.valueOrNull ?? const [];
            final levelsByTopicId = <String, List<TopicLevelCount>>{};
            for (final row in levelCounts) {
              (levelsByTopicId[row.topicId] ??= []).add(row);
            }
            final pinned =
                _optimisticPinned ??
                (prefsAsync.valueOrNull?.priorityTopics.toSet() ??
                    <String>{});
            final goals = prefsAsync.valueOrNull?.learningGoals ?? const [];

            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(vocabularyTopicsProvider);
                ref.invalidate(topicLevelCountsProvider);
                ref.invalidate(learnPreferencesProvider);
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    l10n.topicExploreTitle,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: tokens.foreground,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.topicExploreSubtitleHeader,
                    style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
                  ),
                  const SizedBox(height: 12),
                  TopicSteeringCard(
                    goals: goals,
                    pinnedKeys: pinned,
                    topicByKey: topicByKey,
                  ),
                  const SizedBox(height: 12),
                  if (mainTopics.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: Text(
                          l10n.topicExploreEmpty,
                          style: TextStyle(color: tokens.mutedForeground),
                        ),
                      ),
                    )
                  else
                    for (final topic in mainTopics)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TopicGroupCard(
                          topic: topic,
                          subTopics: subtopicsByParent[topic.id] ?? const [],
                          levelsByTopicId: levelsByTopicId,
                          pinnedKeys: pinned,
                          onTogglePin: (key) => _togglePin(key, pinned),
                        ),
                      ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
