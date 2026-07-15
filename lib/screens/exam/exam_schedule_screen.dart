import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../data/exam/exam_ecosystem_models.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/exam/exam_registration_repository.dart';
import '../../view_models/exam/exam_ecosystem_providers.dart';
import '../../widgets/common/async_state_views.dart';

const _examLevels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
const _examTypes = ['goethe', 'telc', 'osd', 'testdaf_dsh', 'ecl'];
const _examSkills = ['lesen', 'hoeren', 'schreiben', 'sprechen'];

/// Lịch thi + đăng ký + tìm bạn ôn thi (read-only match list).
/// Web tương đương gộp buddy list + registration form trong 1 trang
/// (`exam-schedule-page.tsx` = "Tìm bạn ôn thi").
///
/// GAP: không có nút "xem liên hệ" — `GET /user/exam-buddies/{id}/contact`
/// lộ SĐT/email/Facebook của người khác, cần report/block (GĐ2 P3) trước.
class ExamScheduleScreen extends StatefulWidget {
  const ExamScheduleScreen({super.key});

  @override
  State<ExamScheduleScreen> createState() => _ExamScheduleScreenState();
}

class _ExamScheduleScreenState extends State<ExamScheduleScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(
        title: Text(l10n.examScheduleTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.examBuddyListTab),
            Tab(text: l10n.examMyRegistrationsTab),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [_BuddyListTab(), _MyRegistrationsTab()],
      ),
    );
  }
}

class _BuddyListTab extends ConsumerWidget {
  const _BuddyListTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final buddies = ref.watch(examBuddiesProvider);
    return buddies.when(
      loading: () => const LoadingView(),
      error: (error, _) => ErrorView(
        message: l10n.couldNotLoadData,
        onRetry: () => ref.invalidate(examBuddiesProvider),
      ),
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Text(
              l10n.examBuddyListEmpty,
              style: const TextStyle(color: DesignTokens.mutedForeground),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(examBuddiesProvider);
            await ref.read(examBuddiesProvider.future);
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(
              DesignTokens.screenHorizontalPadding,
            ),
            itemCount: list.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: DesignTokens.spacingSm),
            itemBuilder: (context, index) => _BuddyCard(buddy: list[index]),
          ),
        );
      },
    );
  }
}

class _BuddyCard extends StatelessWidget {
  const _BuddyCard({required this.buddy});
  final ExamBuddy buddy;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(DesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: DesignTokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        border: Border.all(color: DesignTokens.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: DesignTokens.secondary,
            backgroundImage: buddy.avatarUrl.isNotEmpty
                ? NetworkImage(buddy.avatarUrl)
                : null,
            child: buddy.avatarUrl.isEmpty
                ? Text(
                    buddy.displayName.isNotEmpty
                        ? buddy.displayName[0].toUpperCase()
                        : '?',
                  )
                : null,
          ),
          const SizedBox(width: DesignTokens.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  buddy.displayName,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  '${buddy.examType.toUpperCase()} ${buddy.examLevel} · ${buddy.examDate}',
                  style: const TextStyle(color: DesignTokens.mutedForeground),
                ),
                if (buddy.location.isNotEmpty)
                  Text(
                    buddy.location,
                    style: const TextStyle(
                      color: DesignTokens.mutedForeground,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            buddy.daysUntil >= 0
                ? l10n.examBuddyDaysUntil(buddy.daysUntil)
                : l10n.examBuddyPast,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: DesignTokens.brand,
            ),
          ),
        ],
      ),
    );
  }
}

