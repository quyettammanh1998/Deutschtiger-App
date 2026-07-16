import 'package:flutter/material.dart';

import 'package:deutschtiger/l10n/app_localizations.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/grammar/grammar_models.dart';
import '../../../widgets/common/app_markdown_view.dart';

/// Render 1 [GrammarContentBlock] theo đúng loại — web parity
/// `grammar-lesson-page.tsx` `renderContentBlock`/`renderTextBlock`: HTML
/// block (AI-generated lessons) → stripped-tag fallback (no HTML renderer
/// dependency available, see note below); formula/markdown block →
/// [AppMarkdownView]; plain text → German-line highlight; table/list/
/// exercises/image render directly.
Widget buildGrammarContentBlock(
  BuildContext context,
  GrammarContentBlock block,
) {
  return switch (block) {
    GrammarTextBlock(:final text) => _TextBlock(text: text),
    GrammarListBlock(:final items) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• '),
                  Expanded(child: Text(item)),
                ],
              ),
            ),
          )
          .toList(),
    ),
    GrammarTableBlock(:final rows) => _GrammarTable(rows: rows),
    GrammarExercisesBlock(:final exercises) => _ExercisesSection(
      exercises: exercises,
    ),
    GrammarImageBlock(:final image, :final alt) => ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        image,
        semanticLabel: alt,
        errorBuilder: (_, _, _) => const SizedBox.shrink(),
      ),
    ),
    GrammarUnknownBlock() => const SizedBox.shrink(),
  };
}

final RegExp _htmlBlockRe = RegExp(
  r'^<(p|ul|ol|h[1-6]|div|blockquote|span)\b',
  caseSensitive: false,
);
final RegExp _htmlTagRe = RegExp(r'<[^>]+>');
final RegExp _formulaRe = RegExp(
  r'^\*\*(Công thức|Cấu trúc|Cú pháp|Lưu ý|Ghi nhớ|Quy tắc|Ví dụ mẫu)[:\s]',
  caseSensitive: false,
);
final RegExp _hasMarkdownRe = RegExp(r'\*\*|__|\*[^*]|#{1,6} ');
final RegExp _germanMarkersRe = RegExp(
  r'(ä|ö|ü|ß|\b(ich|du|er|sie|wir|ihr|nicht|und|der|die|das|ein|eine|ist|sind|hat|haben|weil|mit|für|nach|vor|zu|im|am|den|dem|dass|wie|als)\b)',
  caseSensitive: false,
);
final RegExp _hasLetterRe = RegExp('[A-Za-z]');

bool _isGermanLine(String text) =>
    _germanMarkersRe.hasMatch(text) && _hasLetterRe.hasMatch(text);

/// Chọn cách render 1 text block — port `renderTextBlock` bên web.
class _TextBlock extends StatelessWidget {
  const _TextBlock({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return const SizedBox.shrink();

    // HTML content (AI-generated lessons) — no safe HTML renderer dependency
    // available; degrade to stripped-tag plain text rather than adding a
    // new package outside contract-before-code scope.
    if (_htmlBlockRe.hasMatch(trimmed)) {
      final stripped = trimmed.replaceAll(_htmlTagRe, ' ').trim();
      return Text(stripped, style: const TextStyle(height: 1.5, fontSize: 14));
    }

    // Formula / key-rule block — highlighted box.
    if (_formulaRe.hasMatch(trimmed) && _hasMarkdownRe.hasMatch(trimmed)) {
      final tokens = context.tokens;
      return DecoratedBox(
        decoration: BoxDecoration(
          color: tokens.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: tokens.primary.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: AppMarkdownView(trimmed, dense: true),
        ),
      );
    }

    // Markdown content (scraped articles with headings/bold).
    if (_hasMarkdownRe.hasMatch(trimmed)) {
      return AppMarkdownView(trimmed, dense: true);
    }

    // Plain text — highlight German sentences.
    final lines = trimmed
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: lines.map((line) {
        final german = _isGermanLine(line);
        final tokens = context.tokens;
        final content = Text(
          line,
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            fontWeight: german ? FontWeight.w500 : FontWeight.normal,
            color: german ? const Color(0xFF0C4A6E) : tokens.foreground,
          ),
        );
        if (!german) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: content,
          );
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: content,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _GrammarTable extends StatelessWidget {
  const _GrammarTable({required this.rows});
  final List<List<String>> rows;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const SizedBox.shrink();
    final tokens = context.tokens;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          border: TableBorder.all(color: tokens.border),
          children: rows
              .map(
                (row) => TableRow(
                  children: row
                      .map(
                        (cell) => Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            cell,
                            style: TextStyle(color: tokens.foreground),
                          ),
                        ),
                      )
                      .toList(),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

/// Khối "Bài tập luyện tập" — web: divider + emerald pill giữa.
class _ExercisesSection extends StatelessWidget {
  const _ExercisesSection({required this.exercises});
  final List<GrammarExercise> exercises;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: tokens.border)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: tokens.success.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 3,
                  ),
                  child: Text(
                    l10n.grammarPracticeExercises,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: tokens.success,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(child: Divider(color: tokens.border)),
          ],
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < exercises.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ExerciseTile(index: i, exercise: exercises[i]),
          ),
      ],
    );
  }
}

/// 1 câu trắc nghiệm — chọn đáp án, chấm ngay tại chỗ. Đáp án sai được tạo từ
/// [answer] gốc (biến đổi đuôi từ đơn giản) khi backend không có `options`.
class _ExerciseTile extends StatefulWidget {
  const _ExerciseTile({required this.index, required this.exercise});
  final int index;
  final GrammarExercise exercise;

  @override
  State<_ExerciseTile> createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<_ExerciseTile> {
  String? _selected;

  List<String> get _options {
    final correct = widget.exercise.answer.trim();
    final options = <String>{correct};
    if (correct.length > 2) {
      options.add('${correct}en');
      options.add(correct.substring(0, correct.length - 1));
    }
    final list = options.toList()..shuffle();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final correct = widget.exercise.answer.trim();
    final answered = _selected != null;
    final isCorrect = _selected == correct;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.card,
        border: Border.all(color: tokens.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: tokens.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${widget.index + 1}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: tokens.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.exercise.question,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: tokens.foreground,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _options.map((opt) {
                final isSelected = _selected == opt;
                Color background = tokens.muted;
                Color foreground = tokens.foreground;
                Color border = tokens.border;
                if (answered) {
                  if (opt == correct) {
                    background = tokens.success.withValues(alpha: 0.12);
                    foreground = tokens.success;
                    border = tokens.success;
                  } else if (isSelected) {
                    background = Colors.red.withValues(alpha: 0.1);
                    foreground = Colors.red.shade700;
                    border = Colors.red.shade300;
                  } else {
                    background = tokens.muted.withValues(alpha: 0.4);
                    foreground = tokens.mutedForeground;
                    border = tokens.border.withValues(alpha: 0.4);
                  }
                }
                return Material(
                  color: background,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: answered
                        ? null
                        : () => setState(() => _selected = opt),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: border),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        opt,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: foreground,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            if (answered) ...[
              const SizedBox(height: 8),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: (isCorrect ? tokens.success : Colors.red).withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 12,
                        color: isCorrect ? tokens.success : Colors.red.shade700,
                      ),
                      children: [
                        TextSpan(
                          text: isCorrect
                              ? l10n.grammarExerciseCorrect
                              : '${l10n.grammarExerciseWrong(correct)} ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (!isCorrect && widget.exercise.explanation != null)
                          TextSpan(text: widget.exercise.explanation),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
