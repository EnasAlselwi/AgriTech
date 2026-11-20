import 'package:flutter/material.dart';

import '../../../../core/config/app_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../models/agritech_models.dart';
import '../../../../shared/widgets/agritech_bottom_nav.dart';
import '../../../../shared/widgets/agritech_header_banner.dart';

/// Screen 10: Agricultural Recommendations (`التوصيات الزراعية`) — Faithful implementation of `agritech_7`.
class RecommendationsPage extends StatefulWidget {
  const RecommendationsPage({super.key});

  @override
  State<RecommendationsPage> createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> {
  int _selectedFilterIndex = 0;
  // All recommendation cards display their full diagnosis and action instructions
  // by default so no agricultural text is hidden or clipped; users can optionally
  // collapse individual cards.
  final Set<String> _collapsedIds = {};
  bool _showCompletedSection = true;

  static const List<String> _filters = [
    'الكل (5)',
    'عاجلة (2)',
    'متوسطة (2)',
    'منخفضة (1)',
  ];

  List<RecommendationModel> _filteredList(List<RecommendationModel> all) {
    return all.where((r) {
      if (_selectedFilterIndex == 1) return r.priority == 'عاجلة';
      if (_selectedFilterIndex == 2) return r.priority == 'متوسطة';
      if (_selectedFilterIndex == 3) return r.priority == 'منخفضة';
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final items = _filteredList(appState.recommendations);
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
              title: 'التوصيات الزراعية',
              subtitle: 'إجراءات مقترحة بناءً على قراءات الحساسات',
              showBackButton: true,
            ),
            AgriTechWhiteSheetContainer(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- 1. ملخص التوصيات ---
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      children: [
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.analytics_outlined,
                                  size: 18,
                                  color: AppColors.primaryContainer,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'ملخص التوصيات',
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
                                border: Border.all(color: borderColor),
                              ),
                              child: Text(
                                'بيانات تجريبية مباشرة',
                                style: AppTextStyles.labelSm.copyWith(
                                  fontSize: 10.5,
                                  color: subColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: _RecStatBox(
                                  icon: Icons.warning_amber_rounded,
                                  iconColor: const Color(0xFFB45309),
                                  iconBg: const Color(0xFFFED6A7),
                                  value: '3',
                                  label: 'تتطلب إجراءً',
                                  borderColor: borderColor,
                                  textColor: textColor,
                                  subColor: subColor,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _RecStatBox(
                                  icon: Icons.hourglass_top,
                                  iconColor: AppColors.tertiary,
                                  iconBg: const Color(0xFFC1EEBC),
                                  value: '2',
                                  label: 'قيد المتابعة',
                                  borderColor: borderColor,
                                  textColor: textColor,
                                  subColor: subColor,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _RecStatBox(
                                  icon: Icons.check_circle,
                                  iconColor: AppColors.primary,
                                  iconBg: const Color(0xFFB3F496),
                                  value: '5',
                                  label: 'تمت معالجتها',
                                  borderColor: borderColor,
                                  textColor: textColor,
                                  subColor: subColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // --- 2. Filter Chips ---
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_filters.length, (idx) {
                        final selected = idx == _selectedFilterIndex;
                        return Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: ChoiceChip(
                            label: Text(_filters[idx]),
                            selected: selected,
                            showCheckmark: false,
                            selectedColor: AppColors.primary,
                            backgroundColor: cardBg,
                            side: BorderSide(
                              color: selected ? AppColors.primary : borderColor,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(99),
                            ),
                            labelStyle: AppTextStyles.labelMd.copyWith(
                              color: selected ? Colors.white : textColor,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                            onSelected: (_) {
                              setState(() {
                                _selectedFilterIndex = idx;
                              });
                            },
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // --- 3. Recommendation Cards ---
                  if (items.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.verified_outlined,
                            size: 40,
                            color: AppColors.primaryContainer,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'لا توجد توصيات مطابقة',
                            style: AppTextStyles.labelLg.copyWith(
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'جميع الحقول والمحاصيل تعمل ضمن المستويات المثالية لهذه الفئة.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodySm.copyWith(
                              color: subColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...items.map((rec) {
                      final isExpanded = !_collapsedIds.contains(rec.id);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _RecommendationCard(
                          rec: rec,
                          isExpanded: isExpanded,
                          onToggleExpand: () {
                            setState(() {
                              if (isExpanded) {
                                _collapsedIds.add(rec.id);
                              } else {
                                _collapsedIds.remove(rec.id);
                              }
                            });
                          },
                          onCompleteAction: () {
                            appState.completeRecommendation(rec.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'تم توثيق تنفيذ الإجراء: ${rec.title}',
                                  style: AppTextStyles.bodyMd.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: AppColors.inverseSurface,
                              ),
                            );
                          },
                        ),
                      );
                    }),

                  // --- 4. تمت معالجتها مؤخرًا (5) ---
                  InkWell(
                    onTap: () {
                      setState(() {
                        _showCompletedSection = !_showCompletedSection;
                      });
                    },
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFB3F496),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.task_alt,
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'تمت معالجتها مؤخرًا (5)',
                                  style: AppTextStyles.labelLg.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                  ),
                                ),
                              ),
                              Icon(
                                _showCompletedSection
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                color: subColor,
                              ),
                            ],
                          ),
                          if (_showCompletedSection) ...[
                            const Divider(height: 20),
                            const _CompletedRecItem(
                              title: 'تعديل ضخ السماد العضوي - حوض رقم 3',
                              time: 'اليوم، 07:15 ص',
                            ),
                            const _CompletedRecItem(
                              title: 'فحص محبس الخط الرئيسي الشمالي',
                              time: 'أمس، 02:40 م',
                            ),
                            const _CompletedRecItem(
                              title: 'تنظيف فلاتر الري بالرشاشات المحورية',
                              time: 'أمس، 10:15 ص',
                            ),
                            const _CompletedRecItem(
                              title: 'معايرة حساس الرطوبة اللاسلكي رقم 12',
                              time: 'قبل يومين',
                            ),
                            const _CompletedRecItem(
                              title: 'تفعيل دورة الري المسائية لحقل القمح',
                              time: 'قبل 3 أيام',
                            ),
                          ],
                        ],
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

class _RecStatBox extends StatelessWidget {
  const _RecStatBox({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.value,
    required this.label,
    required this.borderColor,
    required this.textColor,
    required this.subColor,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String value;
  final String label;
  final Color borderColor;
  final Color textColor;
  final Color subColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, size: 17, color: iconColor),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.headlineSm.copyWith(
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelSm.copyWith(
              fontSize: 11,
              color: subColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.rec,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.onCompleteAction,
  });

  final RecommendationModel rec;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final VoidCallback onCompleteAction;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.inverseOnSurface : AppColors.onSurface;
    final subColor = isDark
        ? AppColors.outlineVariant
        : AppColors.onSurfaceVariant;
    final isUrgent = rec.priority == 'عاجلة';

    IconData categoryIcon;
    Color iconBg;
    Color iconColor;
    switch (rec.categoryType) {
      case 'water':
        categoryIcon = Icons.water_drop_outlined;
        iconBg = const Color(0xFFFDE8E8);
        iconColor = const Color(0xFF991B1B);
      case 'fertilizer':
        categoryIcon = Icons.science_outlined;
        iconBg = const Color(0xFFFED6A7);
        iconColor = const Color(0xFF795B36);
      default:
        categoryIcon = Icons.air;
        iconBg = const Color(0xFFFDE8E8);
        iconColor = const Color(0xFF991B1B);
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.onSurface : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.onSurfaceVariant : AppColors.borderOutline,
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
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(categoryIcon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rec.title,
                      softWrap: true,
                      style: AppTextStyles.labelLg.copyWith(
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      rec.sectorAndTime,
                      softWrap: true,
                      style: AppTextStyles.bodySm.copyWith(color: subColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isUrgent
                      ? const Color(0xFFFDE8E8)
                      : const Color(0xFFFED6A7),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  rec.priority,
                  style: AppTextStyles.labelSm.copyWith(
                    color: isUrgent
                        ? const Color(0xFF991B1B)
                        : const Color(0xFF795B36),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Metric Box — natural multi-line wrapping with zero text clipping
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.inverseSurface
                  : AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.sensors,
                      size: 16,
                      color: AppColors.primaryContainer,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        rec.metricTitle,
                        softWrap: true,
                        style: AppTextStyles.bodySm.copyWith(color: subColor),
                      ),
                    ),
                  ],
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  runSpacing: 2,
                  children: [
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        rec.metricValue,
                        style: AppTextStyles.labelMd.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isUrgent
                              ? const Color(0xFF991B1B)
                              : AppColors.secondary,
                        ),
                      ),
                    ),
                    Text(
                      rec.metricTarget,
                      softWrap: true,
                      style: AppTextStyles.labelSm.copyWith(color: subColor),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (isExpanded) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.inverseSurface
                    : AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 16,
                        color: AppColors.primaryContainer,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'التشخيص الزراعي:',
                        style: AppTextStyles.labelMd.copyWith(
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    rec.diagnosisText,
                    softWrap: true,
                    style: AppTextStyles.bodySm.copyWith(
                      color: subColor,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.task_alt,
                        size: 16,
                        color: AppColors.primaryContainer,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'الإجراء الموصى به:',
                        style: AppTextStyles.labelMd.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryContainer,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    rec.actionText,
                    softWrap: true,
                    style: AppTextStyles.bodySm.copyWith(
                      color: subColor,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: rec.isCompleted ? null : onCompleteAction,
                    icon: Icon(
                      rec.isCompleted
                          ? Icons.check_circle
                          : Icons.play_arrow_outlined,
                      size: 18,
                    ),
                    label: Text(
                      rec.isCompleted
                          ? 'تم توثيق التنفيذ'
                          : rec.actionButtonLabel,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 10),

          // Expandable Toggle Button: إخفاء التفاصيل / عرض التفاصيل والإجراء
          InkWell(
            onTap: onToggleExpand,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.inverseSurface
                    : AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? AppColors.onSurfaceVariant
                      : AppColors.borderOutline,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isExpanded ? 'إخفاء التفاصيل' : 'عرض التفاصيل والإجراء',
                    style: AppTextStyles.labelMd.copyWith(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                    color: subColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletedRecItem extends StatelessWidget {
  const _CompletedRecItem({required this.title, required this.time});

  final String title;
  final String time;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.inverseOnSurface : AppColors.onSurface;
    final subColor = isDark
        ? AppColors.outlineVariant
        : AppColors.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.check_circle,
              size: 16,
              color: AppColors.primaryContainer,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              softWrap: true,
              style: AppTextStyles.bodySm.copyWith(color: textColor),
            ),
          ),
          const SizedBox(width: 8),
          Text(time, style: AppTextStyles.labelSm.copyWith(color: subColor)),
        ],
      ),
    );
  }
}
