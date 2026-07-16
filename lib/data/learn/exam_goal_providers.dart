/// Exam providers a user can set as a learning-goal target, with the CEFR
/// levels each provider actually offers a practice catalog for. Mirrors web
/// `src/lib/exam/exam-goal-providers.ts` so the goal setter can never point a
/// user at a provider/level combo with no exams (e.g. telc A1 → empty list).
///
/// Must stay in sync with the backend `target_provider` CHECK (migration 141).
library;

class ExamGoalProvider {
  const ExamGoalProvider({
    required this.id,
    required this.label,
    required this.short,
    required this.levels,
  });

  /// Backend `target_provider` value: "goethe" | "telc" | "osd".
  final String id;

  /// Full display name, e.g. "Goethe-Zertifikat".
  final String label;

  /// Compact label for tight UI, e.g. "Goethe".
  final String short;

  /// CEFR levels this provider offers exams for, in ascending order.
  final List<String> levels;
}

const List<ExamGoalProvider> examGoalProviders = <ExamGoalProvider>[
  ExamGoalProvider(
    id: 'goethe',
    label: 'Goethe-Zertifikat',
    short: 'Goethe',
    levels: ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'],
  ),
  ExamGoalProvider(
    id: 'telc',
    label: 'telc Deutsch',
    short: 'telc',
    levels: ['B1', 'B2'],
  ),
  ExamGoalProvider(
    id: 'osd',
    label: 'ÖSD Zertifikat',
    short: 'ÖSD',
    levels: ['B2'],
  ),
];

/// CEFR levels a provider offers, defaulting to Goethe's full set for an
/// unknown/legacy provider id.
List<String> levelsForProvider(String? providerId) {
  for (final provider in examGoalProviders) {
    if (provider.id == providerId) return provider.levels;
  }
  return examGoalProviders.first.levels;
}

/// Compact provider name for tight UI (e.g. the ExamCorner countdown
/// heading); falls back to 'Goethe' for unknown/legacy values.
String examGoalProviderShort(String? providerId) {
  for (final provider in examGoalProviders) {
    if (provider.id == providerId) return provider.short;
  }
  return 'Goethe';
}
