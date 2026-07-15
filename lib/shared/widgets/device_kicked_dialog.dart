import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';
import '../../l10n/app_localizations.dart';

/// Dialog thông báo thiết bị bị backend kick (JWT của thiết bị khác đang active).
///
/// Khi server trả 401 kèm `X-Device-Kicked: true` (hoặc body `code: device_kicked`),
/// [ApiClient] sẽ gọi [showDeviceKickedDialog] từ một interceptor bất đồng bộ —
/// vì vậy dialog dùng [GlobalKey<NavigatorState>] truyền từ ngoài vào, tránh
/// phụ thuộc context ngay tại thời điểm lỗi xảy ra.
class DeviceKickedDialog extends StatelessWidget {
  const DeviceKickedDialog({super.key, required this.onAcknowledge});

  /// Hàm được gọi khi user bấm OK — thường là `authService.signOut()`
  /// + `context.go('/login')`.
  final VoidCallback onAcknowledge;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      insetPadding: const EdgeInsets.all(DesignTokens.spacingLg),
      actionsPadding: const EdgeInsets.fromLTRB(
        DesignTokens.spacingMd,
        0,
        DesignTokens.spacingMd,
        DesignTokens.spacingSm,
      ),
      title: Text(l10n.deviceSessionEnded),
      content: Text(l10n.deviceKickedBody),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onAcknowledge();
          },
          child: Text(l10n.signInAgain),
        ),
      ],
    );
  }
}

/// Hiển thị [DeviceKickedDialog] ở root navigator. Fire-and-forget an toàn khi
/// app chưa có navigator (no-op + vẫn gọi [onAcknowledge] để app navigate về
/// `/login`).
Future<void> showDeviceKickedDialog({
  required VoidCallback onAcknowledge,
  GlobalKey<NavigatorState>? rootNavigatorKey,
}) async {
  final navigator = rootNavigatorKey?.currentState;
  if (navigator == null) {
    if (kDebugMode) {
      debugPrint(
        '[DeviceKickedDialog] No navigator available, skipping dialog.',
      );
    }
    onAcknowledge();
    return;
  }

  final dialogContext = rootNavigatorKey!.currentContext;
  if (dialogContext == null) {
    if (kDebugMode) {
      debugPrint(
        '[DeviceKickedDialog] Navigator has no context, skipping dialog.',
      );
    }
    onAcknowledge();
    return;
  }

  await showDialog<void>(
    context: dialogContext,
    barrierDismissible: false,
    builder: (_) => DeviceKickedDialog(onAcknowledge: onAcknowledge),
  );
}
