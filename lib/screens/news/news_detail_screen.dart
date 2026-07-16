import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/repositories/news/news_repository.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import '../../core/design_tokens.dart';
import '../../data/news/news_models.dart';
import '../../shared/widgets/word_lookup_sheet.dart';
import '../reading/widgets/save_article_words_cta.dart';
import 'news_list_screen.dart' show newsCompletedIdsProvider;
import 'widgets/news_cards.dart' show newsTopicVi;
import 'widgets/news_detail_widgets.dart';
import 'widgets/news_quiz.dart';

/// Provider: tất cả level của bài sở hữu `slug`, nguồn
/// `GET /news/story-by-slug/{slug}`.
final newsStoryProvider = FutureProvider.autoDispose.family<
    List<NewsLevelArticle>, String>((ref, slug) {
  return ref.watch(newsRepositoryProvider).fetchStoryBySlug(slug);
});

/// News Detail — đọc 1 bài ở 1 CEFR level, chuyển level qua segmented control,
/// tap từ mở word-lookup sheet, quiz cuối bài ghi tiến độ khi đạt ≥60%.
class NewsDetailScreen extends ConsumerStatefulWidget {
  const NewsDetailScreen({super.key, required this.slug, this.initialLevel});

  final String slug;
  final String? initialLevel;

  @override
  ConsumerState<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends ConsumerState<NewsDetailScreen> {
  String? _selectedLevel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final storyAsync = ref.watch(newsStoryProvider(widget.slug));

    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(
        title: Text(l10n.newsHeaderTitle),
        backgroundColor: DesignTokens.background,
      ),
      body: storyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(
          onRetry: () => ref.invalidate(newsStoryProvider(widget.slug)),
        ),
        data: (levels) {
          if (levels.isEmpty) {
            return ErrorView(message: l10n.newsStoryNotFound);
          }
          final resolvedLevel =
              _selectedLevel ?? widget.initialLevel ?? levels.first.level;
          final article = levels.firstWhere(
            (l) => l.level == resolvedLevel,
            orElse: () => levels.first,
          );

          return ListView(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            children: [
              if (levels.length > 1) ...[
                Text(
                  l10n.newsChooseLevelLabel,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                const SizedBox(height: DesignTokens.spacingSm),
                NewsLevelSwitcher(
                  levels: levels.map((l) => l.level).toList(),
                  active: article.level,
                  onChanged: (level) =>
                      setState(() => _selectedLevel = level),
                ),
                Container(
                  margin: const EdgeInsets.only(top: DesignTokens.spacingSm + 2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingSm,
                    vertical: DesignTokens.spacingSm,
                  ),
                  decoration: BoxDecoration(
                    color: DesignTokens.tigerOrange.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(
                        fontSize: 12,
                        color: DesignTokens.mutedForeground,
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(text: l10n.newsOtherLevelsPrefix),
                        TextSpan(
                          text: levels
                              .where((l) => l.level != article.level)
                              .map((l) => l.level)
                              .join(' · '),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: DesignTokens.tigerOrange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingMd),
              ],
              Wrap(
                spacing: DesignTokens.spacingSm,
                children: [
                  _Badge(label: newsTopicVi(article.topic)),
                  _Badge(label: article.level, emphasis: true),
                ],
              ),
              const SizedBox(height: DesignTokens.spacingSm),
              Text(
                article.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if ((article.titleVi ?? '').isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    article.titleVi!,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                ),
              if (article.imageUrl != null) ...[
                const SizedBox(height: DesignTokens.spacingSm),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 448),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(DesignTokens.radius),
                      child: Image.network(
                        article.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
              ],
              if (article.publishedAt != null || article.attribution != null)
                Padding(
                  padding: const EdgeInsets.only(top: DesignTokens.spacingSm),
                  child: _SourceLine(article: article),
                ),
              const SizedBox(height: DesignTokens.spacingMd),
              if (article.audioUrl != null)
                NewsAudioBar(
                  audioUrl: article.audioUrl!,
                  audioUrlSlow: article.audioUrlSlow,
                ),
              if (article.sentences.isNotEmpty)
                NewsSentenceReader(
                  sentences: article.sentences,
                  onWordTap: (word) => showWordLookupSheet(context, word: word),
                )
              else
                for (final paragraph in article.paragraphs)
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: DesignTokens.spacingSm,
                    ),
                    child: Text(
                      paragraph,
                      style: const TextStyle(fontSize: 16, height: 1.6),
                    ),
                  ),
              const SizedBox(height: DesignTokens.spacingMd),
              if (article.quiz.isNotEmpty) ...[
                NewsQuizCard(
                  quiz: article.quiz,
                  onPass: (scorePct) => _onQuizPass(article, scorePct),
                ),
                const SizedBox(height: DesignTokens.spacingMd),
              ],
              if (article.examSpeakingPrompt != null ||
                  article.examWritingPrompt != null) ...[
                NewsExamPromptsCard(
                  speakingPrompt: article.examSpeakingPrompt,
                  writingPrompt: article.examWritingPrompt,
                ),
                const SizedBox(height: DesignTokens.spacingMd),
              ],
              if (article.vocab.isNotEmpty)
                NewsVocabList(vocab: article.vocab),
              if (article.vocab.any((v) => v.learningItemId != null)) ...[
                const SizedBox(height: DesignTokens.spacingMd),
                SaveArticleWordsCta(
                  resolvableIds: article.vocab
                      .where((v) => v.learningItemId != null)
                      .map((v) => v.learningItemId!)
                      .toList(),
                  totalWords: article.vocab.length,
                  source: 'news',
                ),
              ],
              const SizedBox(height: DesignTokens.spacingXl),
            ],
          );
        },
      ),
    );
  }

  Future<void> _onQuizPass(NewsLevelArticle article, int scorePct) async {
    await ref
        .read(newsRepositoryProvider)
        .markComplete(storyGroupId: article.storyGroupId, scorePct: scorePct);
    ref.invalidate(newsCompletedIdsProvider);
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, this.emphasis = false});
  final String label;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: emphasis
            ? DesignTokens.tigerOrange.withValues(alpha: 0.12)
            : DesignTokens.orange100,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: emphasis ? DesignTokens.tigerOrange : DesignTokens.orange500,
        ),
      ),
    );
  }
}

