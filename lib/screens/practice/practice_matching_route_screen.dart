import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import 'practice_items_loader.dart';
import 'widgets/practice_matching_view.dart';
import 'widgets/practice_route_scaffold.dart';

/// Standalone route `/games/matching` (web `practice-matching-page.tsx`).
class PracticeMatchingRouteScreen extends ConsumerWidget {
  const PracticeMatchingRouteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return PracticeRouteScaffold(
      title: l10n.practiceModeMatching,
      loadItems: () => loadPracticeRoundItems(ref, limit: 24),
      buildView: (items, onComplete) => PracticeMatchingView(items: items, onComplete: onComplete),
    );
  }
}
