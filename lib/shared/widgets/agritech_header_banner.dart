import 'package:flutter/material.dart';

import '../../core/localization/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../routes/app_routes.dart';

/// Auth screen header banner matching `agritech_8`, `agritech_2`, and `agritech_11`.
/// Preserves the top-right settings icon, centered 96px AgriTech logo,
/// agricultural terrace background, and title/subtitle outside the form card.
class AgriTechAuthHeader extends StatelessWidget {
  const AgriTechAuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.onSettingsTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onSettingsTap;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fadeColor = isDark
        ? AppColors.onSurface
        : AppColors.authBannerBackground;

    return Stack(
      children: [
        // Terrace Landscape Artwork
        Positioned.fill(
          child: Opacity(
            opacity: isDark ? 0.35 : 0.85,
            child: Image.asset(
              'lib/assets/images/terrace_bg.png',
              fit: BoxFit.cover,
              alignment: const Alignment(0, -0.4),
            ),
          ),
        ),
        // Gradient Feathering
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  fadeColor.withValues(alpha: 0.5),
                  fadeColor,
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),
        ),
        // Content + Top-Right Settings Gear
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Row: Settings Icon on the start side
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: IconButton(
                      key: const Key('header_settings_button'),
                      tooltip: strings.settingsTooltip,
                      onPressed:
                          onSettingsTap ??
                          () => Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.generalSettings),
                      icon: Icon(
                        Icons.settings_outlined,
                        size: 24,
                        color: isDark
                            ? AppColors.inversePrimary
                            : AppColors.tertiary,
                      ),
                    ),
                  ),
                ),
                // Centered AgriTech Logo (h-24 = 92px)
                Image.asset(
                  'lib/assets/logos/agritech_logo.png',
                  height: 88,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.headlineMd.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.inverseOnSurface
                          : AppColors.authHeadingText,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMd.copyWith(
                      color: isDark
                          ? AppColors.outlineVariant
                          : AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Internal screen header banner matching `agritech_10`, `3`, `9`, `14`, `6`,
/// `4`, `7`, `12`, `5`, `13`, `1`, and `15`.
/// Features top-start action button (settings gear or back arrow), top-end
/// AgriTech logo, and centered screen title & subtitle over the terrace artwork.
class AgriTechInternalHeader extends StatelessWidget {
  const AgriTechInternalHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showBackButton = false,
    this.replaceSettingsWithBackWhenCanPop = false,
    this.onLeadingTap,
  });

  final String title;
  final String subtitle;
  final bool showBackButton;
  final bool replaceSettingsWithBackWhenCanPop;
  final VoidCallback? onLeadingTap;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fadeColor = isDark
        ? AppColors.onSurface
        : AppColors.authBannerBackground;

    final canPop = Navigator.of(context).canPop();
    final shouldShowBack =
        showBackButton || (replaceSettingsWithBackWhenCanPop && canPop);

    return Stack(
      children: [
        Positioned.fill(
          child: Opacity(
            opacity: isDark ? 0.35 : 0.85,
            child: Image.asset(
              'lib/assets/images/terrace_bg.png',
              fit: BoxFit.cover,
              alignment: const Alignment(0, -0.45),
            ),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  fadeColor.withValues(alpha: 0.55),
                  fadeColor,
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
          ),
        ),
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Row: Leading Action on Start, Logo on End
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      key: Key(
                        shouldShowBack
                            ? 'header_back_button'
                            : 'header_settings_button',
                      ),
                      tooltip: shouldShowBack
                          ? strings.backTooltip
                          : strings.settingsTooltip,
                      onPressed:
                          onLeadingTap ??
                          () {
                            if (shouldShowBack) {
                              if (Navigator.of(context).canPop()) {
                                Navigator.of(context).pop();
                              } else {
                                Navigator.of(
                                  context,
                                ).pushReplacementNamed(AppRoutes.home);
                              }
                            } else {
                              Navigator.of(
                                context,
                              ).pushNamed(AppRoutes.settings);
                            }
                          },
                      icon: Icon(
                        shouldShowBack
                            ? Icons.arrow_back
                            : Icons.settings_outlined,
                        size: 24,
                        color: isDark
                            ? AppColors.inversePrimary
                            : AppColors.tertiary,
                      ),
                    ),
                    Image.asset(
                      'lib/assets/logos/agritech_logo.png',
                      height: 44,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headlineLg.copyWith(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.inversePrimary
                        : AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySm.copyWith(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.outlineVariant
                        : AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Reusable White Content Sheet Container (`rounded-t-[28px]`) that remains
/// anchored beneath the fixed header and restricts scrolling and the scrollbar
/// strictly to the white content area.
class AgriTechWhiteSheetContainer extends StatelessWidget {
  const AgriTechWhiteSheetContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(18, 22, 18, 28),
    this.scrollController,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetColor = isDark
        ? AppColors.inverseSurface
        : AppColors.surfaceContainerLowest;

    return Expanded(
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: sheetColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: const [
            BoxShadow(
              color: AppColors.ambientShadow,
              blurRadius: 24,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Scrollbar(
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
