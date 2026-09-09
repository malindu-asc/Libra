import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/domain/entities/member.dart';

/// Placeholder — swapped for the real designed Home screen (with bottom nav
/// shell) once that Figma screen is provided. Exists now so the auth flow
/// has somewhere real to land on success.
class HomeScreen extends StatelessWidget {
  const HomeScreen({required this.member, super.key});

  final Member member;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Welcome, ${member.fullName}!',
                textAlign: TextAlign.center,
                style: AppTextStyles.screenTitle.copyWith(
                  color: AppColors.textHeading,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                member.email,
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'This is a placeholder Home screen — swap in the real design when it\'s ready.',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
