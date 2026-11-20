import 'package:flutter/material.dart';

import '../../../../core/config/app_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/widgets/agritech_bottom_nav.dart';
import '../../../../shared/widgets/agritech_header_banner.dart';

/// Screen 5: Agricultural Monitoring (`المراقبة الزراعية`) — Faithful implementation of `agritech_3`.
class MonitoringPage extends StatelessWidget {
  const MonitoringPage({super.key});

  void _showFarmSelectorSheet(BuildContext context, AppState appState) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.inverseSurface
        : AppColors.surfaceContainerLowest;
    final textColor = isDark ? AppColors.inverseOnSurface : AppColors.onSurface;
    final subColor = isDark
        ? AppColors.outlineVariant
        : AppColors.onSurfaceVariant;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'اختر المزرعة للمراقبة',
                  style: AppTextStyles.headlineSm.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                ...List.generate(appState.farms.length, (index) {
                  final farm = appState.farms[index];
                  final isSelected = index == appState.selectedFarmIndex;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primaryContainer
                              : AppColors.borderOutline,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      tileColor: isSelected
                          ? AppColors.badgeSoftGreen.withValues(
                              alpha: isDark ? 0.15 : 0.6,
                            )
                          : null,
                      leading: const Icon(
                        Icons.yard_outlined,
                        color: AppColors.primaryContainer,
                      ),
                      title: Text(
                        farm.name,
                        style: AppTextStyles.labelMd.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        farm.regionSubtitle,
                        style: AppTextStyles.bodySm.copyWith(color: subColor),
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle,
                              color: AppColors.primaryContainer,
                            )
                          : null,
                      onTap: () {
                        appState.selectFarm(index);
                        Navigator.of(sheetContext).pop();
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final selectedFarm = appState.farms[appState.selectedFarmIndex];
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

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        bottomNavigationBar: const AgriTechBottomNav(
          currentTab: AgriTechNavTab.monitoring,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AgriTechInternalHeader(
              title: 'المراقبة الزراعية',
              subtitle: 'تابع حالة الحساسات والقراءات الحالية',
              replaceSettingsWithBackWhenCanPop: true,
            ),
            AgriTechWhiteSheetContainer(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- 1. المزرعة المحددة ---
                  Text(
                    'المزرعة المحددة',
                    style: AppTextStyles.labelSm.copyWith(color: subColor),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    key: const Key('monitoring_farm_selector'),
                    onTap: () => _showFarmSelectorSheet(context, appState),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.badgeSoftGreen,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.yard_outlined,
                              color: AppColors.primaryContainer,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        selectedFarm.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyles.labelLg.copyWith(
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
                                        color: AppColors.badgeSoftGreen,
                                        borderRadius: BorderRadius.circular(99),
                                      ),
                                      child: Text(
                                        'نشطة',
                                        style: AppTextStyles.labelSm.copyWith(
                                          color: AppColors.primaryContainer,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  selectedFarm.regionSubtitle,
                                  style: AppTextStyles.bodySm.copyWith(
                                    color: subColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.inverseSurface
                                  : AppColors.surfaceContainerLow,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.expand_more,
                              color: subColor,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // --- 2. ملخص المراقبة ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ملخص المراقبة',
                        style: AppTextStyles.headlineSm.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      Text(
                        '18 مستشعر نشط',
                        style: AppTextStyles.bodySm.copyWith(color: subColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
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
                            child: _MonitoringSummaryItem(
                              icon: Icons.sensors,
                              iconColor: AppColors.primaryContainer,
                              iconBg: AppColors.badgeSoftGreen,
                              value: '18',
                              label: 'إجمالي الحساسات',
                              textColor: textColor,
                              subColor: subColor,
                            ),
                          ),
                          VerticalDivider(color: borderColor, width: 1),
                          Expanded(
                            child: _MonitoringSummaryItem(
                              icon: Icons.wifi,
                              iconColor: const Color(0xFF15803D),
                              iconBg: AppColors.badgeSoftGreen,
                              value: '16',
                              label: 'متصلة',
                              textColor: const Color(0xFF15803D),
                              subColor: subColor,
                            ),
                          ),
                          VerticalDivider(color: borderColor, width: 1),
                          Expanded(
                            child: _MonitoringSummaryItem(
                              icon: Icons.wifi_off_outlined,
                              iconColor: const Color(0xFFD97706),
                              iconBg: const Color(0xFFFEF3C7),
                              value: '2',
                              label: 'تنبيهات',
                              textColor: const Color(0xFFB45309),
                              subColor: subColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // --- 3. القراءات الحالية ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'القراءات الحالية',
                        style: AppTextStyles.headlineSm.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.badgeSoftGreen,
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryContainer,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'محدث تلقائيًا',
                                  style: AppTextStyles.labelSm.copyWith(
                                    color: AppColors.primaryContainer,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'الآن',
                            style: AppTextStyles.bodySm.copyWith(
                              color: subColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Reading Card 1: درجة الحرارة
                  _SensorReadingDetailCard(
                    icon: Icons.device_thermostat,
                    iconColor: const Color(0xFFD97706),
                    iconBg: const Color(0xFFFEF3C7),
                    title: 'درجة الحرارة',
                    subtitle: 'القطاع 1 - حقل البن الجنوبي',
                    connectionBadge: 'متصل',
                    isWarning: false,
                    value: '24.5',
                    unit: '°C',
                    timeAgo: 'منذ 5 دقائق',
                    statusNote: 'ضمن المعدل المثالي (20° - 27°)',
                    statusPill: 'طبيعي',
                    onTap: () {
                      appState.selectSensor(0);
                      Navigator.of(context).pushNamed(AppRoutes.sensorDetails);
                    },
                  ),
                  const SizedBox(height: 12),

                  // Reading Card 2: رطوبة الجو
                  _SensorReadingDetailCard(
                    icon: Icons.water_damage_outlined,
                    iconColor: const Color(0xFF0D9488),
                    iconBg: const Color(0xFFCCFBF1),
                    title: 'رطوبة الجو',
                    subtitle: 'القطاع 1 - محطة المناخ',
                    connectionBadge: 'متصل',
                    isWarning: false,
                    value: '58',
                    unit: '%',
                    timeAgo: 'منذ 8 دقائق',
                    statusNote: 'معتدل ومناسب لمرحلة الإزهار',
                    statusPill: 'مستقر',
                    onTap: () {
                      appState.selectSensor(1);
                      Navigator.of(context).pushNamed(AppRoutes.sensorDetails);
                    },
                  ),
                  const SizedBox(height: 12),

                  // Reading Card 3: رطوبة التربة
                  _SensorReadingDetailCard(
                    icon: Icons.water_drop_outlined,
                    iconColor: const Color(0xFF2563EB),
                    iconBg: const Color(0xFFDBEAFE),
                    title: 'رطوبة التربة',
                    subtitle: 'القطاع 2 - حقل البن الشرقي',
                    connectionBadge: 'يحتاج انتباه',
                    isWarning: true,
                    value: '24',
                    unit: '%',
                    timeAgo: 'منذ 12 دقيقة',
                    statusNote: 'انخفاض طفيف عن المعدل الموصى به (30%)',
                    statusPill: 'تنبيه',
                    onTap: () {
                      appState.selectSensor(2);
                      Navigator.of(context).pushNamed(AppRoutes.sensorDetails);
                    },
                  ),

                  const SizedBox(height: 18),

                  // --- 4. عرض سجل القراءات السابقة ---
                  InkWell(
                    key: const Key('monitoring_history_button'),
                    onTap: () => Navigator.of(
                      context,
                    ).pushNamed(AppRoutes.sensorDetails),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppColors.primaryContainer.withValues(
                            alpha: 0.4,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.badgeSoftGreen,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.timeline,
                              color: AppColors.primaryContainer,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'عرض سجل القراءات السابقة',
                              style: AppTextStyles.labelLg.copyWith(
                                color: textColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Icon(Icons.chevron_right, color: subColor, size: 22),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- 5. التوصيات الزراعية الذكية ---
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primaryContainer.withValues(
                          alpha: 0.45,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: AppColors.badgeSoftGreen,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.psychology_outlined,
                                color: AppColors.primaryContainer,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'التوصيات الزراعية الذكية',
                                    style: AppTextStyles.headlineSm.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'اطلع على الإجراءات المقترحة وجدولة الري بناءً على تحليلات الحساسات اللحظية.',
                                    style: AppTextStyles.bodySm.copyWith(
                                      color: subColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        ElevatedButton(
                          key: const Key('monitoring_recommendations_button'),
                          onPressed: () => Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.recommendations),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'عرض التوصيات والمهام',
                                style: AppTextStyles.labelLg.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward,
                                size: 18,
                                color: Colors.white,
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

class _MonitoringSummaryItem extends StatelessWidget {
  const _MonitoringSummaryItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.value,
    required this.label,
    required this.textColor,
    required this.subColor,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String value;
  final String label;
  final Color textColor;
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
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: AppTextStyles.headlineSm.copyWith(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: textColor,
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

class _SensorReadingDetailCard extends StatelessWidget {
  const _SensorReadingDetailCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.connectionBadge,
    required this.isWarning,
    required this.value,
    required this.unit,
    required this.timeAgo,
    required this.statusNote,
    required this.statusPill,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final String connectionBadge;
  final bool isWarning;
  final String value;
  final String unit;
  final String timeAgo;
  final String statusNote;
  final String statusPill;
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
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.onSurface
              : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isWarning
                ? const Color(0xFFFDE68A)
                : (isDark
                      ? AppColors.onSurfaceVariant
                      : AppColors.borderOutline),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.labelLg.copyWith(
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: AppTextStyles.bodySm.copyWith(color: subColor),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            unit,
                            style: AppTextStyles.labelSm.copyWith(
                              color: subColor,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            value,
                            style: AppTextStyles.headlineMd.copyWith(
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                              color: isWarning
                                  ? const Color(0xFFB45309)
                                  : AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      timeAgo,
                      style: AppTextStyles.labelSm.copyWith(
                        fontSize: 10.5,
                        color: subColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        isWarning
                            ? Icons.warning_amber_rounded
                            : Icons.check_circle_outline,
                        size: 16,
                        color: isWarning
                            ? const Color(0xFFD97706)
                            : AppColors.primaryContainer,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          statusNote,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySm.copyWith(color: subColor),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isWarning
                        ? const Color(0xFFFEF3C7)
                        : AppColors.badgeSoftGreen,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    statusPill,
                    style: AppTextStyles.labelSm.copyWith(
                      color: isWarning
                          ? const Color(0xFFB45309)
                          : AppColors.primaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
