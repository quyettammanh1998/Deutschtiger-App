import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../screens/settings/widgets/feedback_sheet.dart';
import 'more_features_catalog.dart';
import 'more_features_tile.dart';

/// "Tất cả tính năng" — centered scale-in dialog (web `more-features-sheet.tsx`
/// via `<BottomSheet centered>`). Replaces the old bottom `DraggableScrollable
/// Sheet` presentation to match web: rounded-2xl, max-width ~512, bg card,
/// backdrop black/40, bordered title row with an X close button, 4-col pastel
/// tile grid grouped under emoji-prefixed uppercase labels.
class MoreFeaturesDialog extends StatelessWidget {
  const MoreFeaturesDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showGeneralDialog<void>(
      context: context,
      barrierLabel: 'Tất cả tính năng',
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (context, animation, secondaryAnimation) =>
          const MoreFeaturesDialog(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 512),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: tokens.card,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: mediaQuery.size.height * 0.85,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _TitleBar(l10n: l10n, tokens: tokens),
                  Flexible(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        16,
                        16,
                        16,
                        16 + mediaQuery.padding.bottom,
                      ),
                      child: _Groups(l10n: l10n, tokens: tokens, isDark: isDark),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleBar extends StatelessWidget {
  const _TitleBar({required this.l10n, required this.tokens});

  final AppLocalizations l10n;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 12, 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: tokens.border.withValues(alpha: 0.5)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.moreFeaturesTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: tokens.foreground,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              PhosphorIcons.xBold,
              size: 20,
              color: tokens.mutedForeground,
            ),
            tooltip: l10n.close,
          ),
        ],
      ),
    );
  }
}

class _Groups extends StatelessWidget {
  const _Groups({required this.l10n, required this.tokens, required this.isDark});

  final AppLocalizations l10n;
  final AppTokens tokens;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final groups = moreFeatureGroups(
      l10n,
      // Tile `onTap` below already pops the dialog before invoking the
      // item's `action` — don't pop again here.
      onFeedback: () => showFeedbackSheet(context),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final group in groups) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 6),
            child: Text(
              '${group.emoji} ${group.label}'.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: tokens.mutedForeground,
              ),
            ),
          ),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.82,
            children: [
              for (final item in group.items)
                MoreFeaturesTile(
                  item: item,
                  isDark: isDark,
                  foreground: tokens.foreground,
                  onTap: () {
                    final path = item.path;
                    final action = item.action;
                    Navigator.of(context).pop();
                    if (action != null) {
                      action();
                    } else if (path != null) {
                      context.push(path);
                    }
                  },
                ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}
