import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Crash reporting service — single entry point cho mọi lỗi runtime.
///
/// Phase 13 §1 yêu cầu:
/// - Crashlytics từ build đầu
/// - Mọi zone error + Flutter error handler + platform channel error đều
///   report
/// - Kèm userId (hash) + route hiện tại
class CrashService {
  CrashService._();
  static final CrashService instance = CrashService._();

  String? _userId;
  String? _route;
  bool _initialized = false;
  bool _remoteReady = false;

  /// Installs local hooks before Firebase initialization. Remote reporting is
  /// enabled separately by [enableRemoteReporting] after Firebase is ready.
  void init() {
    if (_initialized) return;
    _initialized = true;

    // 1. Flutter framework errors (setState sau dispose, build errors...).
    final flutterPrev = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      logError(details.exception, details.stack);
      flutterPrev?.call(details);
    };

    // 2. Platform channel / engine errors không đi qua FlutterError.
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      logError(error, stack);
      return true;
    };

    if (kDebugMode) debugPrint('[CrashService] local error hooks ready.');
  }

  /// Call only after [Firebase.initializeApp] succeeds.
  Future<void> enableRemoteReporting() async {
    if (_remoteReady || kIsWeb) return;
    try {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      _remoteReady = true;
      await FirebaseCrashlytics.instance.setUserIdentifier(_userId ?? '');
      await FirebaseCrashlytics.instance.setCustomKey(
        'platform',
        defaultTargetPlatform.name,
      );
      try {
        final info = await PackageInfo.fromPlatform();
        await FirebaseCrashlytics.instance.setCustomKey(
          'app_version',
          '${info.version}+${info.buildNumber}',
        );
      } catch (_) {
        await FirebaseCrashlytics.instance.setCustomKey(
          'app_version',
          'unknown',
        );
      }
      if (_route != null) {
        await FirebaseCrashlytics.instance.setCustomKey('route', _route!);
      }
      log('Crashlytics remote reporting enabled.');
    } catch (error) {
      if (kDebugMode) {
        debugPrint('[CrashService] remote reporting unavailable: $error');
      }
    }
  }

  /// Đính userId (đã hash ở call-site — KHÔNG hash ở đây để cho phép phía
  /// BE/BigQuery xử lý). Set null khi logout.
  void setUserId(String? userId) {
    _userId = userId;
    if (kDebugMode) debugPrint('[CrashService] crash user identifier updated');
    if (_remoteReady) {
      unawaited(FirebaseCrashlytics.instance.setUserIdentifier(userId ?? ''));
    }
  }

  /// Đính route hiện tại để breadcrumb. Set null khi rời app.
  void setRoute(String? route) {
    _route = route;
    if (kDebugMode) debugPrint('[CrashService] route=$route');
    if (_remoteReady) {
      unawaited(
        FirebaseCrashlytics.instance.setCustomKey('route', route ?? ''),
      );
    }
  }

  String? get userId => _userId;
  String? get route => _route;

  /// Báo một lỗi runtime. Tương thích Crashlytics.recordError về signature.
  void logError(Object error, StackTrace? stack) {
    final errorType = diagnosticErrorType(error);
    if (kDebugMode) {
      debugPrint('[CrashService] error type: $errorType');
      if (stack != null) debugPrint(stack.toString());
      debugPrint('[CrashService] breadcrumb: route=${_route ?? 'unknown'}');
    }
    if (_remoteReady) {
      unawaited(
        FirebaseCrashlytics.instance.recordError(
          StateError('diagnostic_error:$errorType'),
          stack,
          reason: 'route=${_route ?? 'unknown'} error_type=$errorType',
          fatal: false,
        ),
      );
    }
  }

  /// Báo một log string không phải error (vd. breadcrumb sự kiện).
  void log(String message) {
    final event = sanitizeDiagnosticEvent(message);
    if (kDebugMode) {
      debugPrint('[CrashService] log: $event (route=${_route ?? 'unknown'})');
    }
    if (_remoteReady) {
      unawaited(FirebaseCrashlytics.instance.log(event));
    }
  }

  /// Reduces a diagnostic event to a fixed, content-free identifier. Callers
  /// must not forward provider responses, user text, tokens, or draft content.
  @visibleForTesting
  static String sanitizeDiagnosticEvent(String value) {
    final event = value.trim();
    if (event.isEmpty ||
        !RegExp(r'^[A-Za-z0-9_./:-]{1,160}$').hasMatch(event)) {
      return 'diagnostic_event';
    }
    return event;
  }

  /// Error strings may contain server responses or learner input; preserve only
  /// the runtime type for crash grouping.
  @visibleForTesting
  static String diagnosticErrorType(Object error) {
    final type = error.runtimeType.toString();
    return RegExp(r'^[A-Za-z0-9_]{1,80}$').hasMatch(type)
        ? type
        : 'unknown_error';
  }
}
