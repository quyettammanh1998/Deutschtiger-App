import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/exam/exam_ecosystem_models.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repositories/exam/exam_registration_repository.dart';

const examLevelOptions = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
const examTypeOptions = ['goethe', 'telc', 'osd', 'testdaf_dsh', 'ecl'];
const examSkillOptions = ['lesen', 'hoeren', 'schreiben', 'sprechen'];

/// Bottom sheet to create/edit one exam registration ("plan") — mirrors web
/// `ExamBuddyPlanForm`. A learner may register several plans; the backend
/// rejects duplicates of the same provider+level+date.
class RegistrationFormSheet extends ConsumerStatefulWidget {
  const RegistrationFormSheet({
    super.key,
    required this.existing,
    required this.onSaved,
  });
  final ExamRegistration? existing;
  final VoidCallback onSaved;

  @override
  ConsumerState<RegistrationFormSheet> createState() =>
      _RegistrationFormSheetState();
}

class _RegistrationFormSheetState extends ConsumerState<RegistrationFormSheet> {
  late String _level = widget.existing?.examLevel ?? examLevelOptions[2];
  late String _type = widget.existing?.examType ?? examTypeOptions[0];
  late DateTime _date = _parseDate(widget.existing?.examDate) ?? DateTime.now();
  late final Set<String> _skills = {...(widget.existing?.skills ?? const [])};
  bool _saving = false;

  static DateTime? _parseDate(String? s) =>
      (s == null || s.isEmpty) ? null : DateTime.tryParse(s);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.examRegistrationFormTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _type,
              decoration: InputDecoration(labelText: l10n.examTypeLabel),
              items: [
                for (final t in examTypeOptions)
                  DropdownMenuItem(value: t, child: Text(t.toUpperCase())),
              ],
              onChanged: (v) => setState(() => _type = v ?? _type),
            ),
            DropdownButtonFormField<String>(
              initialValue: _level,
              decoration: InputDecoration(labelText: l10n.examLevelLabel),
              items: [
                for (final lvl in examLevelOptions)
                  DropdownMenuItem(value: lvl, child: Text(lvl)),
              ],
              onChanged: (v) => setState(() => _level = v ?? _level),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.examDateLabel),
              subtitle: Text(_date.toIso8601String().split('T').first),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 730)),
                );
                if (picked != null) setState(() => _date = picked);
              },
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final skill in examSkillOptions)
                  FilterChip(
                    label: Text(skill),
                    selected: _skills.contains(skill),
                    onSelected: (sel) => setState(() {
                      if (sel) {
                        _skills.add(skill);
                      } else {
                        _skills.remove(skill);
                      }
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: tokens.primary),
                onPressed: _saving || _skills.isEmpty ? null : _submit,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.examRegistrationSave),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    setState(() => _saving = true);
    final plan = ExamRegistration(
      id: widget.existing?.id ?? '',
      examLevel: _level,
      examType: _type,
      examDate: _date.toIso8601String().split('T').first,
      skills: _skills.toList(),
    );
    try {
      final repo = ref.read(examRegistrationRepositoryProvider);
      if (widget.existing != null) {
        await repo.update(widget.existing!.id, plan);
      } else {
        await repo.create(plan);
      }
      widget.onSaved();
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).couldNotLoadData),
          ),
        );
      }
    }
  }
}
