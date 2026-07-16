/// Conversation ecosystem core models — mirrors backend
/// `internal/feature/content/conversation/conversation_types.go` and the web
/// TS types in `src/types/conversation-scenario.ts`.
///
/// All `fromJson` are defensive: missing/null fields fall back to empty
/// strings/lists rather than throwing, since some paths (custom/interview
/// scenarios) are client-synthesized and may omit optional keys.
library;

String _str(Map<String, dynamic> json, String key) =>
    (json[key] as String?) ?? '';

List<T> _list<T>(
  Map<String, dynamic> json,
  String key,
  T Function(Map<String, dynamic>) fromJson,
) {
  final raw = json[key];
  if (raw is! List) return const [];
  return raw
      .whereType<Map>()
      .map((e) => fromJson(Map<String, dynamic>.from(e)))
      .toList();
}

/// A German/Vietnamese vocab pair shown in the scenario context panel.
class VocabItem {
  const VocabItem({required this.de, required this.vi});

  factory VocabItem.fromJson(Map<String, dynamic> json) =>
      VocabItem(de: _str(json, 'de'), vi: _str(json, 'vi'));

  final String de;
  final String vi;

  Map<String, dynamic> toJson() => {'de': de, 'vi': vi};
}

/// A sample phrase pair shown in the scenario context panel.
class SamplePhrase {
  const SamplePhrase({required this.de, required this.vi});

  factory SamplePhrase.fromJson(Map<String, dynamic> json) =>
      SamplePhrase(de: _str(json, 'de'), vi: _str(json, 'vi'));

  final String de;
  final String vi;

  Map<String, dynamic> toJson() => {'de': de, 'vi': vi};
}

/// One content part the learner must address before the AI ends the
/// conversation. `hintDe`/`hintVi` are interview-only prepared-answer hints
/// (learner-only — never sent to the AI).
class RequiredPoint {
  const RequiredPoint({
    required this.de,
    required this.vi,
    this.hintDe = '',
    this.hintVi = '',
  });

  factory RequiredPoint.fromJson(Map<String, dynamic> json) => RequiredPoint(
    de: _str(json, 'de'),
    vi: _str(json, 'vi'),
    hintDe: _str(json, 'hint_de'),
    hintVi: _str(json, 'hint_vi'),
  );

  final String de;
  final String vi;
  final String hintDe;
  final String hintVi;

  RequiredPoint copyWith({String? de, String? vi, String? hintDe, String? hintVi}) =>
      RequiredPoint(
        de: de ?? this.de,
        vi: vi ?? this.vi,
        hintDe: hintDe ?? this.hintDe,
        hintVi: hintVi ?? this.hintVi,
      );

  Map<String, dynamic> toJson() => {
    'de': de,
    'vi': vi,
    if (hintDe.isNotEmpty) 'hint_de': hintDe,
    if (hintVi.isNotEmpty) 'hint_vi': hintVi,
  };
}

/// Lightweight row from `GET /user/conversation/scenarios`.
class ScenarioMeta {
  const ScenarioMeta({
    required this.id,
    required this.titleDe,
    required this.titleVi,
    required this.level,
  });

  factory ScenarioMeta.fromJson(Map<String, dynamic> json) => ScenarioMeta(
    id: _str(json, 'id'),
    titleDe: _str(json, 'title_de'),
    titleVi: _str(json, 'title_vi'),
    level: _str(json, 'level'),
  );

  final String id;
  final String titleDe;
  final String titleVi;
  final String level;
}

/// Full scenario detail — `GET /user/conversation/scenario/{id}`, plus
/// client-synthesized custom-topic/interview variants.
class Scenario {
  const Scenario({
    required this.id,
    required this.titleDe,
    required this.titleVi,
    required this.level,
    required this.aiRole,
    required this.userRole,
    required this.contextDe,
    required this.contextVi,
    this.vocab = const [],
    this.samplePhrases = const [],
    this.requiredPoints = const [],
    required this.starterPromptDe,
    this.gradientFrom = 'from-orange-500',
    this.gradientTo = 'to-orange-600',
    this.icon = 'chat',
    this.isCustom = false,
    this.customTopic,
    this.customFocus = const [],
  });

