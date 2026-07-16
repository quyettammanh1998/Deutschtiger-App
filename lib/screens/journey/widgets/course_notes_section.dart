import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../repositories/journey/journey_repository.dart';
import '../../../view_models/journey/journey_provider.dart';

/// Free-text lesson notes card — web parity `CourseLessonNotes`.
class CourseNotesSection extends ConsumerStatefulWidget {
  const CourseNotesSection({super.key, required this.slug, required this.lessonKey});

  final String slug;
  final LessonKey lessonKey;

  @override
  ConsumerState<CourseNotesSection> createState() => _CourseNotesSectionState();
}

class _CourseNotesSectionState extends ConsumerState<CourseNotesSection> {
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.coursesNotesSaved)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.coursesNotesSaveFailed)));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final noteAsync = ref.watch(lessonNoteProvider(widget.lessonKey));

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tokens.card,
        border: Border.all(color: tokens.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: noteAsync.when(
        loading: () => const SizedBox(height: 48, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
        error: (_, _) => Text(l10n.coursesSignInRequired, style: TextStyle(color: tokens.mutedForeground, fontSize: 12)),
        data: (note) {
          if (!_hydrated) {
            _controller.text = note?.content ?? '';
            _hydrated = true;
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.coursesNotesLabel, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: tokens.foreground)),
              const SizedBox(height: 8),
              TextField(
                controller: _controller,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: l10n.coursesNotesHint,
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(l10n.coursesNotesSave),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
