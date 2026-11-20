import 'package:flutter/material.dart';

import '../../../../core/config/app_state.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/dialogs/agritech_modals.dart';
import '../../../../shared/widgets/agritech_header_banner.dart';

/// Screen 14 (`agritech_1` — Settings / `الإعدادات`).
/// Reproduces `design_reference/stitch_agritech_mobile_auth_redesign/agritech_1/screen.png`
/// and `code.html`.
/// Supports full Arabic (RTL) and English (LTR) localization and restricts
/// scrolling strictly to the white content container.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final strings = AppStrings.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.onSurface
        : AppColors.authBannerBackground;
    final cardBg = isDark ? AppColors.onSurface : AppColors.surfaceContainerLow;
    final textColor = isDark ? AppColors.inverseOnSurface : AppColors.onSurface;
    final subColor = isDark
        ? AppColors.outlineVariant
        : AppColors.onSurfaceVariant;
    final headingColor = isDark ? AppColors.inversePrimary : AppColors.primary;

    return Directionality(
      textDirection: strings.textDirection,
      child: Scaffold(
        backgroundColor: bgColor,
        body: Column(
          children: [
            AgriTechInternalHeader(
              title: strings.settingsTitle,
              subtitle: strings.settingsSubtitle,
              showBackButton: true,
            ),
            AgriTechWhiteSheetContainer(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Section Header: `تفضيلات التطبيق` / `Application Preferences`
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 16,
                        decoration: BoxDecoration(
                          color: headingColor,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        strings.appPreferencesSection,
                        style: AppTextStyles.labelLg.copyWith(
                          color: headingColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Language (`اللغة` / `Language`)
                  _SubSectionTitle(
                    icon: Icons.translate,
                    title: strings.languageTitle,
                    textColor: textColor,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _LanguageCard(
                          key: const Key('settings_lang_ar_button'),
                          title: strings.arabicLabel,
                          badgeText: strings.arabicBadge,
                          selected: appState.isArabic,
                          isDark: isDark,
                          textColor: textColor,
                          subColor: subColor,
                          onTap: () => appState.setLanguageCode('ar'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _LanguageCard(
                          key: const Key('settings_lang_en_button'),
                          title: strings.englishLabel,
                          badgeText: strings.englishBadge,
                          selected: !appState.isArabic,
                          isDark: isDark,
                          textColor: textColor,
                          subColor: subColor,
                          onTap: () => appState.setLanguageCode('en'),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: Divider(height: 1),
                  ),

                  // Appearance (`المظهر` / `Appearance`)
                  _SubSectionTitle(
                    icon: Icons.palette_outlined,
                    title: strings.appearanceTitle,
                    textColor: textColor,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _ThemeOptionButton(
                            key: const Key('settings_theme_light'),
                            icon: Icons.light_mode_outlined,
                            label: strings.themeLight,
                            selected: appState.themeMode == ThemeMode.light,
                            isDark: isDark,
                            textColor: textColor,
                            subColor: subColor,
                            onTap: () => appState.setThemeMode(ThemeMode.light),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _ThemeOptionButton(
                            key: const Key('settings_theme_dark'),
                            icon: Icons.dark_mode_outlined,
                            label: strings.themeDark,
                            selected: appState.themeMode == ThemeMode.dark,
                            isDark: isDark,
                            textColor: textColor,
                            subColor: subColor,
                            onTap: () => appState.setThemeMode(ThemeMode.dark),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _ThemeOptionButton(
                            key: const Key('settings_theme_system'),
                            icon: Icons.settings_brightness_outlined,
                            label: strings.themeSystem,
                            selected: appState.themeMode == ThemeMode.system,
                            isDark: isDark,
                            textColor: textColor,
                            subColor: subColor,
                            onTap: () =>
                                appState.setThemeMode(ThemeMode.system),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: Divider(height: 1),
                  ),

                  // Notifications (`الإشعارات` / `Notifications`)
                  _SubSectionTitle(
                    icon: Icons.notifications_outlined,
                    title: strings.notificationsSectionTitle,
                    textColor: textColor,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                strings.agriAlertsTitle,
                                style: AppTextStyles.labelLg.copyWith(
                                  color: textColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                strings.agriAlertsDescription,
                                style: AppTextStyles.bodySm.copyWith(
                                  color: subColor,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Switch(
                          value: appState.agriculturalNotifications,
                          thumbColor: const WidgetStatePropertyAll(
                            Colors.white,
                          ),
                          activeTrackColor: AppColors.primaryContainer,
                          onChanged: appState.setAgriculturalNotifications,
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: Divider(height: 1),
                  ),

                  // Connection & Sync (`الاتصال والمزامنة` / `Connection & Sync`)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _SubSectionTitle(
                        icon: Icons.cloud_sync_outlined,
                        title: strings.syncAndConnectionTitle,
                        textColor: textColor,
                        isDark: isDark,
                      ),
                      TextButton.icon(
                        key: const Key('settings_sync_button'),
                        onPressed: () {
                          appState.triggerManualSync();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(strings.syncSuccessToast),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: Icon(Icons.sync, size: 16, color: headingColor),
                        label: Text(
                          strings.refreshAction,
                          style: AppTextStyles.labelSm.copyWith(
                            color: headingColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryContainer,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              strings.connectionStatusLabel,
                              style: AppTextStyles.bodyMd.copyWith(
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              strings.connectedToServer,
                              style: AppTextStyles.labelMd.copyWith(
                                color: headingColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(Icons.wifi, size: 16, color: headingColor),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.history, size: 18, color: subColor),
                            const SizedBox(width: 8),
                            Text(
                              strings.lastFieldSyncLabel,
                              style: AppTextStyles.bodyMd.copyWith(
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.inverseSurface
                                : AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            strings.syncTimeDisplay(appState.lastSyncText),
                            style: AppTextStyles.labelSm.copyWith(
                              color: subColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: Divider(height: 1),
                  ),

                  // Help & Support (`المساعدة والدعم` / `Help & Support`)
                  _SubSectionTitle(
                    icon: Icons.help_outline,
                    title: strings.helpAndSupportTitle,
                    textColor: textColor,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 10),
                  _InteractiveSupportTile(
                    key: const Key('settings_user_guide_button'),
                    icon: Icons.menu_book_outlined,
                    title: strings.userGuideTitle,
                    subtitle: strings.userGuideSubtitle,
                    cardBg: cardBg,
                    textColor: textColor,
                    subColor: subColor,
                    isDark: isDark,
                    onTap: () => showAgriTechUserGuideSheet(context),
                  ),
                  const SizedBox(height: 10),
                  _InteractiveSupportTile(
                    key: const Key('settings_support_team_button'),
                    icon: Icons.support_agent_outlined,
                    title: strings.supportTeamTitle,
                    subtitle: strings.supportTeamSubtitle,
                    cardBg: cardBg,
                    textColor: textColor,
                    subColor: subColor,
                    isDark: isDark,
                    onTap: () => showAgriTechSupportSheet(context),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: Divider(height: 1),
                  ),

                  // About the Application (`حول التطبيق` / `About the Application`)
                  _SubSectionTitle(
                    icon: Icons.info_outline,
                    title: strings.aboutAppTitle,
                    textColor: textColor,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.inverseSurface
                                        : AppColors.surfaceContainerLowest,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.asset(
                                    'lib/assets/logos/agritech_logo.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'AgriTech',
                                      style: AppTextStyles.headlineSm.copyWith(
                                        color: textColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      strings.appTagline,
                                      style: AppTextStyles.labelSm.copyWith(
                                        color: headingColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.inverseSurface
                                    : AppColors.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                strings.appVersionBadge,
                                style: AppTextStyles.labelSm.copyWith(
                                  color: subColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          strings.aboutAppDescription,
                          style: AppTextStyles.bodySm.copyWith(
                            color: subColor,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              key: const Key('settings_privacy_policy_button'),
                              borderRadius: BorderRadius.circular(8),
                              onTap: () => showAgriTechPrivacyModal(context),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 2,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      strings.privacyPolicyTitle,
                                      style: AppTextStyles.labelSm.copyWith(
                                        color: subColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.open_in_new,
                                      size: 14,
                                      color: subColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              key: const Key('settings_terms_of_use_button'),
                              borderRadius: BorderRadius.circular(8),
                              onTap: () => showAgriTechTermsModal(context),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 2,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      strings.termsOfUseTitle,
                                      style: AppTextStyles.labelSm.copyWith(
                                        color: subColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.open_in_new,
                                      size: 14,
                                      color: subColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Sign Out Button (`تسجيل الخروج` / `Sign Out`)
                  ElevatedButton.icon(
                    key: const Key('settings_logout_button'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.errorSoftBackground,
                      foregroundColor: AppColors.error,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () => showAgriTechLogoutDialog(context),
                    icon: const Icon(Icons.logout, size: 20),
                    label: Text(
                      strings.logoutTitle,
                      style: AppTextStyles.labelLg.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubSectionTitle extends StatelessWidget {
  const _SubSectionTitle({
    required this.icon,
    required this.title,
    required this.textColor,
    required this.isDark,
  });

  final IconData icon;
  final String title;
  final Color textColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isDark ? AppColors.onSurface : AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: AppColors.primaryContainer),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.headlineSm.copyWith(
            color: textColor,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    super.key,
    required this.title,
    required this.badgeText,
    required this.selected,
    required this.isDark,
    required this.textColor,
    required this.subColor,
    required this.onTap,
  });

  final String title;
  final String badgeText;
  final bool selected;
  final bool isDark;
  final Color textColor;
  final Color subColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? (isDark ? AppColors.onSurface : AppColors.surfaceContainerLow)
              : (isDark
                    ? AppColors.onSurface.withValues(alpha: 0.5)
                    : AppColors.surfaceContainerHighest.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? AppColors.primaryContainer.withValues(alpha: 0.5)
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.labelLg.copyWith(
                        color: selected
                            ? (isDark
                                  ? AppColors.inversePrimary
                                  : AppColors.primary)
                            : subColor,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w600,
                      ),
                    ),
                  ),
                  if (selected) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryFixed,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        badgeText,
                        style: AppTextStyles.labelSm.copyWith(
                          fontSize: 10,
                          color: AppColors.onPrimaryFixed,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 20,
              color: selected
                  ? (isDark ? AppColors.inversePrimary : AppColors.primary)
                  : AppColors.outlineVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOptionButton extends StatelessWidget {
  const _ThemeOptionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.isDark,
    required this.textColor,
    required this.subColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool isDark;
  final Color textColor;
  final Color subColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeBg = isDark
        ? AppColors.inverseSurface
        : AppColors.surfaceContainerLowest;
    final activeColor = isDark ? AppColors.inversePrimary : AppColors.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: selected ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(icon, size: 22, color: selected ? activeColor : subColor),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.labelMd.copyWith(
                color: selected ? activeColor : subColor,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InteractiveSupportTile extends StatelessWidget {
  const _InteractiveSupportTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.cardBg,
    required this.textColor,
    required this.subColor,
    required this.isDark,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color cardBg;
  final Color textColor;
  final Color subColor;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.inverseSurface
                    : AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primaryContainer, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelLg.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySm.copyWith(color: subColor),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: subColor, size: 20),
          ],
        ),
      ),
    );
  }
}
