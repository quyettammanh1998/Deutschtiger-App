import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import 'package:deutschtiger/repositories/reading/reading_repository.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import '../../core/design_tokens.dart';
import '../../data/reading/reading_models.dart';
import '../../shared/widgets/word_lookup_sheet.dart';
import 'widgets/reading_detail_widgets.dart';

/// Key cho [readingArticleProvider] — level + slug xác định duy nhất 1 bài.
typedef ReadingArticleKey = ({String level, String slug});

final readingArticleProvider = FutureProvider.autoDispose
    .family<ReadingArticle, ReadingArticleKey>((ref, key) {
      return ref
          .watch(readingRepositoryProvider)
          .fetchArticle(level: key.level, slug: key.slug);
    });

/// Id các bài đã đọc của user hiện tại (rỗng khi chưa đăng nhập/lỗi mạng).
final readingCompletedIdsProvider = FutureProvider<List<String>>((ref) {
  return ref.watch(readingRepositoryProvider).fetchCompletedIds();
});

/// Reading Detail — nguồn `GET /reading/articles/{level}/{slug}`.
///
/// Hiển thị header, audio player (nếu có `audio_url`), body với
/// TappableSentence (tap 1 từ → WordLookupSheet), toggle bản dịch, glossary,
/// và nút đánh dấu đã đọc (`POST /user/reading-progress`).
class ReadingDetailScreen extends ConsumerStatefulWidget {
  const ReadingDetailScreen({
    super.key,
    required this.level,
    required this.slug,
    this.title,
  });

  final String level;
  final String slug;
  final String? title;

  @override
  ConsumerState<ReadingDetailScreen> createState() =>
      _ReadingDetailScreenState();
}

class _ReadingDetailScreenState extends ConsumerState<ReadingDetailScreen> {
  bool _showTranslation = false;
  bool _marking = false;

  ReadingArticleKey get _key => (level: widget.level, slug: widget.slug);

  @override
  Widget build(BuildContext context) {
    final articleAsync = ref.watch(readingArticleProvider(_key));
    final completedIdsAsync = ref.watch(readingCompletedIdsProvider);

    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(
        title: Text(widget.title ?? 'Đang tải…'),
        actions: [
          IconButton(
            tooltip: _showTranslation ? 'Ẩn bản dịch' : 'Hiện bản dịch',
            icon: Icon(
              _showTranslation ? Icons.translate : Icons.translate_outlined,
            ),
            onPressed: () =>
                setState(() => _showTranslation = !_showTranslation),
          ),
        ],
      ),
      body: articleAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(
          onRetry: () => ref.invalidate(readingArticleProvider(_key)),
        ),
        data: (article) {
          final completedIds = completedIdsAsync.valueOrNull ?? const [];
          final isDone = completedIds.contains(article.id);
          final paragraphs = article.paragraphs;
          final audioUrl = ref
              .read(readingRepositoryProvider)
              .resolveAudioUrl(article.audioUrl);

          return Column(
            children: [
              ReadingHeader(
                titleVi: article.title,
                topic: article.summary,
                level: article.level,
                durationMinutes: (paragraphs.length * 1.2).ceil().clamp(1, 60),
                wordCount: article.body.split(RegExp(r'\s+')).length,
              ),
              if (audioUrl != null)
                _ReadingAudioLink(audioUrl: audioUrl)
              else
                const SizedBox.shrink(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(DesignTokens.spacingMd),
                  children: [
                    for (final paragraph in paragraphs)
                      ReadingParagraphView(
                        paragraph: paragraph,
                        showTranslation: _showTranslation,
                        onWordTap: (word) => _onWordTap(context, word),
                      ),
                    if (article.glossary.isNotEmpty) ...[
                      const SizedBox(height: DesignTokens.spacingSm),
                      _GlossaryCard(entries: article.glossary),
                    ],
                    const SizedBox(height: DesignTokens.spacingMd),
                    _MarkCompleteButton(
                      isDone: isDone,
                      isBusy: _marking,
                      onPressed: () => _onMarkComplete(article),
                    ),
                    const SizedBox(height: DesignTokens.spacingXl),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _onMarkComplete(ReadingArticle article) async {
    if (_marking) return;
    setState(() => _marking = true);
    try {
      await ref
          .read(readingRepositoryProvider)
          .markComplete(articleId: article.id, level: article.level);
      ref.invalidate(readingCompletedIdsProvider);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể lưu tiến độ, thử lại sau.')),
        );
      }
    } finally {
      if (mounted) setState(() => _marking = false);
    }
  }

  Future<void> _onWordTap(BuildContext context, String word) async {
    await showWordLookupSheet(context, word: word);
  }
}

/// Phát audio bài đọc (`GET /reading/audio/{level}/{file}`) qua `just_audio`.
/// Tách stateful player khỏi [ReadingAudioBar] (UI-only) để widget kia vẫn
/// tái sử dụng được không phụ thuộc audio backend cụ thể.
class _ReadingAudioLink extends StatefulWidget {
  const _ReadingAudioLink({required this.audioUrl});
  final String audioUrl;

  @override
  State<_ReadingAudioLink> createState() => _ReadingAudioLinkState();
}

class _ReadingAudioLinkState extends State<_ReadingAudioLink> {
  late final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _loaded = false;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    try {
      if (!_loaded) {
        await _player.setUrl(widget.audioUrl);
        _loaded = true;
      }
      if (_player.playing) {
        await _player.pause();
      } else {
        await _player.play();
      }
      if (mounted) setState(() => _isPlaying = _player.playing);
    } catch (_) {
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: _player.positionStream,
      builder: (context, snapshot) {
        final duration = _player.duration;
        final position = snapshot.data ?? Duration.zero;
        final progress = (duration != null && duration.inMilliseconds > 0)
            ? (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0)
            : 0.0;
        return ReadingAudioBar(
          isPlaying: _isPlaying,
          progress: progress,
          onPlayPause: _togglePlay,
        );
      },
    );
  }
}

class _GlossaryCard extends StatelessWidget {
  const _GlossaryCard({required this.entries});
  final List<String> entries;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: DesignTokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        border: Border.all(color: DesignTokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Từ vựng & giải thích',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: DesignTokens.foreground,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          for (final entry in entries)
            Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.spacingXs),
              child: Text(
                entry,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: DesignTokens.mutedForeground,
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MarkCompleteButton extends StatelessWidget {
  const _MarkCompleteButton({
    required this.isDone,
    required this.isBusy,
    required this.onPressed,
  });

  final bool isDone;
  final bool isBusy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: isDone || isBusy ? null : onPressed,
        icon: Icon(isDone ? Icons.check_circle : Icons.check_circle_outline),
        label: Text(
          isBusy ? 'Đang lưu…' : (isDone ? 'Đã đọc' : 'Đánh dấu đã đọc'),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: isDone ? Colors.green.shade600 : DesignTokens.tigerOrange,
        ),
      ),
    );
  }
}