class _SourceLine extends StatelessWidget {
  const _SourceLine({required this.article});
  final NewsLevelArticle article;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (article.publishedAt != null)
          Text(
            _formatDate(context, article.publishedAt!),
            style: const TextStyle(
              fontSize: 12,
              color: DesignTokens.mutedForeground,
            ),
          ),
        if (article.publishedAt != null && article.attribution != null)
          const Text(' · ', style: TextStyle(color: DesignTokens.mutedForeground)),
        if (article.attribution != null)
          GestureDetector(
            onTap: article.sourceUrl == null
                ? null
                : () => launchUrl(
                      Uri.parse(article.sourceUrl!),
                      mode: LaunchMode.externalApplication,
                    ),
            child: Text(
              article.attribution!,
              style: TextStyle(
                fontSize: 12,
                color: DesignTokens.mutedForeground,
                decoration: article.sourceUrl != null
                    ? TextDecoration.underline
                    : null,
              ),
            ),
          ),
      ],
    );
  }

  String _formatDate(BuildContext context, String iso) {
    final date = DateTime.tryParse(iso);
    if (date == null) return '';
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final startOfDay = DateTime(date.year, date.month, date.day);
    final startOfToday = DateTime(now.year, now.month, now.day);
    final diffDays = startOfToday.difference(startOfDay).inDays;
    if (diffDays == 0) return l10n.today;
    if (diffDays == 1) return l10n.yesterday;
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
