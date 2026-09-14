import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Shared empty-state view — icon, heading, message, optional action.
/// Matches the Libzo design doc §41 pattern ("No books found" / "No
/// borrowing history" / etc.), so every screen's empty state looks the same.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.section),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: AppColors.textTertiary),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.textHeading,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    ),
  );
}
