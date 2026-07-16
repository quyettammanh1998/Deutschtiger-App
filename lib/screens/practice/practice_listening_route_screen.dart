import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import 'practice_items_loader.dart';
import 'widgets/practice_listening_view.dart';
import 'widgets/practice_route_scaffold.dart';

/// Standalone route `/games/flashcards` (web `practice-listening-page.tsx`,
/// redirect target of the legacy `/games/flashcard`).
class PracticeListeningRouteScreen extends ConsumerWidget {
  const PracticeListeningRouteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return PracticeRouteScaffold(
      title: l10n.practiceModeListening,
      loadItems: () => loadPracticeRoundItems(ref),
      buildView: (items, onComplete) => PracticeListeningView(items: items, onComplete: onComplete),
    );
  }
}
