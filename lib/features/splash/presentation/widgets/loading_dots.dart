import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Three softly pulsing dots — the "very subtle purple loading indicator"
/// called for on the splash screen (design doc section 24).
class LoadingDots extends StatefulWidget {
  const LoadingDots({super.key});

  @override
  State<LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (context, _) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          // Stagger each dot's pulse by a third of the cycle.
          final t = (_controller.value - index * 0.2) % 1.0;
          final opacity = 0.3 + 0.7 * (0.5 - (t - 0.5).abs()) * 2;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Opacity(
              opacity: opacity.clamp(0.3, 1.0),
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          );
        }),
      );
    },
  );
}