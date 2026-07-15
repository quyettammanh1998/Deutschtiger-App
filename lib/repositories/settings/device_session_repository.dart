import 'package:deutschtiger/services/api_client.dart';

List<DeviceSession> parseDeviceSessions(dynamic response) {
  final list = response is Map<String, dynamic>
      ? response['devices'] as List<dynamic>? ?? const []
      : response as List<dynamic>? ?? const [];
  return list
      .whereType<Map<String, dynamic>>()
      .map(DeviceSession.fromJson)
      .toList();
}

/// Một phiên đăng nhập (thiết bị) của user, trả về từ
/// `GET /user/devices`.
class DeviceSession {
  const DeviceSession({
    required this.sessionId,
    required this.isCurrent,
    required this.firstSeen,
    required this.lastSeen,
    this.userAgent,
    this.ip,
  });

  final String sessionId;
  final bool isCurrent;
  final DateTime firstSeen;
  final DateTime lastSeen;
  final String? userAgent;
  final String? ip;

  factory DeviceSession.fromJson(Map<String, dynamic> json) {
    return DeviceSession(
      sessionId: json['session_id'] as String? ?? '',
      isCurrent: json['is_current'] as bool? ?? false,
      firstSeen:
          DateTime.tryParse(json['first_seen'] as String? ?? '') ??
          DateTime.now(),
      lastSeen:
          DateTime.tryParse(json['last_seen'] as String? ?? '') ??
          DateTime.now(),
      userAgent: json['user_agent'] as String?,
      ip: json['ip'] as String?,
    );
  }
}

/// Quản lý các phiên đăng nhập (thiết bị) của user hiện tại.
class DeviceSessionRepository {
  DeviceSessionRepository(this._api);

  final ApiClient _api;

  /// Danh sách thiết bị đang đăng nhập (`GET /user/devices`).
  Future<List<DeviceSession>> fetchDevices() async {
    final response = await _api.get<dynamic>('/user/devices');
    return parseDeviceSessions(response);
  }

  /// Thu hồi một phiên đăng nhập cụ thể (`DELETE /user/devices/{sessionId}`).
  Future<void> revoke(String sessionId) async {
    await _api.delete<dynamic>('/user/devices/$sessionId');
  }

  /// Thu hồi tất cả phiên khác bằng các route thiết bị mà backend
  /// cung cấp. Phiên hiện tại luôn được giữ lại.
  Future<void> revokeOtherDevices() async {
    final devices = await fetchDevices();
    for (final device in devices.where((device) => !device.isCurrent)) {
      await revoke(device.sessionId);
    }
  }
}
