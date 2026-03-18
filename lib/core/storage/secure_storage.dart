// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Secure Storage
// flutter_secure_storage wrapper for API keys and tokens
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:nexus_ai/core/constants/app_constants.dart';

/// Typed wrapper around [FlutterSecureStorage] for NEXUS-specific keys.
///
/// All sensitive data (API keys, session tokens) must be stored here
/// rather than in plain SharedPreferences or similar.
class SecureStorageService {
  SecureStorageService() : _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  final FlutterSecureStorage _storage;

  // ── API Key ───────────────────────────────────────────────

  Future<void> setApiKey(String apiKey) async {
    await _storage.write(
      key: AppConstants.apiKeyStorageKey,
      value: apiKey,
    );
  }

  Future<String?> getApiKey() async {
    return _storage.read(key: AppConstants.apiKeyStorageKey);
  }

  Future<void> deleteApiKey() async {
    await _storage.delete(key: AppConstants.apiKeyStorageKey);
  }

  // ── Session Token ─────────────────────────────────────────

  Future<void> setSessionToken(String token) async {
    await _storage.write(
      key: AppConstants.sessionTokenKey,
      value: token,
    );
  }

  Future<String?> getSessionToken() async {
    return _storage.read(key: AppConstants.sessionTokenKey);
  }

  Future<void> deleteSessionToken() async {
    await _storage.delete(key: AppConstants.sessionTokenKey);
  }

  // ── General ───────────────────────────────────────────────

  /// Clear all secure storage.
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
