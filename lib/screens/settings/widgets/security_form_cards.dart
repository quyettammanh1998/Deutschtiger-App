import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../repositories/settings/device_session_repository.dart';
import 'settings_tiles.dart';

/// Password-change card + device-tile row — extracted from
/// `security_screen.dart` to keep it under the ~200-LOC guideline.

class PasswordChangeCard extends StatelessWidget {
  const PasswordChangeCard({
    super.key,
    required this.newPasswordCtrl,
    required this.confirmPasswordCtrl,
    required this.saving,
    required this.message,
    required this.isError,
    required this.onSubmit,
  });

  final TextEditingController newPasswordCtrl;
  final TextEditingController confirmPasswordCtrl;
  final bool saving;
  final String? message;
  final bool isError;
  final VoidCallback onSubmit;

  InputDecoration _decoration(BuildContext context, String hint) {
    final tokens = context.tokens;
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: tokens.muted,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsCardLabel(l10n.changePassword),
          Text(
            l10n.newPassword,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tokens.foreground),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: newPasswordCtrl,
            obscureText: true,
            autofillHints: const [AutofillHints.newPassword],
            decoration: _decoration(context, l10n.passwordMinLength),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.confirmNewPassword,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tokens.foreground),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: confirmPasswordCtrl,
            obscureText: true,
            autofillHints: const [AutofillHints.newPassword],
            decoration: _decoration(context, l10n.confirmNewPassword),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              GestureDetector(
                onTap: saving ? null : onSubmit,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [tokens.primary, tokens.brandDark]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    saving ? l10n.saving : l10n.changePassword,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              if (message != null) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message!,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isError ? tokens.destructive : tokens.success,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Suy ra nhãn hiển thị của thiết bị từ User-Agent (backend không trả tên
/// thiết bị riêng, chỉ có chuỗi UA thô).
String deviceLabel(DeviceSession device, AppLocalizations l10n) {
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
String relativeTime(DateTime time, AppLocalizations l10n) {
  final diff = DateTime.now().difference(time);
  if (diff.inMinutes < 1) return l10n.justNow;
  if (diff.inMinutes < 60) return l10n.minutesAgo(diff.inMinutes);
  if (diff.inHours < 24) return l10n.hoursAgo(diff.inHours);
  if (diff.inDays < 30) return l10n.daysAgo(diff.inDays);
  return '${time.day}/${time.month}/${time.year}';
}

class DeviceTile extends StatelessWidget {
  const DeviceTile({super.key, required this.device, this.onRevoke});
  final DeviceSession device;

  /// Null khi thiết bị là phiên hiện tại (không thể tự thu hồi).
  final VoidCallback? onRevoke;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tokens.muted.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tokens.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: tokens.primary.withValues(alpha: 0.12),
            child: Icon(_deviceIcon(device), color: tokens.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        deviceLabel(device, l10n),
                        style: TextStyle(fontWeight: FontWeight.w600, color: tokens.foreground),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (device.isCurrent) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: tokens.success.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          l10n.currentDevice,
                          style: TextStyle(
                            fontSize: 11,
                            color: tokens.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  [
                    if (device.ip != null && device.ip!.isNotEmpty) device.ip!,
                    relativeTime(device.lastSeen, l10n),
                  ].join(' · '),
                  style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                ),
              ],
            ),
          ),
          if (onRevoke != null)
            IconButton(
              icon: Icon(Icons.logout, color: tokens.destructive),
              tooltip: l10n.signOutThisDevice,
              onPressed: onRevoke,
            ),
        ],
      ),
    );
  }
}
