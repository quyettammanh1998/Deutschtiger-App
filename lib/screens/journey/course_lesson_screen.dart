import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../features/journey/domain/course_models.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/journey/journey_repository.dart';
import '../../view_models/journey/journey_provider.dart';
import '../../widgets/common/async_state_views.dart';

/// Course lesson content — video (self-hosted only; YouTube parity belongs
/// to the media/video-library phase), vocabulary, exercise count and the
/// user's notes + mark-complete toggle. Mirrors web `course-lesson-page.tsx`
/// minus the interactive exercise engine.
class CourseLessonScreen extends ConsumerWidget {
  const CourseLessonScreen({
    super.key,
    required this.slug,
    required this.lessonNumber,
  });

  final String slug;
  final int lessonNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final key = LessonKey(slug, lessonNumber);
    final lessonAsync = ref.watch(lessonContentProvider(key));

    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(
        backgroundColor: DesignTokens.background,
        title: lessonAsync.maybeWhen(
          data: (lesson) => Text(lesson.nameVi ?? lesson.name),
          orElse: () => Text(l10n.coursesHubTitle),
        ),
      ),
      body: SafeArea(
        child: lessonAsync.when(
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(
            onRetry: () => ref.invalidate(lessonContentProvider(key)),
          ),
          data: (lesson) => _LessonBody(slug: slug, key_: key, lesson: lesson),
        ),
      ),
    );
  }
}

class _LessonBody extends ConsumerWidget {
  const _LessonBody({required this.slug, required this.key_, required this.lesson});

  final String slug;
  final LessonKey key_;
  final DwLessonDetail lesson;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      children: [
        _VideoPlaceholder(video: lesson.video, l10n: l10n),
        const SizedBox(height: DesignTokens.spacingMd),
        _MarkCompleteButton(slug: slug, lessonKey: key_),
        if (lesson.exerciseCount > 0) ...[
          const SizedBox(height: DesignTokens.spacingSm),
          Text(
            l10n.coursesExercisesHint(lesson.exerciseCount),
            style: const TextStyle(color: DesignTokens.mutedForeground),
          ),
        ],
        if (lesson.vocabularies.isNotEmpty) ...[
          const SizedBox(height: DesignTokens.spacingLg),
          Text(
            l10n.coursesVocabularyTitle,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          for (final item in lesson.vocabularies) _VocabRow(item: item),
        ],
        const SizedBox(height: DesignTokens.spacingLg),
        _NotesSection(slug: slug, lessonKey: key_),
      ],
    );
  }
}

class _VideoPlaceholder extends StatelessWidget {
  const _VideoPlaceholder({required this.video, required this.l10n});

  final DwLessonVideo? video;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    if (video == null) return const SizedBox.shrink();
    return ClipRRect(
      borderRadius: BorderRadius.circular(DesignTokens.radius),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (video!.poster != null && video!.poster!.isNotEmpty)
              Image.network(
                video!.poster!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(color: DesignTokens.muted),
              )
            else
              Container(color: DesignTokens.muted),
            Container(color: Colors.black.withValues(alpha: 0.35)),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(DesignTokens.spacingMd),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.ondemand_video, color: Colors.white, size: 36),
                    const SizedBox(height: DesignTokens.spacingXs),
                    Text(
                      l10n.coursesVideoWebOnly,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarkCompleteButton extends ConsumerWidget {
  const _MarkCompleteButton({required this.slug, required this.lessonKey});

  final String slug;
  final LessonKey lessonKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final progressAsync = ref.watch(lessonProgressProvider(lessonKey));

    return progressAsync.when(
      loading: () => const SizedBox(
        height: 48,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => Text(
        l10n.coursesSignInRequired,
        style: const TextStyle(color: DesignTokens.mutedForeground),
      ),
      data: (progress) {
        final isCompleted = progress?.videoCompleted ?? false;
        return FilledButton.icon(
          onPressed: () async {
            final repo = ref.read(journeyRepositoryProvider);
            try {
              await repo.upsertLessonProgress(
                slug: slug,
                lessonNumber: lessonKey.lessonNumber,
                videoCompleted: !isCompleted,
              );
              ref.invalidate(lessonProgressProvider(lessonKey));
              ref.invalidate(courseProgressProvider(slug));
            } catch (_) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.coursesNotesSaveFailed)),
                );
              }
            }
          },
          style: FilledButton.styleFrom(
            backgroundColor: isCompleted ? DesignTokens.success : DesignTokens.tigerOrange,
          ),
          icon: Icon(isCompleted ? Icons.check_circle : Icons.check_circle_outline),
          label: Text(isCompleted ? l10n.coursesMarkIncomplete : l10n.coursesMarkComplete),
        );
      },
    );
  }
}

class _VocabRow extends StatelessWidget {
  const _VocabRow({required this.item});
  final DwVocabularyItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingXs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              item.german,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: DesignTokens.spacingSm),
          Expanded(
            child: Text(
              item.vietnamese ?? item.english ?? '',
              style: const TextStyle(color: DesignTokens.mutedForeground),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotesSection extends ConsumerStatefulWidget {
  const _NotesSection({required this.slug, required this.lessonKey});

  final String slug;
  final LessonKey lessonKey;

  @override
  ConsumerState<_NotesSection> createState() => _NotesSectionState();
}

class _NotesSectionState extends ConsumerState<_NotesSection> {
  final _controller = TextEditingController();
  bool _hydrated = false;
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _saving = true);
    try {
      await ref.read(journeyRepositoryProvider).upsertLessonNote(
            slug: widget.slug,
            lessonNumber: widget.lessonKey.lessonNumber,
            content: _controller.text,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.coursesNotesSaved)),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.coursesNotesSaveFailed)),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final noteAsync = ref.watch(lessonNoteProvider(widget.lessonKey));

    return noteAsync.when(
      loading: () => const SizedBox(
        height: 48,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => Text(
        l10n.coursesSignInRequired,
        style: const TextStyle(color: DesignTokens.mutedForeground),
      ),
      data: (note) {
        if (!_hydrated) {
          _controller.text = note?.content ?? '';
          _hydrated = true;
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.coursesNotesLabel,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: DesignTokens.spacingSm),
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: l10n.coursesNotesHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: DesignTokens.spacingSm),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.coursesNotesSave),
              ),
            ),
          ],
        );
      },
    );
  }
}
