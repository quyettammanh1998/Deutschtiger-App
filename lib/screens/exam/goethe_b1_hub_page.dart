import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/icons/app_phosphor_icons.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../view_models/exam/exam_ecosystem_providers.dart';
import 'widgets/hub/goethe_b1_hub_row_card.dart';
import 'widgets/readiness/readiness_band_card.dart';

/// Goethe B1 hub — web parity `goethe-b1-hub-page.tsx`
/// (`/exams/goethe-b1` + aliases): `ExamReadinessCard` + one `card divide-y`
/// with exactly 3 rows (official / writing / sprechen), all-Vietnamese
/// copy. Replaces the previous DIVERGENT body (English Lesen/Hören/
/// Schreiben/Sprechen section cards + a separate practice-materials block)
/// per `plans/reports/scout-260716-2324-ui-fidelity-exam-writing-report.md`.
class GoetheB1HubPage extends ConsumerWidget {
  const GoetheB1HubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.goetheB1HubTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: tokens.foreground,
                            ),
                          ),
                          Text(
                            l10n.goetheB1HubSubtitle,
                            style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _ReadinessSection(),
              const SizedBox(height: 16),
              GoetheB1HubRows(
                rows: [
                  GoetheB1HubRowCard(
                    icon: AppPhosphorIcons.bookOpen,
                    title: l10n.goetheB1HubOfficialTitle,
                    description: l10n.goetheB1HubOfficialDesc,
                    onTap: () => context.push('/exam/goethe-b1/exams'),
                  ),
                  GoetheB1HubRowCard(
                    icon: AppPhosphorIcons.pencilLine,
                    title: l10n.goetheB1HubWritingTitle,
                    description: l10n.goetheB1HubWritingDesc,
                    onTap: () => context.push('/exam/goethe-b1/writing'),
                  ),
                  GoetheB1HubRowCard(
                    icon: AppPhosphorIcons.microphone,
                    title: l10n.goetheB1HubSpeakingTitle,
                    description: l10n.goetheB1HubSpeakingDesc,
                    onTap: () => context.push('/exam/goethe-b1/speaking-topics'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Web spec: `ExamReadinessCard provider=goethe level=b1`. The live Flutter
/// readiness endpoint (`GET /exam-readiness`, `exam_ecosystem_providers.dart`
/// — already backs `ExamReadinessScreen`) is account-wide rather than
/// per-hub; reused here instead of the legacy `exam_provider.dart` +
/// `ExamRepository`, whose data is hardcoded in-memory and unsuitable for a
/// release-visible screen.
class _ReadinessSection extends ConsumerWidget {
  const _ReadinessSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readinessAsync = ref.watch(examReadinessProvider);
    return readinessAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      ),
      // Readiness is a nice-to-have summary — a fetch failure must not
      // block access to the 3 navigation rows below it.
      error: (_, _) => const SizedBox.shrink(),
      data: (snapshot) => snapshot.attemptCount == 0
          ? const ReadinessBandEmptyCard()
          : ReadinessBandCard(snapshot: snapshot),
    );
  }
}
