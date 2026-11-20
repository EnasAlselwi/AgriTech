import 'package:flutter/material.dart';

import '../../../../core/config/app_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../models/agritech_models.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/widgets/agritech_bottom_nav.dart';
import '../../../../shared/widgets/agritech_header_banner.dart';

/// Screen 9: Diagnosis History (`سجل التشخيصات`) — Faithful implementation of `agritech_4`.
class DiagnosisHistoryPage extends StatefulWidget {
  const DiagnosisHistoryPage({super.key});

  @override
  State<DiagnosisHistoryPage> createState() => _DiagnosisHistoryPageState();
}

class _DiagnosisHistoryPageState extends State<DiagnosisHistoryPage> {
  final _searchController = TextEditingController();
  int _selectedFilterIndex = 0;

  static const List<String> _filters = [
    'الكل (12)',
    'مزرعة البن الرئيسية',
    'صدأ الأوراق',
    'تبقع الأوراق',
    'سليمة',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DiagnosisRecordModel> _filteredRecords(List<DiagnosisRecordModel> all) {
    final query = _searchController.text.trim();
    return all.where((item) {
      if (query.isNotEmpty) {
        final match =
            item.diseaseName.contains(query) ||
            item.farmName.contains(query) ||
            item.statusLabel.contains(query);
        if (!match) return false;
      }
      switch (_selectedFilterIndex) {
        case 1:
          return item.farmName.contains('الرئيسية');
        case 2:
          return item.diseaseName.contains('صدأ');
        case 3:
          return item.diseaseName.contains('التبقع');
        case 4:
          return item.statusType == 'healthy';
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final records = _filteredRecords(appState.diagnosisHistory);
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
              title: 'سجل التشخيصات',
              subtitle: 'راجع نتائج التشخيص السابقة لمزارعك بدقة',
              showBackButton: true,
            ),
            AgriTechWhiteSheetContainer(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- 1. ملخص الفحوصات ---
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.onSurface
                          : AppColors.badgeSoftGreen,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: cardBg,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.analytics_outlined,
                                    size: 18,
                                    color: AppColors.primaryContainer,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'ملخص الفحوصات',
                                  style: AppTextStyles.labelLg.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC1EEBC),
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                'موسم 2024',
                                style: AppTextStyles.labelSm.copyWith(
                                  color: AppColors.onTertiaryFixed,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _HistorySummaryBox(
                                title: '12',
                                subtitle: 'إجمالي\nالفحوصات',
                                cardBg: cardBg,
                                borderColor: borderColor,
                                valueColor: AppColors.primary,
                                subColor: subColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _HistorySummaryBox(
                                title: 'اليوم 11:20 ص',
                                subtitle: 'أحدث\nتشخيص',
                                cardBg: cardBg,
                                borderColor: borderColor,
                                valueColor: textColor,
                                subColor: subColor,
                                smallValueFont: true,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _HistorySummaryBox(
                                title: '75%',
                                subtitle: 'معالجة\nومتابعة',
                                cardBg: cardBg,
                                borderColor: borderColor,
                                valueColor: AppColors.primary,
                                subColor: subColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // --- 2. Search Bar ---
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    style: AppTextStyles.bodyMd.copyWith(color: textColor),
                    decoration: InputDecoration(
                      hintText: 'ابحث عن تشخيص، مزرعة، أو آفة...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.outline,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                              icon: const Icon(Icons.cancel_outlined),
                            )
                          : null,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // --- 3. Filter Chips ---
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

                  // --- 4. Diagnosis Record Cards ---
                  if (records.isEmpty)
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
                            Icons.eco_outlined,
                            size: 40,
                            color: AppColors.primaryContainer,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'لا توجد تشخيصات مطابقة للبحث',
                            style: AppTextStyles.labelLg.copyWith(
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'قم بالتقاط صورة لورقة شجرة البن للتعرف الفوري على الأمراض وتلقي إرشادات العلاج.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodySm.copyWith(
                              color: subColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...records.map(
                      (record) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _DiagnosisHistoryCard(
                          record: record,
                          onTap: () => Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.diagnosisResult),
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

class _HistorySummaryBox extends StatelessWidget {
  const _HistorySummaryBox({
    required this.title,
    required this.subtitle,
    required this.cardBg,
    required this.borderColor,
    required this.valueColor,
    required this.subColor,
    this.smallValueFont = false,
  });

  final String title;
  final String subtitle;
  final Color cardBg;
  final Color borderColor;
  final Color valueColor;
  final Color subColor;
  final bool smallValueFont;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.headlineSm.copyWith(
              fontSize: smallValueFont ? 12.5 : 18,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelSm.copyWith(
              fontSize: 10.5,
              color: subColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _DiagnosisHistoryCard extends StatelessWidget {
  const _DiagnosisHistoryCard({required this.record, required this.onTap});

  final DiagnosisRecordModel record;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.inverseOnSurface : AppColors.onSurface;
    final subColor = isDark
        ? AppColors.outlineVariant
        : AppColors.onSurfaceVariant;

    Color statusBg;
    Color statusText;
    switch (record.statusType) {
      case 'confirmed':
        statusBg = const Color(0xFFFDE8E8);
        statusText = const Color(0xFF991B1B);
      case 'followup':
        statusBg = const Color(0xFFFED6A7);
        statusText = const Color(0xFF795B36);
      default:
        statusBg = const Color(0xFFC1EEBC);
        statusText = AppColors.onTertiaryFixed;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.onSurface
              : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark
                ? AppColors.onSurfaceVariant
                : AppColors.borderOutline,
          ),
        ),
        child: Row(
          children: [
            // Thumbnail on the right (RTL start)
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                record.thumbnailAsset,
                width: 82,
                height: 82,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            // Content in the middle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          record.diseaseName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.labelLg.copyWith(
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
                          color: statusBg,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          record.statusLabel,
                          style: AppTextStyles.labelSm.copyWith(
                            fontSize: 10,
                            color: statusText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.yard_outlined, size: 14, color: subColor),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${record.farmName} · ${record.timestamp}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySm.copyWith(
                            fontSize: 11.5,
                            color: subColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.badgeSoftGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.verified_outlined,
                              size: 13,
                              color: AppColors.primaryContainer,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'دقة %${record.confidencePercent}',
                              style: AppTextStyles.labelSm.copyWith(
                                fontSize: 10.5,
                                color: AppColors.primaryContainer,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          record.actionSummary,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.labelSm.copyWith(
                            fontSize: 11,
                            color: subColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, color: subColor, size: 20),
          ],
        ),
      ),
    );
  }
}
