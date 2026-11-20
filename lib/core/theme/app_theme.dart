import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Application theme configurations based on `terrace_earth/DESIGN.md`.
/// - [lightTheme] reproduces the exact Stitch Light theme specifications.
/// - [darkTheme] provides a consistent dark interpretation derived from the
///   inverse and fixed tokens defined in `DESIGN.md`.
abstract final class AppTheme {
  // --- Shape & Spacing Constants from DESIGN.md ---
  static const double radiusSm = 4.0; // 0.25rem
  static const double radiusDefault = 8.0; // 0.5rem
  static const double radiusMd = 12.0; // 0.75rem
  static const double radiusLg = 16.0; // 1.0rem
  static const double radiusXl = 24.0; // 1.5rem
  static const double radiusFull = 9999.0;

  static const double spaceXs = 4.0; // 0.25rem
  static const double spaceSm = 8.0; // 0.5rem
  static const double spaceMd = 16.0; // 1.0rem
  static const double spaceLg = 24.0; // 1.5rem
  static const double spaceXl = 36.0; // 2.25rem
  static const double horizontalMargin = 20.0; // 1.25rem
  static const double primaryButtonHeight = 52.0;

  /// Approved Light Theme matching Stitch HTML/CSS and `DESIGN.md`.
  static ThemeData get lightTheme {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      primaryFixed: AppColors.primaryFixed,
      primaryFixedDim: AppColors.primaryFixedDim,
      onPrimaryFixed: AppColors.onPrimaryFixed,
      onPrimaryFixedVariant: AppColors.onPrimaryFixedVariant,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      secondaryFixed: AppColors.secondaryFixed,
      secondaryFixedDim: AppColors.secondaryFixedDim,
      onSecondaryFixed: AppColors.onSecondaryFixed,
      onSecondaryFixedVariant: AppColors.onSecondaryFixedVariant,
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.onTertiary,
      tertiaryContainer: AppColors.tertiaryContainer,
      onTertiaryContainer: AppColors.onTertiaryContainer,
      tertiaryFixed: AppColors.tertiaryFixed,
      tertiaryFixedDim: AppColors.tertiaryFixedDim,
      onTertiaryFixed: AppColors.onTertiaryFixed,
      onTertiaryFixedVariant: AppColors.onTertiaryFixedVariant,
      error: AppColors.error,
      onError: AppColors.onError,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.onErrorContainer,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      surfaceDim: AppColors.surfaceDim,
      surfaceBright: AppColors.surfaceBright,
      surfaceContainerLowest: AppColors.surfaceContainerLowest,
      surfaceContainerLow: AppColors.surfaceContainerLow,
      surfaceContainer: AppColors.surfaceContainer,
      surfaceContainerHigh: AppColors.surfaceContainerHigh,
      surfaceContainerHighest: AppColors.surfaceContainerHighest,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      surfaceTint: AppColors.surfaceTint,
      inverseSurface: AppColors.inverseSurface,
      onInverseSurface: AppColors.inverseOnSurface,
      inversePrimary: AppColors.inversePrimary,
    );

