import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';

const _kTigerFramePath = 'assets/images/game/tiger-frames';
const _kObstaclePath = 'assets/images/game/obstacles';
const _kRunFrameCount = 6; // frame-00..frame-05 = run cycle
const _kHitFrame = 'frame-06'; // collision pose

const _kObstacleAssets = [
  'cactus-removebg-preview',
  'cactus2-removebg-preview',
  'rock-removebg-preview',
  'crate-removebg-preview',
  'barrel-removebg-preview',
  'junk-removebg-preview',
  'fence-removebg-preview',
  'tractor-removebg-preview',
];

/// Deterministic pick from [_kObstacleAssets] for a given obstacle "seed" —
/// avoids importing `dart:math` `Random` at every rebuild for a purely
/// cosmetic choice; the caller passes a monotonically increasing spawn
/// counter as the seed so each new obstacle gets a different asset.
String obstacleAssetFor(int seed) =>
    _kObstacleAssets[seed % _kObstacleAssets.length];

/// Sprite/obstacle stage for Deutsch Runner — web parity: `deutsch-runner.tsx`
/// canvas (tiger sprite frames + obstacle images + scrolling background),
/// reimplemented as a cheap `AnimatedBuilder`-driven Stack (no canvas / game
/// engine package — ticker only drives a run-cycle frame index + a looping
/// background parallax offset).
///
/// This widget owns ONLY the visual stage; lane selection / quiz / scoring
/// stays in `runner_game_screen.dart`.
class RunnerSpriteStage extends StatefulWidget {
  const RunnerSpriteStage({
    super.key,
    required this.runnerLane,
    required this.obstacleLane,
    required this.obstacleActive,
    required this.obstacleSeed,
    required this.hit,
    required this.lives,
    required this.score,
    required this.timeLeft,
    required this.onLaneTap,
  });

  /// 1-3.
  final int runnerLane;
  final int obstacleLane;
  final bool obstacleActive;
  final int obstacleSeed;
  final bool hit;
  final int lives;
  final int score;
  final int timeLeft;
  final ValueChanged<int> onLaneTap;

  @override
  State<RunnerSpriteStage> createState() => _RunnerSpriteStageState();
}

class _RunnerSpriteStageState extends State<RunnerSpriteStage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return ClipRRect(
      borderRadius: BorderRadius.circular(tokens.radius),
      child: SizedBox(
        height: 240,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _ScrollingBackground(ticker: _ticker),
            Positioned(
              left: 12,
              right: 12,
              top: 8,
              child: _Hud(
                lives: widget.lives,
                score: widget.score,
                timeLeft: widget.timeLeft,
              ),
            ),
            for (var lane = 1; lane <= 3; lane++)
              Positioned(
                left: 0,
                right: 0,
                top: 44.0 + (lane - 1) * 58,
                height: 52,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                  ),
                ),
              ),
            AnimatedBuilder(
              animation: _ticker,
              builder: (context, _) {
                final frameIndex = widget.hit
                    ? null
                    : (_ticker.value * _kRunFrameCount).floor() %
                          _kRunFrameCount;
                final asset = widget.hit
                    ? '$_kTigerFramePath/$_kHitFrame.webp'
                    : '$_kTigerFramePath/frame-0$frameIndex.webp';
                return Positioned(
                  left: 46,
                  top: 44.0 + (widget.runnerLane - 1) * 58 + 2,
                  child: Image.asset(asset, width: 48, height: 48),
                );
              },
            ),
            if (widget.obstacleActive && widget.obstacleLane > 0)
              Positioned(
                right: 46,
                top: 44.0 + (widget.obstacleLane - 1) * 58 + 4,
                child: Image.asset(
                  '$_kObstaclePath/${obstacleAssetFor(widget.obstacleSeed)}.webp',
                  width: 44,
                  height: 44,
                ),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var lane = 1; lane <= 3; lane++)
                    _LaneButton(
                      lane: lane,
                      isSelected: widget.runnerLane == lane,
                      onTap: () => widget.onLaneTap(lane),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScrollingBackground extends StatelessWidget {
  const _ScrollingBackground({required this.ticker});

  final AnimationController ticker;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF312E81), Color(0xFF4338CA), Color(0xFF818CF8)],
        ),
      ),
      child: AnimatedBuilder(
        animation: ticker,
        builder: (context, _) {
          return OverflowBox(
            maxWidth: double.infinity,
            alignment: Alignment.centerLeft,
            child: Transform.translate(
              offset: Offset(-ticker.value * 400, 0),
              child: Row(
                children: List.generate(
                  3,
                  (_) => Image.asset(
                    '$_kObstaclePath/game-bg.webp',
                    width: 400,
                    height: 240,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Hud extends StatelessWidget {
  const _Hud({required this.lives, required this.score, required this.timeLeft});

  final int lives;
  final int score;
  final int timeLeft;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: List.generate(
            3,
            (i) => Text(
              i < lives ? '♥' : '♡',
              style: TextStyle(
                fontSize: 16,
                color: i < lives ? Colors.pinkAccent : Colors.white38,
              ),
            ),
          ),
        ),
        _Chip(text: '$score điểm'),
        _Chip(text: '${timeLeft}s', urgent: timeLeft <= 10),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text, this.urgent = false});

  final String text;
  final bool urgent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: urgent
            ? Colors.red.withValues(alpha: 0.85)
            : Colors.indigo.shade900.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _LaneButton extends StatelessWidget {
  const _LaneButton({
    required this.lane,
    required this.isSelected,
    required this.onTap,
  });

  final int lane;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.amber.shade600
              : Colors.black.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        ),
        child: Center(
          child: Text(
            '$lane',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}
