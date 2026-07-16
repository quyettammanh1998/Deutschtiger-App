import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/data/notifications/notification_models.dart';
import 'package:deutschtiger/repositories/notifications/notifications_repository.dart';

/// List of notifications for the notification center screen. Read/write
/// through the notifier's methods ([refresh], [markAsRead], [markAllRead])
/// rather than the raw `.state` setter — Riverpod restricts external state
/// mutation to inside the [Notifier] subclass.
class NotificationListNotifier
    extends AutoDisposeAsyncNotifier<List<AppNotification>> {
  @override
  Future<List<AppNotification>> build() {
    return ref.read(notificationsRepositoryProvider).getNotifications();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<List<AppNotification>>().copyWithPrevious(state);
    state = await AsyncValue.guard(
      () => ref.read(notificationsRepositoryProvider).getNotifications(),
    );
  }

  /// Optimistic mark-as-read: flips the local flag immediately, fires the
  /// network call in the background, and self-heals on the next [refresh]
  /// if it failed.
  Future<void> markAsRead(String id) async {
    final list = state.valueOrNull;
    if (list == null) return;
    final target = list.where((n) => n.id == id).firstOrNull;
    if (target == null || target.isRead) return;
    state = AsyncData([
      for (final n in list) if (n.id == id) n.copyWith(isRead: true) else n,
    ]);
    ref.read(unreadNotificationCountProvider.notifier).decrement();
    try {
      await ref.read(notificationsRepositoryProvider).markAsRead(id);
    } catch (_) {
      // Non-fatal — the badge/list self-heal on the next refresh.
    }
  }

  Future<void> markAllRead() async {
    final list = state.valueOrNull;
    if (list != null) {
      state = AsyncData([for (final n in list) n.copyWith(isRead: true)]);
    }
    ref.read(unreadNotificationCountProvider.notifier).setZero();
    try {
      await ref.read(notificationsRepositoryProvider).markAllAsRead();
    } catch (_) {
      // Non-fatal — see [markAsRead].
    }
  }
}

final notificationListProvider = AsyncNotifierProvider.autoDispose<
  NotificationListNotifier,
  List<AppNotification>
>(NotificationListNotifier.new);

/// Unread notification count — refreshed on app resume + whenever the
/// caller calls [UnreadNotificationCountNotifier.refresh] (e.g.
/// pull-to-refresh on home, or after visiting the notification center).
/// Deliberately NOT a background poller: mobile has no FCM push wired yet
/// (see phase-04 notes), so a resume-triggered refresh is the honest
/// signal for "the user might have new notifications".
class UnreadNotificationCountNotifier extends AutoDisposeNotifier<int>
    with WidgetsBindingObserver {
  @override
  int build() {
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() => WidgetsBinding.instance.removeObserver(this));
    unawaited(refresh());
    return 0;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(refresh());
    }
  }

  Future<void> refresh() async {
    try {
      final counts = await ref
          .read(notificationsRepositoryProvider)
          .getUnreadCounts();
      state = counts.notifications;
    } catch (_) {
      // Non-fatal — badge simply stays at its last known value.
    }
  }

  /// Optimistic decrement after marking a single notification read.
  void decrement() => state = (state - 1).clamp(0, 1 << 30);

  /// Optimistic reset after "mark all as read".
  void setZero() => state = 0;
}

final unreadNotificationCountProvider =
    NotifierProvider.autoDispose<UnreadNotificationCountNotifier, int>(
      UnreadNotificationCountNotifier.new,
    );

/// Notification preferences form state (settings screen).
class NotificationPreferencesState {
  const NotificationPreferencesState({
    this.preferences,
    this.isLoading = true,
    this.isSaving = false,
    this.error,
  });

  final NotificationPreferences? preferences;
  final bool isLoading;
  final bool isSaving;
  final String? error;

  NotificationPreferencesState copyWith({
    NotificationPreferences? preferences,
    bool? isLoading,
    bool? isSaving,
    String? error,
    bool clearError = false,
  }) => NotificationPreferencesState(
    preferences: preferences ?? this.preferences,
    isLoading: isLoading ?? this.isLoading,
    isSaving: isSaving ?? this.isSaving,
    error: clearError ? null : (error ?? this.error),
  );
}

class NotificationPreferencesNotifier
    extends AutoDisposeNotifier<NotificationPreferencesState> {
  @override
  NotificationPreferencesState build() {
    // See the identical fix + rationale on `LearningPreferencesNotifier`
    // (`lib/view_models/settings/learning_preferences_provider.dart`):
    // `Future.microtask` guarantees `build()` returns before `_load()`
    // can synchronously write `state`.
    Future.microtask(_load);
    return const NotificationPreferencesState();
  }

  Future<void> _load() async {
    try {
      final prefs = await ref
          .read(notificationsRepositoryProvider)
          .getPreferences();
      state = state.copyWith(
        preferences: prefs,
        isLoading: false,
        clearError: true,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'load',
      );
    }
  }

  Future<void> save(NotificationPreferences updated) async {
    state = state.copyWith(preferences: updated, isSaving: true, clearError: true);
    try {
      final saved = await ref
          .read(notificationsRepositoryProvider)
          .savePreferences(updated);
      state = state.copyWith(preferences: saved, isSaving: false);
    } catch (_) {
      state = state.copyWith(isSaving: false, error: 'save');
    }
  }
}

final notificationPreferencesProvider = NotifierProvider.autoDispose<
  NotificationPreferencesNotifier,
  NotificationPreferencesState
>(NotificationPreferencesNotifier.new);
