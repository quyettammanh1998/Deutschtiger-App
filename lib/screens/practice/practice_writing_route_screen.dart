import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import 'practice_items_loader.dart';
import 'widgets/practice_route_scaffold.dart';
import 'widgets/practice_writing_view.dart';

/// Standalone route `/games/writing` (web `practice-writing-page.tsx`) —
/// same path as the legacy `WritingWordGameScreen` it replaces, now serving
/// the shared [PracticeWritingView].
class PracticeWritingRouteScreen extends ConsumerWidget {
  const PracticeWritingRouteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return PracticeRouteScaffold(
      title: l10n.practiceModeWriting,
      loadItems: () => loadPracticeRoundItems(ref),
      buildView: (items, onComplete) => PracticeWritingView(items: items, onComplete: onComplete),
    );
  }
}
