import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/widgets/agritech_bottom_nav.dart';
import '../../../../shared/widgets/agritech_header_banner.dart';

/// Screen 8: Diagnosis Result (`نتيجة التشخيص`) — Faithful implementation of `agritech_6`.
class DiagnosisResultPage extends StatelessWidget {
  const DiagnosisResultPage({super.key});

  void _showImageLightboxModal(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            backgroundColor: AppColors.onSurface,
            insetPadding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'تفاصيل العينة المصابة',
                        style: AppTextStyles.labelLg.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: InteractiveViewer(
                      child: Image.asset(
                        'lib/assets/images/sample_leaf_rust.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'اسحب للتحريك أو استخدم الإيماءات للمعاينة المجهرية',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.labelSm.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
          currentTab: AgriTechNavTab.diagnosis,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AgriTechInternalHeader(
              title: 'نتيجة التشخيص',
              subtitle: 'تفاصيل تحليل صورة ورقة البن وتوصيات الحالة',
              showBackButton: true,
            ),
            AgriTechWhiteSheetContainer(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- 1. Disease Summary & 94% Confidence Card ---
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.eco,
                                color: Color(0xFFB3F496),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFED6A7),
                                      borderRadius: BorderRadius.circular(99),
                                    ),
                                    child: Text(
                                      'تشخيص مؤكد',
                                      style: AppTextStyles.labelSm.copyWith(
                                        color: const Color(0xFF795B36),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'صدأ أوراق البن',
                                    style: AppTextStyles.headlineSm.copyWith(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w700,
                                      color: textColor,
                                    ),
                                  ),
                                  Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Text(
                                      'Coffee Leaf Rust (Hemileia vastatrix)',
                                      style: AppTextStyles.labelSm.copyWith(
                                        color: subColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              children: [
                                SizedBox(
                                  width: 52,
                                  height: 52,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        value: 0.94,
                                        strokeWidth: 4.5,
                                        backgroundColor:
                                            AppColors.surfaceContainerHigh,
                                        valueColor:
                                            const AlwaysStoppedAnimation(
                                              AppColors.primaryContainer,
                                            ),
                                      ),
                                      Text(
                                        '94%',
                                        style: AppTextStyles.labelMd.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'نسبة الثقة',
                                  style: AppTextStyles.labelSm.copyWith(
                                    fontSize: 10,
                                    color: subColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.inverseSurface
                                : AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 16,
                                    color: AppColors.primaryContainer,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'المزرعة: ',
                                    style: AppTextStyles.bodySm.copyWith(
                                      color: subColor,
                                    ),
                                  ),
                                  Text(
                                    'مزرعة البن الرئيسية',
                                    style: AppTextStyles.labelMd.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.schedule,
                                    size: 16,
                                    color: AppColors.primaryContainer,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'الوقت: ',
                                    style: AppTextStyles.bodySm.copyWith(
                                      color: subColor,
                                    ),
                                  ),
                                  Text(
                                    'اليوم، 11:20 ص',
                                    style: AppTextStyles.labelMd.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: textColor,
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

                  // --- 2. الصورة التي تم تحليلها ---
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(20),
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
                                  Icons.photo_camera_outlined,
                                  size: 18,
                                  color: AppColors.primaryContainer,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'الصورة التي تم تحليلها',
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
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.inverseSurface
                                    : AppColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                'معاينة عالية الدقة',
                                style: AppTextStyles.labelSm.copyWith(
                                  color: subColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => _showImageLightboxModal(context),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'lib/assets/images/sample_leaf_rust.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- 3. طبيعة ووصف الحالة ---
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFED6A7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.info_outline,
                                size: 18,
                                color: AppColors.secondary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'طبيعة ووصف الحالة',
                              style: AppTextStyles.labelLg.copyWith(
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'فطر يصيب أوراق البن ويظهر على شكل بقع صفراء برتقالية مسحوقية على السطح السفلي للأوراق، ويؤدي إلى تساقطها وضعف المحصول. يعتبر من أخطر التحديات التي تهدد جودة حبوب القهوة وإنتاجية المصاطب الجبلية إذا لم يتم التدخل السريع.',
                          style: AppTextStyles.bodySm.copyWith(
                            color: subColor,
                            height: 1.65,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.inverseSurface
                                      : AppColors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'مستوى الخطورة',
                                      style: AppTextStyles.labelSm.copyWith(
                                        color: subColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.warning_amber_rounded,
                                          size: 16,
                                          color: AppColors.secondary,
                                        ),
                                        const SizedBox(width: 4),
                                        Flexible(
                                          child: Text(
                                            'متوسط إلى حاد',
                                            style: AppTextStyles.labelMd
                                                .copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.secondary,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.inverseSurface
                                      : AppColors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'فترة الحضانة المحتملة',
                                      style: AppTextStyles.labelSm.copyWith(
                                        color: subColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.history,
                                          size: 16,
                                          color: AppColors.primaryContainer,
                                        ),
                                        const SizedBox(width: 4),
                                        Flexible(
                                          child: Text(
                                            '10 - 14 يوماً',
                                            style: AppTextStyles.labelMd
                                                .copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.primary,
                                                ),
                                          ),
                                        ),
                                      ],
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

                  const SizedBox(height: 18),

                  // --- 4. التوصيات العلاجية المعتمدة ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.health_and_safety_outlined,
                              size: 17,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'التوصيات العلاجية المعتمدة',
                            style: AppTextStyles.headlineSm.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '3 إجراءات موصى بها',
                        style: AppTextStyles.labelSm.copyWith(
                          color: AppColors.primaryContainer,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const _TreatmentItemCard(
                    icon: Icons.content_cut,
                    iconColor: Color(0xFFB91C1C),
                    iconBg: Color(0xFFFDE8E8),
                    title: 'عزل الأشجار المصابة والتقليم الصحي',
                    body:
                        'إزالة الأوراق شديدة الإصابة فوراً وحرقها في مكان معزول لمنع انتشار الجراثيم بفعل الرياح والرطوبة.',
                  ),
                  const SizedBox(height: 10),
                  const _TreatmentItemCard(
                    icon: Icons.water_drop_outlined,
                    iconColor: AppColors.primary,
                    iconBg: Color(0xFFB3F496),
                    title: 'الرش الوقائي بمبيد نحاسي معتمد',
                    body:
                        'استخدام أوكسي كلوريد النحاس وفق المعايير والجرعات المعتمدة لمحصول البن، مع التركيز التام على السطح السفلي للأوراق.',
                  ),
                  const SizedBox(height: 10),
                  const _TreatmentItemCard(
                    icon: Icons.air,
                    iconColor: AppColors.secondary,
                    iconBg: Color(0xFFFED6A7),
                    title: 'تحسين التهوية والإضاءة',
                    body:
                        'تقليم الظلال الكثيفة لتقليل معدلات الرطوبة النسبية حول الشجيرات وتسهيل جفاف الندى الصباحي.',
                  ),

                  const SizedBox(height: 14),

                  // --- 5. تنبيه الموثوقية والدقة ---
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.onSurface
                          : AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.help_center_outlined,
                          size: 18,
                          color: subColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'تنبيه الموثوقية والدقة',
                                style: AppTextStyles.labelMd.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'النتيجة غير مؤكدة. يُنصح بالتقاط صورة أوضح وإعادة التشخيص عند الحاجة في حال تغيرت الإضاءة أو كانت الورقة غير مستقرة أثناء التصوير.',
                                style: AppTextStyles.bodySm.copyWith(
                                  fontSize: 11.5,
                                  color: subColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // --- 6. Bottom Buttons ---
                  ElevatedButton.icon(
                    key: const Key('diagnose_another_button'),
                    onPressed: () => Navigator.of(
                      context,
                    ).pushReplacementNamed(AppRoutes.diagnosis),
                    icon: const Icon(Icons.add_a_photo_outlined, size: 18),
                    label: const Text('تشخيص صورة أخرى'),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    key: const Key('result_to_history_button'),
                    onPressed: () => Navigator.of(
                      context,
                    ).pushNamed(AppRoutes.diagnosisHistory),
                    icon: const Icon(Icons.history_edu, size: 18),
                    label: const Text('عرض سجل التشخيصات'),
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

class _TreatmentItemCard extends StatelessWidget {
  const _TreatmentItemCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.inverseOnSurface : AppColors.onSurface;
    final subColor = isDark
        ? AppColors.outlineVariant
        : AppColors.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.onSurface : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.onSurfaceVariant : AppColors.borderOutline,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, size: 19, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelMd.copyWith(
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: AppTextStyles.bodySm.copyWith(color: subColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
