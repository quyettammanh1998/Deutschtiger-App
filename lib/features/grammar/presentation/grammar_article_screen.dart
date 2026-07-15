import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import '../../../core/theme/app_colors.dart';
import 'grammar_provider.dart';

/// Bài đọc ngữ pháp dài (markdown tĩnh, `data/grammar/articles/{level}/{slug}.md`).
/// Không có bộ render markdown đầy đủ trong app (chưa có dependency) nên hiển
/// thị dạng rút gọn: heading/bullet nhận diện bằng regex, còn lại là văn bản
/// thường — đủ đọc được, không mất nội dung.
class GrammarArticleScreen extends ConsumerStatefulWidget {
  const GrammarArticleScreen({super.key, required this.level, required this.slug});
  final String level;
  final String slug;

  @override
  ConsumerState<GrammarArticleScreen> createState() => _GrammarArticleScreenState();
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
    final progressId = 'article:${widget.slug}';

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: Text(l10n.grammar),
      ),
      body: articleAsync.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          message: l10n.grammarArticleNotFound,
          onRetry: () => ref.invalidate(grammarArticleProvider(key)),
        ),
        data: (article) {
          if (article == null) {
            return Center(child: Text(l10n.grammarArticleNotFound));
          }
          final completed = Set<String>.from(completedAsync.value ?? const []);
          final alreadyDone = completed.contains(progressId);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                article.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _MarkdownText(article.markdown),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: (_justCompleted || alreadyDone || _marking)
                      ? null
                      : () => _handleComplete(progressId, article.level),
                  child: Text(
                    _justCompleted || alreadyDone
                        ? l10n.grammarCompleted
                        : l10n.grammarMarkComplete,
                  ),
                ),
              ),
            ],
          );
        },
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

/// Renderer markdown tối giản: heading `#`/`##`, bullet `-`/`*`, còn lại là
/// đoạn văn thường. Không xử lý bảng/inline code — đủ cho nội dung bài đọc.
class _MarkdownText extends StatelessWidget {
  const _MarkdownText(this.markdown);
  final String markdown;

  @override
  Widget build(BuildContext context) {
    final lines = markdown.split('\n');
    final children = <Widget>[];
    for (final rawLine in lines) {
      final line = rawLine.trim();
      if (line.isEmpty) continue;
      if (line.startsWith('## ')) {
        children.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            line.substring(3),
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ));
      } else if (line.startsWith('# ')) {
        children.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            line.substring(2),
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ));
      } else if (line.startsWith('- ') || line.startsWith('* ')) {
        children.add(Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• '),
              Expanded(child: Text(line.substring(2))),
            ],
          ),
        ));
      } else {
        children.add(Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(line, style: const TextStyle(height: 1.5)),
        ));
      }
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }
}
