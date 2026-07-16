import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';

/// Static SRS explainer copy. Mirror web `stats-spaced-repetition-card.tsx`.
class StatsSpacedRepetitionCard extends StatelessWidget {
  const StatsSpacedRepetitionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    return Text(
      l10n.statsSpacedRepetitionBody,
      style: TextStyle(
        fontSize: 13,
        height: 1.5,
        color: tokens.mutedForeground,
      ),
    );
  }
}
