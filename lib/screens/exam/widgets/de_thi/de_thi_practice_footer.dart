import 'package:flutter/material.dart';

import '../../../../core/icons/app_phosphor_icons.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Web parity: footer nav bar in `de-thi-practice-page.tsx` — "Đoạn trước" /
/// dot indicators / "Đoạn tiếp" or "Nộp bài" (on the last passage).
class DeThiPracticeFooter extends StatelessWidget {
  const DeThiPracticeFooter({
    super.key,
    required this.passageIndex,
    required this.totalPassages,
    required this.submitted,
    required this.onPrev,
    required this.onNext,
    required this.onSubmit,
    required this.onJumpTo,
  });

  final int passageIndex;
  final int totalPassages;
  final bool submitted;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onSubmit;
  final ValueChanged<int> onJumpTo;

  bool get _isFirst => passageIndex == 0;
  bool get _isLast => passageIndex == totalPassages - 1;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: tokens.background,
        border: Border(top: BorderSide(color: tokens.border)),
      ),
      child: Row(
        children: [
          _isFirst
              ? const SizedBox(width: 96)
              : _PrevButton(onTap: onPrev, tokens: tokens),
          const Spacer(),
          Row(
            children: [
              for (var i = 0; i < totalPassages; i++)
                GestureDetector(
                  onTap: () => onJumpTo(i),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == passageIndex ? tokens.primary : tokens.border,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const Spacer(),
          if (_isLast && !submitted)
            _SubmitButton(label: l10n.submitExam, onTap: onSubmit)
          else if (!_isLast)
            _NextButton(tokens: tokens, onTap: onNext)
          else
            const SizedBox(width: 96),
        ],
      ),
    );
  }
}

class _PrevButton extends StatelessWidget {
  const _PrevButton({required this.onTap, required this.tokens});

  final VoidCallback onTap;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: tokens.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: tokens.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AppPhosphorIcons.caretLeft,
              size: 16,
              color: tokens.foreground,
            ),
            const SizedBox(width: 6),
            Text(
              'Đoạn trước',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: tokens.foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({required this.tokens, required this.onTap});

  final AppTokens tokens;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: tokens.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: tokens.primary),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Đoạn tiếp',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: tokens.primary,
              ),
            ),
            const SizedBox(width: 6),
            Icon(AppPhosphorIcons.caretRight, size: 16, color: tokens.primary),
          ],
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Color(0xFFF97316), Color(0xFFEA580C)],
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 6),
            Icon(AppPhosphorIcons.caretRight, size: 16, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
