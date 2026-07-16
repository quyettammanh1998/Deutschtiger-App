import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/icons/app_phosphor_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/games/sentence_builder_models.dart';
import '../../../view_models/games/sentence_builder_provider.dart';
import '../../../widgets/common/async_state_views.dart';
import '../../../widgets/common/sticky_cta_bar.dart';
import 'widgets/topic_gradient_tile.dart';

const _levels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

/// Chọn chủ đề cho Sentence Builder — `GET /sentence-builder/topics?level=`.
/// Web parity: `topic-select-page.tsx` — tap-to-select card model + sticky
/// bottom CTA row ("Ngẫu nhiên" + "Bắt đầu — {topic}"), not immediate
/// navigate-on-tap. Web's primary CTA goes straight to `/play` (it does not
/// route through `/preview` even though that route exists) — this screen
/// mirrors that, and additionally exposes a secondary "Xem trước" action per
/// card so the new preview screen (`sentence_builder_preview_screen.dart`)
/// is actually reachable from the app (web itself leaves it orphaned).
class SentenceBuilderTopicsScreen extends ConsumerStatefulWidget {
  const SentenceBuilderTopicsScreen({super.key});

  @override
  ConsumerState<SentenceBuilderTopicsScreen> createState() =>
      _SentenceBuilderTopicsScreenState();
}

class _SentenceBuilderTopicsScreenState
    extends ConsumerState<SentenceBuilderTopicsScreen> {
  String _level = 'A1';
  String? _selectedTopicId;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final topicsAsync = ref.watch(sentenceBuilderTopicsProvider(_level));

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(AppPhosphorIcons.caretLeft),
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Viết câu AI',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: tokens.foreground,
                          ),
                        ),
                        Text(
                          'Chọn chủ đề rồi luyện viết câu tiếng Đức',
                          style: TextStyle(
                            fontSize: 12,
                            color: tokens.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trình độ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: tokens.foreground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _LevelSelector(
                      level: _level,
                      onChanged: (v) => setState(() {
                        _level = v;
                        _selectedTopicId = null;
                      }),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Chủ đề',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: tokens.foreground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    topicsAsync.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(child: LoadingView()),
                      ),
                      error: (_, _) => ErrorView(
                        onRetry: () => ref.invalidate(
                          sentenceBuilderTopicsProvider(_level),
                        ),
                      ),
                      data: (topics) {
                        if (topics.isEmpty) {
                          return const ErrorView(
                            message: 'Chưa có chủ đề nào cho cấp độ này.',
                          );
                        }
                        return Column(
                          key: const Key('sentence-builder-topics-list'),
                          children: [
                            for (final topic in topics)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _TopicTile(
                                  topic: topic,
                                  selected: _selectedTopicId == topic.id,
                                  onTap: () => setState(() {
                                    _selectedTopicId =
                                        _selectedTopicId == topic.id
                                        ? null
                                        : topic.id;
                                  }),
                                  onPreview: () => context.push(
                                    Uri(
                                      path: '/games/sentence-builder/preview',
                                      queryParameters: {
                                        'level': _level,
                                        'topicId': topic.id,
                                      },
                                    ).toString(),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: topicsAsync.maybeWhen(
        data: (topics) => topics.isEmpty
            ? null
            : StickyCtaBar(
                child: Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => _startSession(context, topicId: null),
                      icon: Icon(AppPhosphorIcons.shuffle, size: 18),
                      label: const Text('Ngẫu nhiên'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => _startSession(
                          context,
                          topicId: _selectedTopicId,
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: tokens.primary,
                          foregroundColor: tokens.primaryForeground,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          _selectedTopicId == null
                              ? 'Bắt đầu (ngẫu nhiên)'
                              : 'Bắt đầu',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        orElse: () => null,
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
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _levels.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final l = _levels[index];
          final selected = l == level;
          final tokens = context.tokens;
          return GestureDetector(
            onTap: () => onChanged(l),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: selected
                    ? LinearGradient(
                        colors: [
                          tokens.primary,
                          Color.lerp(tokens.primary, Colors.red, 0.5)!,
                        ],
                      )
                    : null,
                color: selected ? null : tokens.muted,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                l,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selected ? tokens.primaryForeground : tokens.mutedForeground,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TopicTile extends StatelessWidget {
  const _TopicTile({
    required this.topic,
    required this.selected,
    required this.onTap,
    required this.onPreview,
  });

  final SentenceBuilderTopic topic;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Material(
      color: tokens.card,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? tokens.primary : tokens.border,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              TopicGradientTile(
                icon: topic.icon,
                color: topic.color,
                fallback: tokens.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: tokens.foreground,
                      ),
                    ),
                    Text(
                      topic.labelVi,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: tokens.mutedForeground,
                      ),
                    ),
                    Text(
                      '${topic.wordCount} từ',
                      style: TextStyle(
                        fontSize: 11,
                        color: tokens.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                key: const Key('sentence-builder-topic-preview'),
                tooltip: 'Xem trước',
                icon: Icon(AppPhosphorIcons.bookOpen, size: 18),
                onPressed: onPreview,
              ),
              if (selected)
                Icon(
                  AppPhosphorIcons.checkCircle,
                  color: tokens.primary,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
