import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_tokens.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../repositories/reading/reading_repository.dart';

/// Nút "lưu từ vựng cuối bài" dùng chung cho reading + news — mirror web
/// `SaveArticleWordsCta`. Chỉ những từ đã match được `learning_item_id`
/// (glossary/vocab đã resolve sẵn ở backend) mới lưu được; số còn lại chỉ
/// tính vào tổng "N/M" cho người dùng biết, không gửi lên server.
class SaveArticleWordsCta extends ConsumerStatefulWidget {
  const SaveArticleWordsCta({
    super.key,
    required this.resolvableIds,
    required this.totalWords,
    required this.source,
  });

  /// `learning_item_id` của các từ có thể lưu.
  final List<String> resolvableIds;

  /// Tổng số từ trong glossary/vocab (kể cả chưa resolve) — cho label "N/M".
  final int totalWords;

  final String source;

  @override
  ConsumerState<SaveArticleWordsCta> createState() => _SaveArticleWordsCtaState();
}

class _SaveArticleWordsCtaState extends ConsumerState<SaveArticleWordsCta> {
  bool _saving = false;
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    if (widget.resolvableIds.isEmpty) return const SizedBox.shrink();
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);

    if (_saved) {
      return SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: () => context.push('/daily-review'),
          style: FilledButton.styleFrom(backgroundColor: const Color(0xFF059669)),
          child: Text(l10n.saveWordsCtaDone),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton(
          onPressed: _saving ? null : _save,
          style: FilledButton.styleFrom(backgroundColor: tokens.primary),
          child: Text(
            _saving ? l10n.saving : l10n.saveWordsCtaSave(widget.resolvableIds.length),
          ),
        ),
        if (widget.resolvableIds.length < widget.totalWords)
          Padding(
            padding: const EdgeInsets.only(top: DesignTokens.spacingXs),
            child: Text(
              l10n.saveWordsCtaResolvedCount(widget.resolvableIds.length, widget.totalWords),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
            ),
          ),
      ],
    );
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(readingRepositoryProvider)
          .saveWordsBatch(widget.resolvableIds, widget.source);
      if (mounted) setState(() => _saved = true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).saveWordsCtaError)),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
