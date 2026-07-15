// ignore_for_file: prefer_initializing_formals

import 'dart:async';
import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'auth_provider.dart';
import 'crash_service.dart';

/// Custom exception for API errors with more context.
class ApiException implements Exception {
  ApiException(this.message, {this.statusCode, this.originalError});
  final String message;
  final int? statusCode;
  final Object? originalError;

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}

/// Callback khi backend trả 401 + `X-Device-Kicked: true` (hoặc body
/// `code: device_kicked`). Implementer sẽ show dialog + navigate về `/login`.
typedef DeviceKickedHandler = Future<void> Function();

/// HTTP client cho Go backend (`/api/v1`).
///
/// Interceptors: Authorization (Bearer JWT, refresh 1 lần khi 401), X-App-Version
/// (`<v>+<build>` từ package_info_plus), X-Platform (`ios|android|web`),
/// device-kicked handler, error log (≥400), retry 429 sau 2s.
/// Feature code dùng [ApiClient], KHÔNG chạm dio trực tiếp.
class ApiClient {
  ApiClient({required String baseUrl, required TokenProvider tokenProvider})
    : _tokenProvider = tokenProvider,
      _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 20),
          contentType: 'application/json',
        ),
      ) {
    _dio.interceptors
      ..add(_headersInterceptor())
      ..add(_responseInterceptor());
  }

  final Dio _dio;
  final TokenProvider _tokenProvider;
  DeviceKickedHandler? _onDeviceKicked;
  String? _cachedAppVersion;

  Dio get raw => _dio;

  /// Setter để app wire-up sau khi GoRouter đã sẵn sàng (ApiClient được tạo
  /// trong providers.dart trước MaterialApp.router, nên không có BuildContext).
  /// Idempotent — set lại nhiều lần vẫn an toàn.
  set onDeviceKicked(DeviceKickedHandler? handler) => _onDeviceKicked = handler;

  Interceptor _headersInterceptor() => InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await _tokenProvider.getAccessToken();
      if (token != null) options.headers['Authorization'] = 'Bearer $token';
      options.headers['X-App-Version'] = await _resolveAppVersion();
      options.headers['X-Platform'] = _resolvePlatform();
      handler.next(options);
    },
  );

  Interceptor _responseInterceptor() => InterceptorsWrapper(
    onError: (err, handler) async {
      final response = err.response;
      final status = response?.statusCode;
      final reqOpts = err.requestOptions;

      // Device-kicked ưu tiên trước refresh: server đã quyết định kill
      // session này, refresh sẽ fail tương tự.
      if (status == 401 && _isDeviceKicked(response)) {
        _log('device-kicked', reqOpts, response);
        if (reqOpts.extra['kicked'] != true) {
          reqOpts.extra['kicked'] = true;
          try {
            await _onDeviceKicked?.call();
          } catch (e) {
            if (kDebugMode) debugPrint('onDeviceKicked threw: $e');
          }
        }
        return handler.next(err);
      }

      // 401 → refresh token một lần rồi retry.
      if (status == 401 && reqOpts.extra['retried'] != true) {
        final newToken = await _tokenProvider.refresh();
        if (newToken != null) {
          final opts = reqOpts
            ..headers['Authorization'] = 'Bearer $newToken'
            ..extra['retried'] = true;
          try {
            final retry = await _dio.fetch<dynamic>(opts);
            return handler.resolve(retry);
          } catch (_) {
            /* rơi xuống reject */
          }
        }
      }

      // 429 → retry 1 lần sau 2s.
      if (status == 429 && reqOpts.extra['rateRetried'] != true) {
        reqOpts.extra['rateRetried'] = true;
        if (kDebugMode) {
          debugPrint('[ApiClient] 429 → retry 2s: ${reqOpts.uri}');
        }
        await Future<void>.delayed(const Duration(seconds: 2));
        try {
          final retry = await _dio.fetch<dynamic>(reqOpts);
          return handler.resolve(retry);
        } catch (_) {
          /* rơi xuống reject */
        }
      }

      // Error log cho response ≥400 (đã loại trừ device-kicked ở trên).
      if (status != null && status >= 400) {
        _log('http_error', reqOpts, response);
      }

      // Network/CORS errors → ApiException có nghĩa.
      if (_isNetworkError(err)) {
        return handler.reject(
          DioException(
            requestOptions: reqOpts,
            error: ApiException(
              'Không thể kết nối đến server. Vui lòng kiểm tra kết nối mạng.',
              statusCode: status,
              originalError: err,
            ),
            type: err.type,
            response: response,
          ),
        );
      }
      handler.next(err);
    },
  );

  Future<T> get<T>(String path, {Map<String, dynamic>? query}) =>
      _request(() => _dio.get<T>(path, queryParameters: query), path);

  Future<T> post<T>(String path, {Object? body}) =>
      _request(() => _dio.post<T>(path, data: body), path);

  Future<T> put<T>(String path, {Object? body}) =>
      _request(() => _dio.put<T>(path, data: body), path);

  Future<T> patch<T>(String path, {Object? body}) =>
      _request(() => _dio.patch<T>(path, data: body), path);

  Future<T> delete<T>(String path, {Object? body}) =>
      _request(() => _dio.delete<T>(path, data: body), path);

  Future<T> _request<T>(
    Future<Response<T>> Function() send,
    String path,
  ) async {
    try {
      final res = await send();
      if (res.data == null && res.statusCode == 204) return null as T;
      if (res.data == null) throw ApiException('Empty response from $path');
      return res.data as T;
    } on DioException catch (e) {
      throw _toApiException(e);
    }
  }

  ApiException _toApiException(DioException e) {
    final status = e.response?.statusCode;
    return ApiException(
      _errorMessage(e.type, status, e.message),
      statusCode: status,
      originalError: e,
    );
  }

  static const _timeoutMsg = 'Hết thời gian kết nối. Vui lòng thử lại.';
  static const _connMsg =
      'Không thể kết nối đến server. Kiểm tra mạng của bạn.';

  String _errorMessage(DioExceptionType type, int? status, String? raw) {
    if (type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.sendTimeout ||
        type == DioExceptionType.receiveTimeout) {
      return _timeoutMsg;
    }
    if (type == DioExceptionType.connectionError) return _connMsg;
    if (type == DioExceptionType.cancel) return 'Yêu cầu đã bị hủy.';
    if (type == DioExceptionType.badResponse) {
      switch (status) {
        case 401:
          return 'Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.';
        case 403:
          return 'Bạn không có quyền truy cập.';
        case 404:
          return 'Không tìm thấy dữ liệu.';
      }
      if (status != null && status >= 500) {
        return 'Server đang bận. Vui lòng thử lại sau.';
      }
      return raw ?? 'Đã xảy ra lỗi không xác định.';
    }
    final lower = raw?.toLowerCase() ?? '';
    if (lower.contains('cors') ||
        lower.contains('access-control') ||
        lower.contains('xmlhttprequest')) {
      return 'Lỗi CORS: Không thể truy cập server. Liên hệ admin.';
    }
    return raw ?? 'Đã xảy ra lỗi kết nối.';
  }

  bool _isNetworkError(DioException e) {
    if (e.type == DioExceptionType.connectionError) return true;
    if (e.type == DioExceptionType.connectionTimeout) return true;
    final m = e.message ?? '';
    return m.contains('CORS') || m.contains('XMLHttpRequest');
  }

  bool _isDeviceKicked(Response<dynamic>? response) {
    if (response == null) return false;
    final headerVal = response.headers.value('X-Device-Kicked');
    if (headerVal != null && headerVal.toLowerCase() == 'true') return true;
    final data = response.data;
    if (data is Map &&
        (data['code'] == 'device_kicked' || data['error'] == 'device_kicked')) {
      return true;
    }
    return false;
  }

  /// Log only route/status metadata. Response bodies can contain learner text
  /// or provider errors and must not reach Crashlytics.
  void _log(String tag, RequestOptions opts, Response<dynamic>? response) {
    final status = response?.statusCode;
    final route = opts.uri.path;
    final message = '[ApiClient:$tag] ${opts.method} $route -> $status';
    if (kDebugMode) debugPrint(message);
    CrashService.instance.log(
      'api.$tag.${opts.method.toLowerCase()}.$status$route',
    );
  }

  Future<String> _resolveAppVersion() async {
    if (_cachedAppVersion != null) return _cachedAppVersion!;
    try {
      final info = await PackageInfo.fromPlatform();
      _cachedAppVersion = '${info.version}+${info.buildNumber}';
    } catch (e) {
      if (kDebugMode) debugPrint('[ApiClient] package_info_plus failed: $e');
      _cachedAppVersion = '0.0.0+0';
    }
    return _cachedAppVersion!;
  }

  String _resolvePlatform() {
    if (kIsWeb) return 'web';
    try {
      if (Platform.isIOS) return 'ios';
      if (Platform.isAndroid) return 'android';
    } catch (_) {
      // Platform không khả dụng (vd. test env không stub).
    }
    return 'unknown';
  }
}
