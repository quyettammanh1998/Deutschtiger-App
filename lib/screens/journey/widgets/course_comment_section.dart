// Generic comment section for course lessons — web `components/comment/
// comment-section.tsx` (targetType="course_lesson"), backed by the existing
// `/api/v1/comments?target_type=&target_id=` REST endpoint (already live,
// same contract `exam_comment_section.dart` uses for `targetType="exam"`).
// Own copy (not a shared import) because `lib/features/exam/**` is another
// phase's file-ownership boundary — flagged in the report as a duplicate the
// W2 report also called out (video comments); a shared widget belongs to a
// later cleanup pass, not this wave.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/providers.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class CourseComment {
  const CourseComment({
    required this.id,
    required this.content,
    required this.displayName,
    required this.createdAt,
  });

  final String id;
  final String content;
  final String displayName;
  final DateTime createdAt;

  factory CourseComment.fromJson(Map<String, dynamic> json) => CourseComment(
        id: json['id']?.toString() ?? '',
        content: json['content']?.toString() ?? '',
        displayName: json['display_name']?.toString() ?? '?',
        createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      );
}

final courseLessonCommentsProvider =
    FutureProvider.autoDispose.family<List<CourseComment>, String>((ref, targetId) async {
  final api = ref.watch(apiClientProvider);
  final rows = await api.get<List<dynamic>>(
    '/comments',
    query: {'target_type': 'course_lesson', 'target_id': targetId},
  );
  return rows.whereType<Map>().map((r) => CourseComment.fromJson(Map<String, dynamic>.from(r))).toList();
});

class CourseCommentSection extends ConsumerStatefulWidget {
  const CourseCommentSection({super.key, required this.courseSlug, required this.lessonNumber});

  final String courseSlug;
  final int lessonNumber;

  String get _targetId => '${courseSlug}_$lessonNumber';

  @override
  ConsumerState<CourseCommentSection> createState() => _CourseCommentSectionState();
}

class _CourseCommentSectionState extends ConsumerState<CourseCommentSection> {
  final _controller = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      final api = ref.read(apiClientProvider);
      await api.post<Map<String, dynamic>>(
        '/comments',
        body: {'target_type': 'course_lesson', 'target_id': widget._targetId, 'content': text},
      );
      _controller.clear();
      ref.invalidate(courseLessonCommentsProvider(widget._targetId));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).coursesCommentsSendError)),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final commentsAsync = ref.watch(courseLessonCommentsProvider(widget._targetId));

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tokens.card,
        border: Border.all(color: tokens.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.coursesCommentsTitle,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: tokens.foreground),
          ),
          const SizedBox(height: 8),
          commentsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            error: (_, _) => Text(l10n.coursesCommentsError, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
            data: (comments) => comments.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(l10n.coursesCommentsEmpty, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
                  )
                : Column(
                    children: [
                      for (final c in comments)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: tokens.muted, borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(c.displayName, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: tokens.foreground)),
                                  const SizedBox(height: 2),
                                  Text(c.content, style: TextStyle(fontSize: 13, color: tokens.foreground)),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  minLines: 1,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: l10n.coursesCommentsPlaceholder,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _sending ? null : _send,
                icon: _sending
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : Icon(PhosphorIcons.paperPlaneTilt, color: tokens.primary, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
