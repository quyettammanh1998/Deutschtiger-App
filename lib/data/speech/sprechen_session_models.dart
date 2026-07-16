/// DTOs for sprechen results / sessions / leaderboard — live API, `Review`
/// status per `docs/flutter-api-contract-matrix.md` (response field shape
/// beyond the documented request bodies is unverified). Parsed defensively:
/// known fields are typed, everything else stays in [raw] so no data is
/// silently dropped while the shape is confirmed.
library;

/// `POST/GET /user/sprechen-results` entry.
class SprechenResult {
  const SprechenResult({
    required this.teil,
    required this.topicSlug,
    required this.score,
    required this.grade,
    this.raw = const {},
  });

  final String teil;
  final String topicSlug;
  final num score;
  final String grade;

  /// Full raw JSON — Review-status fields (e.g. timestamps, ids) live here
  /// until the response shape is verified against a live token probe.
  final Map<String, dynamic> raw;

  factory SprechenResult.fromJson(Map<String, dynamic> json) {
    return SprechenResult(
      teil: json['teil'] as String? ?? '',
      topicSlug: json['topic_slug'] as String? ?? '',
      score: (json['score'] as num?) ?? 0,
      grade: json['grade'] as String? ?? '',
      raw: json,
    );
  }

  Map<String, dynamic> toRequestJson() => {
    'teil': teil,
    'topic_slug': topicSlug,
    'score': score,
    'grade': grade,
  };
}

/// `GET /user/sprechen-leaderboard` entry — Review status, passthrough map
/// with best-effort typed accessors for the fields the UI needs.
class SprechenLeaderboardEntry {
  const SprechenLeaderboardEntry(this.raw);

  final Map<String, dynamic> raw;

  String get displayName =>
      raw['display_name'] as String? ?? raw['username'] as String? ?? '';
  num get totalScore =>
      (raw['total_score'] as num?) ?? (raw['score'] as num?) ?? 0;
  int get rank => (raw['rank'] as num?)?.toInt() ?? 0;
  String? get avatarUrl => raw['avatar_url'] as String?;

  factory SprechenLeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      SprechenLeaderboardEntry(json);
}

/// `POST/GET /user/sprechen-sessions` entry.
class SprechenSession {
  const SprechenSession({
    required this.id,
    required this.teil,
    required this.topic,
    this.aiSessionId,
    this.raw = const {},
  });

  final String id;
  final String teil;
  final String topic;
  final String? aiSessionId;
  final Map<String, dynamic> raw;

  factory SprechenSession.fromJson(Map<String, dynamic> json) {
    return SprechenSession(
      id: json['id'] as String? ?? '',
      teil: json['teil'] as String? ?? '',
      topic: json['topic'] as String? ?? '',
      aiSessionId: json['ai_session_id'] as String?,
      raw: json,
    );
  }
}

/// `GET /user/sprechen-sessions/{id}/messages` entry.
class SprechenSessionMessage {
  const SprechenSessionMessage({
    required this.role,
    required this.text,
    this.raw = const {},
  });

  final String role;
  final String text;
  final Map<String, dynamic> raw;

  factory SprechenSessionMessage.fromJson(Map<String, dynamic> json) {
    return SprechenSessionMessage(
      role: json['role'] as String? ?? '',
      text: json['text'] as String? ?? json['content'] as String? ?? '',
      raw: json,
    );
  }
}
