import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../features/vocabulary/domain/vocabulary_models.dart';
import '../../features/vocabulary/presentation/vocabulary_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../view_models/learn/learn_provider.dart';
import '../../widgets/common/async_state_views.dart';

/// "Khám phá theo chủ đề" — duyệt catalog chủ đề từ vựng thật + ghim ⭐ để lái
/// hướng học (priority_topics). `GET /user/preferences`,
/// `PUT /user/preferences`. Danh mục chủ đề tái dùng
/// [vocabularyTopicsProvider]/[topicLevelCountsProvider] đã live sẵn trong
/// domain vocabulary (tránh gọi trùng contract). Mirrors web
/// `topic-explore-page.tsx`.
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
    final topicsAsync = ref.watch(vocabularyTopicsProvider);
    final levelCountsAsync = ref.watch(topicLevelCountsProvider);
    final prefsAsync = ref.watch(learnPreferencesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(l10n.topicExploreTitle),
      ),
      body: topicsAsync.when(
        loading: () => const LoadingView(),
        error: (_, _) => ErrorView(
          onRetry: () => ref.invalidate(vocabularyTopicsProvider),
        ),
        data: (topics) {
          final mainTopics = topics.where((t) => t.parentId == null).toList();
          final subtopicsByParent = <String, List<VocabularyTopic>>{};
          for (final t in topics) {
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

          if (mainTopics.isEmpty) {
            return Center(
              child: Text(
                l10n.topicExploreEmpty,
                style: const TextStyle(color: AppColors.mutedForeground),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(vocabularyTopicsProvider);
              ref.invalidate(topicLevelCountsProvider);
              ref.invalidate(learnPreferencesProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mainTopics.length,
              itemBuilder: (context, index) {
                final topic = mainTopics[index];
                final subTopics = subtopicsByParent[topic.id] ?? const [];
                return _TopicGroup(
                  topic: topic,
                  subTopics: subTopics,
                  levelsByTopicId: levelsByTopicId,
                  pinnedKeys: pinned,
                  onTogglePin: (key) => _togglePin(key, pinned),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _TopicGroup extends StatelessWidget {
  const _TopicGroup({
    required this.topic,
    required this.subTopics,
    required this.levelsByTopicId,
    required this.pinnedKeys,
    required this.onTogglePin,
  });

  final VocabularyTopic topic;
  final List<VocabularyTopic> subTopics;
  final Map<String, List<TopicLevelCount>> levelsByTopicId;
  final Set<String> pinnedKeys;
  final void Function(String topicKey) onTogglePin;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Row(
          children: [
            Text(topic.icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                topic.labelVi,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            _PinButton(
              pinned: pinnedKeys.contains(topic.key),
              onTap: () => onTogglePin(topic.key),
            ),
          ],
        ),
        children: [
          if (subTopics.isEmpty)
            _TopicRow(
              topic: topic,
              counts: levelsByTopicId[topic.id] ?? const [],
              pinned: pinnedKeys.contains(topic.key),
              onTogglePin: () => onTogglePin(topic.key),
              showPin: false,
            )
          else
            ...subTopics.map(
              (sub) => _TopicRow(
                topic: sub,
                counts: levelsByTopicId[sub.id] ?? const [],
                pinned: pinnedKeys.contains(sub.key),
                onTogglePin: () => onTogglePin(sub.key),
                showPin: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _TopicRow extends StatelessWidget {
  const _TopicRow({
    required this.topic,
    required this.counts,
    required this.pinned,
    required this.onTogglePin,
    required this.showPin,
  });

  final VocabularyTopic topic;
  final List<TopicLevelCount> counts;
  final bool pinned;
  final VoidCallback onTogglePin;
  final bool showPin;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text(topic.icon),
          const SizedBox(width: 8),
          Expanded(child: Text(topic.labelVi)),
        ],
      ),
      subtitle: counts.isEmpty
          ? null
          : Wrap(
              spacing: 6,
              children: counts
                  .map(
                    (c) => Chip(
                      label: Text(
                        '${c.level} · ${c.count}',
                        style: const TextStyle(fontSize: 10),
                      ),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  )
                  .toList(),
            ),
      trailing: showPin
          ? _PinButton(pinned: pinned, onTap: onTogglePin)
          : const Icon(Icons.chevron_right),
      onTap: () => context.push('/vocabulary/detail/${topic.key}'),
    );
  }
}

class _PinButton extends StatelessWidget {
  const _PinButton({required this.pinned, required this.onTap});
  final bool pinned;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        pinned ? Icons.star : Icons.star_border,
        color: pinned ? AppColors.warning : AppColors.mutedForeground,
      ),
      onPressed: onTap,
      visualDensity: VisualDensity.compact,
    );
  }
}
