import 'package:flutter/material.dart';
import 'package:deutschtiger/core/icons/app_phosphor_icons.dart';

import '../../core/release/release_feature_flags.dart';
import '../../core/theme/app_tokens.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/game_completion_screen.dart';

/// Uniform chrome for `/games/*` screens — web parity: §0 "cross-cutting"
/// pattern in `plans/reports/scout-260716-2324-ui-fidelity-flashcard-
/// grammar-games-report.md` (no `AppBar`; scrollable `bg-background px-4
/// pt-3 pb-5` page with an in-content header row: 36px bordered back button
/// + `text-xl font-bold` title + optional right slot).
///
/// This is a SHELL only — no mock game data, no game logic. Individual game
/// screens (P4/P7/etc.) own their body content via [child] and wire real
/// state into [onExit]/[trailing].
class GameShell extends StatelessWidget {
  const GameShell({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
    this.exitGuard = true,
    this.exitConfirmMessage = 'Bạn có chắc muốn thoát? Tiến trình chưa lưu sẽ mất.',
    this.onExit,
    this.scrollable = true,
  });

  final String title;
  final Widget child;

  /// Right-slot content in the header row (e.g. ShuffleToggleButton, level
  /// chip on web).
  final Widget? trailing;

  /// When true (default), back navigation (app-bar back button + Android
  /// system back) shows a destructive confirm dialog first — web parity:
  /// `usePracticeExitGuard`.
  final bool exitGuard;
  final String exitConfirmMessage;

  /// Called after the user confirms exit (or immediately if [exitGuard] is
  /// false). Defaults to `Navigator.pop`.
  final VoidCallback? onExit;

  /// Wrap [child] in a `SingleChildScrollView` (web pages are plain
  /// scrollable containers, not tab views) — disable for games that manage
  /// their own scrolling/canvas.
  final bool scrollable;

  Future<bool> _confirmExit(BuildContext context) async {
    if (!exitGuard) return true;
    return showConfirmDialog(
      context,
      title: 'Thoát bài luyện tập?',
      message: exitConfirmMessage,
      confirmLabel: 'Thoát',
      cancelLabel: 'Ở lại',
      destructive: true,
    );
  }

  void _handleExit(BuildContext context) {
    if (onExit != null) {
      onExit!();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final body = scrollable ? SingleChildScrollView(child: child) : child;

    return PopScope(
      canPop: !exitGuard,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final confirmed = await _confirmExit(context);
        if (confirmed && context.mounted) _handleExit(context);
      },
      child: Scaffold(
        backgroundColor: tokens.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _BackButton(onTap: () async {
                      final confirmed = await _confirmExit(context);
                      if (confirmed && context.mounted) _handleExit(context);
                    }),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: tokens.foreground,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (trailing != null) ...[const SizedBox(width: 12), trailing!],
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(child: body),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Pushes the shared [GameCompletionScreen] (confetti + score card) —
  /// reused as-is, not reimplemented here. See that file for the XP-pill /
  /// retry-wrong web-parity gaps tracked separately (out of this phase's
  /// ownership).
  static Future<void> showCompletion(
    BuildContext context, {
    required int score,
    required int total,
    required VoidCallback onPlayAgain,
    required VoidCallback onGoHome,
    String? completionTitle,
    String? subtitle,
    String? accuracyLabel,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GameCompletionScreen(
          score: score,
          total: total,
          onPlayAgain: onPlayAgain,
          onGoHome: onGoHome,
          title: completionTitle,
          subtitle: subtitle,
          accuracyLabel: accuracyLabel,
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Material(
      color: tokens.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: tokens.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(
            AppPhosphorIcons.caretLeft,
            size: 20,
            color: tokens.foreground,
          ),
        ),
      ),
    );
  }
}

/// Web parity: `src/components/payment/game-wall-overlay.tsx` — shown when
/// a free user exhausts their daily plays for a game.
///
/// Gated behind [ReleaseFeatureFlags.premium] (default OFF) — renders
/// nothing until GĐ2 wires real play-count/premium data, so callers can
/// integrate this now without risking a half-built paywall shipping early.
class GameWallOverlay extends StatelessWidget {
  const GameWallOverlay({
    super.key,
    required this.gameName,
    required this.playsUsed,
    required this.maxPlays,
    required this.onClose,
    required this.onUpgrade,
  });

  final String gameName;
  final int playsUsed;
  final int maxPlays;
  final VoidCallback onClose;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    if (!ReleaseFeatureFlags.premium) return const SizedBox.shrink();
    final tokens = context.tokens;

    return Material(
      color: tokens.background.withValues(alpha: 0.95),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.amber.withValues(alpha: 0.15),
                  child: Icon(
                    AppPhosphorIcons.gameController,
                    size: 32,
                    color: Colors.amber.shade700,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Hết lượt chơi $gameName!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: tokens.foreground,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Bạn đã chơi $playsUsed/$maxPlays lượt $gameName hôm nay',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: tokens.mutedForeground),
                ),
                const SizedBox(height: 16),
                _MidnightCountdownChip(tokens: tokens),
                const SizedBox(height: 16),
                _UpgradeCta(onTap: onUpgrade),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: onClose,
                  child: Text('Quay lại', style: TextStyle(color: tokens.mutedForeground)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Web parity: `src/components/payment/free-limit-overlay.tsx` — shown when
/// a free user exhausts a daily action limit (non-game features). Same
/// premium-flag gate as [GameWallOverlay].
class FreeLimitOverlay extends StatelessWidget {
  const FreeLimitOverlay({
    super.key,
    required this.used,
    required this.max,
    required this.onUpgrade,
    this.onClose,
  });

  final int used;
  final int max;
  final VoidCallback onUpgrade;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    if (!ReleaseFeatureFlags.premium) return const SizedBox.shrink();
    final tokens = context.tokens;

    return Material(
      color: tokens.background.withValues(alpha: 0.95),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.amber.withValues(alpha: 0.15),
                  child: const Text('🔒', style: TextStyle(fontSize: 28)),
                ),
                const SizedBox(height: 16),
                Text(
                  'Hết lượt miễn phí!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: tokens.foreground,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Bạn đã dùng $used/$max lượt hôm nay. Nâng cấp để không giới hạn.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: tokens.mutedForeground),
                ),
                const SizedBox(height: 16),
                _UpgradeCta(onTap: onUpgrade),
                if (onClose != null) ...[
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: onClose,
                    child: Text('Quay lại', style: TextStyle(color: tokens.mutedForeground)),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MidnightCountdownChip extends StatelessWidget {
  const _MidnightCountdownChip({required this.tokens});

  final AppTokens tokens;

  /// Ms until midnight UTC+7 — matches web `getMsUntilMidnight()`.
  static Duration _untilMidnightVn() {
    final nowUtc = DateTime.now().toUtc();
    final vn = nowUtc.add(const Duration(hours: 7));
    final tomorrow = DateTime.utc(vn.year, vn.month, vn.day).add(const Duration(days: 1));
    return tomorrow.difference(vn);
  }

  @override
  Widget build(BuildContext context) {
    final d = _untilMidnightVn();
    final label = '${d.inHours}h ${d.inMinutes.remainder(60)}m';
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tokens.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AppPhosphorIcons.clock,
              size: 16,
              color: tokens.mutedForeground,
            ),
            const SizedBox(width: 8),
            Text(
              'Lượt mới sau $label',
              style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpgradeCta extends StatelessWidget {
  const _UpgradeCta({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.orange.shade600,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          child: const Text(
            'Nâng cấp Lifetime',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
