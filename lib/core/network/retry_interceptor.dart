import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration baseDelay;

  RetryInterceptor({
    this.maxRetries = 3,
    this.baseDelay = const Duration(seconds: 1),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (!_shouldRetry(err)) {
      handler.next(err);
      return;
    }

    final retryCount = _retryCount(err);
    if (retryCount >= maxRetries) {
      handler.next(err);
      return;
    }

    final delay = baseDelay * (1 << retryCount);
    await Future<void>.delayed(delay);

    _incrementRetryCount(err.requestOptions);

    final cleanDio = Dio(BaseOptions(
      baseUrl: err.requestOptions.baseUrl,
      connectTimeout: err.requestOptions.connectTimeout,
      receiveTimeout: err.requestOptions.receiveTimeout,
      headers: err.requestOptions.headers,
    ));

    try {
      final response = await cleanDio.fetch(err.requestOptions);
      handler.resolve(response);
    } catch (_) {
      handler.next(err);
    }
  }

  int _retryCount(DioException err) {
    return err.requestOptions.extra['_retryCount'] as int? ?? 0;
  }

  void _incrementRetryCount(RequestOptions options) {
    final current = options.extra['_retryCount'] as int? ?? 0;
    options.extra['_retryCount'] = current + 1;
  }

  bool _shouldRetry(DioException err) {
    final statusCode = err.response?.statusCode;
    if (statusCode != null && statusCode >= 500) return true;

    return switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError =>
        true,
      _ => false,
    };
  }
}
