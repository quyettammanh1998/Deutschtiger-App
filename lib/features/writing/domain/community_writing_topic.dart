/// Write-capable community writing topic — web parity `CommunityExamTopic`
/// (`src/lib/community/types.ts`). Additive sibling to the read-only
/// `data/exam/exam_ecosystem_models.dart` `CommunityExamTopic` (P8-owned):
/// that model omits owner/vote/version fields needed by W3's version
/// selector + create/report/vote flows, so this file carries its own DTO
/// scoped to `lib/features/writing/` rather than editing P8's file.
class CommunityWritingTopic {
  const CommunityWritingTopic({
    required this.id,
    required this.userId,
    required this.provider,
    required this.level,
    required this.skill,
    required this.teil,
    required this.slug,
    required this.titleDe,
    this.titleVi,
    required this.inputText,
    this.generatedData,
    required this.status,
    required this.reportCount,
    required this.createdAt,
    this.contributorName,
    this.contributorAvatar,
    this.parentTopicId,
    this.versionCount,
    this.versions,
    this.examDate,
    this.examLocation,
    this.voteCount,
    this.isVoted,
    this.isVerified,
    this.defaultVersionId,
  });

  final String id;
  final String userId;
  final String provider;
  final String level;
  final String skill;
  final int teil;
  final String slug;
  final String titleDe;
  final String? titleVi;
  final String inputText;
  final Map<String, dynamic>? generatedData;
  final String status;
  final int reportCount;
  final DateTime createdAt;
  final String? contributorName;
  final String? contributorAvatar;
  final String? parentTopicId;
  final int? versionCount;
  final List<CommunityWritingTopic>? versions;
  final String? examDate;
  final String? examLocation;
  final int? voteCount;
  final bool? isVoted;
  final bool? isVerified;
  final String? defaultVersionId;

  /// `generatedData['task']['de']`.
  String get taskPromptDe {
    final task = generatedData?['task'];
    return task is Map ? (task['de']?.toString() ?? '') : '';
  }

  /// `generatedData['taskAnalysis']['points'][].de`.
  List<String> get writingPoints {
    final analysis = generatedData?['taskAnalysis'];
    if (analysis is! Map) return const [];
    final points = analysis['points'];
    if (points is! List) return const [];
    return points
        .whereType<Map>()
        .map((p) => p['de']?.toString())
        .whereType<String>()
        .where((s) => s.isNotEmpty)
        .toList();
  }

  factory CommunityWritingTopic.fromJson(Map<String, dynamic> json) {
    final gd = json['generated_data'];
    final versionsJson = json['versions'];
    return CommunityWritingTopic(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      provider: json['provider']?.toString() ?? '',
      level: json['level']?.toString() ?? '',
      skill: json['skill']?.toString() ?? 'writing',
      teil: json['teil'] is num ? (json['teil'] as num).toInt() : 0,
      slug: json['slug']?.toString() ?? '',
      titleDe: json['title_de']?.toString() ?? '',
      titleVi: json['title_vi']?.toString(),
      inputText: json['input_text']?.toString() ?? '',
      generatedData: gd is Map ? Map<String, dynamic>.from(gd) : null,
      status: json['status']?.toString() ?? 'published',
      reportCount: json['report_count'] is num ? (json['report_count'] as num).toInt() : 0,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      contributorName: json['contributor_name']?.toString(),
      contributorAvatar: json['contributor_avatar']?.toString(),
      parentTopicId: json['parent_topic_id']?.toString(),
      versionCount: json['version_count'] is num ? (json['version_count'] as num).toInt() : null,
      versions: versionsJson is List
          ? versionsJson
              .whereType<Map>()
              .map((e) => CommunityWritingTopic.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : null,
      examDate: json['exam_date']?.toString(),
      examLocation: json['exam_location']?.toString(),
      voteCount: json['vote_count'] is num ? (json['vote_count'] as num).toInt() : null,
      isVoted: json['is_voted'] == true,
      isVerified: json['is_verified'] == true,
      defaultVersionId: json['default_version_id']?.toString(),
    );
  }
}
