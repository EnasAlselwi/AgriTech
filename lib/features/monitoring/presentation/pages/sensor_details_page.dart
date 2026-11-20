import 'package:flutter/material.dart';

import '../../../../core/config/app_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../models/agritech_models.dart';
import '../../../../shared/widgets/agritech_bottom_nav.dart';
import '../../../../shared/widgets/agritech_header_banner.dart';

/// Screen 6: Sensor Details and Readings (`تفاصيل الحساس`) — Faithful implementation of `agritech_9`.
/// Evaluates the current sensor reading against its configured agricultural
/// thresholds (`minThreshold` / `maxThreshold`) and displays normal status or
/// out-of-range warnings and recommended actions.
class SensorDetailsPage extends StatefulWidget {
  const SensorDetailsPage({super.key});

  @override
  State<SensorDetailsPage> createState() => _SensorDetailsPageState();
}

class _SensorDetailsPageState extends State<SensorDetailsPage> {
  int _selectedRangeIndex = 0; // 0: 24 ساعة, 1: 7 أيام, 2: 30 يومًا

  IconData _iconForSensor(String iconType) {
    switch (iconType) {
      case 'temp':
        return Icons.device_thermostat;
      case 'humidity':
        return Icons.water_damage_outlined;
      case 'soil':
        return Icons.water_drop_outlined;
      default:
        return Icons.tune;
    }
  }

