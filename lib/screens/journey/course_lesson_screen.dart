import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../features/journey/domain/course_models.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/premium_gate_card.dart';
import '../../view_models/journey/journey_provider.dart';
import '../../widgets/common/async_state_views.dart';
import 'widgets/course_lesson_body.dart';
import 'widgets/course_lesson_strip.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

const _freeLessonLimit = 5;

/// Course lesson — video playback + lesson strip + transcript + vocab audio
/// + comments. Web parity `course-lesson-page.tsx`.
class CourseLessonScreen extends ConsumerWidget {
  const CourseLessonScreen({super.key, required this.slug, required this.lessonNumber});

  final String slug;
  final int lessonNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final key = LessonKey(slug, lessonNumber);
    final lessonAsync = ref.watch(lessonContentProvider(key));

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: lessonAsync.when(
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(onRetry: () => ref.invalidate(lessonContentProvider(key))),
          data: (lesson) => _LessonScaffoldBody(slug: slug, lessonKey: key, lesson: lesson),
        ),
      ),
    );
  }
}

class _LessonScaffoldBody extends ConsumerWidget {
  const _LessonScaffoldBody({required this.slug, required this.lessonKey, required this.lesson});
  final String slug;
  final LessonKey lessonKey;
  final DwLessonDetail lesson;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(lessonProgressProvider(lessonKey));
    return progressAsync.when(
      loading: () => const LoadingView(),
      error: (_, _) => _LessonContent(slug: slug, lessonKey: lessonKey, lesson: lesson, progress: null),
      data: (progress) =>
          _LessonContent(slug: slug, lessonKey: lessonKey, lesson: lesson, progress: progress),
    );
  }
}

class _LessonContent extends ConsumerWidget {
  const _LessonContent({
    required this.slug,
    required this.lessonKey,
    required this.lesson,
    required this.progress,
  });

  final String slug;
  final LessonKey lessonKey;
  final DwLessonDetail lesson;
  final CourseLessonProgress? progress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final detailAsync = ref.watch(courseDetailProvider(slug));
    final canAccessAllAsync = ref.watch(courseCanAccessAllProvider);
    final canAccessAll = canAccessAllAsync.maybeWhen(data: (v) => v, orElse: () => true);
    final allLessons = detailAsync.maybeWhen(
      data: (d) => ([...d.lessons]..sort((a, b) => a.number.compareTo(b.number))),
      orElse: () => const <DwCourseLessonSummary>[],
    );
    final lessonIndex = allLessons.indexWhere((l) => l.number == lesson.number);
    final isLocked = !canAccessAll && lessonIndex >= _freeLessonLimit;

    if (isLocked) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: PremiumGateCard(
          title: l10n.coursesLockedLessonTitle,
          description: l10n.coursesLockedLessonDescription,
          actionLabel: l10n.coursesUpsellCta,
          onAction: () => context.push('/settings/premium'),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(lessonProgressProvider(lessonKey));
        ref.invalidate(lessonContentProvider(lessonKey));
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => context.canPop() ? context.pop() : context.go('/course/$slug'),
                  icon: Icon(PhosphorIcons.arrowLeft, color: tokens.foreground),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.coursesLessonHeading(lesson.number.toString().padLeft(2, '0'), lesson.name),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: tokens.foreground),
                      ),
                      if ((lesson.description ?? '').isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            lesson.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (allLessons.length > 1)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CourseLessonStrip(
                  lessons: allLessons,
                  currentNumber: lesson.number,
                  lockedFrom: canAccessAll ? null : _freeLessonLimit,
                  onTap: (item) => context.pushReplacement('/course/$slug/lessons/${item.number}'),
                ),
              ),
            CourseLessonBody(
              key: ValueKey('$slug-${lesson.number}'),
              slug: slug,
              lesson: lesson,
              initialProgress: progress,
              onSaved: () {},
            ),
          ],
        ),
      ),
    );
  }
}
