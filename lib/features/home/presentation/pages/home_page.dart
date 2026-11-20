import 'package:flutter/material.dart';

import '../../../../core/config/app_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/widgets/agritech_bottom_nav.dart';
import '../../../../shared/widgets/agritech_header_banner.dart';

/// Screen 4: Home (`الرئيسية`) — Faithful implementation of `agritech_10`.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.onSurface
        : AppColors.authBannerBackground;
    final textColor = isDark ? AppColors.inverseOnSurface : AppColors.onSurface;
    final subColor = isDark
        ? AppColors.outlineVariant
        : AppColors.onSurfaceVariant;
    final cardBg = isDark
        ? AppColors.onSurface
        : AppColors.surfaceContainerLowest;
    final borderColor = isDark
        ? AppColors.onSurfaceVariant
        : AppColors.borderOutline;

    final publishedProductsCount = appState.products
        .where((p) => p.status == 'منشور')
        .length;
    final totalReservationsCount = appState.products.fold<int>(
      0,
      (sum, p) => sum + p.reservations.length,
    );
    final pendingReservationsCount = appState.products.fold<int>(
      0,
      (sum, p) => sum + p.reservations.where((r) => !r.isConfirmed).length,
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        bottomNavigationBar: const AgriTechBottomNav(
          currentTab: AgriTechNavTab.home,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AgriTechInternalHeader(
              title: 'الرئيسية',
              subtitle: 'إليك ملخص الحالة الزراعية اليوم',
              replaceSettingsWithBackWhenCanPop: true,
            ),
            AgriTechWhiteSheetContainer(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- 1. ملخص الحالة الزراعية ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryContainer,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'ملخص الحالة الزراعية',
                                style: AppTextStyles.headlineSm.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'محدّث تلقائيًا',
                        style: AppTextStyles.bodySm.copyWith(color: subColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.onSurface
                          : AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: borderColor),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => Navigator.of(
                                context,
                              ).pushNamed(AppRoutes.myFarms),
                              child: _SummaryStatColumn(
                                icon: Icons.yard_outlined,
                                iconColor: AppColors.primaryContainer,
                                iconBg: AppColors.badgeSoftGreen,
                                value: '${appState.farms.length}',
                                label: 'المزارع',
                                valueColor: AppColors.primary,
                                subColor: subColor,
                              ),
                            ),
                          ),
                          VerticalDivider(color: borderColor, width: 1),
                          Expanded(
                            child: InkWell(
                              onTap: () => Navigator.of(
                                context,
                              ).pushNamed(AppRoutes.monitoring),
                              child: _SummaryStatColumn(
                                icon: Icons.sensors,
                                iconColor: AppColors.primaryContainer,
                                iconBg: AppColors.badgeSoftGreen,
                                value: '18',
                                label: 'الحساسات المتصلة',
                                valueColor: AppColors.primary,
                                subColor: subColor,
                              ),
                            ),
                          ),
                          VerticalDivider(color: borderColor, width: 1),
                          Expanded(
                            child: _SummaryStatColumn(
                              icon: Icons.notifications_active_outlined,
                              iconColor: const Color(0xFFD97706),
                              iconBg: const Color(0xFFFEF3C7),
                              value: '1',
                              label: 'التنبيهات النشطة',
                              valueColor: const Color(0xFFB45309),
                              subColor: subColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // --- 2. التنبيهات الزراعية ---
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.warning_amber_rounded,
                          size: 18,
                          color: Color(0xFFB45309),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'التنبيهات الزراعية',
                          style: AppTextStyles.headlineSm.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFFFDE68A),
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.water_drop_outlined,
                                color: Color(0xFFD97706),
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'تنبيه رطوبة التربة (حقل البن الشرقي)',
                                          style: AppTextStyles.labelMd.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: textColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFEF3C7),
                                          borderRadius: BorderRadius.circular(
                                            99,
                                          ),
                                        ),
                                        child: Text(
                                          'متوسط',
                                          style: AppTextStyles.labelSm.copyWith(
                                            color: const Color(0xFFB45309),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'انخفضت نسبة رطوبة التربة إلى 24% في القطاع رقم 2، يُرجى فحص جدول الري للمنطقة.',
                                    style: AppTextStyles.bodySm.copyWith(
                                      color: subColor,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          children: [
                            Icon(Icons.schedule, size: 14, color: subColor),
                            const SizedBox(width: 4),
                            Text(
                              'منذ 25 دقيقة',
                              style: AppTextStyles.labelSm.copyWith(
                                color: subColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // --- 3. التوصيات الزراعية ذات الأولوية ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: AppColors.primaryFixed,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.tips_and_updates_outlined,
                                size: 18,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'التوصيات الزراعية ذات الأولوية',
                                style: AppTextStyles.headlineSm.copyWith(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'مبنية على الحساسات',
                        style: AppTextStyles.labelSm.copyWith(color: subColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    key: const Key('home_priority_recommendation_card'),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: AppColors.primaryContainer.withValues(
                          alpha: 0.45,
                        ),
                        width: 1.4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryContainer.withValues(
                            alpha: 0.05,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.badgeSoftGreen,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.psychology_outlined,
                                color: AppColors.primaryContainer,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'جدولة ري خفيفة لأشجار البن',
                                          style: AppTextStyles.labelLg.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: textColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.badgeSoftGreen,
                                          borderRadius: BorderRadius.circular(
                                            99,
                                          ),
                                        ),
                                        child: Text(
                                          'أولوية',
                                          style: AppTextStyles.labelSm.copyWith(
                                            color: AppColors.primaryContainer,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'نظراً لارتفاع درجة الحرارة التدريجي اليوم، يُوصى ببدء دورة ري تنقيط مبكرة قبل ذروة الظهيرة للحفاظ على حيوية التربة.',
                                    style: AppTextStyles.bodySm.copyWith(
                                      color: subColor,
                                      height: 1.55,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 22),
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.tune, size: 15, color: subColor),
                                const SizedBox(width: 4),
                                Text(
                                  'قاعدة ري الأشجار #14',
                                  style: AppTextStyles.labelSm.copyWith(
                                    color: subColor,
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              key: const Key('home_recommendations_button'),
                              onTap: () => Navigator.of(
                                context,
                              ).pushNamed(AppRoutes.recommendations),
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.badgeSoftGreen,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'عرض التفاصيل',
                                      style: AppTextStyles.labelSm.copyWith(
                                        color: AppColors.primaryContainer,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.arrow_forward,
                                      size: 14,
                                      color: AppColors.primaryContainer,
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

                  const SizedBox(height: 22),

                  // --- 4. آخر القراءات ---
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.primaryFixed,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.query_stats,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'آخر القراءات',
                        style: AppTextStyles.headlineSm.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _ReadingMiniCard(
                          icon: Icons.device_thermostat,
                          iconColor: const Color(0xFFD97706),
                          dotColor: const Color(0xFF10B981),
                          label: 'الحرارة',
                          value: '24.5',
                          unit: '°C',
                          timeAgo: 'منذ 8 دقائق',
                          onTap: () {
                            appState.selectSensor(0);
                            Navigator.of(
                              context,
                            ).pushNamed(AppRoutes.sensorDetails);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ReadingMiniCard(
                          icon: Icons.water_drop_outlined,
                          iconColor: const Color(0xFF2563EB),
                          dotColor: const Color(0xFFF59E0B),
                          label: 'رطوبة التربة',
                          value: '24',
                          unit: '%',
                          timeAgo: 'منذ 12 دقيقة',
                          onTap: () {
                            appState.selectSensor(2);
                            Navigator.of(
                              context,
                            ).pushNamed(AppRoutes.sensorDetails);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ReadingMiniCard(
                          icon: Icons.air,
                          iconColor: const Color(0xFF0D9488),
                          dotColor: const Color(0xFF10B981),
                          label: 'رطوبة الجو',
                          value: '58',
                          unit: '%',
                          timeAgo: 'منذ 15 دقيقة',
                          onTap: () {
                            appState.selectSensor(1);
                            Navigator.of(
                              context,
                            ).pushNamed(AppRoutes.sensorDetails);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    key: const Key('home_all_readings_button'),
                    onTap: () =>
                        Navigator.of(context).pushNamed(AppRoutes.monitoring),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.onSurface
                            : AppColors.badgeSoftGreen,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'عرض جميع القراءات',
                            style: AppTextStyles.labelMd.copyWith(
                              color: isDark
                                  ? AppColors.inversePrimary
                                  : AppColors.primaryContainer,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: isDark
                                ? AppColors.inversePrimary
                                : AppColors.primaryContainer,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // --- 5. السوق الإلكتروني (إدارة منتجاتي وطلباتي) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.primaryFixed,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.storefront_outlined,
                              size: 18,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'السوق الإلكتروني',
                            style: AppTextStyles.headlineSm.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'منصة المزارع',
                        style: AppTextStyles.labelSm.copyWith(color: subColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF286018),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.ambientShadow,
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.16,
                                      ),
                                      borderRadius: BorderRadius.circular(99),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.store_outlined,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'لوحة المزارع',
                                          style: AppTextStyles.labelSm.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'إدارة منتجاتي وطلباتي',
                                    style: AppTextStyles.headlineSm.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.inventory_2_outlined,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'أضف منتجاتك واعرضها للمشترين عبر المنصة الإلكترونية، وتابع المنتجات المنشورة والحجوزات والطلبات من تطبيقك.',
                          style: AppTextStyles.bodySm.copyWith(
                            color: Colors.white.withValues(alpha: 0.88),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              children: [
                                Expanded(
                                  child: _MarketDarkStat(
                                    value: '$publishedProductsCount',
                                    label: 'المنتجات\nالمنشورة',
                                  ),
                                ),
                                VerticalDivider(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                                Expanded(
                                  child: _MarketDarkStat(
                                    value: '$totalReservationsCount',
                                    label: 'الطلبات\nالجديدة',
                                  ),
                                ),
                                VerticalDivider(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                                Expanded(
                                  child: _MarketDarkStat(
                                    value: '$pendingReservationsCount',
                                    label: 'الحجوزات قيد\nالمتابعة',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 14,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'تظهر المنتجات المنشورة للمشترين عبر المنصة الإلكترونية.',
                                style: AppTextStyles.labelSm.copyWith(
                                  color: Colors.white.withValues(alpha: 0.85),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          key: const Key('home_manage_products_button'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            minimumSize: const Size.fromHeight(46),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () => Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.myProducts),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.inventory_2_outlined,
                                size: 18,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'إدارة المنتجات والطلبات',
                                style: AppTextStyles.labelMd.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.arrow_forward,
                                size: 16,
                                color: AppColors.primary,
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
          ],
        ),
      ),
    );
  }
}

class _SummaryStatColumn extends StatelessWidget {
  const _SummaryStatColumn({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.value,
    required this.label,
    required this.valueColor,
    required this.subColor,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String value;
  final String label;
  final Color valueColor;
  final Color subColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 19, color: iconColor),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: AppTextStyles.headlineSm.copyWith(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.labelSm.copyWith(color: subColor),
        ),
      ],
    );
  }
}

class _ReadingMiniCard extends StatelessWidget {
  const _ReadingMiniCard({
    required this.icon,
    required this.iconColor,
    required this.dotColor,
    required this.label,
    required this.value,
    required this.unit,
    required this.timeAgo,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color dotColor;
  final String label;
  final String value;
  final String unit;
  final String timeAgo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.inverseOnSurface : AppColors.onSurface;
    final subColor = isDark
        ? AppColors.outlineVariant
        : AppColors.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.onSurface
              : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? AppColors.onSurfaceVariant
                : AppColors.borderOutline,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 18, color: iconColor),
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(label, style: AppTextStyles.labelSm.copyWith(color: subColor)),
            const SizedBox(height: 2),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    unit,
                    style: AppTextStyles.labelSm.copyWith(color: subColor),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    value,
                    style: AppTextStyles.headlineSm.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              timeAgo,
              style: AppTextStyles.labelSm.copyWith(
                fontSize: 10,
                color: subColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarketDarkStat extends StatelessWidget {
  const _MarketDarkStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTextStyles.headlineSm.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.labelSm.copyWith(
            fontSize: 10.5,
            color: Colors.white.withValues(alpha: 0.85),
          ),
        ),
      ],
    );
  }
}