  void _showSensorSelectorSheet(BuildContext context, AppState appState) {
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
                  'اختر الحساس لعرض تفاصيله',
                  style: AppTextStyles.headlineSm.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                ...List.generate(appState.sensors.length, (idx) {
                  final s = appState.sensors[idx];
                  final isSelected = idx == appState.selectedSensorIndex;
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
                      leading: Icon(
                        _iconForSensor(s.iconType),
                        color: AppColors.primaryContainer,
                      ),
                      title: Text(
                        s.shortName,
                        style: AppTextStyles.labelMd.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        '${s.measurementType} • ${s.currentValue} ${s.unit}',
                        style: AppTextStyles.bodySm.copyWith(color: subColor),
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check,
                              color: AppColors.primaryContainer,
                            )
                          : null,
                      onTap: () {
                        appState.selectSensor(idx);
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

  /// Helper values for testing Low / Normal / High readings on the selected sensor.
  (String lowVal, String normalVal, String highVal) _presetValuesFor(
    SensorItemModel sensor,
  ) {
    switch (sensor.iconType) {
      case 'soil':
        return ('24', '42', '56');
      case 'temp':
        return ('16.5', '24.5', '31.0');
      case 'humidity':
        return ('42', '68', '78');
      default:
        return ('0.0', '22.0', '39.0');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final sensorIndex = appState.selectedSensorIndex;
    final sensor = appState.sensors[sensorIndex];
    final eval = sensor.evaluateReading();
    final sensorIcon = _iconForSensor(sensor.iconType);
    final presets = _presetValuesFor(sensor);

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

    final isWarningOrAlert = eval.isOutOfRange || eval.isDisconnected;
    final statusBadgeBg = eval.isNormal
        ? AppColors.badgeSoftGreen
        : (eval.isDisconnected
              ? AppColors.errorContainer
              : const Color(0xFFFEF3C7));
    final statusBadgeFg = eval.isNormal
        ? AppColors.primaryContainer
        : (eval.isDisconnected ? AppColors.error : const Color(0xFFB45309));
    final statusIcon = eval.isNormal
        ? Icons.check_circle_outline
        : (eval.isDisconnected
              ? Icons.signal_wifi_off_outlined
              : (eval.state == 'low'
                    ? Icons.trending_down
                    : Icons.trending_up));

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
              title: 'تفاصيل الحساس',
              subtitle: 'متابعة القراءات وتغيرها بمرور الوقت',
              replaceSettingsWithBackWhenCanPop: true,
            ),
            AgriTechWhiteSheetContainer(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- 1. الحساس المحدد ---
                  Text(
                    'الحساس المحدد',
                    style: AppTextStyles.labelSm.copyWith(color: subColor),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    key: const Key('sensor_details_selector'),
                    onTap: () => _showSensorSelectorSheet(context, appState),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.onSurface
                            : AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFB3F496),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              sensorIcon,
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        sensor.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyles.labelMd.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: sensor.isOnline
                                            ? const Color(0xFFB3F496)
                                            : AppColors.errorContainer,
                                        borderRadius: BorderRadius.circular(99),
                                      ),
                                      child: Text(
                                        sensor.isOnline ? 'نشط' : 'غير متصل',
                                        style: AppTextStyles.labelSm.copyWith(
                                          color: sensor.isOnline
                                              ? AppColors.onPrimaryFixed
                                              : AppColors.error,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${sensor.measurementType} • ${sensor.updateInterval}',
                                  style: AppTextStyles.bodySm.copyWith(
                                    color: subColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.expand_more, color: subColor),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // --- 2. نوع القياس ومعدل التحديث ---
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.onSurface
                          : AppColors.badgeSoftGreen,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: AppColors.badgeBorderGreen.withValues(
                          alpha: isDark ? 0.2 : 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: sensor.isOnline
                                ? AppColors.primaryContainer
                                : AppColors.error,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            sensorIcon,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'نوع القياس',
                                style: AppTextStyles.labelSm.copyWith(
                                  color: subColor,
                                ),
                              ),
                              Text(
                                sensor.measurementType,
                                style: AppTextStyles.labelMd.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'معدل التحديث',
                              style: AppTextStyles.labelSm.copyWith(
                                color: subColor,
                              ),
                            ),
                            Text(
                              sensor.updateInterval,
                              style: AppTextStyles.labelMd.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- 3. معلومات الحساس ---
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.sensors,
                                  size: 18,
                                  color: AppColors.primaryContainer,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'معلومات الحساس',
                                  style: AppTextStyles.labelLg.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: sensor.isOnline
                                    ? const Color(0xFFB3F496)
                                    : AppColors.errorContainer,
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                sensor.isOnline ? 'حساس متصل' : 'غير متصل',
                                style: AppTextStyles.labelSm.copyWith(
                                  color: sensor.isOnline
                                      ? AppColors.onPrimaryFixed
                                      : AppColors.error,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'اسم الحساس والمعرف المكاني',
                          style: AppTextStyles.labelSm.copyWith(
                            color: subColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          sensor.name,
                          style: AppTextStyles.labelMd.copyWith(
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.inverseSurface
                                      : AppColors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'المزرعة التابعة',
                                      style: AppTextStyles.labelSm.copyWith(
                                        color: subColor,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      sensor.farmName,
                                      style: AppTextStyles.labelMd.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: textColor,
                                      ),
                                    ),
                                    Text(
                                      sensor.farmRegion,
                                      style: AppTextStyles.labelSm.copyWith(
                                        color: subColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.inverseSurface
                                      : AppColors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'حالة الاتصال',
                                      style: AppTextStyles.labelSm.copyWith(
                                        color: subColor,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Container(
                                          width: 7,
                                          height: 7,
                                          decoration: BoxDecoration(
                                            color: sensor.isOnline
                                                ? AppColors.primaryContainer
                                                : AppColors.error,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Flexible(
                                          child: Text(
                                            sensor.statusText,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTextStyles.labelMd
                                                .copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  color: textColor,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'آخر تحديث: ${sensor.lastUpdated}',
                                      style: AppTextStyles.labelSm.copyWith(
                                        color: subColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.inverseSurface
                                : AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.fingerprint,
                                    size: 16,
                                    color: subColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'المعرف: ${sensor.id}',
                                    style: AppTextStyles.labelSm.copyWith(
                                      color: subColor,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.wifi_tethering,
                                    size: 16,
                                    color: subColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'بروتوكول: ${sensor.protocol}',
                                    style: AppTextStyles.labelSm.copyWith(
                                      color: subColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- 4. القراءة الحالية (With Threshold & Agricultural Rule Evaluation) ---
                  Container(
                    key: const Key('sensor_current_reading_card'),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isWarningOrAlert
                            ? const Color(0xFFF59E0B)
                            : borderColor,
                        width: isWarningOrAlert ? 1.5 : 1,
                      ),
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
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: statusBadgeBg,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    sensorIcon,
                                    color: statusBadgeFg,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'القراءة الحالية',
                                  style: AppTextStyles.labelLg.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            if (sensor.isOnline)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _ThresholdSimulationChip(
                                    key: const Key('sensor_sim_low'),
                                    label: 'منخفض',
                                    isSelected: eval.state == 'low',
                                    onTap: () =>
                                        appState.updateSensorReadingValue(
                                          sensorIndex,
                                          presets.$1,
                                        ),
                                  ),
                                  const SizedBox(width: 4),
                                  _ThresholdSimulationChip(
                                    key: const Key('sensor_sim_normal'),
                                    label: 'طبيعي',
                                    isSelected: eval.state == 'normal',
                                    onTap: () =>
                                        appState.updateSensorReadingValue(
                                          sensorIndex,
                                          presets.$2,
                                        ),
                                  ),
                                  const SizedBox(width: 4),
                                  _ThresholdSimulationChip(
                                    key: const Key('sensor_sim_high'),
                                    label: 'مرتفع',
                                    isSelected: eval.state == 'high',
                                    onTap: () =>
                                        appState.updateSensorReadingValue(
                                          sensorIndex,
                                          presets.$3,
                                        ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                sensor.unit,
                                style: AppTextStyles.headlineSm.copyWith(
                                  color: subColor,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                sensor.currentValue,
                                style: AppTextStyles.headlineLg.copyWith(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w700,
                                  color: eval.isNormal
                                      ? (isDark
                                            ? AppColors.inversePrimary
                                            : AppColors.primary)
                                      : statusBadgeFg,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: statusBadgeBg,
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  statusIcon,
                                  size: 16,
                                  color: statusBadgeFg,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    eval.badgeText,
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.labelSm.copyWith(
                                      color: statusBadgeFg,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.schedule, size: 14, color: subColor),
                            const SizedBox(width: 4),
                            Text(
                              'وقت القراءة: 10:45 ص (اليوم)',
                              style: AppTextStyles.labelSm.copyWith(
                                color: subColor,
                              ),
                            ),
                          ],
                        ),

                        // Out-of-Range Warning & Agricultural Recommendation Box
                        // inside Current Reading section
                        if (isWarningOrAlert) ...[
                          const SizedBox(height: 14),
                          Container(
                            key: const Key(
                              'sensor_current_reading_recommendation_box',
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: eval.isDisconnected
                                  ? AppColors.errorSoftBackground
                                  : const Color(0xFFFFFBEB),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: eval.isDisconnected
                                    ? AppColors.error.withValues(alpha: 0.35)
                                    : const Color(0xFFFDE68A),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.warning_amber_rounded,
                                      size: 18,
                                      color: statusBadgeFg,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        eval.recommendationTitle,
                                        style: AppTextStyles.labelMd.copyWith(
                                          color: statusBadgeFg,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'حالة المؤشر: ${eval.directionLabel}',
                                  style: AppTextStyles.labelSm.copyWith(
                                    color: statusBadgeFg,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  eval.diagnosisText,
                                  style: AppTextStyles.bodySm.copyWith(
                                    color: AppColors.onSurface,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.task_alt,
                                        size: 16,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          'الإجراء الموصى به: ${eval.recommendedAction}',
                                          style: AppTextStyles.labelSm.copyWith(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w700,
                                            height: 1.45,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- 5. مخطط تغير القراءات ---
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'مخطط تغير القراءات',
                                    style: AppTextStyles.labelLg.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: textColor,
                                    ),
                                  ),
                                  Text(
                                    '(بيانات توضيحية تجريبية)',
                                    style: AppTextStyles.labelSm.copyWith(
                                      color: subColor,
                                      fontSize: 10.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Range Tabs
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.inverseSurface
                                    : AppColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _RangeTabChip(
                                    label: '24 ساعة',
                                    selected: _selectedRangeIndex == 0,
                                    onTap: () =>
                                        setState(() => _selectedRangeIndex = 0),
                                  ),
                                  _RangeTabChip(
                                    label: '7 أيام',
                                    selected: _selectedRangeIndex == 1,
                                    onTap: () =>
                                        setState(() => _selectedRangeIndex = 1),
                                  ),
                                  _RangeTabChip(
                                    label: '30 يومًا',
                                    selected: _selectedRangeIndex == 2,
                                    onTap: () =>
                                        setState(() => _selectedRangeIndex = 2),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.onSurface,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${sensor.currentValue}${sensor.unit} عند 10:45 ص',
                              style: AppTextStyles.labelSm.copyWith(
                                color: Colors.white,
                                fontSize: 10.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 150,
                          child: CustomPaint(
                            painter: _SensorAreaChartPainter(
                              rangeIndex: _selectedRangeIndex,
                              isAlert: isWarningOrAlert,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:
                                const [
                                      '02:00',
                                      '06:00',
                                      '10:00',
                                      '14:00',
                                      '18:00',
                                      '22:00',
                                    ]
                                    .map(
                                      (t) => Text(
                                        t,
                                        style: AppTextStyles.labelSm.copyWith(
                                          fontSize: 10,
                                          color: subColor,
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                        const Divider(height: 20),
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            Text(
                              sensor.optimalRangeLabel,
                              style: AppTextStyles.labelSm.copyWith(
                                color: subColor,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isWarningOrAlert
                                      ? Icons.warning_amber_rounded
                                      : Icons.trending_up,
                                  size: 15,
                                  color: statusBadgeFg,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  eval.chartFooterStatus,
                                  style: AppTextStyles.labelSm.copyWith(
                                    color: statusBadgeFg,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- 6. سجل القراءات ---
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.history, size: 18, color: subColor),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'سجل القراءات',
                                    style: AppTextStyles.labelLg.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: textColor,
                                    ),
                                  ),
                                  Text(
                                    'أحدث ${sensor.recentReadings.length} قراءات مسجلة مرتبة من الأحدث إلى الأقدم',
                                    style: AppTextStyles.labelSm.copyWith(
                                      color: subColor,
                                      fontSize: 10.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        for (
                          var i = 0;
                          i < sensor.recentReadings.length;
                          i++
                        ) ...[
                          _ReadingLogTile(
                            badgeValue: sensor.recentReadings[i].value,
                            readingText:
                                '${sensor.recentReadings[i].value} ${sensor.recentReadings[i].unit}',
                            timeText: sensor.recentReadings[i].timeText,
                            statusLabel: sensor.recentReadings[i].statusLabel,
                            isWarning: sensor.recentReadings[i].isWarning,
                          ),
                          if (i < sensor.recentReadings.length - 1)
                            const SizedBox(height: 8),
                        ],
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'تم تجهيز ملف سجل القراءات (CSV)',
                                  style: AppTextStyles.bodyMd.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: AppColors.inverseSurface,
                              ),
                            );
                          },
                          icon: const Icon(Icons.download_outlined, size: 18),
                          label: const Text('تصدير السجل الكامل (CSV)'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- 7. توصية زراعية لحظية ---
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.onSurface
                          : const Color(0xFFFFF8EE),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFFED6A7)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFED6A7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            isWarningOrAlert
                                ? Icons.warning_amber_rounded
                                : Icons.lightbulb_outline,
                            color: AppColors.secondary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                eval.recommendationTitle,
                                style: AppTextStyles.labelMd.copyWith(
                                  color: isDark
                                      ? AppColors.secondaryFixed
                                      : AppColors.secondary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${eval.diagnosisText}\nالإجراء الموصى به: ${eval.recommendedAction}',
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

class _ThresholdSimulationChip extends StatelessWidget {
  const _ThresholdSimulationChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryContainer
              : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryContainer
                : AppColors.outlineVariant.withValues(alpha: 0.6),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSm.copyWith(
            fontSize: 10,
            color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _RangeTabChip extends StatelessWidget {
  const _RangeTabChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSm.copyWith(
            fontSize: 10.5,
            color: selected ? Colors.white : AppColors.onSurfaceVariant,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _ReadingLogTile extends StatelessWidget {
  const _ReadingLogTile({
    required this.badgeValue,
    required this.readingText,
    required this.timeText,
    required this.statusLabel,
    required this.isWarning,
  });

  final String badgeValue;
  final String readingText;
  final String timeText;
  final String statusLabel;
  final bool isWarning;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.inverseOnSurface : AppColors.onSurface;
    final subColor = isDark
        ? AppColors.outlineVariant
        : AppColors.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.inverseSurface
            : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isWarning
                  ? const Color(0xFFFED6A7)
                  : const Color(0xFFB3F496),
              shape: BoxShape.circle,
            ),
            child: Text(
              badgeValue,
              style: AppTextStyles.labelSm.copyWith(
                fontWeight: FontWeight.w700,
                color: isWarning
                    ? const Color(0xFF795B36)
                    : AppColors.onPrimaryFixed,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    readingText,
                    style: AppTextStyles.labelMd.copyWith(
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                ),
                Text(
                  timeText,
                  style: AppTextStyles.labelSm.copyWith(color: subColor),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: isWarning
                  ? const Color(0xFFFED6A7)
                  : AppColors.badgeSoftGreen,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              statusLabel,
              style: AppTextStyles.labelSm.copyWith(
                color: isWarning
                    ? const Color(0xFF795B36)
                    : AppColors.primaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Icon(Icons.chevron_right, size: 18, color: subColor),
        ],
      ),
    );
  }
}

class _SensorAreaChartPainter extends CustomPainter {
  const _SensorAreaChartPainter({
    required this.rangeIndex,
    this.isAlert = false,
  });

  final int rangeIndex;
  final bool isAlert;

  @override
  void paint(Canvas canvas, Size size) {
    final accentColor = isAlert
        ? const Color(0xFFD97706)
        : AppColors.primaryContainer;

    final gridPaint = Paint()
      ..color = AppColors.outlineVariant.withValues(alpha: 0.35)
      ..strokeWidth = 1;

    for (var i = 1; i <= 3; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final points = rangeIndex == 0
        ? [
            Offset(size.width * 0.05, size.height * 0.72),
            Offset(size.width * 0.24, size.height * 0.58),
            Offset(size.width * 0.44, size.height * 0.36),
            Offset(size.width * 0.62, size.height * 0.24),
            Offset(size.width * 0.80, size.height * 0.38),
            Offset(size.width * 0.95, size.height * 0.54),
          ]
        : [
            Offset(size.width * 0.05, size.height * 0.64),
            Offset(size.width * 0.24, size.height * 0.48),
            Offset(size.width * 0.44, size.height * 0.42),
            Offset(size.width * 0.62, size.height * 0.30),
            Offset(size.width * 0.80, size.height * 0.34),
            Offset(size.width * 0.95, size.height * 0.46),
          ];

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final midX = (p0.dx + p1.dx) / 2;
      linePath.cubicTo(midX, p0.dy, midX, p1.dy, p1.dx, p1.dy);
    }

    final fillPath = Path.from(linePath)
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points.first.dx, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          accentColor.withValues(alpha: 0.32),
          accentColor.withValues(alpha: 0.02),
        ],
      ).createShader(Offset.zero & size);

    canvas.drawPath(fillPath, fillPaint);

    final strokePaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8;
    canvas.drawPath(linePath, strokePaint);

    final dotFill = Paint()..color = Colors.white;
    final dotStroke = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    for (final pt in points) {
      canvas.drawCircle(pt, 4.5, dotFill);
      canvas.drawCircle(pt, 4.5, dotStroke);
    }
  }

  @override
  bool shouldRepaint(covariant _SensorAreaChartPainter oldDelegate) =>
      oldDelegate.rangeIndex != rangeIndex || oldDelegate.isAlert != isAlert;
}
