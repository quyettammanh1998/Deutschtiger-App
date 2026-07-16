import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/domain/sprint/sprint_types.dart';
import '../../../../../l10n/app_localizations.dart';

/// Mini-exam essay grading result card — rubric bars, grade badge, error
/// list (AI-graded via `POST /sprint/grade-essay`). The essay-highlight
/// (`<mark>` per error snippet)
/// and re-grade-confirm affordances are simplified to a plain toggle + a
/// direct "Chấm lại" action (no inline highlighting — Flutter has no cheap
/// rich-text-range-search primitive matching web's DOM `indexOf` approach;
/// the error list below already shows each snippet/correction pair).
class EssayResultCard extends StatefulWidget {
  const EssayResultCard({
    super.key,
    required this.result,
    required this.essayText,
    required this.onRegrade,
    this.regradeDisabled = false,
  });

  final SprintEssayResult result;
  final String essayText;
  final VoidCallback onRegrade;
  final bool regradeDisabled;

  @override
  State<EssayResultCard> createState() => _EssayResultCardState();
}

class _EssayResultCardState extends State<EssayResultCard> {
  bool _showEssay = false;

  static const _criteria = [
    ('erfullung', 'Erfüllung (hoàn thành)'),
    ('koharenz', 'Kohärenz (mạch lạc)'),
    ('wortschatz', 'Wortschatz (từ vựng)'),
    ('strukturen', 'Strukturen (ngữ pháp)'),
  ];

  Color _gradeColor(AppTokens tokens, String grade) => switch (grade) {
    'sehr_gut' => tokens.success,
    'gut' => tokens.primary,
    'befriedigend' => tokens.warning,
    _ => tokens.destructive,
  };

  String _gradeLabel(String grade) => switch (grade) {
    'sehr_gut' => 'Sehr gut',
    'gut' => 'Gut',
    'befriedigend' => 'Befriedigend',
    _ => 'Schwach',
  };

  int _score(String key) => switch (key) {
    'erfullung' => widget.result.erfullung,
    'koharenz' => widget.result.koharenz,
    'wortschatz' => widget.result.wortschatz,
    _ => widget.result.strukturen,
  };

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final result = widget.result;
    final gradeColor = _gradeColor(tokens, result.grade);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: tokens.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: tokens.border)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${result.total}/100', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: tokens.foreground)),
                  Text(l10n.writingSprintTeilLabel(result.teil), style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: gradeColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(999)),
                child: Text(_gradeLabel(result.grade), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: gradeColor)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: tokens.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: tokens.border)),
          child: Column(
            children: [
              for (final c in _criteria) ...[
                _RubricBar(label: c.$2, score: _score(c.$1), feedback: result.feedback[c.$1]),
                if (c != _criteria.last) const SizedBox(height: 12),
              ],
            ],
          ),
        ),
        if (result.errors.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: tokens.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: tokens.border)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.writingSprintErrorsToFixLabel, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: tokens.foreground)),
                const SizedBox(height: 8),
                for (final err in result.errors)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: tokens.muted, borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(text: TextSpan(style: TextStyle(fontSize: 12, color: tokens.foreground), children: [
                          TextSpan(text: '${l10n.writingSprintErrorWrongLabel}: ', style: const TextStyle(fontWeight: FontWeight.w600)),
                          TextSpan(text: err.snippet),
                        ])),
                        RichText(text: TextSpan(style: TextStyle(fontSize: 12, color: tokens.success), children: [
                          TextSpan(text: '${l10n.writingSprintErrorFixLabel}: ', style: const TextStyle(fontWeight: FontWeight.w600)),
                          TextSpan(text: err.correction),
                        ])),
                        Text(err.explanation, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: tokens.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: tokens.border)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => setState(() => _showEssay = !_showEssay),
                child: Text(
                  _showEssay ? l10n.writingSprintHideEssay : l10n.writingSprintShowEssay,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tokens.primary),
                ),
              ),
              if (_showEssay) ...[
                const SizedBox(height: 8),
                Text(widget.essayText, style: TextStyle(fontSize: 13, height: 1.6, color: tokens.foreground)),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: widget.regradeDisabled ? null : widget.onRegrade,
            child: Text(l10n.writingSprintRegradeButton, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
          ),
        ),
      ],
    );
  }
}

class _RubricBar extends StatelessWidget {
  const _RubricBar({required this.label, required this.score, this.feedback});

  final String label;
  final int score;
  final String? feedback;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final color = score >= 75 ? tokens.success : (score >= 50 ? tokens.warning : tokens.destructive);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
            Text('$score/100', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: tokens.foreground)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: score / 100,
            minHeight: 6,
            backgroundColor: tokens.muted,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
        if ((feedback ?? '').isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(feedback!, style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
          ),
      ],
    );
  }
}
