import 'package:flutter/material.dart';
import 'package:deutschtiger/core/theme/app_tokens.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';

/// Card nguồn luyện nghe trên hub (`/listening`) — thumbnail YouTube tuỳ chọn
/// + icon tile + đếm số video, hoặc pill "Sắp ra mắt" khi chưa active. Web
/// parity: `components/listening/listening-source-card.tsx`.
class ListeningSourceCard extends StatelessWidget {
  const ListeningSourceCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.thumbnailUrl,
    this.count,
    required this.active,
    this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final String? thumbnailUrl;
  final int? count;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Opacity(
      opacity: active ? 1 : 0.5,
      child: Material(
        color: tokens.card,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: active ? onTap : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (thumbnailUrl != null)
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    thumbnailUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => ColoredBox(color: tokens.muted),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: active ? tokens.primary.withValues(alpha: 0.1) : tokens.muted,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, size: 20, color: active ? tokens.primary : tokens.mutedForeground),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: tokens.foreground),
                                ),
                              ),
                              if (!active) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: tokens.muted,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    l10n.practiceModeComingSoon,
                                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: tokens.mutedForeground),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                          ),
                          if (active && count != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              l10n.listeningSourceVideoCount(count!),
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: tokens.primary),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
