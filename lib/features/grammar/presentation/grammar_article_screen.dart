import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/widgets/common/app_card.dart';
import 'package:deutschtiger/widgets/common/app_markdown_view.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/back_button.dart';
import 'grammar_level_widgets.dart';
import 'grammar_provider.dart';

/// Bài đọc ngữ pháp dài (markdown tĩnh, `data/grammar/articles/{level}/{slug}.md`)
/// — web parity `grammar-article-page.tsx`: level pill, "Nguồn: deutsch.vn",
/// full markdown (tables/blockquote/inline-code/images/audio via
/// [AppMarkdownView]), footer gradient complete CTA.
class GrammarArticleScreen extends ConsumerStatefulWidget {
  const GrammarArticleScreen({
    super.key,
    required this.level,
    required this.slug,
  });
  final String level;
  final String slug;

  @override
  ConsumerState<GrammarArticleScreen> createState() =>
      _GrammarArticleScreenState();
}

class _GrammarArticleScreenState extends ConsumerState<GrammarArticleScreen> {
  bool _marking = false;
  bool _justCompleted = false;

  @override
  Widget build(BuildContext context) {
    final key = (level: widget.level, slug: widget.slug);
    final articleAsync = ref.watch(grammarArticleProvider(key));
    final completedAsync = ref.watch(grammarCompletedIdsProvider);
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final progressId = 'article:${widget.slug}';

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: articleAsync.when(
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(
            message: l10n.grammarArticleNotFound,
            onRetry: () => ref.invalidate(grammarArticleProvider(key)),
          ),
          data: (article) {
            if (article == null) {
              return Center(child: Text(l10n.grammarArticleNotFound));
            }
            final completed = Set<String>.from(
              completedAsync.value ?? const [],
            );
            final alreadyDone = completed.contains(progressId);
            final isCompleted = _justCompleted || alreadyDone;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                GrammarLevelBadge(level: article.level),
                const SizedBox(height: 8),
                Row(
                  children: [
                    AppBackButton(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        article.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (article.source != null) ...[
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () => launchUrl(Uri.parse(article.source!)),
                    child: Text(
                      l10n.grammarArticleSource,
                      style: TextStyle(
                        fontSize: 11,
                        color: tokens.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                AppCard.card(
                  padding: const EdgeInsets.all(16),
                  child: AppMarkdownView(article.markdown),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: Icon(
                        Icons.arrow_back,
                        size: 16,
                        color: tokens.mutedForeground,
                      ),
                      label: Text(
                        l10n.back,
                        style: TextStyle(
                          color: tokens.mutedForeground,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const Spacer(),
                    _CompleteChip(
                      completed: isCompleted,
                      marking: _marking,
                      onPressed: isCompleted
                          ? null
                          : () => _handleComplete(progressId, article.level),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleComplete(String lessonId, String level) async {
    setState(() => _marking = true);
    try {
      await markGrammarComplete(ref, lessonId: lessonId, level: level);
      if (mounted) setState(() => _justCompleted = true);
    } catch (_) {
      // Best-effort — người dùng có thể bấm lại.
    } finally {
      if (mounted) setState(() => _marking = false);
    }
  }
}

class _CompleteChip extends StatelessWidget {
  const _CompleteChip({
    required this.completed,
    required this.marking,
    required this.onPressed,
  });
  final bool completed;
  final bool marking;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final radius = BorderRadius.circular(12);

    final decoration = completed
        ? BoxDecoration(
            color: tokens.success.withValues(alpha: 0.15),
            borderRadius: radius,
          )
        : BoxDecoration(
            gradient: LinearGradient(
              colors: [
                tokens.primary,
                Color.lerp(tokens.primary, Colors.black, 0.2)!,
              ],
            ),
            borderRadius: radius,
          );

    return Opacity(
      opacity: marking ? 0.6 : 1,
      child: DecoratedBox(
        decoration: decoration,
        child: Material(
          color: Colors.transparent,
          borderRadius: radius,
          child: InkWell(
            borderRadius: radius,
            onTap: marking ? null : onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check,
                    size: 16,
                    color: completed ? tokens.success : Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    completed
                        ? l10n.grammarCompleted
                        : l10n.grammarMarkComplete,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: completed ? tokens.success : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
