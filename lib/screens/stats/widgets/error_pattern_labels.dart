import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

/// Nhãn hiển thị + màu cho một `error_type`. Mirror `ERROR_TYPE_CONFIG` (web
/// `error-patterns-page.tsx`) — cùng bộ khoá do backend `user_error_patterns`
/// sinh ra (grammar-grading pipeline).
class ErrorTypeLabel {
  const ErrorTypeLabel(this.label, this.color);
  final String label;
  final Color color;
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
    ),
    'case_akkdat' => ErrorTypeLabel(l10n.errorTypeCaseAkkDat, Colors.orange),
    'verb_conjugation' => ErrorTypeLabel(
      l10n.errorTypeVerbConjugation,
      Colors.amber,
    ),
    'verb_position' => ErrorTypeLabel(
      l10n.errorTypeVerbPosition,
      Colors.yellow.shade800,
    ),
    'word_order' => ErrorTypeLabel(l10n.errorTypeWordOrder, Colors.green),
    'preposition' => ErrorTypeLabel(l10n.errorTypePreposition, Colors.teal),
    'plural' => ErrorTypeLabel(l10n.errorTypePlural, Colors.cyan),
    'spelling' => ErrorTypeLabel(l10n.errorTypeSpelling, Colors.blue),
    'punctuation' => ErrorTypeLabel(l10n.errorTypePunctuation, Colors.indigo),
    'tense_consistency' => ErrorTypeLabel(
      l10n.errorTypeTenseConsistency,
      Colors.pink,
    ),
    _ => ErrorTypeLabel(l10n.errorTypeOther, Colors.grey),
  };
}
