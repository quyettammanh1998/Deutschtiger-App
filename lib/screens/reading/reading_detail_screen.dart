import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/repositories/reading/reading_repository.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import '../../core/design_tokens.dart';
import '../../core/theme/app_tokens.dart';
import '../../data/reading/reading_models.dart';
import '../../shared/widgets/word_lookup_sheet.dart';
import 'widgets/reading_detail_widgets.dart';
import 'widgets/save_article_words_cta.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

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
/// Mirror `reading-detail-page.tsx`: level pill + "Đã đọc" → tiêu đề tappable
/// → nút dịch sky-blue inline + gợi ý chạm từ → audio → thân bài (tap từ →
/// WordLookupSheet) → glossary → save-words CTA → nút đánh dấu đã đọc.
///
/// Deviation: web gate hoàn thành theo bài tập trắc nghiệm cuối bài
/// (`ReadingExercises`, nguồn `GET /reading/articles/{level}/{slug}/exercises`).
/// Route đó KHÔNG tồn tại trên backend hiện tại (chỉ có List/Levels/Topics/
/// Get/GetBySlug/Audio — xem `reading_handler.go`); theo nguyên tắc "contract
/// trước code" không dựng UI gọi endpoint chưa có thật. Giữ nguyên nút đánh
/// dấu đã đọc thủ công (nhánh "không có exercises" của web) cho MỌI bài.
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
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final articleAsync = ref.watch(readingArticleProvider(_key));
    final completedIdsAsync = ref.watch(readingCompletedIdsProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: articleAsync.when(
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
            final resolvableIds =
                article.glossaryItems.map((g) => g.learningItemId).toList();

            return ListView(
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
              children: [
                Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                      onTap: () => Navigator.of(context).maybePop(),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: tokens.card,
                          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                          border: Border.all(color: tokens.border),
                        ),
                        child: Icon(PhosphorIcons.caretLeft, size: 18, color: tokens.mutedForeground),
                      ),
                    ),
                    const SizedBox(width: DesignTokens.spacingSm),
                    Icon(PhosphorIcons.bookOpen, size: 18, color: tokens.mutedForeground),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        l10n.readingHubTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: tokens.mutedForeground,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DesignTokens.spacingMd),
                Wrap(
                  spacing: DesignTokens.spacingSm,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: tokens.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        article.level,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: tokens.primary),
                      ),
                    ),
                    if (isDone)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(PhosphorIcons.checkCircle, size: 16, color: Color(0xFF059669)),
                          const SizedBox(width: 4),
                          Text(l10n.readingDoneChip, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF059669))),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: DesignTokens.spacingSm),
                Text(
                  widget.title ?? article.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, height: 1.2, color: tokens.foreground),
                ),
                const SizedBox(height: DesignTokens.spacingMd),
                Wrap(
                  spacing: DesignTokens.spacingSm,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => setState(() => _showTranslation = !_showTranslation),
                      icon: Icon(_showTranslation ? PhosphorIcons.eyeSlash : PhosphorIcons.translate, size: 16),
                      label: Text(_showTranslation ? l10n.examHideTranslation : l10n.readingShowTranslation),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _showTranslation ? Colors.white : const Color(0xFF0369A1),
                        backgroundColor: _showTranslation ? const Color(0xFF0284C7) : const Color(0xFFF0F9FF),
                        side: BorderSide(color: _showTranslation ? const Color(0xFF0284C7) : const Color(0xFF7DD3FC)),
                      ),
                    ),
                    Text(
                      l10n.readingTapWordHint,
                      style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                    ),
                  ],
                ),
                if (audioUrl != null) ...[
                  const SizedBox(height: DesignTokens.spacingMd),
                  _ReadingAudioLink(audioUrl: audioUrl),
                ],
                const SizedBox(height: DesignTokens.spacingMd),
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
                if (resolvableIds.isNotEmpty) ...[
                  const SizedBox(height: DesignTokens.spacingMd),
                  SaveArticleWordsCta(
                    resolvableIds: resolvableIds,
                    totalWords: article.glossary.length,
                    source: 'reading',
                  ),
                ],
                const SizedBox(height: DesignTokens.spacingMd),
                _MarkCompleteButton(
                  isDone: isDone,
                  isBusy: _marking,
                  onPressed: () => _onMarkComplete(article),
                ),
                const SizedBox(height: DesignTokens.spacingXl),
              ],
            );
          },
        ),
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
          SnackBar(content: Text(AppLocalizations.of(context).readingSaveProgressError)),
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
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        border: Border.all(color: tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).readingGlossaryTitle,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: tokens.foreground),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          for (final entry in entries)
            Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.spacingXs),
              child: Text(
                entry,
                style: TextStyle(color: tokens.mutedForeground, height: 1.5, fontSize: 13),
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
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: isDone || isBusy ? null : onPressed,
        icon: Icon(isDone ? PhosphorIcons.checkCircle : PhosphorIcons.checkCircle),
        label: Text(
          isBusy ? l10n.saving : (isDone ? l10n.readingDoneChip : l10n.readingMarkComplete),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: isDone ? const Color(0xFF059669) : DesignTokens.tigerOrange,
        ),
      ),
    );
  }
}
