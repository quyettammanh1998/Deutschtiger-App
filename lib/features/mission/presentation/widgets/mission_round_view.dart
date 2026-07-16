import 'package:flutter/material.dart';

import '../../../../data/practice/practice_result.dart';
import '../../../../data/practice/practice_round_item.dart';
import '../../../../screens/practice/widgets/practice_listening_view.dart';
import '../../../../screens/practice/widgets/practice_writing_view.dart';
import '../../domain/mission_game_type.dart';

/// Dispatches the current mission round to the shared P4 practice-view round
/// type (mirrors web's unified `<PracticeSession>` engine, minus the modes
/// the mission rotation never emits — see [canonicalMissionGame]).
class MissionRoundView extends StatelessWidget {
  const MissionRoundView({
    super.key,
    required this.items,
    required this.game,
    required this.onComplete,
  });

  final List<PracticeRoundItem> items;
  final MissionCanonicalGame game;
  final void Function(List<PracticeResultEntry>) onComplete;

  @override
  Widget build(BuildContext context) {
    return switch (game) {
      MissionCanonicalGame.recognition =>
        PracticeListeningView(items: items, onComplete: onComplete),
      MissionCanonicalGame.production =>
        PracticeWritingView(items: items, onComplete: onComplete),
    };
  }
}
