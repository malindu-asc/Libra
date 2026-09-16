import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/member_providers.dart';
import '../widgets/profile_success_dialog.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _current.dispose();
    _newPassword.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    // _confirm is never sent — matching it is a UI-only check.
    ref
        .read(changePasswordControllerProvider.notifier)
        .submit(
          currentPassword: _current.text,
          newPassword: _newPassword.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(changePasswordControllerProvider);
    final isSaving = state.isLoading;

    ref.listen(changePasswordControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (saved) async {
          if (!saved) return;
          await showProfileSuccessDialog(
            context,
            title: 'Password Updated!',
            message: 'Use your new password the next time you sign in.',
          );
          if (context.mounted) context.pop();
        },
        error: (error, _) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$error'))),
      );
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(),
        title: Text(
          'Change Password',
          style: AppTextStyles.sectionTitle.copyWith(
            color: AppColors.textHeading,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.md,
          ),
          children: [
            _PasswordField(
              label: 'Current Password',
              controller: _current,
              validator: (value) => (value ?? '').isEmpty
                  ? 'Enter your current password.'
                  : null,
            ),
            const SizedBox(height: AppSpacing.md),
            _PasswordField(
              label: 'New Password',
              controller: _newPassword,
              validator: (value) => (value ?? '').length < 8
                  ? 'Password must be at least 8 characters.'
                  : null,
            ),
            const SizedBox(height: AppSpacing.md),
            _PasswordField(
              label: 'Confirm New Password',
              controller: _confirm,
              validator: (value) =>
                  value == _newPassword.text ? null : 'Passwords do not match.',
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: isSaving ? null : _submit,
              child: isSaving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator.adaptive(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Text('Update Password'),
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordField extends StatefulWidget {
  const _PasswordField({
    required this.label,
    required this.controller,
    required this.validator,
  });

  final String label;
  final TextEditingController controller;
  final String? Function(String?) validator;

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        widget.label,
        style: AppTextStyles.inputLabel.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      const SizedBox(height: AppSpacing.xs),
      TextFormField(
        controller: widget.controller,
        obscureText: _obscure,
        validator: widget.validator,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            onPressed: () => setState(() => _obscure = !_obscure),
            icon: Icon(
              _obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
          ),
        ),
      ),
    ],
  );
}
