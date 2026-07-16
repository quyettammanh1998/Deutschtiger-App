import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/learn/learn_provider.dart';

/// "Bản đồ năng lực" snapshot — full-card gradient button. Mirrors web
/// `capability-map-snapshot.tsx`: `from-orange-50 to-amber-50` card, `{pct}%`
/// header, progress bar on `bg-white/60`, up to 2 highlight can-do lines,
/// "Xem bản đồ →" footer. Data: [capabilityMapProvider] (shared with
/// `/learner-model`).
class JourneyCapabilityMapSnapshot extends ConsumerWidget {
  const JourneyCapabilityMapSnapshot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapAsync = ref.watch(capabilityMapProvider);
    return mapAsync.maybeWhen(
      data: (map) => map.total == 0
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _SnapshotCard(
                progressPct: map.progressPct,
                mastered: map.mastered,
                total: map.total,
                highlights: map.canDos
                    .where((c) => !c.isMastered)
                    .take(2)
                    .map((c) => c.labelVi)
                    .toList(),
              ),
            ),
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _SnapshotCard extends StatelessWidget {
  const _SnapshotCard({
    required this.progressPct,
    required this.mastered,
    required this.total,
    required this.highlights,
  });

  final int progressPct;
  final int mastered;
  final int total;
  final List<String> highlights;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push('/learner-model'),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      tokens.primary.withValues(alpha: 0.1),
                      const Color(0xFFD97706).withValues(alpha: 0.1),
                    ]
                  : const [Color(0xFFFFF7ED), Color(0xFFFFFBEB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.capabilityMapSnapshotTitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: tokens.foreground,
                    ),
                  ),
                  Text(
                    '$progressPct%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: tokens.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: (progressPct / 100).clamp(0.0, 1.0),
                  minHeight: 8,
                  backgroundColor: Colors.white.withValues(alpha: 0.6),
                  valueColor: AlwaysStoppedAnimation(tokens.primary),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.capabilityMapMasteredCount(mastered, total),
                style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
              ),
              for (final h in highlights) ...[
                const SizedBox(height: 4),
                Text(
                  '✨ $h',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: tokens.foreground),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                l10n.capabilityMapViewCta,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: tokens.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
