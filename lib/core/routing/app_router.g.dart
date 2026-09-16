// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Every route in the app, declared in one place — the folder `plan.md` §3
/// always reserved for this.
///
/// A provider rather than a top-level final so [redirect] can read
/// `currentMemberProvider`. `keepAlive` because rebuilding the router would
/// throw away the whole navigation stack.

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// Every route in the app, declared in one place — the folder `plan.md` §3
/// always reserved for this.
///
/// A provider rather than a top-level final so [redirect] can read
/// `currentMemberProvider`. `keepAlive` because rebuilding the router would
/// throw away the whole navigation stack.

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// Every route in the app, declared in one place — the folder `plan.md` §3
  /// always reserved for this.
  ///
  /// A provider rather than a top-level final so [redirect] can read
  /// `currentMemberProvider`. `keepAlive` because rebuilding the router would
  /// throw away the whole navigation stack.
  AppRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$appRouterHash() => r'b24f20988b2ec17b31fab2678ecff423d4f0b7a0';
