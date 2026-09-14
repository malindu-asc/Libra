import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/widgets/main_shell.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/presentation/providers/current_member_provider.dart';
import '../../../onboarding/presentation/screens/onboarding_screen.dart';
import '../widgets/loading_dots.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(_navigateNext());
  }

  Future<void> _navigateNext() async {
    // Kick the read off first, then hold for the splash duration — the
    // storage lookup overlaps with the logo instead of adding to it.
    final restoring = ref.read(restoreSessionUseCaseProvider)(const NoParams());
    await Future<void>.delayed(const Duration(milliseconds: 1800));
    final result = await restoring;

    if (!mounted) return;

    final session = result.match((failure) => null, (session) => session);

    if (session == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
      return;
    }

    ref.read(currentMemberProvider.notifier).set(session.member);
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const MainShell()));
  }

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ), //shows the batter,time and those default stuff
    child: Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea( //doesnt overlay with notch and borders
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: Column(//content start from here
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 96,
                  height: 96,
                  fit: BoxFit.contain,
                ),
              ),
              const Spacer(flex: 4),
              const Center(child: LoadingDots()),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    ),
  );
}