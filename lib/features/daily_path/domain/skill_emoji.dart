/// Emoji shown next to a daily-path step — mirrors web
/// `src/lib/learn/daily-path-meta.ts` `SKILL_EMOJI`.
///
/// Web keys the map with German skill slugs (`wiederholung`, `fortsetzen`,
/// `wortschatz`, `hoeren`, `lesen`, `schreiben`, `sprechen`, `spiel`,
/// `pruefung`). The Flutter `/user/learn/path/today` response instead uses
/// the English-ish slugs already relied on by
/// `daily_path_route_resolver.dart` and the repository fixtures (`vocab`,
/// `review`, `flashcard`, `grammar`, `listening`, `reading`, `writing`,
/// `speaking`, `game`, `exam`). Both slug families are mapped here so real
/// steps never fall back to the placeholder dot.
const Map<String, String> kSkillEmoji = <String, String>{
  // Web (German) slugs.
  'wiederholung': '🔁',
  'fortsetzen': '⏯️',
  'wortschatz': '🃏',
  'hoeren': '👂',
  'lesen': '📖',
  'schreiben': '✍️',
  'sprechen': '🗣️',
  'spiel': '🎮',
  'pruefung': '📝',
  // Flutter API slugs actually returned by `/user/learn/path/today`.
  'vocab': '🃏',
  'review': '🔁',
  'flashcard': '🔁',
  'grammar': '📚',
  'listening': '👂',
  'reading': '📖',
  'writing': '✍️',
  'speaking': '🗣️',
  'game': '🎮',
  'exam': '📝',
};

/// Fallback glyph for an unrecognized skill slug — mirrors web `?? '•'`.
const String kSkillEmojiFallback = '•';

/// Looks up the display emoji for a daily-path step `skill` slug.
String skillEmoji(String skill) => kSkillEmoji[skill] ?? kSkillEmojiFallback;
