import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import 'package:deutschtiger/view_models/providers.dart';
import '../../../core/theme/app_colors.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import 'profile_controller.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_stats_grid.dart';

/// Màn Hồ sơ (tab Profile): thông tin + thống kê + sửa hồ sơ, đăng xuất.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(myProfileProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: Text(
          l10n.profile,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.tigerOrange,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
            tooltip: l10n.settings,
          ),
        ],
      ),
      body: profile.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          message: l10n.couldNotLoadProfile,
          onRetry: () => ref.invalidate(myProfileProvider),
        ),
        data: (user) => RefreshIndicator(
          color: AppColors.tigerOrange,
          onRefresh: () async => ref.invalidate(myProfileProvider),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 8),
              ProfileHeader(user: user),
              const SizedBox(height: 24),
              ProfileStatsGrid(user: user),
              const SizedBox(height: 24),
              _ActionTile(
                icon: Icons.edit_outlined,
                label: l10n.editProfile,
                onTap: () => context.push('/profile/edit'),
              ),
              _ActionTile(
                icon: Icons.settings_outlined,
                label: l10n.settings,
                onTap: () => context.push('/settings'),
              ),
              const SizedBox(height: 8),
              _ActionTile(
                icon: Icons.logout,
                label: l10n.signOut,
                onTap: () => _confirmSignOut(context, ref),
              ),
              const SizedBox(height: 8),
              _ActionTile(
                icon: Icons.delete_outline,
                label: l10n.deleteAccount,
                destructive: true,
                onTap: () => context.push('/settings/delete-account'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final ok = await _confirmDialog(
      context,
      title: l10n.signOut,
      message: l10n.signOutConfirm,
      confirmLabel: l10n.signOut,
    );
    if (ok) await ref.read(profileControllerProvider.notifier).signOut();
  }

  Future<bool> _confirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    bool destructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppLocalizations.of(ctx).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              confirmLabel,
              style: TextStyle(
                color: destructive
                    ? AppColors.destructive
                    : AppColors.tigerOrange,
              ),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive ? AppColors.destructive : AppColors.foreground;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(label, style: TextStyle(color: color)),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.mutedForeground,
        ),
        onTap: onTap,
      ),
    );
  }
}
