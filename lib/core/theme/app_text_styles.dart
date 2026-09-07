import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Type scale, design system sections 7–10.
///
/// Styles carry size/weight/line-height only — callers apply color from
/// [AppColors] based on context (heading vs. secondary vs. actionable text).
abstract final class AppTextStyles {
  static TextStyle _inter({
    required double size,
    required FontWeight weight,
    required double height,
  }) => GoogleFonts.inter(fontSize: size, fontWeight: weight, height: height);

  static final displayLarge = _inter(
    size: 32,
    weight: FontWeight.w700,
    height: 38 / 32,
  );
  static final displayMedium = _inter(
    size: 28,
    weight: FontWeight.w700,
    height: 34 / 28,
  );

  static final screenTitle = _inter(
    size: 24,
    weight: FontWeight.w700,
    height: 30 / 24,
  );
  static final sectionTitle = _inter(
    size: 18,
    weight: FontWeight.w700,
    height: 24 / 18,
  );
  static final cardTitle = _inter(
    size: 16,
    weight: FontWeight.w600,
    height: 21 / 16,
  );

  static final bodyLarge = _inter(
    size: 16,
    weight: FontWeight.w400,
    height: 24 / 16,
  );
  static final body = _inter(
    size: 14,
    weight: FontWeight.w400,
    height: 21 / 14,
  );
  static final caption = _inter(
    size: 12,
    weight: FontWeight.w400,
    height: 17 / 12,
  );
  static final metadata = _inter(
    size: 12,
    weight: FontWeight.w500,
    height: 18 / 12,
  );

  // Component-specific
  static final buttonLabel = _inter(
    size: 15,
    weight: FontWeight.w600,
    height: 1.2,
  );
  static final inputLabel = _inter(
    size: 13,
    weight: FontWeight.w500,
    height: 1.3,
  );
  static final inputText = _inter(
    size: 15,
    weight: FontWeight.w500,
    height: 1.3,
  );
  static final inputPlaceholder = _inter(
    size: 14,
    weight: FontWeight.w400,
    height: 1.3,
  );
  static final errorText = _inter(
    size: 12,
    weight: FontWeight.w400,
    height: 1.4,
  );
}
