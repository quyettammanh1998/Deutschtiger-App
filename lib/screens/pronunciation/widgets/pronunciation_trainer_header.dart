import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// `h-9 w-9` bordered back button + title row — web parity: the header row
/// repeated at the top of every pronunciation screen (hub + 4 trainers +
/// minimal-pairs).
class PronunciationTrainerHeader extends StatelessWidget {
  const PronunciationTrainerHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.trailing,
  });

  final String title;
  final String? subtitle;

  /// Defaults to popping the route, falling back to `/pronunciation`.
  final VoidCallback? onBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Row(
      children: [
        Material(
          color: tokens.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: tokens.border),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap:
                onBack ??
                () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    context.go('/pronunciation');
                  }
                },
            child: SizedBox(
              width: 36,
              height: 36,
              child: Icon(
                PhosphorIcons.caretLeft,
                size: 18,
                color: tokens.mutedForeground,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: tokens.foreground,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: tokens.mutedForeground,
                  ),
                ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
