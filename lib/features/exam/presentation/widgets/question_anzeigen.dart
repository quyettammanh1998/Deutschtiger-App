// ignore_for_file: prefer_initializing_formals
//
// Anzeigen cards renderer — tái sử dụng MC renderer vì cùng data shape (chọn 1
// option đúng). Tách file riêng để future-proof khi Teil 3 cần layout card grid
// thay vì list dọc.
//
// Lesen Teil 3 ("Anzeigen") có thể kèm 1 ảnh minh họa (`question.imageUrl`,
// map từ BE `image_url`) — render phía trên list option nếu có.

import 'package:flutter/material.dart';

import '../../../../core/design_tokens.dart';
import '../../domain/exam_models.dart';
import 'question_mc.dart';

class QuestionAnzeigen extends StatelessWidget {
  const QuestionAnzeigen({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.sectionLabel,
    required this.selectedOptionId,
    required this.onSelect,
    this.showCorrectness = false,
  });

  final ExamQuestion question;
  final int questionNumber;
  final String sectionLabel;
  final String? selectedOptionId;
  final ValueChanged<String> onSelect;
  final bool showCorrectness;

  @override
  Widget build(BuildContext context) {
    final mc = QuestionMc(
      question: question,
      questionNumber: questionNumber,
      sectionLabel: sectionLabel,
      selectedOptionId: selectedOptionId,
      onSelect: onSelect,
      showCorrectness: showCorrectness,
    );

    if (!question.hasImage) return mc;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(DesignTokens.radius),
            child: Image.network(
              question.imageUrl!,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const _ImagePlaceholder(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) => const _ImagePlaceholder(
                child: Icon(Icons.broken_image_outlined, size: 32, color: Colors.grey),
              ),
            ),
          ),
        ),
        mc,
      ],
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      alignment: Alignment.center,
      color: Colors.grey.shade100,
      child: child,
    );
  }
}