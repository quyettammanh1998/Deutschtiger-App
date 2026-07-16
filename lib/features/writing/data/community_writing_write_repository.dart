import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/api_client.dart';
import '../../../view_models/providers.dart';
import '../domain/community_writing_topic.dart';

/// Write-capable community-writing-topic surface — canonical+versions read,
/// AI "polish"/generate, create, add-version, vote/unvote, report. Additive
/// sibling to the P8 read-only `CommunityExamRepository`
/// (`lib/repositories/exam/community_exam_repository.dart`, which
/// deliberately deferred write actions to "GĐ2 P3 social moderation").
///
/// This wave needs those write actions for two screens the plan explicitly
/// requires (`writing-community-topic`'s create wizard/version add,
/// `writing-custom`'s AI-polish + "đóng góp đề"), so they're implemented
/// here — scoped to `lib/features/writing/` (this phase's ownership), not by
/// editing the P8 file. Endpoints verified live in
/// `thamkhao/deutschtiger-backend/cmd/server/routes_user_exam.go`
/// (`/user/community/exams/**`) — see `docs/flutter-api-contract-matrix.md`.
class CommunityWritingWriteRepository {
  const CommunityWritingWriteRepository(this._api);

  final ApiClient _api;

  /// `GET /user/community/exams/by-slug?provider=&level=&skill=writing&teil=&slug=`
  /// — canonical topic + all its versions.
  Future<CommunityWritingTopic> getCanonicalBySlug({
    required String provider,
    required String level,
    required int teil,
    required String slug,
  }) async {
    final data = await _api.get<Map<String, dynamic>>(
      '/user/community/exams/by-slug',
      query: {
        'provider': provider,
        'level': level,
        'skill': 'writing',
        'teil': teil.toString(),
        'slug': slug,
      },
    );
    return CommunityWritingTopic.fromJson(data);
  }

  /// `POST /user/community/exams/generate` — AI turns a rough VN/keyword
  /// prompt into a full German Aufgabe. Returns `{generated_data, title_de,
  /// title_vi}`.
  Future<({Map<String, dynamic> generatedData, String titleDe, String titleVi})>
      generate({
    required String provider,
    String? level,
    required int teil,
    required String input,
  }) async {
    final data = await _api.post<Map<String, dynamic>>(
      '/user/community/exams/generate',
      body: {
        'provider': provider,
        if (level != null) 'level': level,
        'skill': 'writing',
        'teil': teil,
        'input': input,
      },
    );
    final gd = data['generated_data'];
    return (
      generatedData: gd is Map ? Map<String, dynamic>.from(gd) : <String, dynamic>{},
      titleDe: data['title_de']?.toString() ?? '',
      titleVi: data['title_vi']?.toString() ?? '',
    );
  }

  /// `POST /user/community/exams/` — publish a new canonical topic. Returns
  /// the created topic (with server-assigned `id`/`slug`).
  Future<CommunityWritingTopic> create({
    required String provider,
    String? level,
    required int teil,
    required String titleDe,
    String? titleVi,
    required String inputText,
    required Map<String, dynamic> generatedData,
    String? examDate,
    String? examLocation,
  }) async {
    final data = await _api.post<Map<String, dynamic>>(
      '/user/community/exams/',
      body: {
        'provider': provider,
        if (level != null) 'level': level,
        'skill': 'writing',
        'teil': teil,
        'title_de': titleDe,
        if (titleVi != null) 'title_vi': titleVi,
        'input_text': inputText,
        'generated_data': generatedData,
        if (examDate != null) 'exam_date': examDate,
        if (examLocation != null) 'exam_location': examLocation,
      },
    );
    return CommunityWritingTopic.fromJson(data);
  }

  /// `POST /user/community/exams/{canonicalId}/versions` — add the caller's
  /// own version under an existing canonical topic. Returns the new row id.
  Future<String> upsertMyVersion({
    required String canonicalId,
    required String titleDe,
    String? titleVi,
    required String inputText,
    required Map<String, dynamic> generatedData,
    String? examDate,
    String? examLocation,
  }) async {
    final data = await _api.post<Map<String, dynamic>>(
      '/user/community/exams/$canonicalId/versions',
      body: {
        'title_de': titleDe,
        if (titleVi != null) 'title_vi': titleVi,
        'input_text': inputText,
        'generated_data': generatedData,
        if (examDate != null) 'exam_date': examDate,
        if (examLocation != null) 'exam_location': examLocation,
      },
    );
    return data['id']?.toString() ?? '';
  }

  /// `POST /user/community/exams/{id}/vote`.
  Future<void> vote(String id) =>
      _api.post<Map<String, dynamic>>('/user/community/exams/$id/vote');

  /// `DELETE /user/community/exams/{id}/vote`.
  Future<void> unvote(String id) =>
      _api.delete<Map<String, dynamic>>('/user/community/exams/$id/vote');

  /// `POST /user/community/exams/{id}/report`.
  Future<void> report(String id, String reason) => _api.post<Map<String, dynamic>>(
        '/user/community/exams/$id/report',
        body: {'reason': reason},
      );
}

final communityWritingWriteRepositoryProvider =
    Provider<CommunityWritingWriteRepository>((ref) {
  return CommunityWritingWriteRepository(ref.watch(apiClientProvider));
});

/// `(provider, level, teil, slug)` scoped canonical + versions.
final communityWritingTopicProvider = FutureProvider.autoDispose.family<
    CommunityWritingTopic,
    ({String provider, String level, int teil, String slug})>((ref, scope) {
  final repo = ref.watch(communityWritingWriteRepositoryProvider);
  return repo.getCanonicalBySlug(
    provider: scope.provider,
    level: scope.level,
    teil: scope.teil,
    slug: scope.slug,
  );
});
