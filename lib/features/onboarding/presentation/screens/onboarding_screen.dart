import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/screens/login_screen.dart';

class OnboardingPageData {
  const OnboardingPageData({
    required this.lottieAsset,
    required this.title,
    required this.subtitle,
  });

  final String lottieAsset;
  final String title;
  final String subtitle;
}

const _onboardingPages = [
  OnboardingPageData(
    lottieAsset: 'assets/animations/onboarding_1.lottie',
    title: 'Expand Knowledge Hub',
    subtitle:
        "Explore the library collection and find books you'll want to read.",
  ),
  OnboardingPageData(
    lottieAsset: 'assets/animations/onboarding_2.lottie',
    title: 'Discover Your Next Book',
    subtitle: 'Browse the collection and find your next favorite read.',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentIndex = 0;

  bool get _isLastPage => _currentIndex == _onboardingPages.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _skip() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  void _next() {
    if (_isLastPage) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              right: AppSpacing.screenPadding,
              top: AppSpacing.sm,
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _skip,
                child: Text(
                  'Skip',
                  style: AppTextStyles.buttonLabel.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: _onboardingPages.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) =>
                  _OnboardingPage(data: _onboardingPages[index]),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_onboardingPages.length, (index) {
              final isActive = index == _currentIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.section,
              AppSpacing.screenPadding,
              AppSpacing.md,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                child: Text(_isLastPage ? 'Get Started' : 'Next'),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});

  final OnboardingPageData data;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
    child: Column(
      children: [
        const SizedBox(height: AppSpacing.section),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360, maxHeight: 360),
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.section),
              decoration: BoxDecoration(
                color: AppColors.infoSoft,
                borderRadius: AppRadius.largeCardRadius,
              ),
              child: Lottie.asset(data.lottieAsset, fit: BoxFit.contain),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          data.title,
          textAlign: TextAlign.center,
          style: AppTextStyles.displayMedium.copyWith(
            color: AppColors.textHeading,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          data.subtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    ),
  );
}
