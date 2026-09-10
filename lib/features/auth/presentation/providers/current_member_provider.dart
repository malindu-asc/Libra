import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/authenticated_member.dart';

part 'current_member_provider.g.dart';

/// The logged-in member for this app session. `null` until [set] is called
/// (after a successful login) — nothing else in the app should assume a
/// member is present without checking first.
///
/// Exists because, until now, `AuthenticatedMember` only ever lived as a
/// constructor parameter handed down from Login's success navigation
/// (`MainShell(member: ...)`) — no provider anywhere could read "who's
/// currently logged in." `borrowings` needs exactly that, to stamp
/// `memberId` on a new borrowing — but this is app-wide session state, not
/// borrowings-specific, so it lives in `auth`.
@Riverpod(keepAlive: true)
class CurrentMember extends _$CurrentMember {
  @override
  AuthenticatedMember? build() => null;

  void set(AuthenticatedMember member) => state = member;

  void clear() => state = null;
}
