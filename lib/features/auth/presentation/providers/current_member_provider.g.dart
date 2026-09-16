// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_member_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(CurrentMember)
final currentMemberProvider = CurrentMemberProvider._();

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
final class CurrentMemberProvider
    extends $NotifierProvider<CurrentMember, AuthenticatedMember?> {
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
  CurrentMemberProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentMemberProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentMemberHash();

  @$internal
  @override
  CurrentMember create() => CurrentMember();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthenticatedMember? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthenticatedMember?>(value),
    );
  }
}

String _$currentMemberHash() => r'b2a4f81fcd68c7b15d4a29dff4c7e917ceb8c6a5';

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

abstract class _$CurrentMember extends $Notifier<AuthenticatedMember?> {
  AuthenticatedMember? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AuthenticatedMember?, AuthenticatedMember?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthenticatedMember?, AuthenticatedMember?>,
              AuthenticatedMember?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