class _MyRegistrationsTab extends ConsumerWidget {
  const _MyRegistrationsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final regs = ref.watch(myExamRegistrationsProvider);
    return regs.when(
      loading: () => const LoadingView(),
      error: (error, _) => ErrorView(
        message: l10n.couldNotLoadData,
        onRetry: () => ref.invalidate(myExamRegistrationsProvider),
      ),
      data: (list) => ListView(
        padding: const EdgeInsets.all(DesignTokens.screenHorizontalPadding),
        children: [
          for (final reg in list)
            _RegistrationCard(
              registration: reg,
              onDeleted: () => ref.invalidate(myExamRegistrationsProvider),
            ),
          const SizedBox(height: DesignTokens.spacingMd),
          OutlinedButton.icon(
            onPressed: () => _openForm(context, ref, existing: null),
            icon: const Icon(Icons.add),
            label: Text(l10n.examRegistrationAdd),
          ),
        ],
      ),
    );
  }

  void _openForm(
    BuildContext context,
    WidgetRef ref, {
    required ExamRegistration? existing,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _RegistrationFormSheet(
        existing: existing,
        onSaved: () => ref.invalidate(myExamRegistrationsProvider),
      ),
    );
  }
}

class _RegistrationCard extends ConsumerWidget {
  const _RegistrationCard({required this.registration, required this.onDeleted});
  final ExamRegistration registration;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
      padding: const EdgeInsets.all(DesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: DesignTokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        border: Border.all(color: DesignTokens.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${registration.examType.toUpperCase()} ${registration.examLevel}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(registration.examDate),
                if (registration.skills.isNotEmpty)
                  Text(
                    registration.skills.join(', '),
                    style: const TextStyle(
                      color: DesignTokens.mutedForeground,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: l10n.examRegistrationDelete,
            onPressed: () async {
              try {
                await ref
                    .read(examRegistrationRepositoryProvider)
                    .delete(registration.id);
                onDeleted();
              } catch (_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.couldNotLoadData)),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

class _RegistrationFormSheet extends ConsumerStatefulWidget {
  const _RegistrationFormSheet({required this.existing, required this.onSaved});
  final ExamRegistration? existing;
  final VoidCallback onSaved;

  @override
  ConsumerState<_RegistrationFormSheet> createState() =>
      _RegistrationFormSheetState();
}

class _RegistrationFormSheetState
    extends ConsumerState<_RegistrationFormSheet> {
  late String _level = widget.existing?.examLevel ?? _examLevels[2];
  late String _type = widget.existing?.examType ?? _examTypes[0];
  late DateTime _date = _parseDate(widget.existing?.examDate) ?? DateTime.now();
  late final Set<String> _skills = {...(widget.existing?.skills ?? const [])};
  bool _saving = false;

  static DateTime? _parseDate(String? s) =>
      (s == null || s.isEmpty) ? null : DateTime.tryParse(s);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: DesignTokens.screenHorizontalPadding,
        right: DesignTokens.screenHorizontalPadding,
        top: DesignTokens.spacingLg,
        bottom: MediaQuery.of(context).viewInsets.bottom + DesignTokens.spacingLg,
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
            const SizedBox(height: DesignTokens.spacingMd),
            DropdownButtonFormField<String>(
              initialValue: _type,
              decoration: InputDecoration(labelText: l10n.examTypeLabel),
              items: [
                for (final t in _examTypes)
                  DropdownMenuItem(value: t, child: Text(t.toUpperCase())),
              ],
              onChanged: (v) => setState(() => _type = v ?? _type),
            ),
            DropdownButtonFormField<String>(
              initialValue: _level,
              decoration: InputDecoration(labelText: l10n.examLevelLabel),
              items: [
                for (final lvl in _examLevels)
                  DropdownMenuItem(value: lvl, child: Text(lvl)),
              ],
              onChanged: (v) => setState(() => _level = v ?? _level),
            ),
            const SizedBox(height: DesignTokens.spacingSm),
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
            const SizedBox(height: DesignTokens.spacingSm),
            Wrap(
              spacing: DesignTokens.spacingSm,
              children: [
                for (final skill in _examSkills)
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
            const SizedBox(height: DesignTokens.spacingLg),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
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
          SnackBar(content: Text(AppLocalizations.of(context).couldNotLoadData)),
        );
      }
    }
  }
}
