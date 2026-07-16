import 'package:flutter/material.dart';

import '../../../data/practice/practice_result.dart';
import '../../../data/practice/practice_round_item.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/common/async_state_views.dart';
import '../../../widgets/common/game_shell.dart';
import 'practice_results_view.dart';

/// Shared chrome for the 4 standalone `/games/{cloze,flashcards,matching,
/// writing}` practice-view routes: [GameShell] header + async item loading +
/// results screen + restart — DRY wrapper so each route screen only supplies
/// its data source ([loadItems]) and its practice view ([buildView]).
///
/// This is what makes the 4 practice views (round type = [PracticeRoundItem])
/// reusable both here (standalone route, real corpus source) and in
/// deck-scoped `PracticeScreen` (P4), the mission runner (P3), and the
/// guided-lesson deck flow (P5) — every caller just needs a
/// `List<PracticeRoundItem>` and an `onComplete` callback.
class PracticeRouteScaffold extends StatefulWidget {
  const PracticeRouteScaffold({
    super.key,
    required this.title,
    required this.loadItems,
    required this.buildView,
    this.minItems = 2,
  });

  final String title;
  final Future<List<PracticeRoundItem>> Function() loadItems;
  final Widget Function(List<PracticeRoundItem> items, void Function(List<PracticeResultEntry>) onComplete) buildView;
  final int minItems;

  @override
  State<PracticeRouteScaffold> createState() => _PracticeRouteScaffoldState();
}

class _PracticeRouteScaffoldState extends State<PracticeRouteScaffold> {
  late Future<List<PracticeRoundItem>> _future;
  List<PracticeResultEntry>? _results;

  @override
  void initState() {
    super.initState();
    _future = widget.loadItems();
  }

  void _restart() {
    setState(() {
      _results = null;
      _future = widget.loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GameShell(
      title: widget.title,
      scrollable: false,
      child: FutureBuilder<List<PracticeRoundItem>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView();
          }
          if (snapshot.hasError) {
            return ErrorView(onRetry: _restart);
          }
          final items = snapshot.data ?? const [];
          if (items.length < widget.minItems) {
            return ErrorView(message: l10n.practiceNotEnoughWords, onRetry: _restart);
          }

          final results = _results;
          if (results != null) {
            return PracticeResultsView(
              results: results,
              onRestart: _restart,
              onBackToDeck: () => Navigator.of(context).pop(),
              backLabel: l10n.practiceBackToGames,
            );
          }

          return widget.buildView(items, (r) => setState(() => _results = r));
        },
      ),
    );
  }
}
