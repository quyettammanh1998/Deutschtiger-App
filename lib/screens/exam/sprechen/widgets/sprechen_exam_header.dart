import 'package:flutter/material.dart';

import '../../../../core/icons/app_phosphor_icons.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Web parity: `sprechen-exam-header.tsx` — sticky top bar of
/// `SprechenExamMode`. Study tab shows "Lịch sử"/"Zurück"; practice tab
/// shows the countdown timer + ABGABE (submit) / EXIT actions.
class SprechenExamHeader extends StatelessWidget {
  const SprechenExamHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isPracticeTab,
    this.remaining,
    this.onHistory,
    this.onBack,
    this.onSubmit,
    this.onExit,
  });

  /// e.g. "Sprechen, TEIL 2 · Thema diskutieren — `slug`".
  final String title;

  /// e.g. "Teil 2 · 30 Punkte · 6 Min".
  final String subtitle;

  final bool isPracticeTab;
  final Duration? remaining;
  final VoidCallback? onHistory;
  final VoidCallback? onBack;
  final VoidCallback? onSubmit;
  final VoidCallback? onExit;

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.background,
        border: Border(bottom: BorderSide(color: tokens.border)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 10,
                        color: tokens.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (isPracticeTab) ...[
                if (remaining != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Restzeit',
                          style: TextStyle(
                            fontSize: 9,
                            color: tokens.mutedForeground,
                          ),
                        ),
                        Text(
                          _formatDuration(remaining!),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                _HeaderIconButton(
                  icon: AppPhosphorIcons.checkCircle,
                  color: const Color(0xFF2563EB),
                  onTap: onSubmit,
                ),
                const SizedBox(width: 6),
                _HeaderIconButton(
                  icon: Icons.logout,
                  color: tokens.destructive,
                  onTap: onExit,
                ),
              ] else ...[
                _HeaderOutlineButton(
                  icon: AppPhosphorIcons.clock,
                  label: AppLocalizations.of(context).sprechenHistoryButtonLabel,
                  onTap: onHistory,
                ),
                const SizedBox(width: 6),
                _HeaderOutlineButton(
                  icon: AppPhosphorIcons.arrowLeft,
                  label: 'Zurück',
                  onTap: onBack,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.color,
    this.onTap,
  });
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 18, color: Colors.white),
        ),
      ),
    );
  }
}

class _HeaderOutlineButton extends StatelessWidget {
  const _HeaderOutlineButton({
    required this.icon,
    required this.label,
    this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: tokens.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: tokens.foreground),
              const SizedBox(width: 4),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
