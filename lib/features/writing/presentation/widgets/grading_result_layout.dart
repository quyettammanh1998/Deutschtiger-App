import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';

/// Shared "divider above a padded block" wrapper used by every section of
/// [GradingResultCard] — kept in its own file (no cross-imports between the
/// card/bars/lists sibling files) to avoid an import cycle.
Widget sectionBorder(BuildContext context, {required Widget child}) {
  final tokens = context.tokens;
  return DecoratedBox(
    decoration: BoxDecoration(border: Border(top: BorderSide(color: tokens.border))),
    child: Padding(padding: const EdgeInsets.all(16), child: child),
  );
}

/// Uppercase 11px muted section label — e.g. "CHI TIẾT ĐÁNH GIÁ".
Widget sectionLabel(BuildContext context, String text) {
  final tokens = context.tokens;
  return Text(
    text.toUpperCase(),
    style: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.4,
      color: tokens.mutedForeground,
    ),
  );
}
