/// B3 — Mission Session domain models.
///
/// Mirrors web `src/lib/learn/learn-types.ts` (`DailyMission`, `MissionRound`,
/// `DailyMissionWord`, `CompleteRoundPayload`, `CompleteMissionResult`).
/// Backend: `GET /api/v1/user/learn/mission/today`,
/// `POST /api/v1/user/learn/mission/{id}/start`,
/// `POST /api/v1/user/learn/mission/{id}/round/{idx}/complete`,
/// `POST /api/v1/user/learn/mission/{id}/complete`.
library;

/// One vocab word seeded into today's mission.
class DailyMissionWord {
  const DailyMissionWord({
    required this.wordId,
    required this.contentDe,
    required this.contentVi,
    this.audioUrl,
    this.level,
  });

  final String wordId;
  final String contentDe;
  final String contentVi;
  final String? audioUrl;
  final String? level;

  factory DailyMissionWord.fromJson(Map<String, dynamic> json) {
    return DailyMissionWord(
      wordId: json['word_id'] as String? ?? '',
      contentDe: json['content_de'] as String? ?? '',
      contentVi: json['content_vi'] as String? ?? '',
      audioUrl: json['audio_url'] as String?,
      level: json['level'] as String?,
    );
  }
}

/// One round of the mission plan — a batch of words to intro + practice.
/// `game_type == 'resume'` rounds are a pre-step, not a playable round (mirrors
/// web `mission.rounds.filter(r => r.game_type !== 'resume')`).
class MissionRound {
  const MissionRound({
    required this.index,
    required this.gameType,
    required this.wordIds,
  });

  final int index;
  final String gameType;
  final List<String> wordIds;

  bool get isPlayable => gameType != 'resume';

  factory MissionRound.fromJson(Map<String, dynamic> json) {
    return MissionRound(
      index: (json['index'] as num?)?.toInt() ?? 0,
      gameType: json['game_type'] as String? ?? '',
      wordIds: (json['word_ids'] as List<dynamic>? ?? const [])
          .map((e) => e as String)
          .toList(),
    );
  }
}

/// Today's mission — `GET /user/learn/mission/today`.
class DailyMission {
  const DailyMission({
    required this.id,
    required this.words,
    required this.rounds,
    required this.roundsPlanned,
    required this.roundsCompleted,
    required this.completionPct,
    required this.xpEarned,
    this.startedAt,
    this.completedAt,
  });

  final String id;
  final List<DailyMissionWord> words;
  final List<MissionRound> rounds;
  final int roundsPlanned;
  final int roundsCompleted;
  final double completionPct;
  final int xpEarned;
  final DateTime? startedAt;
  final DateTime? completedAt;

  /// Playable rounds (resume pre-step excluded).
  List<MissionRound> get playableRounds =>
      rounds.where((r) => r.isPlayable).toList();

  DailyMissionWord? wordById(String id) {
    for (final w in words) {
      if (w.wordId == id) return w;
    }
    return null;
  }

  factory DailyMission.fromJson(Map<String, dynamic> json) {
    return DailyMission(
      id: json['id'] as String? ?? '',
      words: (json['words'] as List<dynamic>? ?? const [])
          .map((e) => DailyMissionWord.fromJson(e as Map<String, dynamic>))
          .toList(),
      rounds: (json['rounds'] as List<dynamic>? ?? const [])
          .map((e) => MissionRound.fromJson(e as Map<String, dynamic>))
          .toList(),
      roundsPlanned: (json['rounds_planned'] as num?)?.toInt() ?? 0,
      roundsCompleted: (json['rounds_completed'] as num?)?.toInt() ?? 0,
      completionPct: (json['completion_pct'] as num?)?.toDouble() ?? 0,
      xpEarned: (json['xp_earned'] as num?)?.toInt() ?? 0,
      startedAt: json['started_at'] != null
          ? DateTime.tryParse(json['started_at'] as String)
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'] as String)
          : null,
    );
  }
}

/// One answer entry inside a `CompleteRoundPayload` (`item_id` + `correct`).
class MissionRoundAnswer {
  const MissionRoundAnswer({required this.itemId, required this.correct});

  final String itemId;
  final bool correct;

  Map<String, dynamic> toJson() => {'item_id': itemId, 'correct': correct};
}

/// Body of `POST /user/learn/mission/{id}/round/{idx}/complete`.
class CompleteRoundPayload {
  const CompleteRoundPayload({
    required this.score,
    required this.answers,
    this.skipped = false,
  });

  final int score;
  final List<MissionRoundAnswer> answers;
  final bool skipped;

  Map<String, dynamic> toJson() => {
        'score': score,
        'answers': answers.map((a) => a.toJson()).toList(),
        'skipped': skipped,
      };
}

/// Result of `POST /user/learn/mission/{id}/complete`.
class CompleteMissionResult {
  const CompleteMissionResult({
    required this.xpAwarded,
    required this.streakUpdated,
    required this.completionPct,
  });

  final int xpAwarded;
  final bool streakUpdated;
  final double completionPct;

  factory CompleteMissionResult.fromJson(Map<String, dynamic> json) {
    return CompleteMissionResult(
      xpAwarded: (json['xp_awarded'] as num?)?.toInt() ?? 0,
      streakUpdated: json['streak_updated'] as bool? ?? false,
      completionPct: (json['completion_pct'] as num?)?.toDouble() ?? 0,
    );
  }
}
