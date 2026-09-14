import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/main_shell_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/presentation/providers/current_member_provider.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../borrowings/domain/entities/borrowing.dart';
import '../../../borrowings/presentation/providers/borrowings_providers.dart';
import '../../domain/entities/member.dart';
import '../providers/member_providers.dart';
import 'edit_profile_screen.dart';


class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> { //login state manage
  bool _isLoggingOut = false;

  Future<void> _logout() async {
    setState(() => _isLoggingOut = true);

    final useCase = ref.read(logoutUseCaseProvider);
    await useCase(const NoParams());

    if (!mounted) return;

    // Session state is cleared regardless of what the server said — the
    // member asked to leave, so the app must stop showing their data.
    ref.read(currentMemberProvider.notifier).clear();
    ref.read(mainShellTabIndexProvider.notifier).select(0);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(myProfileProvider); //#

    return Scaffold(
      backgroundColor: AppColors.softSurface,
      body: profileAsync.when( //#
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) =>
            AppErrorState(onRetry: () => ref.invalidate(myProfileProvider)), //= riverpod is cachebase so once after the update it should rerender
        data: (member) => SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _Header(member: member),
              const SizedBox(height: AppSpacing.section),
              const _SectionLabel('ACCOUNT SETTINGS'),
              _SettingsTile(
                icon: Icons.person_outline,
                label: 'Edit Profile',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EditProfileScreen(member: member),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _SettingsTile(
                icon: Icons.lock_outline,
                label: 'Change Password',
                onTap: () {
                  // TODO: push ChangePasswordScreen once it exists.
                },
              ),
              const SizedBox(height: AppSpacing.section),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _isLoggingOut ? null : _logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.buttonRadius,
                      ),
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.section),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.member});

  final Member member;

  @override
  Widget build(BuildContext context) {//take member obj pass from mainui
    final initial = member.fullName.trim().isEmpty
        ? '?'
        : member.fullName.trim()[0].toUpperCase(); //show the firstletter as image

    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.section,
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 44,
            backgroundColor: AppColors.primarySoft,
            child: Text(
              initial,
              style: AppTextStyles.displayMedium.copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            member.fullName,
            style: AppTextStyles.screenTitle.copyWith(
              color: AppColors.textHeading,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            member.email,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),
          const _StatsRow(),
        ],
      ),
    );
  }
}

class _StatsRow extends ConsumerWidget { //statrow - fetching
  const _StatsRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) { //retrieve the length pass as numbers to  each _stat
    final activeAsync = ref.watch(
      borrowingListProvider(BorrowingStatus.active),
    );
    final historyAsync = ref.watch(
      borrowingListProvider(BorrowingStatus.history),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Stat(
          value: historyAsync.maybeWhen( //mean show the value,either -
            data: (items) => '${items.length}',
            orElse: () => '—',
          ),
          label: 'Books Read',
        ),
        Container(
          width: 1,
          height: 36,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          color: AppColors.border, //devider
        ),
        _Stat(
          value: activeAsync.maybeWhen(
            data: (items) => '${items.length}',
            orElse: () => '—',
          ),
          label: 'Borrowing',
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget { // make the ui for it,ifnot make it twice
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        value,
        style: AppTextStyles.sectionTitle.copyWith(
          color: AppColors.textHeading,
        ),
      ),
      const SizedBox(height: 2),
      Text(
        label,
        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
      ),
    ],
  );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.screenPadding,
      0,
      AppSpacing.screenPadding,
      AppSpacing.sm,
    ),
    child: Text(
      label,
      style: AppTextStyles.metadata.copyWith(
        color: AppColors.textTertiary,
        letterSpacing: 0.8,
      ),
    ),
  );
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.screenPadding,
    ),
    child: Material(
      color: AppColors.surface,
      borderRadius: AppRadius.cardRadius,
      child: InkWell(
        borderRadius: AppRadius.cardRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.softSurface,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: AppColors.textPrimary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.cardTitle.copyWith(
                    color: AppColors.textHeading,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}