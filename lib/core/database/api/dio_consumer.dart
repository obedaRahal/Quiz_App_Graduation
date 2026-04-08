import 'package:dio/dio.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';

import 'api_consumer.dart';
import '../../errors/exceptions.dart';

typedef AccessTokenGetter = Future<String?> Function();
typedef TokenExpiringSoonChecker = Future<bool> Function();
typedef RefreshTokenCallback = Future<bool> Function();
typedef ClearSessionCallback = Future<void> Function();

class DioConsumer extends ApiConsumer {
  final Dio dio;

  final AccessTokenGetter? getAccessToken;
  final TokenExpiringSoonChecker? isTokenExpiringSoon;
  final RefreshTokenCallback? refreshToken;
  final ClearSessionCallback? clearSession;

  Future<bool>? _refreshFuture;

  DioConsumer({
    required this.dio,
    this.getAccessToken,
    this.isTokenExpiringSoon,
    this.refreshToken,
    this.clearSession,
  }) {
    dio.options = dio.options.copyWith(
      baseUrl: dio.options.baseUrl.isEmpty ? EndPoints.baseUrl : dio.options.baseUrl,
      receiveDataWhenStatusError: true,
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            final requiresAuth = options.extra['requiresAuth'] != false;

            if (!requiresAuth) {
              handler.next(options);
              return;
            }

            final token = await getAccessToken?.call();

            if (token != null && token.isNotEmpty) {
              final shouldRefresh = await isTokenExpiringSoon?.call() ?? false;

              if (shouldRefresh) {
                final refreshSucceeded = await _runRefreshOnce();
                if (!refreshSucceeded) {
                  // لا نطرد المستخدم هنا مباشرة بسبب احتمالية أن يكون الخطأ مؤقتًا
                  // فقط نكمل بالـ token الحالي، وقد يعالج onError الأمر لاحقًا إن رجع 401
                }
              }

              final latestToken = await getAccessToken?.call();
              if (latestToken != null && latestToken.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $latestToken';
              }
            }

            handler.next(options);
          } catch (e) {
            handler.next(options);
          }
        },
        onError: (error, handler) async {
          final statusCode = error.response?.statusCode;
          final requestOptions = error.requestOptions;

          final requiresAuth = requestOptions.extra['requiresAuth'] != false;
          final isRefreshRequest = requestOptions.path.contains(EndPoints.refreshToken);
          final alreadyRetried = requestOptions.extra['retried'] == true;

          if (!requiresAuth || isRefreshRequest || alreadyRetried || statusCode != 401) {
            handler.next(error);
            return;
          }

          final refreshSucceeded = await _runRefreshOnce(
            clearSessionOnUnauthorizedOnly: true,
          );

          if (!refreshSucceeded) {
            handler.next(error);
            return;
          }

          final latestToken = await getAccessToken?.call();
          if (latestToken == null || latestToken.isEmpty) {
            handler.next(error);
            return;
          }

          try {
            final clonedRequest = await _retryRequest(
              requestOptions,
              latestToken,
            );
            handler.resolve(clonedRequest);
          } on DioException catch (e) {
            handler.next(e);
          } catch (_) {
            handler.next(error);
          }
        },
      ),
    );
  }

  Future<bool> _runRefreshOnce({
    bool clearSessionOnUnauthorizedOnly = false,
  }) async {
    if (refreshToken == null) return false;

    if (_refreshFuture != null) {
      return _refreshFuture!;
    }

    _refreshFuture = _performRefresh(
      clearSessionOnUnauthorizedOnly: clearSessionOnUnauthorizedOnly,
    );

    final result = await _refreshFuture!;
    _refreshFuture = null;
    return result;
  }

  Future<bool> _performRefresh({
    required bool clearSessionOnUnauthorizedOnly,
  }) async {
    try {
      final success = await refreshToken!.call();
      return success;
    } on UnauthorizedException {
      if (clearSessionOnUnauthorizedOnly) {
        await clearSession?.call();
      }
      return false;
    } on ForbiddenException {
      if (clearSessionOnUnauthorizedOnly) {
        await clearSession?.call();
      }
      return false;
    } catch (_) {
      // لا نمسح الجلسة هنا لأن الخطأ قد يكون:
      // - انقطاع إنترنت
      // - Timeout
      // - 500 من السيرفر
      return false;
    }
  }

  Future<Response<dynamic>> _retryRequest(
    RequestOptions requestOptions,
    String token,
  ) async {
    final headers = Map<String, dynamic>.from(requestOptions.headers);
    headers['Authorization'] = 'Bearer $token';

    final options = Options(
      method: requestOptions.method,
      headers: headers,
      responseType: requestOptions.responseType,
      contentType: requestOptions.contentType,
      extra: {
        ...requestOptions.extra,
        'retried': true,
      },
      receiveTimeout: requestOptions.receiveTimeout,
      sendTimeout: requestOptions.sendTimeout,
      validateStatus: requestOptions.validateStatus,
      followRedirects: requestOptions.followRedirects,
      receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
    );

    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      cancelToken: requestOptions.cancelToken,
      options: options,
      onReceiveProgress: requestOptions.onReceiveProgress,
      onSendProgress: requestOptions.onSendProgress,
    );
  }

  dynamic _prepareData(dynamic data, bool isFormData) {
    if (!isFormData || data == null) return data;
    if (data is FormData) return data;
    if (data is Map<String, dynamic>) return FormData.fromMap(data);
    return data;
  }

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    Options? options,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    Options? options,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: _prepareData(data, isFormData),
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    Options? options,
  }) async {
    try {
      final response = await dio.put(
        path,
        data: _prepareData(data, isFormData),
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future<dynamic> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    Options? options,
  }) async {
    try {
      final response = await dio.patch(
        path,
        data: _prepareData(data, isFormData),
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }
}