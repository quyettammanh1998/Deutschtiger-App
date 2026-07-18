import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/core/theme/app_tokens.dart';
import 'package:deutschtiger/view_models/providers.dart';

import 'widgets/social_avatar.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Duel match screen — UI shell only (web parity: `duel-play-page.tsx`,
/// `duel-score-overlay.tsx`, `duel-result-screen.tsx`: fixed score overlay,
/// red timer bar, DE word card, VS result card). No question loop, no
/// scoring, no opponent simulation — the previous mock question generator
/// and fake-opponent `Timer`-based scoring were removed, not replaced. The
/// realtime match loop is GĐ2 P3's responsibility; this screen is
/// unreachable in release (`ReleaseFeatureFlags.socialDuels` off).
class DuelPlayPage extends ConsumerWidget {
  const DuelPlayPage({super.key, this.opponent});

  /// Passed through from the lobby route (`extra`); kept `dynamic` since no
  /// real duel-room contract is wired yet — display-only when present.
  final dynamic opponent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final me = ref.watch(myProfileProvider).valueOrNull;

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Column(
          children: [
            _ScoreOverlay(myName: me?.displayName ?? '...', myAvatarUrl: me?.avatarUrl),
            ClipRRect(
              child: LinearProgressIndicator(
                value: 1,
                minHeight: 4,
                backgroundColor: tokens.muted,
                valueColor: const AlwaysStoppedAnimation(Color(0xFFEF4444)),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(PhosphorIcons.hourglass, size: 48, color: tokens.mutedForeground),
                      const SizedBox(height: 16),
                      Text(
                        'Trận đấu trực tiếp sắp ra mắt',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: tokens.foreground,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Vòng đấu trực tiếp đang được kết nối. Quay lại sau nhé!',
                        style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton(
                        onPressed: () => context.pop(),
                        child: const Text('Quay lại'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fixed top bar mirroring `duel-score-overlay.tsx` — my avatar/score vs
/// opponent avatar/score. Scores stay at 0 (no live loop wired yet).
class _ScoreOverlay extends StatelessWidget {
  const _ScoreOverlay({required this.myName, required this.myAvatarUrl});

  final String myName;
  final String? myAvatarUrl;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: tokens.card,
      child: Row(
        children: [
          SocialAvatar(displayName: myName, avatarUrl: myAvatarUrl, size: 36),
          const SizedBox(width: 8),
          Text(
            '0',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: tokens.primary),
          ),
          const Spacer(),
          Text(
            'vs',
            style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
          ),
          const Spacer(),
          Text(
            '0',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: tokens.mutedForeground),
          ),
          const SizedBox(width: 8),
          SocialAvatar(displayName: '?', avatarUrl: null, size: 36),
        ],
      ),
    );
  }
}
