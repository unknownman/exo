import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../storage/secure_storage_service.dart';
import 'app_config.dart';
import 'auth_interceptor.dart';
import 'retry_interceptor.dart';

part 'api_client_provider.g.dart';

Future<String?> _refreshToken(SecureStorageService storage) async {
  final refreshToken = await storage.refreshToken;
  if (refreshToken == null) return null;

  final refreshDio = Dio(BaseOptions(
    baseUrl: AppConfig.apiBaseUrl,
    connectTimeout: AppConfig.connectTimeout,
    receiveTimeout: AppConfig.receiveTimeout,
  ));

  try {
    final response = await refreshDio.post(
      '/api/auth/refresh',
      data: {'token': refreshToken},
    );
    final data = response.data as Map<String, dynamic>?;
    final newToken = data?['token'] as String?;
    if (newToken != null) {
      await storage.saveAccessToken(newToken);
    }
    return newToken;
  } catch (_) {
    return null;
  }
}

@Riverpod(keepAlive: true)
Dio apiClient(ApiClientRef ref) {
  final storage = ref.watch(secureStorageServiceProvider);

  final dio = Dio(BaseOptions(
    baseUrl: AppConfig.apiBaseUrl,
    connectTimeout: AppConfig.connectTimeout,
    receiveTimeout: AppConfig.receiveTimeout,
    headers: Map<String, String>.from(AppConfig.defaultHeaders),
  ));

  dio.interceptors.addAll([
    AuthInterceptor(
      storage: storage,
      onTokenRefresh: () => _refreshToken(storage),
    ),
    RetryInterceptor(),
  ]);

  return dio;
}
