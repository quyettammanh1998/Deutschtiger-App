import 'package:flutter/material.dart';
import 'package:deutschtiger/core/theme/app_tokens.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';

/// Thanh phân trang "Trước / Trang x/y / Tiếp". Web parity:
/// `components/listening/video-pagination.tsx` (đơn giản hoá — bỏ dải số
/// trang giữa để vừa màn hình mobile hẹp).
class VideoPaginationBar extends StatelessWidget {
  const VideoPaginationBar({
    super.key,
    required this.page,
    required this.totalPages,
    required this.onChanged,
  });

  final int page;
  final int totalPages;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavButton(
            icon: Icons.chevron_left,
            label: l10n.examSetPagePrev,
            enabled: page > 1,
            onTap: () => onChanged(page - 1),
            tokens: tokens,
          ),
          Text(
            l10n.videoCollectionPageInfo(page, totalPages),
            style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
          ),
          _NavButton(
            icon: Icons.chevron_right,
            label: l10n.examSetPageNext,
            enabled: page < totalPages,
            onTap: () => onChanged(page + 1),
            tokens: tokens,
            trailingIcon: true,
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onTap,
    required this.tokens,
    this.trailingIcon = false,
  });

  final IconData icon;
  final String label;
  final bool enabled;
  final VoidCallback onTap;
  final AppTokens tokens;
  final bool trailingIcon;

  @override
  Widget build(BuildContext context) {
    final children = [
      if (!trailingIcon) Icon(icon, size: 16),
      if (!trailingIcon) const SizedBox(width: 2),
      Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      if (trailingIcon) const SizedBox(width: 2),
      if (trailingIcon) Icon(icon, size: 16),
    ];
    return Material(
      color: tokens.card,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: tokens.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Opacity(
            opacity: enabled ? 1 : 0.4,
            child: Row(mainAxisSize: MainAxisSize.min, children: children),
          ),
        ),
      ),
    );
  }
}
