/// Parse ANY writing-submission `exam_id` into a typed shape for the history
/// hub / session-detail — web parity `parseWritingExamId`
/// (`src/lib/exam/exam-id-builder.ts`). Additive sibling to
/// `writing_exam_id.dart` (which only builds Goethe B1 ids); this file adds
/// parsing + the generic/custom id builders needed by the W3 screens.
library;

/// Set segment used in the exam_id for generic official writing topics.
const String kWritingOfficialSet = 'official';

/// Set segment marking a user-authored ("tự nhập") writing topic.
const String kWritingCustomSet = 'custom';

/// Build the exam_id for a generic official writing topic:
/// `{provider}-{level}-official/{slug}/schreiben`.
String buildOfficialWritingExamId({
  required String provider,
  required String level,
  required String slug,
}) => '$provider-$level-$kWritingOfficialSet/$slug/schreiben';

/// Build an exam ID for a user-authored custom writing topic.
/// Format: `{provider}-{level}-custom[-teil{n}]/{slug}/schreiben`.
String buildCustomWritingExamId({
  required String provider,
  required String level,
  int? teil,
  required String slug,
}) {
  final set = teil != null && teil > 0
      ? '$kWritingCustomSet-teil$teil'
      : kWritingCustomSet;
  return '$provider-$level-$set/$slug/schreiben';
}

/// Generate a unique, URL-safe slug for a custom writing topic.
String generateCustomWritingSlug() {
  final now = DateTime.now().millisecondsSinceEpoch.toRadixString(36);
  final rand = (DateTime.now().microsecondsSinceEpoch % 1000000)
      .toRadixString(36);
  return 'c-$now-$rand';
}

/// True when a parsed schreiben `set` segment denotes a custom topic.
bool isCustomWritingSet(String set) =>
    set == kWritingCustomSet || set.startsWith('$kWritingCustomSet-');

/// Recover the Teil number from a set segment like `custom-teil2`, else null.
int? teilFromWritingSet(String set) {
  final m = RegExp(r'-teil(\d)$').firstMatch(set);
  return m == null ? null : int.tryParse(m.group(1)!);
}

/// Discriminated parse result of a writing-submission `exam_id`.
sealed class ParsedWritingExamId {
  const ParsedWritingExamId();
}

class ParsedGoetheB1WritingExamId extends ParsedWritingExamId {
  const ParsedGoetheB1WritingExamId({required this.teil, required this.slug});
  final int teil;
  final String slug;
}

class ParsedSchreibenExamId extends ParsedWritingExamId {
  const ParsedSchreibenExamId({
    required this.provider,
    required this.level,
    required this.set,
    required this.slug,
  });
  final String provider;
  final String level;
  final String set;
  final String slug;
}

final RegExp _kGoetheB1Re = RegExp(
  r'^goethe-b1-writing-teil-(\d)/([a-z0-9-]+)/schreiben$',
);
final RegExp _kSchreibenRe = RegExp(
  r'^([a-z]+)-([a-z0-9]+)-(.+)/([a-z0-9-]+)/schreiben$',
);

/// Parse any writing-submission exam ID into a typed shape. Returns null for
/// unrecognised IDs — callers must degrade gracefully (skip the row), never
/// throw, matching web's `parseWritingExamId`.
ParsedWritingExamId? parseWritingExamId(String examId) {
  final goethe = _kGoetheB1Re.firstMatch(examId);
  if (goethe != null) {
    return ParsedGoetheB1WritingExamId(
      teil: int.parse(goethe.group(1)!),
      slug: goethe.group(2)!,
    );
  }
  final generic = _kSchreibenRe.firstMatch(examId);
  if (generic != null) {
    return ParsedSchreibenExamId(
      provider: generic.group(1)!,
      level: generic.group(2)!,
      set: generic.group(3)!,
      slug: generic.group(4)!,
    );
  }
  return null;
}
