/// `grammarFocus[]` entry — web parity `GoetheB1WritingTopic.grammarFocus`.
class GrammarFocusItem {
  const GrammarFocusItem({
    required this.pattern,
    required this.example,
    required this.vi,
    this.structure,
    this.when,
    this.audioUrl,
  });

  final String pattern;
  final String? structure;
  final String example;
  final String vi;
  final String? when;
  final String? audioUrl;

  factory GrammarFocusItem.fromJson(Map<String, dynamic> json) =>
      GrammarFocusItem(
        pattern: json['pattern']?.toString() ?? '',
        structure: json['structure']?.toString(),
        example: json['example']?.toString() ?? '',
        vi: json['vi']?.toString() ?? '',
        when: json['when']?.toString(),
        audioUrl: json['audioUrl']?.toString(),
      );

  static List<GrammarFocusItem> listFromJson(Object? raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => GrammarFocusItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}

/// One `wortschatzBox.kernwortschatz[]` word — `genus` drives the der/die/das
/// grouping (`m`/`f`/`n`/other) in [WortschatzBoxCard].
class KernwortschatzItem {
  const KernwortschatzItem({
    required this.de,
    required this.vi,
    this.genus,
    this.example,
    this.exampleVi,
    this.collocation,
    this.audioUrl,
  });

  final String de;
  final String? genus;
  final String vi;
  final String? example;
  final String? exampleVi;
  final String? collocation;
  final String? audioUrl;

  factory KernwortschatzItem.fromJson(Map<String, dynamic> json) =>
      KernwortschatzItem(
        de: json['de']?.toString() ?? '',
        genus: json['genus']?.toString(),
        vi: json['vi']?.toString() ?? '',
        example: json['example']?.toString(),
        exampleVi: json['example_vi']?.toString(),
        collocation: json['collocation']?.toString(),
        audioUrl: json['audioUrl']?.toString(),
      );
}

/// One `wortschatzBox.chunks[]` entry.
class WortschatzChunk {
  const WortschatzChunk({
    required this.chunk,
    required this.vi,
    this.useCase,
    this.audioUrl,
  });

  final String chunk;
  final String vi;
  final String? useCase;
  final String? audioUrl;

  factory WortschatzChunk.fromJson(Map<String, dynamic> json) =>
      WortschatzChunk(
        chunk: json['chunk']?.toString() ?? '',
        vi: json['vi']?.toString() ?? '',
        useCase: json['useCase']?.toString(),
        audioUrl: json['audioUrl']?.toString(),
      );
}

/// One `wortschatzBox.konnektoren[]` entry.
class WortschatzKonnektor {
  const WortschatzKonnektor({
    required this.de,
    required this.vi,
    this.position,
    this.audioUrl,
  });

  final String de;
  final String vi;
  final String? position;
  final String? audioUrl;

  factory WortschatzKonnektor.fromJson(Map<String, dynamic> json) =>
      WortschatzKonnektor(
        de: json['de']?.toString() ?? '',
        vi: json['vi']?.toString() ?? '',
        position: json['position']?.toString(),
        audioUrl: json['audioUrl']?.toString(),
      );
}

/// `sec-wortschatz` payload — structured (kernwortschatz/chunks/konnektoren)
/// with a legacy `flat[]` fallback for older parses.
class WortschatzBox {
  const WortschatzBox({
    this.kernwortschatz = const [],
    this.chunks = const [],
    this.konnektoren = const [],
    this.flat = const [],
  });

  final List<KernwortschatzItem> kernwortschatz;
  final List<WortschatzChunk> chunks;
  final List<WortschatzKonnektor> konnektoren;
  final List<KernwortschatzItem> flat;

  bool get isEmpty =>
      kernwortschatz.isEmpty &&
      chunks.isEmpty &&
      konnektoren.isEmpty &&
      flat.isEmpty;

  factory WortschatzBox.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const WortschatzBox();
    List<T> parse<T>(String key, T Function(Map<String, dynamic>) fn) {
      final raw = json[key];
      if (raw is! List) return const [];
      return raw.whereType<Map>().map((e) => fn(Map<String, dynamic>.from(e))).toList();
    }

    return WortschatzBox(
      kernwortschatz: parse('kernwortschatz', KernwortschatzItem.fromJson),
      chunks: parse('chunks', WortschatzChunk.fromJson),
      konnektoren: parse('konnektoren', WortschatzKonnektor.fromJson),
      flat: parse('flat', KernwortschatzItem.fromJson),
    );
  }
}

/// `sec-fehler` entry — wrong/correct pair.
class CommonMistake {
  const CommonMistake({
    required this.wrong,
    required this.correct,
    required this.vi,
    this.audioUrl,
  });

  final String wrong;
  final String correct;
  final String vi;
  final String? audioUrl;

  factory CommonMistake.fromJson(Map<String, dynamic> json) => CommonMistake(
        wrong: json['wrong']?.toString() ?? '',
        correct: json['correct']?.toString() ?? '',
        vi: json['vi']?.toString() ?? '',
        audioUrl: json['audioUrl']?.toString(),
      );

  static List<CommonMistake> listFromJson(Object? raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => CommonMistake.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
