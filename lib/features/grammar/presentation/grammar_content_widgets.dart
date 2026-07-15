import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/grammar/grammar_models.dart';

/// Render 1 [GrammarContentBlock] theo đúng loại (text/list/table/exercises/
/// image). Block không nhận dạng được → widget rỗng, không throw.
Widget buildGrammarContentBlock(BuildContext context, GrammarContentBlock block) {
  return switch (block) {
    GrammarTextBlock(:final text) => Text(text, style: const TextStyle(height: 1.5)),
    GrammarListBlock(:final items) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• '),
                    Expanded(child: Text(item)),
                  ],
                ),
              ))
          .toList(),
    ),
    GrammarTableBlock(:final rows) => _GrammarTable(rows: rows),
    GrammarExercisesBlock(:final exercises) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < exercises.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ExerciseTile(index: i, exercise: exercises[i]),
          ),
      ],
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

class _GrammarTable extends StatelessWidget {
  const _GrammarTable({required this.rows});
  final List<List<String>> rows;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const SizedBox.shrink();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        border: TableBorder.all(color: AppColors.border),
        children: rows
            .map(
              (row) => TableRow(
                children: row
                    .map(
                      (cell) => Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(cell),
                      ),
                    )
                    .toList(),
              ),
            )
            .toList(),
      ),
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
    // Biến thể đơn giản khi thiếu options thật từ backend.
    if (correct.length > 2) {
      options.add('${correct}en');
      options.add(correct.substring(0, correct.length - 1));
    }
    final list = options.toList()..shuffle();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final correct = widget.exercise.answer.trim();
    final answered = _selected != null;
    final isCorrect = _selected == correct;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.index + 1}. ${widget.exercise.question}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _options.map((opt) {
              final isSelected = _selected == opt;
              Color? color;
              if (answered) {
                if (opt == correct) {
                  color = AppColors.success;
                } else if (isSelected) {
                  color = Colors.red;
                }
              }
              return ChoiceChip(
                label: Text(opt),
                selected: isSelected,
                selectedColor: color?.withValues(alpha: 0.2),
                onSelected: answered ? null : (_) => setState(() => _selected = opt),
              );
            }).toList(),
          ),
          if (answered) ...[
            const SizedBox(height: 8),
            Text(
              isCorrect
                  ? '✓ Chính xác!'
                  : '✗ Sai. Đáp án đúng: $correct. ${widget.exercise.explanation ?? ''}',
              style: TextStyle(
                color: isCorrect ? AppColors.success : Colors.red,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
