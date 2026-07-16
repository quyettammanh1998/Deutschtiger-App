import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import 'practice_items_loader.dart';
import 'widgets/practice_cloze_view.dart';
import 'widgets/practice_route_scaffold.dart';

/// Standalone route `/games/cloze` (web `practice-cloze-page.tsx`, redirect
/// target of the legacy `/games/fill-blank`) — same [PracticeClozeView] used
/// by deck practice, fed from the live learning-item corpus.
class PracticeClozeRouteScreen extends ConsumerWidget {
  const PracticeClozeRouteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return PracticeRouteScaffold(
      title: l10n.practiceModeCloze,
      loadItems: () => loadPracticeRoundItems(ref),
      buildView: (items, onComplete) => PracticeClozeView(items: items, onComplete: onComplete),
    );
  }
}