  factory Scenario.fromJson(Map<String, dynamic> json) => Scenario(
    id: _str(json, 'id'),
    titleDe: _str(json, 'title_de'),
    titleVi: _str(json, 'title_vi'),
    level: _str(json, 'level'),
    aiRole: _str(json, 'ai_role'),
    userRole: _str(json, 'user_role'),
    contextDe: _str(json, 'context_de'),
    contextVi: _str(json, 'context_vi'),
    vocab: _list(json, 'vocab', VocabItem.fromJson),
    samplePhrases: _list(json, 'sample_phrases', SamplePhrase.fromJson),
    requiredPoints: _list(json, 'required_points', RequiredPoint.fromJson),
    starterPromptDe: _str(json, 'starter_prompt_de'),
    gradientFrom: (json['gradient_from'] as String?) ?? 'from-orange-500',
    gradientTo: (json['gradient_to'] as String?) ?? 'to-orange-600',
    icon: (json['icon'] as String?) ?? 'chat',
    isCustom: json['is_custom'] as bool? ?? false,
    customTopic: json['custom_topic'] as String?,
    customFocus:
        (json['custom_focus'] as List?)?.whereType<String>().toList() ??
        const [],
  );

  final String id;
  final String titleDe;
  final String titleVi;
  final String level;
  final String aiRole;
  final String userRole;
  final String contextDe;
  final String contextVi;
  final List<VocabItem> vocab;
  final List<SamplePhrase> samplePhrases;
  final List<RequiredPoint> requiredPoints;
  final String starterPromptDe;
  final String gradientFrom;
  final String gradientTo;
  final String icon;
  final bool isCustom;
  final String? customTopic;
  final List<String> customFocus;

  Scenario copyWith({List<String>? customFocus}) => Scenario(
    id: id,
    titleDe: titleDe,
    titleVi: titleVi,
    level: level,
    aiRole: aiRole,
    userRole: userRole,
    contextDe: contextDe,
    contextVi: contextVi,
    vocab: vocab,
    samplePhrases: samplePhrases,
    requiredPoints: requiredPoints,
    starterPromptDe: starterPromptDe,
    gradientFrom: gradientFrom,
    gradientTo: gradientTo,
    icon: icon,
    isCustom: isCustom,
    customTopic: customTopic,
    customFocus: customFocus ?? this.customFocus,
  );
}

/// One turn in the dialog — role is either `ai` or `user`.
class DialogMessage {
  const DialogMessage({required this.role, required this.text});

  factory DialogMessage.fromJson(Map<String, dynamic> json) => DialogMessage(
    role: _str(json, 'role'),
    text: _str(json, 'text'),
  );

  final String role; // 'ai' | 'user'
  final String text;

  bool get isUser => role == 'user';

  Map<String, dynamic> toJson() => {'role': role, 'text': text};
}

/// Coverage status for one required content part, returned alongside each
/// `/user/conversation/turn` response once the scenario has required points.
class CoveragePoint {
  const CoveragePoint({
    required this.index,
    required this.labelDe,
    required this.labelVi,
    required this.covered,
  });

  factory CoveragePoint.fromJson(Map<String, dynamic> json) => CoveragePoint(
    index: (json['index'] as num?)?.toInt() ?? 0,
    labelDe: _str(json, 'label_de'),
    labelVi: _str(json, 'label_vi'),
    covered: json['covered'] as bool? ?? false,
  );

  final int index;
  final String labelDe;
  final String labelVi;
  final bool covered;
}

/// Response from `POST /user/conversation/turn`.
class TurnResponse {
  const TurnResponse({
    required this.aiMessage,
    this.sessionDone = false,
    this.coverage = const [],
  });

  factory TurnResponse.fromJson(Map<String, dynamic> json) => TurnResponse(
    aiMessage: _str(json, 'ai_message'),
    sessionDone: json['session_done'] as bool? ?? false,
    coverage: _list(json, 'coverage', CoveragePoint.fromJson),
  );

  final String aiMessage;
  final bool sessionDone;
  final List<CoveragePoint> coverage;
}

/// Payload sent alongside `/turn` and `/opening` for custom (AI-generated)
/// topics — see `custom-scenario.ts` `toCustomScenarioPayload`.
class CustomScenarioPayload {
  const CustomScenarioPayload({
    required this.topic,
    required this.level,
    this.focusPoints = const [],
  });

  Map<String, dynamic> toJson() => {
    'topic': topic,
    'level': level,
    if (focusPoints.isNotEmpty) 'focus_points': focusPoints,
  };

  final String topic;
  final String level;
  final List<String> focusPoints;

  /// Builds the payload from a [Scenario], or null when the scenario isn't
  /// custom (mirrors `toCustomScenarioPayload`).
  static CustomScenarioPayload? fromScenario(Scenario scenario) {
    if (!scenario.isCustom) return null;
    return CustomScenarioPayload(
      topic: scenario.customTopic?.isNotEmpty == true
          ? scenario.customTopic!
          : scenario.titleVi,
      level: scenario.level,
      focusPoints: scenario.customFocus,
    );
  }
}
