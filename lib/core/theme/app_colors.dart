import 'package:flutter/material.dart';

/// Design tokens from the Libzo UI/UX design system, section 65.
abstract final class AppColors {
  // Brand — purple scale
  static const primary = Color(0xFF832DFE);
  static const primaryDark = Color(0xFF6B18E8);
  static const primaryDeep = Color(0xFF5510BF);
  static const primaryLight = Color(0xFFA66BFF);
  static const primarySoft = Color(0xFFF1E8FF);
  static const primaryVerySoft = Color(0xFFF8F4FF);

  // Neutral
  static const background = Color(0xFFFFFFFF);
  static const surface = Color(0xFFFFFFFF);
  static const softSurface = Color(0xFFF8F8F8);
  static const mutedSurface = Color(0xFFF3F3F3);

  static const textPrimary = Color(0xFF171717);
  static const textHeading = Color(0xFF111111);
  static const textSecondary = Color(0xFF5F5F5F);
  static const textTertiary = Color(0xFF888888);

  static const border = Color(0xFFE8E8E8);
  static const divider = Color(0xFFEEEEEE);

  static const disabledText = Color(0xFFA5A5A5);
  static const disabledSurface = Color(0xFFF2F2F2);

  // Semantic
  static const success = Color(0xFF2E8B57);
  static const successSoft = Color(0xFFEAF7EF);

  static const warning = Color(0xFFC77A00);
  static const warningSoft = Color(0xFFFFF5E5);

  static const error = Color(0xFFD64545);
  static const errorSoft = Color(0xFFFDECEC);

  static const info = Color(0xFF3976D3);
  static const infoSoft = Color(0xFFEDF4FF);

  // On-brand
  static const onPrimary = Color(0xFFFFFFFF);
}
