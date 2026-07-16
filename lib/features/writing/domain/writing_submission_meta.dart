import 'writing_exam_id_parser.dart';
import 'writing_offering.dart';

/// Derived display + routing metadata for a writing submission — web parity
/// `getWritingSubmissionMeta` (`src/lib/writing/writing-submission-meta.ts`).
/// Shared by the catalog's "Bài của tôi" tab and the session-detail screen so
/// the badge/title/"practice again" target stay consistent.
class WritingSubmissionMeta {
  const WritingSubmissionMeta({
    required this.badge,
    required this.title,
    required this.provider,
    required this.level,
    required this.teil,
    required this.isCustom,
    required this.practiceRoute,
  });

  final String badge;
  final String title;
  final String provider;
  final String level;
  final int? teil;
  final bool isCustom;

  /// Route to re-practice this exact topic, or null when the caller must
  /// handle it (custom → re-open the tự-nhập form with a prefill).
  final String? practiceRoute;
}

String _levelLabel(String provider, String level) {
  final offering = findWritingOffering('$provider-$level');
  return offering?.label ?? '${provider.toUpperCase()} ${level.toUpperCase()}';
}

/// First non-empty line of the task prompt, trimmed for display.
String _promptTitle(String taskPrompt, String fallback) {
  final line = taskPrompt
      .split('\n')
      .map((l) => l.trim())
      .firstWhere((l) => l.isNotEmpty, orElse: () => '');
  if (line.isEmpty) return fallback;
  return line.length > 70 ? '${line.substring(0, 70)}…' : line;
}

WritingSubmissionMeta getWritingSubmissionMeta({
  required ParsedWritingExamId parsed,
  required String taskPrompt,
}) {
  if (parsed is ParsedGoetheB1WritingExamId) {
    return WritingSubmissionMeta(
      badge: 'Goethe B1 · Teil ${parsed.teil}',
      title: parsed.slug.replaceAll('-', ' '),
      provider: 'goethe',
      level: 'b1',
      teil: parsed.teil,
      isCustom: false,
      practiceRoute: '/exam/goethe-b1/writing/${parsed.teil}/${parsed.slug}/practice',
    );
  }

  final p = parsed as ParsedSchreibenExamId;
  final teil = teilFromWritingSet(p.set);
  final custom = isCustomWritingSet(p.set);
  final teilSuffix = teil != null ? ' · Teil $teil' : '';

  if (custom) {
    return WritingSubmissionMeta(
      badge: 'Tự nhập · ${_levelLabel(p.provider, p.level)}$teilSuffix',
      title: _promptTitle(taskPrompt, p.slug.replaceAll('-', ' ')),
      provider: p.provider,
      level: p.level,
      teil: teil,
      isCustom: true,
      practiceRoute: null,
    );
  }

  final providerLevel = '${p.provider}-${p.level}';
  final hasOffering = findWritingOffering(providerLevel) != null;
  return WritingSubmissionMeta(
    badge: '${_levelLabel(p.provider, p.level)}$teilSuffix',
    title: p.slug.replaceAll('-', ' '),
    provider: p.provider,
    level: p.level,
    teil: teil,
    isCustom: false,
    practiceRoute: hasOffering
        ? '/exam/$providerLevel/writing/${p.slug}/practice'
        : null,
  );
}
