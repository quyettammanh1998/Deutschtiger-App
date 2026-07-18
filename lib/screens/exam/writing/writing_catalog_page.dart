import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import 'widgets/hub/examiner_rubric_sheet.dart';
import 'widgets/hub/writing_community_tab.dart';
import 'widgets/hub/writing_hub_tabs.dart';
import 'widgets/hub/writing_start_tab.dart';
import 'widgets/hub/writing_submissions_tab.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// `writing-catalog` (`/luyen-viet`) — unified writing hub: 3 tabs (Bắt đầu/
/// Bài của tôi/Cộng đồng), rubric sheet. Web parity `WritingCatalogPage`.
///
/// DEVIATION: web's `PageIntro pageKey="luyen-viet"` orienting strip is
/// omitted — `PageIntro` is a P1 primitive under `lib/shared/widgets/`
/// (not in this phase's file ownership to newly wire without risking a
/// contested-file edit); the tab bar + rubric sheet cover the same "what is
/// this page" job. Named follow-up.
class WritingCatalogPage extends StatefulWidget {
  const WritingCatalogPage({super.key});

  @override
  State<WritingCatalogPage> createState() => _WritingCatalogPageState();
}

class _WritingCatalogPageState extends State<WritingCatalogPage> {
  WritingHubTab _tab = WritingHubTab.start;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                IconButton(icon: const Icon(PhosphorIcons.arrowLeft), onPressed: () => context.pop()),
                Expanded(
                  child: Text(
                    l10n.writingHubTitle,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: tokens.foreground),
                  ),
                ),
                OutlinedButton(
                  onPressed: () => showExaminerRubricSheet(context),
                  child: Text(l10n.writingHubRubricButton, style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            WritingHubTabsBar(active: _tab, onChange: (t) => setState(() => _tab = t)),
            const SizedBox(height: 16),
            switch (_tab) {
              WritingHubTab.start => const WritingStartTab(),
              WritingHubTab.my => WritingSubmissionsTab(
                  onStartPractice: () => setState(() => _tab = WritingHubTab.start),
                ),
              WritingHubTab.community => const WritingCommunityTab(),
            },
          ],
        ),
      ),
    );
  }
}
