import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_shell_providers.g.dart';

@riverpod
class MainShellTabIndex extends _$MainShellTabIndex {
  @override
  int build() => 0; //landing on the home

  void select(int index) => state = index;
}
