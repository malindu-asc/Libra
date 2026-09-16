import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/member_model.dart';
import 'member_exception.dart';

/// Mock datasource — reads `assets/data/users.json` once, then serves and
/// mutates an in-memory copy, so a profile edit or password change survives
/// the rest of the session (bundled assets can't be written back to).
///
/// Rows stay as raw maps rather than `MemberModel`s because each row also
/// carries a `password`, which has no home on the domain entity — same
/// reasoning `auth_local_datasource.dart` already uses.
abstract class MemberLocalDataSource {
  Future<MemberModel> getMyProfile();

  Future<MemberModel> updateMyProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
  });

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}

class MemberLocalDatasourceImpl implements MemberLocalDataSource {
  MemberLocalDatasourceImpl(this._currentMemberId);

  /// Reads the logged-in member's id at call time — the mock's stand-in for a
  /// real backend reading identity off the JWT.
  final String? Function() _currentMemberId;

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  List<Map<String, dynamic>>? _cache;

  Future<List<Map<String, dynamic>>> _load() async {
    final cached = _cache;
    if (cached != null) return cached;

    final raw = await rootBundle.loadString('assets/data/users.json');
    final rows = (json.decode(raw) as List<dynamic>)
        .cast<Map<String, dynamic>>();
    _cache = rows;
    return rows;
  }

  Future<Map<String, dynamic>> _currentRow() async {
    final id = _currentMemberId();
    if (id == null) {
      throw const MemberException('You must be logged in to do that.'); //used member_exception.dart
    }

    final rows = await _load();
    for (final row in rows) {
      if (row['id'] == id) return row;
    }
    throw const MemberException('Your profile could not be found.');
  }

  @override
  Future<MemberModel> getMyProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MemberModel.fromJson(await _currentRow());
  }

  @override
  Future<MemberModel> updateMyProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    if (fullName.trim().isEmpty) {
      throw const MemberException('Enter your full name.');
    }
    if (!_emailPattern.hasMatch(email)) {
      throw const MemberException('Enter a valid email address.');
    }

    final row = await _currentRow();
    final rows = await _load();
    final takenByAnother = rows.any(
      (other) =>
          other['id'] != row['id'] &&
          (other['email'] as String).toLowerCase() == email.toLowerCase(),
    );
    if (takenByAnother) {
      throw const MemberException('An account with this email already exists.');
    }

    row['fullName'] = fullName.trim();
    row['email'] = email.trim();
    row['phoneNumber'] = phoneNumber.trim();
    return MemberModel.fromJson(row);
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final row = await _currentRow();
    if (row['password'] != currentPassword) {
      throw const MemberException('Your current password is incorrect.');
    }
    if (newPassword.length < 8) {
      throw const MemberException('Password must be at least 8 characters.');
    }
    if (newPassword == currentPassword) {
      throw const MemberException(
        'Your new password must be different from the current one.',
      );
    }

    row['password'] = newPassword;
  }
}