import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:deutschtiger/core/theme/app_tokens.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';

import 'video_collection_models.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Widget "chrome" nhỏ dùng trong [VideoCollectionLayout] (breadcrumb, header
/// card, ô tìm kiếm, tab bar, empty/error state) — tách riêng để giữ file
/// layout chính dưới 200 dòng.

class VideoCollectionBreadcrumb extends StatelessWidget {
  const VideoCollectionBreadcrumb({super.key, required this.label, required this.tokens});
  final String label;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => context.canPop() ? context.pop() : context.go('/listening'),
          child: Icon(PhosphorIcons.arrowLeft, size: 18, color: tokens.mutedForeground),
        ),
        const SizedBox(width: 6),
        Text(AppLocalizations.of(context).listeningPageTitle, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
        Icon(PhosphorIcons.caretRight, size: 14, color: tokens.mutedForeground),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tokens.foreground),
          ),
        ),
      ],
    );
  }
}

class VideoCollectionHeaderCard extends StatelessWidget {
  const VideoCollectionHeaderCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.tokens,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tokens.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: accentColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: tokens.foreground)),
                Text(subtitle, style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VideoCollectionSearchField extends StatelessWidget {
  const VideoCollectionSearchField({super.key, required this.hint, required this.tokens, required this.onChanged});
  final String hint;
  final AppTokens tokens;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: tokens.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: tokens.border)),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(fontSize: 13, color: tokens.foreground),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 13, color: tokens.mutedForeground),
          prefixIcon: Icon(PhosphorIcons.magnifyingGlass, size: 18, color: tokens.mutedForeground),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );
  }
}

class VideoCollectionTabBar extends StatelessWidget {
  const VideoCollectionTabBar({super.key, required this.tabs, required this.activeKey, required this.onChanged, required this.tokens});
  final List<VideoCollectionTab> tabs;
  final String activeKey;
  final ValueChanged<String> onChanged;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: tabs.map((t) {
        final active = t.key == activeKey;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(t.key),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: active ? tokens.primary : tokens.muted.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${t.label} (${t.videos.length})',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: active ? Colors.white : tokens.mutedForeground),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class VideoCollectionEmptyBox extends StatelessWidget {
  const VideoCollectionEmptyBox({super.key, required this.tokens});
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(border: Border.all(color: tokens.border), borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(l10n.videoCollectionEmptyTitle, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tokens.foreground)),
          const SizedBox(height: 4),
          Text(l10n.videoCollectionEmptyHint, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
        ],
      ),
    );
  }
}

class VideoCollectionErrorBox extends StatelessWidget {
  const VideoCollectionErrorBox({super.key, required this.text, required this.tokens});
  final String text;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: tokens.destructive.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
      child: Text(text, style: TextStyle(fontSize: 13, color: tokens.destructive)),
    );
  }
}
