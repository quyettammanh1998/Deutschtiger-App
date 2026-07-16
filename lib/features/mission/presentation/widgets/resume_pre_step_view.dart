import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../widgets/common/app_card.dart';
import '../../../../widgets/common/app_button.dart';
import '../../../../widgets/common/app_pill.dart';
import '../../domain/mission_models.dart';

/// Pre-session step for a mission with unfinished work to resume — mirrors
/// web `resume-pre-step.tsx`. Each item is a deep-link that navigates AWAY
/// from the session (e.g. back into an exam/video); rendered before the
/// round dispatch, never as a playable round.
class ResumePreStepView extends StatelessWidget {
  const ResumePreStepView({
    super.key,
    required this.items,
    required this.onContinue,
  });

  final List<MissionResumeTarget> items;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            Text(
              l10n.missionResumeTitle,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: tokens.foreground,
              ),
            ),
            const SizedBox(height: 12),
            for (final item in items) ...[
              _ResumeRow(item: item),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 8),
            Center(
              child: SizedBox(
                width: 220,
                child: AppGradientButton(
                  label: l10n.missionResumeContinueCta,
                  onPressed: onContinue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResumeRow extends StatelessWidget {
  const _ResumeRow({required this.item});

  final MissionResumeTarget item;

  @override
  Widget build(BuildContext context) {
    return AppCard.small(
      onTap: () => context.push(item.route),
      child: Row(
        children: [
          if (item.icon != null) ...[
            Text(item.icon!, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: context.tokens.foreground,
                  ),
                ),
                Text(
                  item.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: context.tokens.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          if (item.progressPct != null && item.progressPct! > 0) ...[
            const SizedBox(width: 8),
            AppPill.tinted(context, label: '${item.progressPct}%'),
          ],
        ],
      ),
    );
  }
}
