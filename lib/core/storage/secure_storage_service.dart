import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage_service.g.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';
  static const _deviceIdKey = 'deviceId';

  Future<String?> get accessToken => _storage.read(key: _accessTokenKey);
  Future<void> saveAccessToken(String value) =>
      _storage.write(key: _accessTokenKey, value: value);
  Future<void> deleteAccessToken() =>
      _storage.delete(key: _accessTokenKey);

  Future<String?> get refreshToken => _storage.read(key: _refreshTokenKey);
  Future<void> saveRefreshToken(String value) =>
      _storage.write(key: _refreshTokenKey, value: value);
  Future<void> deleteRefreshToken() =>
      _storage.delete(key: _refreshTokenKey);

  Future<String?> get deviceId => _storage.read(key: _deviceIdKey);
  Future<void> saveDeviceId(String value) =>
      _storage.write(key: _deviceIdKey, value: value);
  Future<void> deleteDeviceId() => _storage.delete(key: _deviceIdKey);

  Future<void> clearAll() => _storage.deleteAll();
}

@riverpod
SecureStorageService secureStorageService(SecureStorageServiceRef ref) {
  return SecureStorageService();
}
