import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design_tokens.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../view_models/notifications/notifications_provider.dart';
import '../../widgets/common/async_state_views.dart';
import 'widgets/notification_tile.dart';

/// In-app notification center — `GET /user/notifications`. Mark-as-read is
/// optimistic (list + badge update immediately, repository call fires in
/// the background) so taps feel instant even on a slow connection — see
/// [NotificationListNotifier].
class NotificationCenterScreen extends ConsumerWidget {
  const NotificationCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notificationsAsync = ref.watch(notificationListProvider);
    final background = context.tokens.background;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        title: Text(
          l10n.notifications,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: DesignTokens.tigerOrange,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () => ref.read(notificationListProvider.notifier).markAllRead(),
            child: Text(l10n.notificationMarkAllRead),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.wait([
          ref.read(notificationListProvider.notifier).refresh(),
          ref.read(unreadNotificationCountProvider.notifier).refresh(),
        ]),
        child: notificationsAsync.when(
          loading: () => const LoadingView(),
          error: (e, _) => ListView(
            children: [
              ErrorView(
                message: l10n.notificationLoadError,
                onRetry: () => ref.invalidate(notificationListProvider),
              ),
            ],
          ),
          data: (items) => items.isEmpty
              ? ListView(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Center(
                        child: Text(
                          l10n.notificationEmpty,
                          style: TextStyle(color: context.tokens.mutedForeground),
                        ),
                      ),
                    ),
                  ],
                )
              : ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final notification = items[index];
                    return NotificationTile(
                      notification: notification,
                      onTap: () => ref
                          .read(notificationListProvider.notifier)
                          .markAsRead(notification.id),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
