import 'package:dio/dio.dart';
import '../storage/secure_storage_service.dart';

class _PendingRequest {
  final RequestOptions options;
  final ErrorInterceptorHandler handler;

  const _PendingRequest({
    required this.options,
    required this.handler,
  });
}

class AuthInterceptor extends Interceptor {
  final SecureStorageService _storage;
  final Future<String?> Function() _onTokenRefresh;

  bool _isRefreshing = false;
  final _pendingRequests = <_PendingRequest>[];

  AuthInterceptor({
    required SecureStorageService storage,
    required Future<String?> Function() onTokenRefresh,
  })  : _storage = storage,
        _onTokenRefresh = onTokenRefresh;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.accessToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    if (statusCode != 401) {
      handler.next(err);
      return;
    }

    if (_isRefreshing) {
      _pendingRequests.add(_PendingRequest(
        options: err.requestOptions,
        handler: handler,
      ));
      return;
    }

    _isRefreshing = true;
    try {
      final newToken = await _onTokenRefresh();
      if (newToken != null) {
        await _retryWithToken(err.requestOptions, newToken, handler);
        await _processPendingRequests(newToken);
      } else {
        handler.reject(err);
        _rejectPendingRequests(err);
      }
    } catch (e) {
      final dioException = e is DioException ? e : err;
      handler.reject(dioException);
      _rejectPendingRequests(dioException);
    } finally {
      _isRefreshing = false;
      _pendingRequests.clear();
    }
  }

  Future<void> _retryWithToken(
    RequestOptions options,
    String token,
    ErrorInterceptorHandler handler,
  ) async {
    options.headers['Authorization'] = 'Bearer $token';
    final cleanDio = Dio(BaseOptions(
      baseUrl: options.baseUrl,
      connectTimeout: options.connectTimeout,
      receiveTimeout: options.receiveTimeout,
    ));
    try {
      final response = await cleanDio.fetch(options);
      handler.resolve(response);
    } catch (e) {
      handler.reject(e is DioException ? e : DioException(
        requestOptions: options,
        error: e,
      ));
    }
  }

  Future<void> _processPendingRequests(String token) async {
    final pending = List<_PendingRequest>.from(_pendingRequests);
    for (final item in pending) {
      final cleanDio = Dio(BaseOptions(
        baseUrl: item.options.baseUrl,
        connectTimeout: item.options.connectTimeout,
        receiveTimeout: item.options.receiveTimeout,
      ));
      item.options.headers['Authorization'] = 'Bearer $token';
      try {
        final response = await cleanDio.fetch(item.options);
        item.handler.resolve(response);
      } catch (e) {
        item.handler.reject(e is DioException ? e : DioException(
          requestOptions: item.options,
          error: e,
        ));
      }
    }
  }

  void _rejectPendingRequests(DioException err) {
    for (final item in _pendingRequests) {
      item.handler.reject(err);
    }
  }
}
