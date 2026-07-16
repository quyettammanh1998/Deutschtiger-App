import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/exam/exam_ecosystem_models.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repositories/exam/exam_registration_repository.dart';
import '../../../../view_models/exam/exam_ecosystem_providers.dart';
import '../../../../widgets/common/async_state_views.dart';
import 'registration_form_sheet.dart';

const _examTypeLabels = {
  'goethe': 'Goethe',
  'telc': 'telc',
  'osd': 'ÖSD',
  'testdaf_dsh': 'TestDaF/DSH',
  'ecl': 'ECL',
};

/// "Thông tin của tôi" tab — mirrors web `ExamBuddyForm`: lists the user's
/// own exam plans with edit/delete, plus a privacy note (web's
/// `ExamBuddyAside` `PrivacyNote`, inlined here since mobile has no side
/// rail).
class MyRegistrationsTab extends ConsumerWidget {
  const MyRegistrationsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final regs = ref.watch(myExamRegistrationsProvider);

    return regs.when(
      loading: () => const LoadingView(),
      error: (error, _) => ErrorView(
        message: l10n.couldNotLoadData,
        onRetry: () => ref.invalidate(myExamRegistrationsProvider),
      ),
      data: (list) => ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          if (list.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'Bạn chưa đăng ký lịch thi nào',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: tokens.foreground,
                  ),
                ),
              ),
            )
          else ...[
            Text(
              '${list.length} lịch thi · gần ngày thi nhất xếp trước',
              style: TextStyle(fontSize: 11.5, color: tokens.mutedForeground),
            ),
            const SizedBox(height: 8),
            for (final reg in list) ...[
              _RegistrationCard(
                registration: reg,
                onDeleted: () => ref.invalidate(myExamRegistrationsProvider),
              ),
              const SizedBox(height: 8),
            ],
          ],
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF97316), Color(0xFFEA580C)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _openForm(context, ref, existing: null),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: Text(
                        '+ ${l10n.examRegistrationAdd}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          DecoratedBox(
            decoration: BoxDecoration(
              color: tokens.muted,
              borderRadius: BorderRadius.circular(tokens.radius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontSize: 11.5,
                    color: tokens.mutedForeground,
                  ),
                  children: [
                    const TextSpan(
                      text: '🔒 Liên hệ của bạn (SĐT, email, Facebook) ',
                    ),
                    TextSpan(
                      text: 'ẩn mặc định',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: tokens.foreground,
                      ),
                    ),
                    const TextSpan(
                      text: ' — chỉ thành viên đã đăng ký mới xem được.',
                    ),
                  ],
                ),
              ),
            ),
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
      builder: (_) => RegistrationFormSheet(
        existing: existing,
        onSaved: () => ref.invalidate(myExamRegistrationsProvider),
      ),
    );
  }
}

class _RegistrationCard extends ConsumerWidget {
  const _RegistrationCard({
    required this.registration,
    required this.onDeleted,
  });
  final ExamRegistration registration;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(tokens.radius),
        border: Border.all(color: tokens.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_examTypeLabels[registration.examType] ?? registration.examType.toUpperCase()} · '
                    '${registration.examLevel}',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: tokens.foreground,
                    ),
                  ),
                  Text(
                    '📅 ${registration.examDate}',
                    style: TextStyle(color: tokens.mutedForeground),
                  ),
                  if (registration.skills.isNotEmpty)
                    Text(
                      registration.skills.join(' · '),
                      style: TextStyle(
                        color: tokens.mutedForeground,
                        fontSize: 11.5,
                      ),
                    ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (_) => RegistrationFormSheet(
                  existing: registration,
                  onSaved: onDeleted,
                ),
              ),
              child: const Text('Sửa'),
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
      ),
    );
  }
}
