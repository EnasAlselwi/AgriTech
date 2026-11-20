import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

/// Temporary Phase 1 Visual Verification Screen.
/// Verifies:
/// A. AgriTech Logo (`lib/assets/logos/agritech_logo.png`)
/// B. Agricultural Terrace Background (`lib/assets/images/terrace_bg.png`)
/// C. Locally bundled Cairo Font (400, 500, 600, 700)
/// D. RTL Layout & Arabic Alignment
/// E. Light & Dark Theme Switching (`AppTheme.lightTheme` / `AppTheme.darkTheme`)
/// F. Application Colors (`AppColors`)
class Phase1VerificationPage extends StatelessWidget {
  const Phase1VerificationPage({
    super.key,
    required this.themeMode,
    required this.onToggleTheme,
  });

  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  bool get _isDark => themeMode == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bannerFadeColor = _isDark
        ? AppColors.onSurface
        : AppColors.authBannerBackground;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- A & B: Terrace Background Banner + AgriTech Logo + Theme Toggle ---
                SizedBox(
                  height: 255,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // B. Agricultural Background Image
                      Opacity(
                        opacity: _isDark ? 0.45 : 0.88,
                        child: Image.asset(
                          'lib/assets/images/terrace_bg.png',
                          fit: BoxFit.cover,
                          alignment: const Alignment(0, -0.35),
                        ),
                      ),
                      // Smooth gradient feathering into surface
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              bannerFadeColor.withValues(alpha: 0.55),
                              bannerFadeColor,
                            ],
                            stops: const [0.0, 0.65, 1.0],
                          ),
                        ),
                      ),
                      // Top Bar with Theme Toggle Button
                      Positioned(
                        top: MediaQuery.paddingOf(context).top + 8,
                        right: 16,
                        left: 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.surface.withValues(
                                  alpha: 0.9,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppTheme.radiusFull,
                                ),
                                border: Border.all(
                                  color: AppColors.primaryContainer.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.verified_outlined,
                                    size: 16,
                                    color: AppColors.primaryContainer,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'المرحلة 1: التحقق البصري',
                                    style: AppTextStyles.labelMd.copyWith(
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // E. Theme Toggle Button
                            Material(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusFull,
                              ),
                              child: InkWell(
                                key: const Key('theme_toggle_button'),
                                borderRadius: BorderRadius.circular(
                                  AppTheme.radiusFull,
                                ),
                                onTap: onToggleTheme,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _isDark
                                            ? Icons.light_mode_outlined
                                            : Icons.dark_mode_outlined,
                                        size: 18,
                                        color: AppColors.onPrimary,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        _isDark
                                            ? 'المظهر: داكن'
                                            : 'المظهر: فاتح',
                                        style: AppTextStyles.labelMd.copyWith(
                                          color: AppColors.onPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // A. Official AgriTech Logo
                      Positioned(
                        bottom: 12,
                        right: 20,
                        left: 20,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'lib/assets/logos/agritech_logo.png',
                              height: 96,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'فحص الهوية البصرية والخطوط والألوان',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.headlineSm.copyWith(
                                color: _isDark
                                    ? AppColors.inverseOnSurface
                                    : AppColors.authHeadingText,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Content Sheet
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.horizontalMargin,
                    vertical: AppTheme.spaceMd,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // --- C. Cairo Font Weights Verification ---
                      _buildSectionCard(
                        context: context,
                        icon: Icons.font_download_outlined,
                        title: '1. اختبار أوزان خط Cairo (محلي بدون إنترنت)',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFontWeightRow(
                              context,
                              weightLabel: 'Cairo Regular (400)',
                              sampleText:
                                  'خط كايرو عادي (400) - متابعة حالة المزرعة والمحاصيل اليومية.',
                              fontWeight: FontWeight.w400,
                            ),
                            const Divider(height: 16),
                            _buildFontWeightRow(
                              context,
                              weightLabel: 'Cairo Medium (500)',
                              sampleText:
                                  'خط كايرو متوسط (500) - قراءات رطوبة التربة ودرجة الحرارة.',
                              fontWeight: FontWeight.w500,
                            ),
                            const Divider(height: 16),
                            _buildFontWeightRow(
                              context,
                              weightLabel: 'Cairo SemiBold (600)',
                              sampleText:
                                  'خط كايرو شبه عريض (600) - تشخيص أمراض البن والتوصيات الذكية.',
                              fontWeight: FontWeight.w600,
                            ),
                            const Divider(height: 16),
                            _buildFontWeightRow(
                              context,
                              weightLabel: 'Cairo Bold (700)',
                              sampleText:
                                  'خط كايرو عريض (700) - AgriTech زراعة ذكية .. مستقبل أفضل.',
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppTheme.spaceMd),

                      // --- D. RTL Layout & Input Alignment Verification ---
                      _buildSectionCard(
                        context: context,
                        icon: Icons.format_textdirection_r_to_l_outlined,
                        title: '2. التحقق من اتجاه RTL والمحاذاة',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryContainer
                                        .withValues(alpha: 0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.agriculture_outlined,
                                    color: AppColors.primaryContainer,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'مزرعة البن الرئيسية - حراز',
                                        style: AppTextStyles.labelLg.copyWith(
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                      Text(
                                        'الأيقونة في اليمين والشارة في اليسار وفق اتجاه RTL',
                                        style: AppTextStyles.bodySm.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.badgeSoftGreen,
                                    borderRadius: BorderRadius.circular(
                                      AppTheme.radiusFull,
                                    ),
                                    border: Border.all(
                                      color: AppColors.badgeBorderGreen,
                                    ),
                                  ),
                                  child: Text(
                                    'متصل',
                                    style: AppTextStyles.labelSm.copyWith(
                                      color: AppColors.primaryContainer,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Phone prefix LTR inside RTL field verification
                            Container(
                              height: 48,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: _isDark
                                    ? AppColors.onSurface
                                    : AppColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(
                                  AppTheme.radiusMd,
                                ),
                                border: Border.all(
                                  color: _isDark
                                      ? AppColors.onSurfaceVariant
                                      : AppColors.borderOutline,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.phone_iphone_outlined,
                                    size: 18,
                                    color: AppColors.primaryContainer,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'رقم الهاتف (محاذاة عربية مع مفتاح دولي LTR)',
                                      style: AppTextStyles.bodySm.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 24,
                                    color: AppColors.outlineVariant,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                  ),
                                  Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Text(
                                      '+967 770 000 000',
                                      style: AppTextStyles.labelMd.copyWith(
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppTheme.spaceMd),

                      // --- F. Application Colors Verification ---
                      _buildSectionCard(
                        context: context,
                        icon: Icons.palette_outlined,
                        title: '3. لوحة ألوان Terrace Earth المعتمدة',
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: const [
                            _ColorSwatchTile(
                              name: 'Primary',
                              hex: '#185004',
                              color: AppColors.primary,
                              textColor: Colors.white,
                            ),
                            _ColorSwatchTile(
                              name: 'Primary Container',
                              hex: '#31691D',
                              color: AppColors.primaryContainer,
                              textColor: Colors.white,
                            ),
                            _ColorSwatchTile(
                              name: 'Secondary',
                              hex: '#765934',
                              color: AppColors.secondary,
                              textColor: Colors.white,
                            ),
                            _ColorSwatchTile(
                              name: 'Tertiary',
                              hex: '#274E29',
                              color: AppColors.tertiary,
                              textColor: Colors.white,
                            ),
                            _ColorSwatchTile(
                              name: 'Surface',
                              hex: '#F8FAF5',
                              color: AppColors.surface,
                              textColor: AppColors.onSurface,
                            ),
                            _ColorSwatchTile(
                              name: 'Outline Border',
                              hex: '#E2E8DC',
                              color: AppColors.borderOutline,
                              textColor: AppColors.onSurface,
                            ),
                            _ColorSwatchTile(
                              name: 'Inverse Primary',
                              hex: '#98D77D',
                              color: AppColors.inversePrimary,
                              textColor: AppColors.onPrimaryFixed,
                            ),
                            _ColorSwatchTile(
                              name: 'Error',
                              hex: '#BA1A1A',
                              color: AppColors.error,
                              textColor: Colors.white,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppTheme.spaceMd),

                      // --- B & E. Uncropped Background Proportions & Buttons ---
                      _buildSectionCard(
                        context: context,
                        icon: Icons.landscape_outlined,
                        title: '4. معاينة الخلفية الزراعية والأزرار والمظهر',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusMd,
                              ),
                              child: AspectRatio(
                                aspectRatio: 994 / 809,
                                child: Image.asset(
                                  'lib/assets/images/terrace_bg.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: onToggleTheme,
                              icon: Icon(
                                _isDark
                                    ? Icons.light_mode_outlined
                                    : Icons.dark_mode_outlined,
                              ),
                              label: Text(
                                _isDark
                                    ? 'التبديل إلى المظهر الفاتح (Light Theme)'
                                    : 'التبديل إلى المظهر الداكن (Dark Theme)',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isDark
            ? AppColors.inverseSurface
            : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(
          color: _isDark ? AppColors.onSurfaceVariant : AppColors.borderOutline,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.ambientShadow,
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: _isDark
                    ? AppColors.inversePrimary
                    : AppColors.primaryContainer,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.labelLg.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildFontWeightRow(
    BuildContext context, {
    required String weightLabel,
    required String sampleText,
    required FontWeight fontWeight,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            weightLabel,
            style: AppTextStyles.labelSm.copyWith(
              color: _isDark
                  ? AppColors.inversePrimary
                  : AppColors.primaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          sampleText,
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 15,
            fontWeight: fontWeight,
            height: 1.5,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _ColorSwatchTile extends StatelessWidget {
  const _ColorSwatchTile({
    required this.name,
    required this.hex,
    required this.color,
    required this.textColor,
  });

  final String name;
  final String hex;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: AppTextStyles.labelSm.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              hex,
              style: AppTextStyles.bodySm.copyWith(
                color: textColor.withValues(alpha: 0.9),
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
