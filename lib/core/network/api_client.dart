import 'package:dio/dio.dart';

import '../auth/token_provider.dart';

/// Custom exception for API errors with more context.
class ApiException implements Exception {
  ApiException(this.message, {this.statusCode, this.originalError});
  final String message;
  final int? statusCode;
  final Object? originalError;

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}

/// HTTP client cho Go backend (`/api/v1`).
///
/// Interceptor tự đính `Authorization: Bearer <jwt>` và xử lý 401 tập trung
/// (refresh → retry 1 lần) — mirror logic web `src/lib/shared/api-client.ts`.
/// Feature code dùng [ApiClient], KHÔNG chạm dio trực tiếp.
class ApiClient {
  ApiClient({required String baseUrl, required this._tokenProvider})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 20),
          contentType: 'application/json',
        ),
      ) {
    _dio.interceptors.add(_authInterceptor());
  }

  final Dio _dio;
  final TokenProvider _tokenProvider;

  Dio get raw => _dio;

  InterceptorsWrapper _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _tokenProvider.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (err, handler) async {
        // 401 → thử refresh token một lần rồi retry request.
        final is401 = err.response?.statusCode == 401;
        final alreadyRetried = err.requestOptions.extra['retried'] == true;
        if (is401 && !alreadyRetried) {
          final newToken = await _tokenProvider.refresh();
          if (newToken != null) {
            final opts = err.requestOptions
              ..headers['Authorization'] = 'Bearer $newToken'
              ..extra['retried'] = true;
            try {
              final response = await _dio.fetch<dynamic>(opts);
              return handler.resolve(response);
            } catch (_) {
              // rơi xuống reject bên dưới
            }
          }
        }

        // Transform network/CORS errors into meaningful exceptions
        if (err.type == DioExceptionType.connectionError ||
            err.type == DioExceptionType.connectionTimeout ||
            err.message?.contains('CORS') == true ||
            err.message?.contains('XMLHttpRequest') == true) {
          return handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: ApiException(
                'Không thể kết nối đến server. Vui lòng kiểm tra kết nối mạng.',
                statusCode: err.response?.statusCode,
                originalError: err,
              ),
              type: err.type,
              response: err.response,
            ),
          );
        }

        handler.next(err);
      },
    );
  }

  Future<T> get<T>(String path, {Map<String, dynamic>? query}) async {
    try {
      final res = await _dio.get<T>(path, queryParameters: query);
      if (res.data == null) {
        throw ApiException('Empty response from $path');
      }
      return res.data as T;
    } on DioException catch (e) {
      throw _transformError(e, path);
    }
  }

  Future<T> post<T>(String path, {Object? body}) async {
    try {
      final res = await _dio.post<T>(path, data: body);
      if (res.data == null) {
        throw ApiException('Empty response from $path');
      }
      return res.data as T;
    } on DioException catch (e) {
      throw _transformError(e, path);
    }
  }

  Future<T> put<T>(String path, {Object? body}) async {
    try {
      final res = await _dio.put<T>(path, data: body);
      if (res.data == null) {
        throw ApiException('Empty response from $path');
      }
      return res.data as T;
    } on DioException catch (e) {
      throw _transformError(e, path);
    }
  }

  Future<T> delete<T>(String path, {Object? body}) async {
    try {
      final res = await _dio.delete<T>(path, data: body);
      if (res.data == null) {
        throw ApiException('Empty response from $path');
      }
      return res.data as T;
    } on DioException catch (e) {
      throw _transformError(e, path);
    }
  }

  ApiException _transformError(DioException e, String path) {
    final statusCode = e.response?.statusCode;
    final type = e.type;

    String message;
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Hết thời gian kết nối. Vui lòng thử lại.';
        break;
      case DioExceptionType.connectionError:
        message = 'Không thể kết nối đến server. Kiểm tra mạng của bạn.';
        break;
      case DioExceptionType.badResponse:
        if (statusCode == 401) {
          message = 'Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.';
        } else if (statusCode == 403) {
          message = 'Bạn không có quyền truy cập.';
        } else if (statusCode == 404) {
          message = 'Không tìm thấy dữ liệu.';
        } else if (statusCode != null && statusCode >= 500) {
          message = 'Server đang bận. Vui lòng thử lại sau.';
        } else {
          message = e.message ?? 'Đã xảy ra lỗi không xác định.';
        }
        break;
      case DioExceptionType.cancel:
        message = 'Yêu cầu đã bị hủy.';
        break;
      default:
        // Check for CORS errors
        final errorMsg = e.message?.toLowerCase() ?? '';
        if (errorMsg.contains('cors') ||
            errorMsg.contains('access-control') ||
            errorMsg.contains('xmlhttprequest')) {
          message = 'Lỗi CORS: Không thể truy cập server. Liên hệ admin.';
        } else {
          message = e.message ?? 'Đã xảy ra lỗi kết nối.';
        }
    }

    return ApiException(message, statusCode: statusCode, originalError: e);
  }
}
