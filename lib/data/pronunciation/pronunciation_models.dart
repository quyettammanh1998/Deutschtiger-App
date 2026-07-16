/// Models for the pronunciation trainer cluster — mirrors web
/// `src/types/pronunciation-exercise.ts` and
/// `src/lib/pronunciation/minimal-pairs-service.ts`.
///
/// Backend is the live source of truth (`GET /user/pronunciation/{trainer}`,
/// `GET /minimal-pairs/contrasts`, `GET /minimal-pairs`) — these are plain
/// data-transfer models, not static content, so they stay in sync with
/// whatever word/IPA/hint corpus the server ships.
library;

/// Umlaut trainer item — `ä | ö | ü`.
class UmlautItem {
  const UmlautItem({
    required this.id,
    required this.word,
    required this.ipa,
    required this.umlaut,
    required this.viMeaning,
    required this.viHint,
    required this.minimalPair,
  });

  factory UmlautItem.fromJson(Map<String, dynamic> json) => UmlautItem(
    id: json['id'] as String? ?? '',
    word: json['word'] as String? ?? '',
    ipa: json['ipa'] as String? ?? '',
    umlaut: json['umlaut'] as String? ?? '',
    viMeaning: json['vi_meaning'] as String? ?? '',
    viHint: json['vi_hint'] as String? ?? '',
    minimalPair: json['minimal_pair'] as String? ?? '',
  );

  final String id;
  final String word;
  final String ipa;

  /// One of `ä`, `ö`, `ü`.
  final String umlaut;
  final String viMeaning;
  final String viHint;
  final String minimalPair;
}

/// Ich-laut `[ç]` vs Ach-laut `[x]` trainer item.
class IchAchItem {
  const IchAchItem({
    required this.id,
    required this.word,
    required this.ipa,
    required this.sound,
    required this.viMeaning,
    required this.viHint,
    required this.minimalPair,
  });

  factory IchAchItem.fromJson(Map<String, dynamic> json) => IchAchItem(
    id: json['id'] as String? ?? '',
    word: json['word'] as String? ?? '',
    ipa: json['ipa'] as String? ?? '',
    sound: json['sound'] as String? ?? '',
    viMeaning: json['vi_meaning'] as String? ?? '',
    viHint: json['vi_hint'] as String? ?? '',
    minimalPair: json['minimal_pair'] as String? ?? '',
  );

  final String id;
  final String word;
  final String ipa;

  /// `ich-laut` or `ach-laut`.
  final String sound;
  final String viMeaning;
  final String viHint;
  final String minimalPair;

  bool get isIchLaut => sound == 'ich-laut';
}

/// R-sound position groups — `initial | after-vowel | consonant-cluster |
/// vocalic`.
enum RPosition {
  initial,
  afterVowel,
  consonantCluster,
  vocalic;

  static RPosition fromWire(String value) => switch (value) {
    'initial' => RPosition.initial,
    'after-vowel' => RPosition.afterVowel,
    'consonant-cluster' => RPosition.consonantCluster,
    'vocalic' => RPosition.vocalic,
    _ => RPosition.initial,
  };
}

class RSoundItem {
  const RSoundItem({
    required this.id,
    required this.word,
    required this.ipa,
    required this.position,
    required this.viMeaning,
    required this.viHint,
  });

  factory RSoundItem.fromJson(Map<String, dynamic> json) => RSoundItem(
    id: json['id'] as String? ?? '',
    word: json['word'] as String? ?? '',
    ipa: json['ipa'] as String? ?? '',
    position: RPosition.fromWire(json['position'] as String? ?? 'initial'),
    viMeaning: json['vi_meaning'] as String? ?? '',
    viHint: json['vi_hint'] as String? ?? '',
  );

  final String id;
  final String word;
  final String ipa;
  final RPosition position;
  final String viMeaning;
  final String viHint;
}

/// `sp → /ʃp/` vs `st → /ʃt/` initial-cluster trainer item.
class SpStItem {
  const SpStItem({
    required this.id,
    required this.word,
    required this.ipa,
    required this.cluster,
    required this.viMeaning,
    required this.viHint,
  });

  factory SpStItem.fromJson(Map<String, dynamic> json) => SpStItem(
    id: json['id'] as String? ?? '',
    word: json['word'] as String? ?? '',
    ipa: json['ipa'] as String? ?? '',
    cluster: json['cluster'] as String? ?? 'sp',
    viMeaning: json['vi_meaning'] as String? ?? '',
    viHint: json['vi_hint'] as String? ?? '',
  );

  final String id;
  final String word;
  final String ipa;

  /// `sp` or `st`.
  final String cluster;
  final String viMeaning;
  final String viHint;

  bool get isSp => cluster == 'sp';
}

/// A selectable minimal-pair contrast group (e.g. "ich vs ach").
class MinimalPairContrast {
  const MinimalPairContrast({
    required this.contrastKey,
    required this.focusLabel,
    required this.focusLabelVi,
    required this.pairCount,
  });

  factory MinimalPairContrast.fromJson(Map<String, dynamic> json) =>
      MinimalPairContrast(
        contrastKey: json['contrast_key'] as String? ?? '',
        focusLabel: json['focus_label'] as String? ?? '',
        focusLabelVi: json['focus_label_vi'] as String? ?? '',
        pairCount: (json['pair_count'] as num?)?.toInt() ?? 0,
      );

  final String contrastKey;
  final String focusLabel;
  final String focusLabelVi;
  final int pairCount;
}

/// A single A/B minimal-pair word pair within a contrast.
class MinimalPair {
  const MinimalPair({
    required this.id,
    required this.contrastKey,
    required this.focusLabel,
    required this.focusLabelVi,
    required this.level,
    required this.wordADe,
    required this.wordAIpa,
    required this.wordAGlossVi,
    required this.wordAAudioUrl,
    required this.wordBDe,
    required this.wordBIpa,
    required this.wordBGlossVi,
    required this.wordBAudioUrl,
  });

  factory MinimalPair.fromJson(Map<String, dynamic> json) => MinimalPair(
    id: json['id'] as String? ?? '',
    contrastKey: json['contrast_key'] as String? ?? '',
    focusLabel: json['focus_label'] as String? ?? '',
    focusLabelVi: json['focus_label_vi'] as String? ?? '',
    level: json['level'] as String? ?? '',
    wordADe: json['word_a_de'] as String? ?? '',
    wordAIpa: json['word_a_ipa'] as String?,
    wordAGlossVi: json['word_a_gloss_vi'] as String?,
    wordAAudioUrl: json['word_a_audio_url'] as String?,
    wordBDe: json['word_b_de'] as String? ?? '',
    wordBIpa: json['word_b_ipa'] as String?,
    wordBGlossVi: json['word_b_gloss_vi'] as String?,
    wordBAudioUrl: json['word_b_audio_url'] as String?,
  );

  final String id;
  final String contrastKey;
  final String focusLabel;
  final String focusLabelVi;
  final String level;
  final String wordADe;
  final String? wordAIpa;
  final String? wordAGlossVi;
  final String? wordAAudioUrl;
  final String wordBDe;
  final String? wordBIpa;
  final String? wordBGlossVi;
  final String? wordBAudioUrl;
}
