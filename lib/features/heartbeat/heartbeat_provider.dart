import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../view_models/providers.dart';

/// Heartbeat state — port of web `useHeartbeat()`.
class HeartbeatState {
  const HeartbeatState({
    this.streak = 0,
    this.streakClaimed = false,
    this.claimable = false,
    this.onlineSeconds = 0,
  });

  final int streak;
  final bool streakClaimed;
  final bool claimable;
  final int onlineSeconds;

  HeartbeatState copyWith({
    int? streak,
    bool? streakClaimed,
    bool? claimable,
    int? onlineSeconds,
  }) => HeartbeatState(
    streak: streak ?? this.streak,
    streakClaimed: streakClaimed ?? this.streakClaimed,
    claimable: claimable ?? this.claimable,
    onlineSeconds: onlineSeconds ?? this.onlineSeconds,
  );
}

/// Heartbeat notifier — POST /api/v1/heartbeat every 60s while app is foreground.
/// Mirrors `use-heartbeat.ts` web behaviour.
class HeartbeatNotifier extends AutoDisposeNotifier<HeartbeatState>
    with WidgetsBindingObserver {
  static const _interval = Duration(seconds: 60);

  Timer? _timer;

  @override
  HeartbeatState build() {
    WidgetsBinding.instance.addObserver(this);
    _startTimer();
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
      _stopTimer();
    });
    return const HeartbeatState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startTimer();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden) {
      _stopTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _beat(); // immediate ping on foreground
    _timer = Timer.periodic(_interval, (_) => _beat());
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _beat() async {
    try {
      final api = ref.read(apiClientProvider);
      final json = await api.post<Map<String, dynamic>>(
        '/user/heartbeat',
        body: const {},
      );
      state = state.copyWith(
        streak: (json['current_streak'] as num?)?.toInt() ?? state.streak,
        streakClaimed: json['streak_counted'] as bool? ?? state.streakClaimed,
        claimable: json['claimable'] as bool? ?? false,
        onlineSeconds: ((json['active_minutes'] as num?)?.toInt() ?? 0) * 60,
      );
    } catch (_) {
      // Heartbeat failure is non-fatal — silently ignore.
    }
  }

  void markStreakClaimed(int currentStreak) {
    state = state.copyWith(
      streakClaimed: true,
      claimable: false,
      streak: currentStreak,
    );
  }
}

final heartbeatProvider =
    NotifierProvider.autoDispose<HeartbeatNotifier, HeartbeatState>(
      HeartbeatNotifier.new,
    );

/// Convenience helper — claim streak via notifier.
void markStreakClaimed(WidgetRef ref, int currentStreak) {
  ref.read(heartbeatProvider.notifier).markStreakClaimed(currentStreak);
}
