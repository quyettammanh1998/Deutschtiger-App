import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

/// Nhãn hiển thị + màu + CTA luyện tập cho một `error_type`. Mirror
/// `ERROR_TYPE_CONFIG` (web `error-patterns-page.tsx`) — cùng bộ khoá do
/// backend `user_error_patterns` sinh ra (grammar-grading pipeline).
class ErrorTypeLabel {
  const ErrorTypeLabel(this.label, this.color, {this.drillRoute, this.drillLabel});
  final String label;
  final Color color;

  /// Route CTA "Luyện ..." ở cuối mỗi pattern card. Null khi web không có
  /// drill tương ứng.
  final String? drillRoute;
  final String Function(AppLocalizations)? drillLabel;
}

/// Nhãn cho các nguồn phát hiện lỗi (feature nào tạo ra pattern này).
final Map<String, String Function(AppLocalizations)> _sourceLabels = {
  'schreiben_exam': (l10n) => l10n.errorSourceSchreibenExam,
  'sprechen': (l10n) => l10n.errorSourceSprechen,
  'sentence_builder': (l10n) => l10n.errorSourceSentenceBuilder,
};

String errorSourceLabel(BuildContext context, String source) {
  final l10n = AppLocalizations.of(context);
  return _sourceLabels[source]?.call(l10n) ?? source;
}

ErrorTypeLabel errorTypeLabel(BuildContext context, String errorType) {
  final l10n = AppLocalizations.of(context);
  return switch (errorType) {
    'article_gender' => ErrorTypeLabel(
      l10n.errorTypeArticleGender,
      Colors.red,
      drillRoute: '/games/artikel',
      drillLabel: (l) => l.errorPatternsDrillArtikel,
    ),
    'case_akkdat' => ErrorTypeLabel(
      l10n.errorTypeCaseAkkDat,
      Colors.orange,
      drillRoute: '/games/sentence-builder',
      drillLabel: (l) => l.errorPatternsDrillSentenceBuilder,
    ),
    'verb_conjugation' => ErrorTypeLabel(
      l10n.errorTypeVerbConjugation,
      Colors.amber,
      drillRoute: '/games/sentence-builder',
      drillLabel: (l) => l.errorPatternsDrillSentenceBuilder,
    ),
    'verb_position' => ErrorTypeLabel(
      l10n.errorTypeVerbPosition,
      Colors.yellow.shade800,
      drillRoute: '/games/wortstellung',
      drillLabel: (l) => l.errorPatternsDrillWordOrder,
    ),
    'word_order' => ErrorTypeLabel(
      l10n.errorTypeWordOrder,
      Colors.green,
      drillRoute: '/games/wortstellung',
      drillLabel: (l) => l.errorPatternsDrillWordOrder,
    ),
    'preposition' => ErrorTypeLabel(
      l10n.errorTypePreposition,
      Colors.teal,
      drillRoute: '/games/sentence-builder',
      drillLabel: (l) => l.errorPatternsDrillPreposition,
    ),
    'plural' => ErrorTypeLabel(
      l10n.errorTypePlural,
      Colors.cyan,
      drillRoute: '/grammar',
      drillLabel: (l) => l.errorPatternsDrillNoun,
    ),
    'spelling' => ErrorTypeLabel(
      l10n.errorTypeSpelling,
      Colors.blue,
      drillRoute: '/games/typing-sprint',
      drillLabel: (l) => l.errorPatternsDrillSpelling,
    ),
    'punctuation' => ErrorTypeLabel(
      l10n.errorTypePunctuation,
      Colors.indigo,
      drillRoute: '/grammar',
      drillLabel: (l) => l.errorPatternsDrillGrammar,
    ),
    'tense_consistency' => ErrorTypeLabel(
      l10n.errorTypeTenseConsistency,
      Colors.pink,
      drillRoute: '/games/sentence-builder',
      drillLabel: (l) => l.errorPatternsDrillTense,
    ),
    _ => ErrorTypeLabel(
      l10n.errorTypeOther,
      Colors.grey,
      drillRoute: '/grammar',
      drillLabel: (l) => l.errorPatternsDrillGrammar,
    ),
  };
}
