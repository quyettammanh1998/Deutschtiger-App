import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../../services/api_client.dart';
import '../../repositories/settings/device_session_repository.dart';
import 'package:deutschtiger/view_models/settings/device_session_provider.dart';

/// Màn Bảo mật: danh sách thiết bị (`GET /user/devices`) + thu hồi từng
/// thiết bị (`DELETE /user/devices/{sessionId}`) + đăng xuất khỏi thiết bị
/// khác + link xoá tài khoản.
class SecurityScreen extends ConsumerStatefulWidget {
  const SecurityScreen({super.key});

  @override
  ConsumerState<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends ConsumerState<SecurityScreen> {
  bool _loading = false;

  Future<void> _signOutOtherDevices() async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.signOutOtherDevicesTitle),
        content: Text(l10n.signOutOtherDevicesBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => _loading = true);
    try {
      await ref.read(deviceSessionListProvider.notifier).revokeOtherDevices();
      if (!mounted) return;
      _snack(l10n.signedOutOtherDevices);
    } on ApiException {
      if (!mounted) return;
      _snack(l10n.couldNotSignOut);
    } catch (_) {
      if (mounted) _snack(l10n.couldNotSignOut);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _revokeDevice(DeviceSession device) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.signOutDeviceTitle),
        content: Text(l10n.signOutDeviceBody(_deviceLabel(device, l10n))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await ref
          .read(deviceSessionListProvider.notifier)
          .revoke(device.sessionId);
      if (mounted) _snack(l10n.signedOutDevice);
    } on ApiException {
      if (mounted) _snack(l10n.couldNotSignOut);
    } catch (_) {
      if (mounted) _snack(l10n.couldNotSignOut);
    }
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    final devicesAsync = ref.watch(deviceSessionListProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: DesignTokens.authBackground,
      appBar: AppBar(
        backgroundColor: DesignTokens.authBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.security,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: DesignTokens.tigerOrange,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(deviceSessionListProvider.notifier).refresh(),
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.screenHorizontalPadding,
            vertical: DesignTokens.spacingMd,
          ),
          children: [
            _SectionHeader(title: l10n.signedInDevices),
            _buildDeviceSection(devicesAsync),
            const SizedBox(height: DesignTokens.spacingMd),
            SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: _loading ? null : _signOutOtherDevices,
                style: OutlinedButton.styleFrom(
                  foregroundColor: DesignTokens.foreground,
                  side: const BorderSide(color: DesignTokens.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radius),
                  ),
                ),
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.signOutOtherDevices),
              ),
            ),
            const SizedBox(height: DesignTokens.spacingLg),
            _SectionHeader(title: l10n.account),
            _Card(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline,
                    color: DesignTokens.error,
                  ),
                  title: Text(
                    l10n.deleteAccount,
                    style: const TextStyle(
                      color: DesignTokens.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(l10n.deleteAccountDescription),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: DesignTokens.mutedForeground,
                  ),
                  onTap: () => context.push('/settings/delete-account'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceSection(AsyncValue<List<DeviceSession>> devicesAsync) {
    final l10n = AppLocalizations.of(context);
    return devicesAsync.when(
      loading: () => const _Card(
        children: [
          Padding(
            padding: EdgeInsets.all(DesignTokens.spacingLg),
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
      error: (_, _) => _Card(
        children: [
          Padding(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: DesignTokens.error),
                const SizedBox(width: DesignTokens.spacingSm),
                Expanded(child: Text(l10n.couldNotLoadDevices)),
                TextButton(
                  onPressed: () =>
                      ref.read(deviceSessionListProvider.notifier).refresh(),
                  child: Text(l10n.retry),
                ),
              ],
            ),
          ),
        ],
      ),
      data: (devices) {
        if (devices.isEmpty) {
          return _Card(
            children: [
              Padding(
                padding: const EdgeInsets.all(DesignTokens.spacingMd),
                child: Text(l10n.noSignedInDevices),
              ),
            ],
          );
        }
        return _Card(
          children: [
            for (var i = 0; i < devices.length; i++) ...[
              if (i > 0) const Divider(height: 1),
              _DeviceTile(
                device: devices[i],
                onRevoke: devices[i].isCurrent
                    ? null
                    : () => _revokeDevice(devices[i]),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// Suy ra nhãn hiển thị của thiết bị từ User-Agent (backend không trả tên
/// thiết bị riêng, chỉ có chuỗi UA thô).
String _deviceLabel(DeviceSession device, AppLocalizations l10n) {
  final ua = device.userAgent;
  if (ua == null || ua.isEmpty) return l10n.unknownDevice;
  if (ua.contains('iPhone') || ua.contains('iPad')) return 'iOS';
  if (ua.contains('Android')) return 'Android';
  if (ua.contains('Macintosh')) return 'macOS · Web';
  if (ua.contains('Windows')) return 'Windows · Web';
  return 'Web';
}

IconData _deviceIcon(DeviceSession device) {
  final ua = device.userAgent ?? '';
  if (ua.contains('iPhone')) return Icons.phone_iphone;
  if (ua.contains('iPad')) return Icons.tablet_mac;
  if (ua.contains('Android')) return Icons.android;
  return Icons.laptop_mac;
}

/// Định dạng thời gian tương đối đơn giản (không phụ thuộc `intl`/`timeago`).
String _relativeTime(DateTime time, AppLocalizations l10n) {
  final diff = DateTime.now().difference(time);
  if (diff.inMinutes < 1) return l10n.justNow;
  if (diff.inMinutes < 60) return l10n.minutesAgo(diff.inMinutes);
  if (diff.inHours < 24) return l10n.hoursAgo(diff.inHours);
  if (diff.inDays < 30) return l10n.daysAgo(diff.inDays);
  return '${time.day}/${time.month}/${time.year}';
}

class _DeviceTile extends StatelessWidget {
  const _DeviceTile({required this.device, this.onRevoke});
  final DeviceSession device;

  /// Null khi thiết bị là phiên hiện tại (không thể tự thu hồi).
  final VoidCallback? onRevoke;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: DesignTokens.orange50.withValues(alpha: 0.6),
        child: Icon(_deviceIcon(device), color: DesignTokens.tigerOrange),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              _deviceLabel(device, l10n),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          if (device.isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingSm,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: DesignTokens.success.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
              ),
              child: Text(
                l10n.currentDevice,
                style: const TextStyle(
                  fontSize: 11,
                  color: DesignTokens.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      subtitle: Text(
        [
          if (device.ip != null && device.ip!.isNotEmpty) device.ip!,
          _relativeTime(device.lastSeen, l10n),
        ].join(' · '),
        style: const TextStyle(fontSize: 12),
      ),
      trailing: onRevoke == null
          ? null
          : IconButton(
              icon: const Icon(Icons.logout, color: DesignTokens.error),
              tooltip: l10n.signOutThisDevice,
              onPressed: onRevoke,
            ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(
      left: DesignTokens.spacingXs,
      bottom: DesignTokens.spacingSm,
    ),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: DesignTokens.mutedForeground,
      ),
    ),
  );
}

class _Card extends StatelessWidget {
  const _Card({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(DesignTokens.radius),
      border: Border.all(color: DesignTokens.border),
      boxShadow: DesignTokens.shadowSm,
    ),
    child: Column(children: children),
  );
}
