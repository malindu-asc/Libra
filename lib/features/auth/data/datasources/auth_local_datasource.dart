import 'dart:convert';

import 'package:flutter/services.dart';

import 'auth_exception.dart';
import '../models/auth_session_model.dart';
import '../models/authenticated_member_model.dart';

/// Mock datasource — simulates network delay and basic validation so the UI
/// has real loading/error/success states to react to.;
/// nothing above this layer (repository, use cases, screens) needs to change.
abstract class AuthLocalDataSource {
  Future<AuthSessionModel> login({required String email, required String password});

  Future<void> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  });

  Future<void> forgotPassword({required String email});

  Future<void> logout();
}

class AuthLocalDatasourceImpl implements AuthLocalDataSource {
  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  
  /// check for a clashing email, not actually add a new row.
  Future<List<Map<String, dynamic>>> _loadSampleUsers() async {
    final raw = await rootBundle.loadString('assets/data/users.json');
    return (json.decode(raw) as List<dynamic>).cast<Map<String, dynamic>>();
  }

  @override
  Future<AuthSessionModel> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (!_emailPattern.hasMatch(email)) {
      throw const AuthException('Enter a valid email address.');
    }

    final users = await _loadSampleUsers();
    Map<String, dynamic>? match;
    for (final user in users) {
      if ((user['email'] as String).toLowerCase() == email.toLowerCase()) {
        match = user;
        break;
      }
    }

    if (match == null || match['password'] != password) {
      throw const AuthException('Incorrect email or password.');
    }

    return AuthSessionModel(
      accessToken: 'mock-access-token',
      refreshToken: 'mock-refresh-token',
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
      member: AuthenticatedMemberModel(
        id: match['id'] as String,
        fullName: match['fullName'] as String,
        email: match['email'] as String,
      ),
    );
  }

  @override
  Future<void> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (fullName.trim().isEmpty) {
      throw const AuthException('Enter your full name.');
    }
    if (!_emailPattern.hasMatch(email)) {
      throw const AuthException('Enter a valid email address.');
    }
    if (phoneNumber.trim().isEmpty) {
      throw const AuthException('Enter your phone number.');
    }
    if (password.length < 8) {
      throw const AuthException('Password must be at least 8 characters.');
    }

    final users = await _loadSampleUsers();
    final alreadyExists = users.any(
      (user) => (user['email'] as String).toLowerCase() == email.toLowerCase(),
    );
    if (alreadyExists) {
      throw const AuthException('An account with this email already exists.');
    }
    // Bundled JSON is read-only at runtime, so there's nothing to persist -
    // matches the real backend's "don't auto-login" recommendation anyway.
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (!_emailPattern.hasMatch(email)) {
      throw const AuthException('Enter a valid email address.');
    }
    // Backend always returns a generic success from here regardless of
    // whether the email exists — nothing else to validate.
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 400));
    // Nothing to revoke in the mock — the real datasource will POST the
    // refresh token here so the server can invalidate it.
  }
}
