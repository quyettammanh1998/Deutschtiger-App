import 'package:dio/dio.dart';

import '../auth/token_provider.dart';

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
        handler.next(err);
      },
    );
  }

  Future<T> get<T>(String path, {Map<String, dynamic>? query}) async {
    final res = await _dio.get<T>(path, queryParameters: query);
    return res.data as T;
  }

  Future<T> post<T>(String path, {Object? body}) async {
    final res = await _dio.post<T>(path, data: body);
    return res.data as T;
  }

  Future<T> put<T>(String path, {Object? body}) async {
    final res = await _dio.put<T>(path, data: body);
    return res.data as T;
  }

  Future<T> delete<T>(String path, {Object? body}) async {
    final res = await _dio.delete<T>(path, data: body);
    return res.data as T;
  }
}
