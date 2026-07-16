/// VN label for a `MyWord.source` tag — web parity: `SOURCE_VI` lookup table
/// in `word-status-chip.tsx`. Short fixed vocabulary of internal source
/// identifiers, not user-facing sentences — kept as a Dart lookup (matches
/// the plan's exception for short hardcoded VN copy) rather than 11 more
/// ARB keys for internal tag words.
const _kSourceLabelsVi = <String, String>{
  'new': 'mới',
  'manual': 'tự thêm',
  'subtitle': 'video',
  'subtitle_mirror': 'video',
  'exam_fail': 'bài thi',
  'writing_error': 'bài viết',
  'auto_struggle': 'hay sai',
  'practice': 'luyện tập',
  'reading': 'bài đọc',
  'news': 'tin tức',
  'flashcard': 'thẻ',
  'lesson': 'bài học',
};

String? sourceLabelVi(String? source) {
  if (source == null || source.isEmpty) return null;
  return _kSourceLabelsVi[source] ?? source;
}
