import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../view_models/exam/exam_ecosystem_providers.dart';
import 'widgets/schedule/buddy_count_strip.dart';
import 'widgets/schedule/buddy_directory_tab.dart';
import 'widgets/schedule/my_registrations_tab.dart';
import 'widgets/schedule/schedule_pill_tabs.dart';

/// Lịch thi + đăng ký + tìm bạn ôn thi — web parity rebuild of
/// `exam-schedule-page.tsx`: pill tabs (list/mine), buddy count strip,
/// status-tab + filtered directory, and a registration manager.
///
/// Web's FAQ/testimonials/founder trust block (`ExamBuddyTrust`) and the
/// desktop side rail (`ExamBuddyAside`) are anonymous-visitor / desktop-only
/// concerns — this app is always logged-in and mobile-only, so they are
/// intentionally not ported; the rail's "my plan" summary + privacy note are
/// folded into the "mine" tab instead (`MyRegistrationsTab`).
class ExamScheduleScreen extends StatefulWidget {
  const ExamScheduleScreen({super.key});

  @override
  State<ExamScheduleScreen> createState() => _ExamScheduleScreenState();
}

class _ExamScheduleScreenState extends State<ExamScheduleScreen> {
  String _tab = 'list';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(title: Text(l10n.examScheduleTitle)),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer(
              builder: (context, ref, _) {
                final buddies = ref.watch(examBuddiesProvider);
                return buddies.maybeWhen(
                  data: (list) => BuddyCountStrip(buddies: list),
                  orElse: () => const SizedBox.shrink(),
                );
              },
            ),
            const SizedBox(height: 10),
            SchedulePillTabs<String>(
              value: _tab,
              onChanged: (v) => setState(() => _tab = v),
              tabs: [
                SchedulePillTab(value: 'list', label: l10n.examBuddyListTab),
                SchedulePillTab(
                  value: 'mine',
                  label: l10n.examMyRegistrationsTab,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _tab == 'list'
                  ? const BuddyDirectoryTab()
                  : const MyRegistrationsTab(),
            ),
          ],
        ),
      ),
    );
  }
}
