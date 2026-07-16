/// Presentation metadata for the conversation hub — port of web
/// `src/lib/conversation/scenario-display.ts` and `custom-scenario.ts`.
///
/// The `/scenarios` endpoint only returns id/title/level; this module maps
/// each known scenario id to a category/gradient/icon for the hub tiles and
/// filter pills, and provides the custom-topic slug/scenario builders.
library;

import 'conversation_models.dart';

class ConversationCategory {
  const ConversationCategory({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final String icon;
}

const conversationCategories = <ConversationCategory>[
  ConversationCategory(id: 'daily', label: 'Đời sống hàng ngày', icon: 'daily'),
  ConversationCategory(id: 'travel', label: 'Du lịch & Di chuyển', icon: 'travel'),
  ConversationCategory(id: 'work', label: 'Công việc & Học tập', icon: 'work'),
  ConversationCategory(id: 'admin', label: 'Hành chính & Dịch vụ', icon: 'admin'),
];

const conversationLevels = <String>['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

/// "Thử ngay" quick-suggest chips under the hub hero search.
const conversationQuickSuggest = <String>[
  'Phỏng vấn xin việc',
  'Đặt phòng khách sạn',
  'Khám bệnh ở Đức',
  'Nói chuyện với hàng xóm về tiếng ồn',
  'Đăng ký cư trú (Anmeldung)',
  'Mở tài khoản ngân hàng',
];

class ScenarioDisplay {
  const ScenarioDisplay({
    required this.category,
    required this.gradientFrom,
    required this.gradientTo,
    required this.icon,
  });

  final String category;
  final String gradientFrom;
  final String gradientTo;
  final String icon;
}

const _fallbackDisplay = ScenarioDisplay(
  category: 'daily',
  gradientFrom: 'from-orange-500',
  gradientTo: 'to-orange-600',
  icon: 'chat',
);

const _scenarioDisplay = <String, ScenarioDisplay>{
  'restaurant': ScenarioDisplay(category: 'daily', gradientFrom: 'from-amber-500', gradientTo: 'to-orange-600', icon: 'restaurant'),
  'einkaufen': ScenarioDisplay(category: 'daily', gradientFrom: 'from-green-500', gradientTo: 'to-emerald-600', icon: 'einkaufen'),
  'arzt': ScenarioDisplay(category: 'daily', gradientFrom: 'from-red-500', gradientTo: 'to-pink-600', icon: 'arzt'),
  'telefon': ScenarioDisplay(category: 'daily', gradientFrom: 'from-sky-500', gradientTo: 'to-blue-600', icon: 'telefon'),
  'fitness': ScenarioDisplay(category: 'daily', gradientFrom: 'from-orange-500', gradientTo: 'to-red-600', icon: 'fitness'),
  'nachbarn': ScenarioDisplay(category: 'daily', gradientFrom: 'from-rose-500', gradientTo: 'to-red-600', icon: 'nachbarn'),
  'wegbeschreibung': ScenarioDisplay(category: 'travel', gradientFrom: 'from-blue-500', gradientTo: 'to-indigo-600', icon: 'wegbeschreibung'),
  'hotel': ScenarioDisplay(category: 'travel', gradientFrom: 'from-cyan-500', gradientTo: 'to-blue-600', icon: 'hotel'),
  'bahnhof': ScenarioDisplay(category: 'travel', gradientFrom: 'from-lime-500', gradientTo: 'to-green-600', icon: 'bahnhof'),
  'reisen': ScenarioDisplay(category: 'travel', gradientFrom: 'from-sky-500', gradientTo: 'to-cyan-600', icon: 'reisen'),
  'bewerbung': ScenarioDisplay(category: 'work', gradientFrom: 'from-indigo-500', gradientTo: 'to-purple-600', icon: 'bewerbung'),
  'schule': ScenarioDisplay(category: 'work', gradientFrom: 'from-yellow-500', gradientTo: 'to-amber-600', icon: 'schule'),
  'bank': ScenarioDisplay(category: 'admin', gradientFrom: 'from-emerald-500', gradientTo: 'to-teal-600', icon: 'bank'),
  'behoerde': ScenarioDisplay(category: 'admin', gradientFrom: 'from-slate-500', gradientTo: 'to-zinc-700', icon: 'behoerde'),
  'wohnung': ScenarioDisplay(category: 'admin', gradientFrom: 'from-violet-500', gradientTo: 'to-fuchsia-600', icon: 'wohnung'),
  'post': ScenarioDisplay(category: 'admin', gradientFrom: 'from-blue-500', gradientTo: 'to-sky-600', icon: 'post'),
};

ScenarioDisplay getScenarioDisplay(String id) =>
    _scenarioDisplay[id] ?? _fallbackDisplay;

// ── CEFR pastel badge palette (light-mode ARGB; dark variants applied by
//    the widget layer via `context.tokens` opacity, since these hex pairs
//    mirror Tailwind's fixed light/dark classes rather than semantic tokens).
class LevelBadgeColors {
  const LevelBadgeColors(this.background, this.foreground);
  final int background;
  final int foreground;
}

const _levelBadgeColors = <String, LevelBadgeColors>{
  'A1': LevelBadgeColors(0xFFDCFCE7, 0xFF15803D),
  'A2': LevelBadgeColors(0xFFE0F2FE, 0xFF0369A1),
  'B1': LevelBadgeColors(0xFFEDE9FE, 0xFF6D28D9),
  'B2': LevelBadgeColors(0xFFFFEDD5, 0xFFC2410C),
  'C1': LevelBadgeColors(0xFFFEE2E2, 0xFFB91C1C),
  'C2': LevelBadgeColors(0xFFFAE8FF, 0xFFA21CAF),
};

LevelBadgeColors levelBadgeColors(String level) =>
    _levelBadgeColors[level] ?? _levelBadgeColors['A1']!;

// ── Custom-topic helpers — port of `custom-scenario.ts` ────────────────────

const customScenarioId = 'custom';
const _allowedLevels = {'A1', 'A2', 'B1', 'B2', 'C1', 'C2'};

String normalizeConversationLevel(String? level) {
  final safe = (level ?? '').trim().toUpperCase();
  return _allowedLevels.contains(safe) ? safe : 'B1';
}

/// Strips Vietnamese/German diacritics and slugifies a free-text topic.
String slugifyTopic(String topic) {
  var base = topic
      .replaceAll('đ', 'd')
      .replaceAll('Đ', 'd')
      .toLowerCase();
  base = _stripDiacritics(base);
  base = base.replaceAll(RegExp(r'[^a-z0-9]+'), '-');
  base = base.replaceAll(RegExp(r'^-+|-+$'), '');
  if (base.length > 80) base = base.substring(0, 80);
  base = base.replaceAll(RegExp(r'-+$'), '');
  return base.isEmpty ? 'chu-de' : base;
}

String _stripDiacritics(String input) {
  const withDiacritics =
      'àáảãạăằắẳẵặâầấẩẫậèéẻẽẹêềếểễệìíỉĩịòóỏõọôồốổỗộơờớởỡợùúủũụưừứửữựỳýỷỹỵ';
  const withoutDiacritics =
      'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyy';
  final buffer = StringBuffer();
  for (final rune in input.runes) {
    final ch = String.fromCharCode(rune);
    final idx = withDiacritics.indexOf(ch);
    buffer.write(idx >= 0 ? withoutDiacritics[idx] : ch);
  }
  return buffer.toString();
}

/// Builds the pretty custom-conversation path segment: `<slug>-<level>`.
String buildCustomConversationSlug(String topic, String level) =>
    '${slugifyTopic(topic)}-${normalizeConversationLevel(level).toLowerCase()}';

/// Recovers {topic, level} from a slug for cold/shared links. Returns null
/// when the slug is empty.
({String topic, String level})? parseCustomConversationSlug(String? slug) {
  final clean = (slug ?? '').trim();
  if (clean.isEmpty) return null;
  final match = RegExp(
    r'^(.*?)-(a1|a2|b1|b2|c1|c2)$',
    caseSensitive: false,
  ).firstMatch(clean);
  final rawTopic = match != null ? match.group(1)! : clean;
  final level = match != null
      ? normalizeConversationLevel(match.group(2))
      : 'B1';
  final topic = rawTopic.replaceAll(RegExp(r'-+'), ' ').trim();
  if (topic.isEmpty) return null;
  return (topic: topic, level: level);
}

/// Synthesizes a full [Scenario] for a free-typed custom topic (mirrors
/// `buildCustomConversationScenario`).
Scenario buildCustomConversationScenario(String topic, String level) {
  final cleanTopic = topic.trim().length > 180
      ? topic.trim().substring(0, 180)
      : topic.trim();
  final safeLevel = normalizeConversationLevel(level);
  return Scenario(
    id: customScenarioId,
    titleDe: 'Freies Gespräch',
    titleVi: cleanTopic,
    level: safeLevel,
    aiRole: 'Gesprächspartner/in',
    userRole: 'Deutschlernende/r',
    contextDe: 'Freies Gespräch über: $cleanTopic',
    contextVi: 'Chủ đề tự tạo: $cleanTopic',
    vocab: const [
      VocabItem(de: 'Meiner Meinung nach ...', vi: 'Theo ý kiến của tôi ...'),
      VocabItem(de: 'Ich habe eine Frage dazu.', vi: 'Tôi có một câu hỏi về điều đó.'),
      VocabItem(de: 'Das ist mir wichtig.', vi: 'Điều đó quan trọng với tôi.'),
      VocabItem(de: 'Können Sie das genauer erklären?', vi: 'Bạn có thể giải thích rõ hơn không?'),
    ],
    samplePhrases: const [
      SamplePhrase(de: 'Ich möchte über dieses Thema sprechen.', vi: 'Tôi muốn nói về chủ đề này.'),
      SamplePhrase(de: 'Meiner Meinung nach ist das interessant.', vi: 'Theo tôi, điều đó thú vị.'),
      SamplePhrase(de: 'Ich habe damit schon Erfahrungen gemacht.', vi: 'Tôi đã có kinh nghiệm với việc đó.'),
      SamplePhrase(de: 'Können Sie mir eine Frage dazu stellen?', vi: 'Bạn có thể hỏi tôi một câu về việc đó không?'),
      SamplePhrase(de: 'In Vietnam ist das oft anders.', vi: 'Ở Việt Nam điều đó thường khác.'),
    ],
    starterPromptDe: 'Hallo! Lass uns über „$cleanTopic" sprechen. Was möchtest du dazu sagen?',
    gradientFrom: 'from-orange-500',
    gradientTo: 'to-orange-600',
    icon: 'Sparkle',
    isCustom: true,
    customTopic: cleanTopic,
  );
}