    final textTheme = AppTextStyles.buildTextTheme(
      primaryTextColor: AppColors.onSurface,
      secondaryTextColor: AppColors.onSurfaceVariant,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: AppTextStyles.fontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.surface,
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.onSurface),
        titleTextStyle: AppTextStyles.headlineSm,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerLowest,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: const BorderSide(color: AppColors.borderOutline, width: 1.0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryContainer,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          minimumSize: const Size.fromHeight(primaryButtonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: AppTextStyles.labelLg.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.onPrimary,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryContainer,
          backgroundColor: Colors.transparent,
          minimumSize: const Size.fromHeight(primaryButtonHeight),
          side: const BorderSide(color: AppColors.primaryContainer, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: AppTextStyles.labelLg.copyWith(
            color: AppColors.primaryContainer,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.outline),
        labelStyle: AppTextStyles.labelMd.copyWith(color: AppColors.onSurface),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(
            color: AppColors.borderOutline,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(
            color: AppColors.borderOutline,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(
            color: AppColors.primaryContainer,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: AppColors.error, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderOutline,
        thickness: 1.0,
        space: 1.0,
      ),
    );
  }

  /// Consistent Dark Theme interpretation derived from the inverse and fixed
  /// tokens specified in `terrace_earth/DESIGN.md`.
  static ThemeData get darkTheme {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.inversePrimary,
      onPrimary: AppColors.onPrimaryFixed,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      primaryFixed: AppColors.primaryFixed,
      primaryFixedDim: AppColors.primaryFixedDim,
      onPrimaryFixed: AppColors.onPrimaryFixed,
      onPrimaryFixedVariant: AppColors.onPrimaryFixedVariant,
      secondary: AppColors.secondaryFixedDim,
      onSecondary: AppColors.onSecondaryFixed,
      secondaryContainer: AppColors.onSecondaryFixedVariant,
      onSecondaryContainer: AppColors.secondaryFixed,
      secondaryFixed: AppColors.secondaryFixed,
      secondaryFixedDim: AppColors.secondaryFixedDim,
      onSecondaryFixed: AppColors.onSecondaryFixed,
      onSecondaryFixedVariant: AppColors.onSecondaryFixedVariant,
      tertiary: AppColors.tertiaryFixedDim,
      onTertiary: AppColors.onTertiaryFixed,
      tertiaryContainer: AppColors.tertiaryContainer,
      onTertiaryContainer: AppColors.onTertiaryContainer,
      tertiaryFixed: AppColors.tertiaryFixed,
      tertiaryFixedDim: AppColors.tertiaryFixedDim,
      onTertiaryFixed: AppColors.onTertiaryFixed,
      onTertiaryFixedVariant: AppColors.onTertiaryFixedVariant,
      error: AppColors.errorContainer,
      onError: AppColors.onErrorContainer,
      errorContainer: AppColors.onErrorContainer,
      onErrorContainer: AppColors.errorContainer,
      surface: AppColors.onSurface,
      onSurface: AppColors.inverseOnSurface,
      surfaceDim: AppColors.onPrimaryFixed,
      surfaceBright: AppColors.inverseSurface,
      surfaceContainerLowest: AppColors.onPrimaryFixed,
      surfaceContainerLow: AppColors.onSurface,
      surfaceContainer: AppColors.inverseSurface,
      surfaceContainerHigh: AppColors.onSurfaceVariant,
      surfaceContainerHighest: AppColors.onSurfaceVariant,
      onSurfaceVariant: AppColors.outlineVariant,
      outline: AppColors.outline,
      outlineVariant: AppColors.onSurfaceVariant,
      surfaceTint: AppColors.inversePrimary,
      inverseSurface: AppColors.surface,
      onInverseSurface: AppColors.onSurface,
      inversePrimary: AppColors.primary,
    );

    final textTheme = AppTextStyles.buildTextTheme(
      primaryTextColor: AppColors.inverseOnSurface,
      secondaryTextColor: AppColors.outlineVariant,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: AppTextStyles.fontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.onSurface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.inverseOnSurface),
        titleTextStyle: AppTextStyles.headlineSm.copyWith(
          color: AppColors.inverseOnSurface,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.inverseSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: const BorderSide(color: AppColors.onSurfaceVariant, width: 1.0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryContainer,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          minimumSize: const Size.fromHeight(primaryButtonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: AppTextStyles.labelLg.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.onPrimary,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.inversePrimary,
          backgroundColor: Colors.transparent,
          minimumSize: const Size.fromHeight(primaryButtonHeight),
          side: const BorderSide(color: AppColors.inversePrimary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: AppTextStyles.labelLg.copyWith(
            color: AppColors.inversePrimary,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inverseSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.outline),
        labelStyle: AppTextStyles.labelMd.copyWith(
          color: AppColors.inverseOnSurface,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(
            color: AppColors.onSurfaceVariant,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(
            color: AppColors.onSurfaceVariant,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(
            color: AppColors.inversePrimary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(
            color: AppColors.errorContainer,
            width: 1.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(
            color: AppColors.errorContainer,
            width: 1.5,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.onSurfaceVariant,
        thickness: 1.0,
        space: 1.0,
      ),
    );
  }
}
