import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../features/journey/domain/course_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../../repositories/journey/journey_repository.dart';
import '../../../view_models/journey/journey_provider.dart';
import '../../../widgets/common/app_button.dart';
import 'course_comment_section.dart';
import 'course_notes_section.dart';
import 'course_transcript_panel.dart';
import 'course_video_player.dart';
import 'course_vocab_paginated.dart';

/// Lesson content body: video + completion gate + transcript + vocab +
/// notes + comments. Web parity `LessonEditor` in `course-lesson-page.tsx`
/// (exercise engine excluded — web itself has it commented out, see
/// `DwLessonDetail` model doc comment).
///
/// DEVIATION (documented): no periodic 30s auto-save timer or accumulated
/// anti-skip watch-time tracker — watch-ready uses the simpler
/// current/duration ratio from [CourseVideoPlayer]'s periodic JS bridge
/// pings, and progress is saved on toggle-complete + an explicit "Lưu tiến
/// độ" button (matches web's manual save button, just without the silent
/// interval autosave).
class CourseLessonBody extends ConsumerStatefulWidget {
  const CourseLessonBody({
    super.key,
    required this.slug,
    required this.lesson,
    required this.initialProgress,
    required this.onSaved,
  });

  final String slug;
  final DwLessonDetail lesson;
  final CourseLessonProgress? initialProgress;
  final VoidCallback onSaved;

  @override
  ConsumerState<CourseLessonBody> createState() => _CourseLessonBodyState();
}

class _CourseLessonBodyState extends ConsumerState<CourseLessonBody> {
  late bool _videoCompleted;
  late bool _watchReady;
  int _currentSeconds = 0;
  int _activeTranscriptIndex = -1;
  bool _saving = false;
  bool _awardingXp = false;
  String _saveMessage = '';
  final _playerKey = GlobalKey<CourseVideoPlayerState>();

  LessonKey get _key => LessonKey(widget.slug, widget.lesson.number);

  @override
  void initState() {
    super.initState();
    _videoCompleted = widget.initialProgress?.videoCompleted ?? false;
    _watchReady = _videoCompleted;
    _currentSeconds = widget.initialProgress?.lastWatchedSeconds ?? 0;
  }

  Future<void> _persist({bool showMessage = true}) async {
    setState(() => _saving = true);
    try {
      await ref.read(journeyRepositoryProvider).upsertLessonProgress(
            slug: widget.slug,
            lessonNumber: widget.lesson.number,
            videoCompleted: _videoCompleted,
            lastWatchedSeconds: _currentSeconds,
          );
      ref.invalidate(lessonProgressProvider(_key));
      ref.invalidate(courseProgressProvider(widget.slug));
      widget.onSaved();
      if (showMessage && mounted) {
        setState(() => _saveMessage = AppLocalizations.of(context).coursesProgressSaved);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _saveMessage = AppLocalizations.of(context).coursesProgressSaveFailed);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _toggleComplete() async {
    final wasCompleted = _videoCompleted;
    setState(() => _videoCompleted = !wasCompleted);
    if (!wasCompleted) {
      setState(() => _awardingXp = true);
      await ref.read(journeyRepositoryProvider).awardLessonVideoXp();
      if (mounted) setState(() => _awardingXp = false);
    }
    await _persist(showMessage: false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final transcript = widget.lesson.video?.transcript ?? const <CourseTranscriptSegment>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.lesson.video != null)
          CourseVideoPlayer(
            key: _playerKey,
            video: widget.lesson.video!,
            resumeSeconds: widget.initialProgress?.lastWatchedSeconds ?? 0,
            onProgress: (fraction) {
              if (fraction >= 0.8 && !_watchReady) setState(() => _watchReady = true);
            },
            onTimeUpdate: (seconds) {
              _currentSeconds = seconds;
              final idx = transcript.indexWhere((s) {
                final start = _seconds(s.start);
                final end = _seconds(s.end);
                return seconds >= start && seconds <= end;
              });
              if (idx != _activeTranscriptIndex && mounted) {
                setState(() => _activeTranscriptIndex = idx);
              }
            },
            onEnded: () {
              if (!_watchReady) setState(() => _watchReady = true);
            },
          ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: tokens.card,
            border: Border.all(color: tokens.border),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              if (_watchReady || _videoCompleted)
                AppButton(
                  label: _videoCompleted ? l10n.coursesLessonVideoDone : l10n.coursesLessonMarkVideoDone,
                  onPressed: _awardingXp ? null : _toggleComplete,
                  loading: _awardingXp,
                  variant: _videoCompleted ? AppButtonVariant.outline : AppButtonVariant.primary,
                )
              else if (widget.lesson.video != null)
                Builder(
                  builder: (context) {
                    final isDark =
                        Theme.of(context).brightness == Brightness.dark;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        // Amber hint pill: keep the light cream in light mode,
                        // switch to a translucent amber tint in dark mode.
                        color: isDark
                            ? const Color(0x33F59E0B)
                            : const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        l10n.coursesLessonWatchHint,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? const Color(0xFFFCD34D)
                              : const Color(0xFFB45309),
                        ),
                      ),
                    );
                  },
                ),
              OutlinedButton(
                onPressed: _saving ? null : () => _persist(),
                child: Text(_saving ? l10n.coursesLessonSaving : l10n.coursesProgressSaveCta),
              ),
              if (_saveMessage.isNotEmpty)
                Text(_saveMessage, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tokens.primary)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        CourseTranscriptPanel(
          transcript: transcript,
          activeIndex: _activeTranscriptIndex,
          onSeek: (seconds) => _playerKey.currentState?.seekTo(seconds),
        ),
        const SizedBox(height: 12),
        CourseNotesSection(slug: widget.slug, lessonKey: _key),
        const SizedBox(height: 12),
        CourseVocabPaginated(vocabularies: widget.lesson.vocabularies),
        const SizedBox(height: 12),
        CourseCommentSection(courseSlug: widget.slug, lessonNumber: widget.lesson.number),
      ],
    );
  }

  double _seconds(String value) {
    final parts = value.split(':').map((p) => double.tryParse(p) ?? 0).toList();
    if (parts.length == 3) return parts[0] * 3600 + parts[1] * 60 + parts[2];
    if (parts.length == 2) return parts[0] * 60 + parts[1];
    return double.tryParse(value) ?? 0;
  }
}
