import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/auth_session_model.dart';

/// Keeps the signed-in session on the device so closing the app doesn't sign
/// the member out. Lives in `auth/data/` rather than `core/` because it deals
/// in `AuthSessionModel` — core shouldn't know a feature's models.
class AuthSessionStorage {
  const AuthSessionStorage(this._storage);

  static const _key = 'auth_session';

  final FlutterSecureStorage _storage;

  Future<void> save(AuthSessionModel session) =>
      _storage.write(key: _key, value: json.encode(session.toJson()));

  /// Returns `null` when nothing is stored, or when what's stored can't be
  /// parsed — a corrupt entry is dropped rather than crashing the launch.
  Future<AuthSessionModel?> read() async {
    final raw = await _storage.read(key: _key);
    if (raw == null) return null;

    try {
      return AuthSessionModel.fromJson(
        json.decode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      await clear();
      return null;
    }
  }

  Future<void> clear() => _storage.delete(key: _key);
}
