import 'package:flutter/material.dart';

/// Exact "Terrace Earth" color palette tokens from `terrace_earth/DESIGN.md`
/// and the exported Stitch HTML/Tailwind configurations.
abstract final class AppColors {
  // --- Core Surface & Background Tokens (DESIGN.md YAML & Tailwind Config) ---
  static const Color surface = Color(0xFFF8FAF5);
  static const Color surfaceDim = Color(0xFFD8DBD6);
  static const Color surfaceBright = Color(0xFFF8FAF5);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F4EF);
  static const Color surfaceContainer = Color(0xFFECEFEA);
  static const Color surfaceContainerHigh = Color(0xFFE7E9E4);
  static const Color surfaceContainerHighest = Color(0xFFE1E3DE);
  static const Color surfaceVariant = Color(0xFFE1E3DE);
  static const Color background = Color(0xFFF8FAF5);

  // --- On-Surface & Inverse Tokens ---
  static const Color onSurface = Color(0xFF191C1A);
  static const Color onBackground = Color(0xFF191C1A);
  static const Color onSurfaceVariant = Color(0xFF41493C);
  static const Color inverseSurface = Color(0xFF2E312E);
  static const Color inverseOnSurface = Color(0xFFEFF1EC);

  // --- Outline & Surface Tint ---
  static const Color outline = Color(0xFF727A6B);
  static const Color outlineVariant = Color(0xFFC1C9B8);
  static const Color surfaceTint = Color(0xFF336B1F);

  // --- Primary Tokens ---
  static const Color primary = Color(0xFF185004);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF31691D);
  static const Color onPrimaryContainer = Color(0xFFA7E78B);
  static const Color inversePrimary = Color(0xFF98D77D);
  static const Color primaryFixed = Color(0xFFB3F496);
  static const Color primaryFixedDim = Color(0xFF98D77D);
  static const Color onPrimaryFixed = Color(0xFF052100);
  static const Color onPrimaryFixedVariant = Color(0xFF1A5206);

  // --- Secondary Tokens ---
  static const Color secondary = Color(0xFF765934);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFFED6A7);
  static const Color onSecondaryContainer = Color(0xFF795B36);
  static const Color secondaryFixed = Color(0xFFFFDDB6);
  static const Color secondaryFixedDim = Color(0xFFE6C093);
  static const Color onSecondaryFixed = Color(0xFF2A1800);
  static const Color onSecondaryFixedVariant = Color(0xFF5C421F);

  // --- Tertiary Tokens ---
  static const Color tertiary = Color(0xFF274E29);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF3E663F);
  static const Color onTertiaryContainer = Color(0xFFB5E2B0);
  static const Color tertiaryFixed = Color(0xFFC1EEBC);
  static const Color tertiaryFixedDim = Color(0xFFA5D2A2);
  static const Color onTertiaryFixed = Color(0xFF002106);
  static const Color onTertiaryFixedVariant = Color(0xFF284F2A);

  // --- Error Tokens ---
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // --- Documented Narrative Spec Tokens in DESIGN.md ---
  static const Color brandPrimary = Color(0xFF31691D);
  static const Color brandSecondary = Color(0xFF8C6D46);
  static const Color brandTertiary = Color(0xFF588157);
  static const Color neutralSurface = Color(0xFFF7F9F4);
  static const Color borderOutline = Color(0xFFE2E8DC);

  // --- Screen-Specific Inline Colors from Stitch `code.html` ---
  static const Color authBannerBackground = Color(0xFFEEF3EB);
  static const Color authHeadingText = Color(0xFF1D3315);
  static const Color cardSoftGreenTint = Color(0xFFF0F7EE);
  static const Color badgeSoftGreen = Color(0xFFE8F5E9);
  static const Color badgeBorderGreen = Color(0xFFE1EEDD);
  static const Color errorSoftBackground = Color(0xFFFDE8E8);
  static const Color errorDarkText = Color(0xFF991B1B);

  // --- Ambient Shadow Color (`0 8px 24px rgba(49, 105, 29, 0.04)`) ---
  static const Color ambientShadow = Color(0x0A31691D);
}
