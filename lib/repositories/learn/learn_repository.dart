import 'package:deutschtiger/services/api_client.dart';

import '../../data/learn/learn_models.dart';

/// Repository cho learn extensions: capability map (can-do), weekly recap,
/// focus session, learner model, preferences (pin topic) và chấm câu cho
/// can-do practice. Mirrors web `capability-map-service.ts`,
/// `focus-session-service.ts`, `learner-model-service.ts`,
/// `sentence-grading-service.ts`.
class LearnRepository {
  LearnRepository(this._api);

  final ApiClient _api;

  static const _defaultGoal = 'comm_a1_a2';

  /// `GET /user/learn/capability-map?goal=`.
  Future<CapabilityMap> fetchCapabilityMap({String goal = _defaultGoal}) async {
    final json = await _api.get<Map<String, dynamic>>(
      '/user/learn/capability-map',
      query: {'goal': goal},
    );
    return CapabilityMap.fromJson(json);
  }

  /// `GET /user/learn/weekly-recap?tz=&days=`.
  Future<WeeklyRecap> fetchWeeklyRecap({
    required String timezone,
    int days = 7,
  }) async {
    final json = await _api.get<Map<String, dynamic>>(
      '/user/learn/weekly-recap',
      query: {'tz': timezone, 'days': days},
    );
    return WeeklyRecap.fromJson(json);
  }

  /// `GET /focus-session?due=&fails=&subs=` — tổng hợp việc cần luyện ngay:
  /// thẻ tới hạn, từ thi sai, từ từ video, lỗi ngữ pháp hay gặp.
  Future<FocusSessionData> fetchFocusSession({
    int due = 15,
    int fails = 10,
    int subs = 10,
  }) async {
    final json = await _api.get<Map<String, dynamic>>(
      '/focus-session',
      query: {'due': due, 'fails': fails, 'subs': subs},
    );
    return FocusSessionData.fromJson(json);
  }

  /// `GET /user/learner-model?weak_limit=`.
  Future<LearnerModel> fetchLearnerModel({int weakLimit = 20}) async {
    final json = await _api.get<Map<String, dynamic>>(
      '/user/learner-model',
      query: {'weak_limit': weakLimit},
    );
    return LearnerModel.fromJson(json);
  }

  /// `GET /user/preferences` — chỉ dùng cho topic explore (goals + pin).
  Future<LearnPreferences> fetchPreferences() async {
    final json = await _api.get<Map<String, dynamic>>('/user/preferences');
    return LearnPreferences.fromJson(json);
  }

  /// `PUT /user/preferences` sparse update — chỉ gửi `priority_topics`.
  Future<LearnPreferences> updatePriorityTopics(
    List<String> priorityTopics,
  ) async {
    final json = await _api.put<Map<String, dynamic>>(
      '/user/preferences',
      body: {'priority_topics': priorityTopics},
    );
    return LearnPreferences.fromJson(json);
  }

  /// `POST /ai/grade-sentence` — dùng trong can-do practice để chấm câu học
  /// viên viết cho một block (từ vựng/cấu trúc) còn yếu. Endpoint thuộc AI
  /// domain (đã live trên backend) nhưng KHÔNG thuộc AI feature code Flutter
  /// hiện có — gọi trực tiếp ở đây để tránh phụ thuộc file domain AI khác.
  Future<GradeSentenceResult> gradeSentence({
    required String promptWord,
    required String promptMeaning,
    required String userSentence,
    required String userLevel,
    required List<TargetBlockInput> targetBlocks,
  }) async {
    final json = await _api.post<Map<String, dynamic>>(
      '/ai/grade-sentence',
      body: {
        'prompt_word': promptWord,
        'prompt_meaning': promptMeaning,
        'user_sentence': userSentence,
        'user_level': userLevel,
        'target_blocks': targetBlocks.map((e) => e.toJson()).toList(),
      },
    );
    return GradeSentenceResult.fromJson(json);
  }
}

/// Một block mục tiêu (từ vựng hoặc cấu trúc) gửi kèm khi chấm câu — chỉ
/// đúng 1 trong 2 field `lemma`/`patternKey` non-null theo kind.
class TargetBlockInput {
  const TargetBlockInput({
    required this.kind,
    required this.ref,
    required this.label,
    this.lemma,
    this.patternKey,
  });

  final String kind; // 'vocab' | 'structure'
  final String ref;
  final String label;
  final String? lemma;
  final String? patternKey;

  Map<String, dynamic> toJson() => {
    'kind': kind,
    'ref': ref,
    'label': label,
    if (lemma != null) 'lemma': lemma,
    if (patternKey != null) 'pattern_key': patternKey,
  };
}
