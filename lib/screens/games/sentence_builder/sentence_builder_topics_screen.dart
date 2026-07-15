import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/games/sentence_builder_models.dart';
import '../../../view_models/games/sentence_builder_provider.dart';
import '../../../widgets/common/async_state_views.dart';

const _levels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

/// Chọn chủ đề cho Sentence Builder — `GET /sentence-builder/topics?level=`.
/// Danh sách chủ đề đã bao gồm `wordCount`/`essentialWordCount` nên đóng vai
/// trò "preview" luôn trên màn này, không cần màn riêng xem trước từng từ.
class SentenceBuilderTopicsScreen extends ConsumerStatefulWidget {
  const SentenceBuilderTopicsScreen({super.key});

  @override
  ConsumerState<SentenceBuilderTopicsScreen> createState() =>
      _SentenceBuilderTopicsScreenState();
}

class _SentenceBuilderTopicsScreenState
    extends ConsumerState<SentenceBuilderTopicsScreen> {
  String _level = 'A1';

  @override
  Widget build(BuildContext context) {
    final topicsAsync = ref.watch(sentenceBuilderTopicsProvider(_level));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Viết câu AI'),
      ),
      body: Column(
        children: [
          _LevelSelector(
            level: _level,
            onChanged: (v) => setState(() => _level = v),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _startSession(context, topicId: null),
                icon: const Icon(Icons.shuffle),
                label: const Text('Chủ đề ngẫu nhiên'),
              ),
            ),
          ),
          Expanded(
            child: topicsAsync.when(
              loading: () => const LoadingView(),
              error: (_, _) => ErrorView(
                onRetry: () =>
                    ref.invalidate(sentenceBuilderTopicsProvider(_level)),
              ),
              data: (topics) {
                if (topics.isEmpty) {
                  return const ErrorView(
                    message: 'Chưa có chủ đề nào cho cấp độ này.',
                  );
                }
                return ListView.separated(
                  key: const Key('sentence-builder-topics-list'),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: topics.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final topic = topics[index];
                    return _TopicTile(
                      topic: topic,
                      onTap: () => _startSession(context, topicId: topic.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _startSession(BuildContext context, {String? topicId}) {
    final query = <String, String>{'level': _level};
    if (topicId != null) query['topicId'] = topicId;
    context.push(
      Uri(
        path: '/games/sentence-builder/play',
        queryParameters: query,
      ).toString(),
    );
  }
}

class _LevelSelector extends StatelessWidget {
  const _LevelSelector({required this.level, required this.onChanged});

  final String level;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        itemCount: _levels.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final l = _levels[index];
          final selected = l == level;
          return ChoiceChip(
            label: Text(l),
            selected: selected,
            onSelected: (_) => onChanged(l),
            selectedColor: AppColors.tigerOrange,
            labelStyle: TextStyle(
              color: selected ? Colors.white : AppColors.foreground,
              fontWeight: FontWeight.w600,
            ),
          );
        },
      ),
    );
  }
}

class _TopicTile extends StatelessWidget {
  const _TopicTile({required this.topic, required this.onTap});

  final SentenceBuilderTopic topic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        onTap: onTap,
        title: Text(
          topic.labelVi,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${topic.wordCount} từ · ${topic.essentialWordCount} từ thiết yếu',
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
