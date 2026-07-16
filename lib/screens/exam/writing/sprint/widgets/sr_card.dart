import 'package:flutter/material.dart';

import '../../../../../features/writing/domain/sprint/sprint_types.dart';
import '../../../../../features/writing/domain/sprint/sr_keyword_match.dart';
import 'sr_card_back.dart';
import 'sr_card_front.dart';

/// SR card orchestrator — manages front/back phase transition + keyword
/// matching. Web parity `sr-card.tsx`. Caller MUST use `key: ValueKey(topic.slug)`
/// so this widget's internal state (phase, controllers) resets when the
/// active card changes.
class SrCard extends StatefulWidget {
  const SrCard({
    super.key,
    required this.topic,
    required this.cardNum,
    required this.total,
    required this.mode,
    required this.onRate,
    required this.onSkip,
  });

  final SprintTopicData topic;
  final int cardNum;
  final int total;
  final SRMode mode;
  final ValueChanged<SRRating> onRate;
  final VoidCallback onSkip;

  @override
  State<SrCard> createState() => _SrCardState();
}

class _SrCardState extends State<SrCard> {
  late final List<TextEditingController> _controllers = List.generate(3, (_) => TextEditingController());
  bool _revealed = false;
  List<bool> _matchResults = const [false, false, false];

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _check() {
    final outlineDe = widget.topic.speedrun?.outline3.de ?? const [];
    final fallback = widget.topic.speedrun?.generationCheckKeywords ?? const [];
    setState(() {
      _matchResults = List.generate(3, (i) {
        final expected = i < outlineDe.length ? outlineDe[i] : '';
        return matchBullet(_controllers[i].text, expected, fallback);
      });
      _revealed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_revealed) {
      return SrCardBack(
        topic: widget.topic,
        userBullets: _controllers.map((c) => c.text).toList(),
        matchResults: _matchResults,
        mode: widget.mode,
        onRate: widget.onRate,
      );
    }
    return SrCardFront(
      topic: widget.topic,
      cardNum: widget.cardNum,
      total: widget.total,
      controllers: _controllers,
      onCheck: _check,
      // Skip = rate "again" immediately, no back face shown.
      onSkip: widget.onSkip,
    );
  }
}
