import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Kết quả so sánh version hiện tại với `minAppVersion` từ BE.
class ForceUpdateDecision {
  const ForceUpdateDecision({
    required this.required,
    required this.storeUrl,
    this.latestVersion,
    this.message,
  });

  final bool required;
  final String storeUrl;
  final String? latestVersion;
  final String? message;
}

/// Phase 06 / Phase 13 §"Force-update path":
///   app đọc min-version từ BE config → màn chặn khi API đổi breaking
///   (đi cùng quy ước additive phase-00 — chỉ dùng khi bất khả kháng).
///
/// Mock GĐ1: BE chưa có endpoint thật → fallback `enabled=false`. Khi BE
/// sẵn sàng `GET /api/v1/app-config` trả về `{ minAppVersion, storeUrl,
/// message }` thì chỉ cần đổi [_fetchRemoteConfig].
class ForceUpdateService {
  ForceUpdateService({Dio? client}) : _dio = client;

  // ignore: unused_field — giữ ref để Phase 06.1 wire BE.
  final Dio? _dio;

  /// App Store / Play Store URL — dùng cho nút "Cập nhật".
  /// TODO(store-ids): thay bằng URL thật khi có Apple Connect + Play Console
  /// bundle ID; hiện tại dùng URL trỏ về landing web để reviewer không thấy
  /// màn trắng.
  static const String defaultStoreUrl = 'https://deutschtiger.com/download';

  /// Quyết định có cần chặn user update hay không.
  ///
  /// Trả về `required=false` khi:
  /// - remote config fail (offline → không chặn user)
  /// - currentVersion ≥ minAppVersion
  /// - BE chưa khai minAppVersion (null/empty)
  Future<ForceUpdateDecision> check({String? overrideStoreUrl}) async {
    final storeUrl = overrideStoreUrl ?? defaultStoreUrl;
    try {
      final remote = await _fetchRemoteConfig();
      final minVersion = remote.minAppVersion?.trim();
      if (minVersion == null || minVersion.isEmpty) {
        return ForceUpdateDecision(required: false, storeUrl: storeUrl);
      }
      final current = await _currentVersion();
      final required = _compareVersions(current, minVersion) < 0;
      return ForceUpdateDecision(
        required: required,
        storeUrl: storeUrl,
        latestVersion: remote.latestVersion ?? minVersion,
        message: remote.message,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ForceUpdateService] check failed (offline OK): $e');
      }
      return ForceUpdateDecision(required: false, storeUrl: storeUrl);
    }
  }

  // ========== Internal ==========

  Future<_RemoteConfig> _fetchRemoteConfig() async {
    // GĐ1 mock: BE chưa có endpoint. Khi có, đổi sang:
    //   final dio = _dio ?? Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));
    //   final res = await dio.get<Map<String, dynamic>>('/app-config');
    //   return _RemoteConfig.fromJson(res.data ?? const {});
    return const _RemoteConfig(minAppVersion: null);
  }

  Future<String> _currentVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return info.version; // bỏ "+build" — so sánh semantic
    } catch (e) {
      if (kDebugMode) debugPrint('[ForceUpdateService] package_info: $e');
      return '0.0.0';
    }
  }

  /// Trả: -1 (a<b), 0, 1. Parse "1.2.3" → [1,2,3].
  static int _compareVersions(String a, String b) {
    final pa = a.split(RegExp(r'[.\-+]')).map(int.tryParse).toList();
    final pb = b.split(RegExp(r'[.\-+]')).map(int.tryParse).toList();
    final len = pa.length > pb.length ? pa.length : pb.length;
    for (var i = 0; i < len; i++) {
      final ai = i < pa.length ? pa[i] ?? 0 : 0;
      final bi = i < pb.length ? pb[i] ?? 0 : 0;
      if (ai < bi) return -1;
      if (ai > bi) return 1;
    }
    return 0;
  }
}

class _RemoteConfig {
  // latestVersion + message chưa được truyền từ GĐ1 (BE chưa có), nhưng
  // giữ API surface để wire ngay khi `_fetchRemoteConfig` đọc từ BE.
  // ignore: unused_element_parameter
  const _RemoteConfig({this.minAppVersion, this.latestVersion, this.message});
  final String? minAppVersion;
  // ignore: unused_field
  final String? latestVersion;
  // ignore: unused_field
  final String? message;
}