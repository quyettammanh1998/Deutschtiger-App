import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_tokens.dart';
import '../../../data/learn/exam_goal_providers.dart';
import '../../../data/learn/learn_goal.dart';
import '../../../features/daily_path/presentation/daily_path_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/providers.dart';

/// Modal bottom sheet to create/edit the user's exam goal — mirrors web
/// `ExamGoalSetterCard`'s expanded form. Writes only `user_learning_goals`
/// via `POST /user/learn/goals`; never a public exam registration.
class ExamGoalSetterSheet extends ConsumerStatefulWidget {
  const ExamGoalSetterSheet({super.key, this.existing});

  /// Current goal when editing ("Đổi mục tiêu"); null for a fresh goal.
  final LearnGoal? existing;

  /// Opens the sheet. Pass [existing] to prefill the edit flow.
  static Future<void> show(BuildContext context, {LearnGoal? existing}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ExamGoalSetterSheet(existing: existing),
    );
  }

  @override
  ConsumerState<ExamGoalSetterSheet> createState() =>
      _ExamGoalSetterSheetState();
}

class _ExamGoalSetterSheetState extends ConsumerState<ExamGoalSetterSheet> {
  late String _providerId;
  late String _level;
  DateTime? _date;

  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _providerId = widget.existing?.targetProvider ?? 'goethe';
    _level = widget.existing?.targetLevel ?? 'A1';
    _date = widget.existing?.targetDate;
  }

  List<String> get _levels => levelsForProvider(_providerId);

  void _onProviderChanged(String providerId) {
    setState(() {
      _providerId = providerId;
      // Clamp to a level this provider actually offers exams for (e.g. telc
      // has no A1) so the goal never deep-links into an empty exam catalog.
      final allowed = levelsForProvider(providerId);
      if (!allowed.contains(_level)) _level = allowed.first;
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _date != null && !_date!.isBefore(today) ? _date! : today,
      firstDate: today,
      lastDate: today.add(const Duration(days: 3650)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _error = null);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = _date;
    if (date == null) {
      setState(() => _error = l10n.examGoalSetterDateRequired);
      return;
    }
    if (date.isBefore(today)) {
      setState(() => _error = l10n.examGoalSetterDateInPast);
      return;
    }

    setState(() => _saving = true);
    try {
      await ref
          .read(learnGoalRepositoryProvider)
          .upsertGoal(
            targetLevel: _level,
            targetProvider: _providerId,
            targetDate: _formatDate(date),
          );
      ref.invalidate(learnGoalProvider);
      ref.invalidate(dailyPathProvider);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = l10n.examGoalSetterSaveFailed;
      });
    }
  }

  static String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets),
      child: Container(
        decoration: const BoxDecoration(
          color: DesignTokens.card,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(DesignTokens.radiusLg),
          ),
        ),
        padding: const EdgeInsets.all(DesignTokens.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: SizedBox(
                width: 40,
                height: 4,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: DesignTokens.border),
                ),
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            Text(
              l10n.examGoalSetterTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            Text(
              l10n.examGoalSetterProviderLabel,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: DesignTokens.foreground,
              ),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _providerId,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: [
                for (final provider in examGoalProviders)
                  DropdownMenuItem(
                    value: provider.id,
                    child: Text(provider.label),
                  ),
              ],
              onChanged: (value) {
                if (value != null) _onProviderChanged(value);
              },
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            Text(
              l10n.examGoalSetterLevelLabel,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: DesignTokens.foreground,
              ),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _levels.contains(_level) ? _level : _levels.first,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: [
                for (final level in _levels)
                  DropdownMenuItem(value: level, child: Text(level)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _level = value);
              },
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            Text(
              l10n.examGoalSetterDateLabel,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: DesignTokens.foreground,
              ),
            ),
            const SizedBox(height: 6),
            OutlinedButton(
              onPressed: _pickDate,
              style: OutlinedButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                side: const BorderSide(color: DesignTokens.border),
              ),
              child: Text(
                _date == null ? l10n.examGoalSetterDateLabel : _formatDate(_date!),
                style: const TextStyle(color: DesignTokens.foreground),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: DesignTokens.spacingSm),
              Text(
                _error!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
            const SizedBox(height: DesignTokens.spacingMd),
            SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [DesignTokens.orange500, DesignTokens.orange600],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(DesignTokens.radius),
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(DesignTokens.radius),
                    onTap: _saving ? null : _submit,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Center(
                        child: Text(
                          _saving
                              ? l10n.examGoalSetterSaving
                              : l10n.examGoalSetterSave,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
