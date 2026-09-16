import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../domain/entities/member.dart';
import '../providers/member_providers.dart';
import '../widgets/profile_success_dialog.dart';

/// A route can't carry a [Member] object, so this reads it from the provider
/// instead of taking it as an argument. The loading branch effectively never
/// shows — Profile is still mounted underneath keeping `myProfileProvider`
/// warm, so the value is already cached.
class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(myProfileProvider).when(
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator.adaptive()),
        ),
        error: (error, _) => Scaffold(
          body: AppErrorState(
            onRetry: () => ref.invalidate(myProfileProvider),
          ),
        ),
        data: (member) => _EditProfileForm(member: member),
      );
}

class _EditProfileForm extends ConsumerStatefulWidget {
  const _EditProfileForm({required this.member});

  final Member member;

  @override
  ConsumerState<_EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends ConsumerState<_EditProfileForm> {
  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final _formKey = GlobalKey<FormState>();
  late final _fullName = TextEditingController(text: widget.member.fullName);
  late final _email = TextEditingController(text: widget.member.email);
  late final _phone = TextEditingController(text: widget.member.phoneNumber);

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    ref
        .read(updateProfileControllerProvider.notifier)
        .submit(
          fullName: _fullName.text,
          email: _email.text,
          phoneNumber: _phone.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(updateProfileControllerProvider);
    final isSaving = state.isLoading;

    ref.listen(updateProfileControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (saved) async {
          if (!saved) return;
          await showProfileSuccessDialog(
            context,
            title: 'Profile Updated!',
            message: 'Your personal information has been saved successfully.',
          );
          if (context.mounted) context.pop();
        },
        error: (error, _) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$error'))),
      );
    });

    final initial = widget.member.fullName.trim().isEmpty
        ? '?'
        : widget.member.fullName.trim()[0].toUpperCase();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(),
        title: Text(
          'Edit Profile',
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
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primarySoft,
                child: Text(
                  initial,
                  style: AppTextStyles.displayMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.section),
            _LabeledField(
              label: 'Full Name',
              controller: _fullName,
              icon: Icons.person_outline,
              validator: (value) => (value ?? '').trim().isEmpty
                  ? 'Enter your full name.'
                  : null,
            ),
            const SizedBox(height: AppSpacing.md),
            _LabeledField(
              label: 'Email',
              controller: _email,
              icon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => _emailPattern.hasMatch((value ?? '').trim())
                  ? null
                  : 'Enter a valid email address.',
            ),
            const SizedBox(height: AppSpacing.md),
            _LabeledField(
              label: 'Phone Number',
              controller: _phone,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (value) => (value ?? '').trim().isEmpty
                  ? 'Enter your phone number.'
                  : null,
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
                  : const Text('Save Changes'),
            ),
          ),
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.controller,
    required this.icon,
    required this.validator,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String? Function(String?) validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: AppTextStyles.inputLabel.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      const SizedBox(height: AppSpacing.xs),
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(prefixIcon: Icon(icon)),
      ),
    ],
  );
}
