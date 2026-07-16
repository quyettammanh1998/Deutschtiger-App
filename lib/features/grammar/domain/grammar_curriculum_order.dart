import '../../../data/grammar/grammar_models.dart';

/// Sắp xếp bài học theo thứ tự sư phạm (level → chủ đề → thứ tự trong chủ đề),
/// port từ `grammar-curriculum-order.ts` bên web để giữ trải nghiệm nhất quán.
const _topicOrder = <String, int>{
  'Khác': 1,
  'Số': 2,
  'Danh từ và quán từ': 3,
  'Đại từ': 4,
  'Động từ': 5,
  'Verbs': 5,
  'Thể phủ định': 6,
  'Chia đuôi từ': 7,
  'Chia từ': 7,
  'Tính từ và trạng từ': 8,
  'Cấu trúc câu': 9,
  'Giới từ': 10,
  'Thì': 11,
  'Phân biệt từ': 12,
  'Cách dùng': 13,
};

const _levelOrder = <String, int>{'A1': 0, 'A2': 1, 'B1': 2, 'B2': 3, 'C1': 4};

const _soloGroupPrefix = '__solo::';

String _normalizeTag(String tag) {
  if (tag == 'Verbs') return 'Động từ';
  if (tag == 'Chia từ') return 'Chia đuôi từ';
  return tag;
}

int _extractSortNumber(String title) {
  final paren = RegExp(r'\((\d+)\)\s*$').firstMatch(title);
  if (paren != null) return int.parse(paren.group(1)!);

  final range = RegExp(r'(\d+)\s*đến\s*(\d+)').firstMatch(title);
  if (range != null) return int.parse(range.group(1)!);

  final greater = RegExp(r'lớn hơn\s*(\d+)').firstMatch(title);
  if (greater != null) return 1000 + int.parse(greater.group(1)!);

  return 0;
}

String _primaryTopic(GrammarLessonSummary lesson) =>
    lesson.tags.isNotEmpty ? lesson.tags.first : 'Khác';

/// Sắp xếp danh sách bài học theo thứ tự curriculum.
List<T> sortByCurriculum<T extends GrammarLessonSummary>(List<T> lessons) {
  final sorted = [...lessons];
  sorted.sort((a, b) {
    final aLevel = _levelOrder[a.level] ?? 99;
    final bLevel = _levelOrder[b.level] ?? 99;
    if (aLevel != bLevel) return aLevel - bLevel;

    final aTopic = _topicOrder[_primaryTopic(a)] ?? 50;
    final bTopic = _topicOrder[_primaryTopic(b)] ?? 50;
    if (aTopic != bTopic) return aTopic - bTopic;

    final aSub = _extractSortNumber(a.title);
    final bSub = _extractSortNumber(b.title);
    if (aSub != bSub) return aSub - bSub;

    return a.title.compareTo(b.title);
  });
  return sorted;
}

/// Khoá nhóm chủ đề: bài không có tag rõ ràng (hoặc tag "Khác") là nhóm đơn lẻ.
String lessonGroupKey(GrammarLessonSummary lesson) {
  final tag = lesson.tags.isNotEmpty ? lesson.tags.first : null;
  if (tag == null || tag == 'Khác') return '$_soloGroupPrefix${lesson.id}';
  return _normalizeTag(tag);
}

bool isSoloGroup(String key) => key.startsWith(_soloGroupPrefix);

/// Nhóm ký tự có dấu → ký tự gốc, dùng cho tìm kiếm không phân biệt dấu.
const _diacriticGroups = <String, String>{
  'aàáảãạăằắẳẵặâầấẩẫậ': 'a',
  'eèéẻẽẹêềếểễệ': 'e',
  'iìíỉĩị': 'i',
  'oòóỏõọôồốổỗộơờớởỡợ': 'o',
  'uùúủũụưừứửữự': 'u',
  'yỳýỷỹỵ': 'y',
  'đ': 'd',
};

String _stripDiacritic(String lowerChar) {
  for (final entry in _diacriticGroups.entries) {
    if (entry.key.contains(lowerChar)) return entry.value;
  }
  return lowerChar;
}

/// Chuẩn hoá chuỗi tìm kiếm không dấu — port `normalizeSearch` bên web
/// (`grammar-list-page.tsx`/`grammar-level-detail.tsx`).
String normalizeGrammarSearch(String text) {
  final buffer = StringBuffer();
  for (final rune in text.toLowerCase().runes) {
    buffer.write(_stripDiacritic(String.fromCharCode(rune)));
  }
  return buffer.toString();
}
