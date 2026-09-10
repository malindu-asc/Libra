// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_shell_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MainShellTabIndex)
final mainShellTabIndexProvider = MainShellTabIndexProvider._();

final class MainShellTabIndexProvider
    extends $NotifierProvider<MainShellTabIndex, int> {
  MainShellTabIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mainShellTabIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mainShellTabIndexHash();

  @$internal
  @override
  MainShellTabIndex create() => MainShellTabIndex();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$mainShellTabIndexHash() => r'5bc7fee94c8cd646335024971e22110c52e46392';

abstract class _$MainShellTabIndex extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
