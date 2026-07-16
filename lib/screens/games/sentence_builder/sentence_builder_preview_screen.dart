import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/icons/app_phosphor_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/games/sentence_builder_models.dart';
import '../../../view_models/games/sentence_builder_provider.dart';
import '../../../widgets/common/async_state_views.dart';
import '../../../widgets/common/game_shell.dart';
import 'widgets/word_preview_card.dart';

const _kFilters = ['all', 'verb', 'noun', 'adjective'];
const _kFilterLabels = {
  'all': 'Tất cả',
  'verb': 'Động từ',
  'noun': 'Danh từ',
  'adjective': 'Tính từ',
};
const _kStartLimit = 10;

/// `/games/sentence-builder/preview` — word list preview trước khi vào
/// phiên chơi. Mirrors web `word-preview-page.tsx`. Nguồn:
/// `GET /sentence-builder/topics/:id/words` (đã live, xem contract matrix).
///
/// Web bypasses this screen entirely when `topicId === 'random'` (điều hướng
/// thẳng tới `/play`); [SentenceBuilderTopicsScreen] giữ nguyên hành vi đó
/// và chỉ điều hướng vào đây khi người dùng chọn 1 topic cụ thể.
class SentenceBuilderPreviewScreen extends ConsumerStatefulWidget {
  const SentenceBuilderPreviewScreen({
    super.key,
    required this.level,
    required this.topicId,
  });

  final String level;
  final String topicId;

  @override
  ConsumerState<SentenceBuilderPreviewScreen> createState() =>
      _SentenceBuilderPreviewScreenState();
}

class _SentenceBuilderPreviewScreenState
    extends ConsumerState<SentenceBuilderPreviewScreen> {
  String _filter = 'all';
  final Set<String> _expanded = {};

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(
      sentenceBuilderTopicWordsProvider((widget.topicId, widget.level)),
    );

    return GameShell(
      title: 'Xem trước từ vựng',
      exitGuard: false,
      scrollable: false,
      child: async.when(
        loading: () => const LoadingView(),
        error: (_, _) => ErrorView(
          message: 'Không tìm thấy chủ đề.',
          onRetry: () => ref.invalidate(
            sentenceBuilderTopicWordsProvider((widget.topicId, widget.level)),
          ),
        ),
        data: _buildContent,
      ),
    );
  }

  Widget _buildContent(SentenceBuilderTopicWordsResponse data) {
    final filtered = _filter == 'all'
        ? data.words
        : data.words.where((w) => w.wordType == _filter).toList();
    final startCount = filtered.length < _kStartLimit
        ? filtered.length
        : _kStartLimit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.topic.label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        Text(
          data.topic.labelVi,
          style: TextStyle(color: context.tokens.mutedForeground),
        ),
        const SizedBox(height: 12),
        _StatsCard(stats: data.stats),
        const SizedBox(height: 12),
        _FilterRow(
          stats: data.stats,
          selected: _filter,
          onSelected: (f) => setState(() => _filter = f),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.separated(
            key: const Key('sentence-builder-preview-list'),
            padding: const EdgeInsets.only(bottom: 90),
            itemCount: filtered.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final word = filtered[index];
              return WordPreviewCard(
                word: word,
                isExpanded: _expanded.contains(word.id),
                onToggle: () => setState(() {
                  if (!_expanded.remove(word.id)) _expanded.add(word.id);
                }),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              key: const Key('sentence-builder-preview-start'),
              onPressed: () => context.pushReplacement(
                Uri(
                  path: '/games/sentence-builder/play',
                  queryParameters: {
                    'level': widget.level,
                    'topicId': widget.topicId,
                  },
                ).toString(),
              ),
              icon: Icon(AppPhosphorIcons.play),
              label: Text('Bắt đầu luyện tập ($startCount từ)'),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.stats});

  final SentenceBuilderWordStats stats;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(tokens.radius),
        border: Border.all(color: tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(AppPhosphorIcons.bookOpen, size: 20, color: tokens.primary),
              const SizedBox(width: 8),
              Text(
                '${stats.totalWords} từ quan trọng',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              if (stats.essentialWords > 0) ...[
                Icon(
                  AppPhosphorIcons.sparkle,
                  size: 16,
                  color: Colors.amber.shade700,
                ),
                const SizedBox(width: 4),
                Text(
                  '${stats.essentialWords} thiết yếu',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.amber.shade700,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _WordTypeStat(
                  value: stats.verbs,
                  label: 'Động từ',
                  color: const Color(0xFF1D4ED8),
                  bg: const Color(0xFFDCEBFF),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _WordTypeStat(
                  value: stats.nouns,
                  label: 'Danh từ',
                  color: const Color(0xFF15803D),
                  bg: const Color(0xFFDCF6E3),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _WordTypeStat(
                  value: stats.adjectives,
                  label: 'Tính từ',
                  color: const Color(0xFF7C3AED),
                  bg: const Color(0xFFEEE1FB),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WordTypeStat extends StatelessWidget {
  const _WordTypeStat({
    required this.value,
    required this.label,
    required this.color,
    required this.bg,
  });

  final int value;
  final String label;
  final Color color;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(label, style: TextStyle(fontSize: 11, color: color)),
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.stats,
    required this.selected,
    required this.onSelected,
  });

  final SentenceBuilderWordStats stats;
  final String selected;
  final ValueChanged<String> onSelected;

  int _countFor(String key) => switch (key) {
    'verb' => stats.verbs,
    'noun' => stats.nouns,
    'adjective' => stats.adjectives,
    _ => stats.totalWords,
  };

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _kFilters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final key = _kFilters[index];
          final isSelected = key == selected;
          return GestureDetector(
            onTap: () => onSelected(key),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          tokens.primary,
                          Color.lerp(tokens.primary, Colors.black, 0.2)!,
                        ],
                      )
                    : null,
                color: isSelected ? null : tokens.muted,
                borderRadius: BorderRadius.circular(999),
              ),
              alignment: Alignment.center,
              child: Text(
                '${_kFilterLabels[key]} (${_countFor(key)})',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? tokens.primaryForeground : tokens.foreground,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
