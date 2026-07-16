/// Session/quota/interview-library models — `POST/GET /user/conversation/
/// sessions(/{id})`, `GET /user/conversation/daily-quota`,
/// `GET/DELETE /user/conversation/interview/scenarios(/{id})`.
library;

import 'conversation_models.dart';

String _str(Map<String, dynamic> json, String key) =>
    (json[key] as String?) ?? '';

/// Lightweight row for the conversation history list — no transcript.
class ConversationSessionSummary {
  const ConversationSessionSummary({
    required this.id,
    required this.scenarioId,
    required this.title,
    required this.level,
    required this.userTurns,
    required this.hasVerdict,
    required this.createdAt,
  });

  factory ConversationSessionSummary.fromJson(Map<String, dynamic> json) =>
      ConversationSessionSummary(
        id: _str(json, 'id'),
        scenarioId: _str(json, 'scenario_id'),
        title: _str(json, 'title'),
        level: _str(json, 'level'),
        userTurns: (json['user_turns'] as num?)?.toInt() ?? 0,
        hasVerdict: json['has_verdict'] as bool? ?? false,
        createdAt: _str(json, 'created_at'),
      );

  final String id;
  final String scenarioId;
  final String title;
  final String level;
  final int userTurns;
  final bool hasVerdict;
  final String createdAt;
}

/// Full saved session — transcript + per-turn feedback + holistic verdict.
/// `feedback`/`verdict` are kept as raw maps: the AI-grading endpoints that
/// produce their typed shape (`/ai/sprechen-feedback`, `/ai/conversation-
/// examiner`) are outside this phase's documented contract (MASTER P8), so
/// the history detail screen renders them defensively/read-only without
/// binding to a typed schema.
class ConversationSessionDetail {
  const ConversationSessionDetail({
    required this.id,
    required this.scenarioId,
    required this.title,
    required this.level,
    required this.userTurns,
    required this.messages,
    required this.feedback,
    required this.verdict,
    required this.createdAt,
  });

  factory ConversationSessionDetail.fromJson(Map<String, dynamic> json) {
    final rawMessages = json['messages'];
    final messages = rawMessages is List
        ? rawMessages
              .whereType<Map>()
              .map((e) => DialogMessage.fromJson(Map<String, dynamic>.from(e)))
              .toList()
        : <DialogMessage>[];
    final rawFeedback = json['feedback'];
    return ConversationSessionDetail(
      id: _str(json, 'id'),
      scenarioId: _str(json, 'scenario_id'),
      title: _str(json, 'title'),
      level: _str(json, 'level'),
      userTurns: (json['user_turns'] as num?)?.toInt() ?? 0,
      messages: messages,
      feedback: rawFeedback is Map
          ? Map<String, dynamic>.from(rawFeedback)
          : const {},
      verdict: json['verdict'] is Map
          ? Map<String, dynamic>.from(json['verdict'] as Map)
          : null,
      createdAt: _str(json, 'created_at'),
    );
  }

  final String id;
  final String scenarioId;
  final String title;
  final String level;
  final int userTurns;
  final List<DialogMessage> messages;
  final Map<String, dynamic> feedback;
  final Map<String, dynamic>? verdict;
  final String createdAt;
}

/// Server-side free-tier conversation quota (UTC+7 day; interview module is
/// unlimited). Nullable fields default conservatively (walled) if the
/// backend response shape drifts, since this gates a paid feature.
class ConversationDailyQuota {
  const ConversationDailyQuota({
    required this.sessionsUsed,
    required this.maxSessions,
    required this.unlimited,
  });

  factory ConversationDailyQuota.fromJson(Map<String, dynamic> json) =>
      ConversationDailyQuota(
        sessionsUsed: (json['sessions_used'] as num?)?.toInt() ?? 0,
        maxSessions: (json['max_sessions'] as num?)?.toInt() ?? 4,
        unlimited: json['unlimited'] as bool? ?? false,
      );

  final int sessionsUsed;
  final int maxSessions;
  final bool unlimited;

  bool get isWalled => !unlimited && sessionsUsed >= maxSessions;
}

/// Lightweight row for the saved interview-scenario library list.
class InterviewScenarioSummary {
  const InterviewScenarioSummary({
    required this.id,
    required this.title,
    required this.level,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InterviewScenarioSummary.fromJson(Map<String, dynamic> json) =>
      InterviewScenarioSummary(
        id: _str(json, 'id'),
        title: _str(json, 'title'),
        level: _str(json, 'level'),
        createdAt: _str(json, 'created_at'),
        updatedAt: _str(json, 'updated_at'),
      );

  final String id;
  final String title;
  final String level;
  final String createdAt;
  final String updatedAt;
}

/// One tickable discussion point from the pre-chat survey.
class ConversationSurveyItem {
  const ConversationSurveyItem({required this.vi, required this.recommended});

  factory ConversationSurveyItem.fromJson(Map<String, dynamic> json) =>
      ConversationSurveyItem(
        vi: _str(json, 'vi'),
        recommended: json['recommended'] as bool? ?? false,
      );

  final String vi;
  final bool recommended;
}

/// A group of related discussion points under a Vietnamese heading.
class ConversationSurveyCategory {
  const ConversationSurveyCategory({required this.titleVi, required this.items});

  factory ConversationSurveyCategory.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    return ConversationSurveyCategory(
      titleVi: _str(json, 'title_vi'),
      items: rawItems is List
          ? rawItems
                .whereType<Map>()
                .map(
                  (e) => ConversationSurveyItem.fromJson(
                    Map<String, dynamic>.from(e),
                  ),
                )
                .toList()
          : const [],
    );
  }

  final String titleVi;
  final List<ConversationSurveyItem> items;
}

/// AI-generated survey for a custom topic — `POST /user/conversation/survey`.
class ConversationSurvey {
  const ConversationSurvey({required this.categories});

  factory ConversationSurvey.fromJson(Map<String, dynamic> json) {
    final rawCategories = json['categories'];
    return ConversationSurvey(
      categories: rawCategories is List
          ? rawCategories
                .whereType<Map>()
                .map(
                  (e) => ConversationSurveyCategory.fromJson(
                    Map<String, dynamic>.from(e),
                  ),
                )
                .toList()
          : const [],
    );
  }

  final List<ConversationSurveyCategory> categories;
}
