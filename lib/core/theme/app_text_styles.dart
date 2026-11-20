import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Exact Cairo typography scale from `terrace_earth/DESIGN.md`.
/// Uses the locally bundled `Cairo` font family for offline rendering.
abstract final class AppTextStyles {
  static const String fontFamily = 'Cairo';

  // headline-lg: 26px / 38px, weight 700
  static const TextStyle headlineLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    height: 38 / 26,
    color: AppColors.onSurface,
  );

  // headline-md: 22px / 32px, weight 700
  static const TextStyle headlineMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 32 / 22,
    color: AppColors.onSurface,
  );

  // headline-sm: 18px / 28px, weight 600
  static const TextStyle headlineSm = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 28 / 18,
    color: AppColors.onSurface,
  );

  // body-lg: 16px / 26px, weight 500
  static const TextStyle bodyLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 26 / 16,
    color: AppColors.onSurface,
  );

  // body-md: 14px / 24px, weight 400
  static const TextStyle bodyMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 24 / 14,
    color: AppColors.onSurface,
  );

  // body-sm: 12px / 20px, weight 400
  static const TextStyle bodySm = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 20 / 12,
    color: AppColors.onSurfaceVariant,
  );

  // label-lg: 15px / 24px, weight 600
  static const TextStyle labelLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 24 / 15,
    color: AppColors.onSurface,
  );

  // label-md: 13px / 20px, weight 600
  static const TextStyle labelMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 20 / 13,
    color: AppColors.onSurface,
  );

  // label-sm: 11px / 16px, weight 500
  static const TextStyle labelSm = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 16 / 11,
    color: AppColors.onSurfaceVariant,
  );

  /// Builds a Flutter [TextTheme] mapped to the Cairo typography scale.
  static TextTheme buildTextTheme({
    required Color primaryTextColor,
    required Color secondaryTextColor,
  }) {
    return TextTheme(
      headlineLarge: headlineLg.copyWith(color: primaryTextColor),
      headlineMedium: headlineMd.copyWith(color: primaryTextColor),
      headlineSmall: headlineSm.copyWith(color: primaryTextColor),
      titleLarge: headlineSm.copyWith(color: primaryTextColor),
      titleMedium: labelLg.copyWith(color: primaryTextColor),
      titleSmall: labelMd.copyWith(color: primaryTextColor),
      bodyLarge: bodyLg.copyWith(color: primaryTextColor),
      bodyMedium: bodyMd.copyWith(color: primaryTextColor),
      bodySmall: bodySm.copyWith(color: secondaryTextColor),
      labelLarge: labelLg.copyWith(color: primaryTextColor),
      labelMedium: labelMd.copyWith(color: primaryTextColor),
      labelSmall: labelSm.copyWith(color: secondaryTextColor),
    );
  }
}
