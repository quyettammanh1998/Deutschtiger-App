import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../data/exam/exam_ecosystem_models.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/exam/de_thi_repository.dart';
import '../../view_models/exam/exam_ecosystem_providers.dart';
import '../../widgets/common/async_state_views.dart';

/// Làm đề thi public theo mã đề (`/de-thi/:code`) — public route, không cần
/// đăng nhập, phục vụ deep-link SEO. Đọc + chọn đáp án tại chỗ (không lưu
/// tiến độ — đây là đề tham khảo public, không phải exam attempt có điểm).
class DeThiPracticeScreen extends ConsumerStatefulWidget {
  const DeThiPracticeScreen({super.key, required this.code});
  final String code;

  @override
  ConsumerState<DeThiPracticeScreen> createState() =>
      _DeThiPracticeScreenState();
}

class _DeThiPracticeScreenState extends ConsumerState<DeThiPracticeScreen> {
  final Map<String, String> _selected = {};
  final Set<String> _revealed = {};

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entry = ref.read(deThiRepositoryProvider).findEntry(widget.code);

    if (entry == null) {
      return Scaffold(
        backgroundColor: DesignTokens.background,
        appBar: AppBar(title: Text(l10n.deThiListTitle)),
        body: Center(
          child: Text(
            l10n.deThiNotFound,
            style: const TextStyle(color: DesignTokens.mutedForeground),
          ),
        ),
      );
    }

    final examAsync = ref.watch(deThiExamProvider(entry.dataPath));

    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(title: Text(entry.title)),
      body: examAsync.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          message: l10n.couldNotLoadData,
          onRetry: () => ref.invalidate(deThiExamProvider(entry.dataPath)),
        ),
        data: (exam) => ListView(
          padding: const EdgeInsets.all(DesignTokens.screenHorizontalPadding),
          children: [
            if (entry.disclaimer != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(DesignTokens.spacingSm),
                margin: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
                decoration: BoxDecoration(
                  color: DesignTokens.warning.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                ),
                child: Text(
                  entry.disclaimer!,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            for (final passage in exam.passages)
              _PassageBlock(
                passage: passage,
                selected: _selected,
                revealed: _revealed,
                onSelect: (qId, opt) => setState(() => _selected[qId] = opt),
                onReveal: (qId) => setState(() => _revealed.add(qId)),
              ),
          ],
        ),
      ),
    );
  }
}

class _PassageBlock extends StatelessWidget {
  const _PassageBlock({
    required this.passage,
    required this.selected,
    required this.revealed,
    required this.onSelect,
    required this.onReveal,
  });

  final DeThiPassage passage;
  final Map<String, String> selected;
  final Set<String> revealed;
  final void Function(String questionId, String option) onSelect;
  final void Function(String questionId) onReveal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(passage.title, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: DesignTokens.spacingSm),
          Text(passage.textDe),
          const SizedBox(height: DesignTokens.spacingXs),
          Text(
            passage.textVi,
            style: const TextStyle(color: DesignTokens.mutedForeground),
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          for (final q in passage.questions)
            _QuestionBlock(
              passageId: passage.id,
              question: q,
              selectedOption: selected['${passage.id}-${q.no}'],
              isRevealed: revealed.contains('${passage.id}-${q.no}'),
              onSelect: (opt) => onSelect('${passage.id}-${q.no}', opt),
              onReveal: () => onReveal('${passage.id}-${q.no}'),
            ),
        ],
      ),
    );
  }
}

class _QuestionBlock extends StatelessWidget {
  const _QuestionBlock({
    required this.passageId,
    required this.question,
    required this.selectedOption,
    required this.isRevealed,
    required this.onSelect,
    required this.onReveal,
  });

  final String passageId;
  final DeThiQuestion question;
  final String? selectedOption;
  final bool isRevealed;
  final ValueChanged<String> onSelect;
  final VoidCallback onReveal;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
      padding: const EdgeInsets.all(DesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: DesignTokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        border: Border.all(color: DesignTokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${question.no}. ${question.questionDe}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          for (final key in question.optionsDe.keys)
            RadioListTile<String>(
              contentPadding: EdgeInsets.zero,
              dense: true,
              value: key,
              groupValue: selectedOption,
              title: Text('$key. ${question.optionsDe[key]}'),
              onChanged: (v) => v != null ? onSelect(v) : null,
            ),
          if (!isRevealed)
            TextButton(
              onPressed: onReveal,
              child: Text(l10n.deThiRevealAnswer),
            )
          else
            Container(
              padding: const EdgeInsets.all(DesignTokens.spacingSm),
              decoration: BoxDecoration(
                color:
                    (selectedOption == question.answer
                            ? DesignTokens.success
                            : DesignTokens.destructive)
                        .withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.deThiCorrectAnswer(question.answer),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  if (question.explanationVi.isNotEmpty)
                    Text(question.explanationVi),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
