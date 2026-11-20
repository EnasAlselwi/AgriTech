import 'package:flutter/material.dart';

import '../../../../core/config/app_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../models/agritech_models.dart';
import '../../../../shared/widgets/agritech_bottom_nav.dart';
import '../../../../shared/widgets/agritech_header_banner.dart';

/// Screen 11 (`agritech_12` — My Farms / `مزارعي`).
/// Reproduces `design_reference/stitch_agritech_mobile_auth_redesign/agritech_12/screen.png`
/// and `code.html`.
class MyFarmsPage extends StatefulWidget {
  const MyFarmsPage({super.key});

  @override
  State<MyFarmsPage> createState() => _MyFarmsPageState();
}

class _MyFarmsPageState extends State<MyFarmsPage> {
  String _sortBy = 'المساحة'; // 'المساحة', 'الموقع', 'عدد الحساسات'

  List<FarmModel> _sortedFarms(List<FarmModel> rawFarms) {
    final copy = List<FarmModel>.from(rawFarms);
    if (_sortBy == 'المساحة') {
      copy.sort((a, b) => b.areaHectares.compareTo(a.areaHectares));
    } else if (_sortBy == 'الموقع') {
      copy.sort((a, b) => a.location.compareTo(b.location));
    } else if (_sortBy == 'عدد الحساسات') {
      copy.sort((a, b) => b.connectedSensors.compareTo(a.connectedSensors));
    }
    return copy;
  }

  Future<void> _showSortSheet(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.inverseSurface
        : AppColors.surfaceContainerLowest;
    final textColor = isDark ? AppColors.inverseOnSurface : AppColors.onSurface;
    final subColor = isDark
        ? AppColors.outlineVariant
        : AppColors.onSurfaceVariant;

    final options = [
      ('المساحة', 'من الأكبر إلى الأصغر مساحة (بالهكتار)', Icons.square_foot),
      ('الموقع', 'ترتيب أبجدي حسب منطقة المزرعة', Icons.location_on_outlined),
      ('عدد الحساسات', 'من الأكثر حساسات متصلة إلى الأقل', Icons.sensors),
    ];

    await showModalBottomSheet<void>(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.sort,
                          color: AppColors.primaryContainer,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'ترتيب المزارع حسب',
                          style: AppTextStyles.headlineSm.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(sheetContext).pop(),
                      icon: Icon(Icons.close, color: subColor),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                for (final opt in options) ...[
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      setState(() {
                        _sortBy = opt.$1;
                      });
                      Navigator.of(sheetContext).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: _sortBy == opt.$1
                            ? AppColors.primaryContainer.withValues(alpha: 0.1)
                            : (isDark
                                  ? AppColors.onSurface
                                  : AppColors.surfaceContainerLow),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _sortBy == opt.$1
                              ? AppColors.primaryContainer
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            opt.$3,
                            color: _sortBy == opt.$1
                                ? AppColors.primaryContainer
                                : subColor,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  opt.$1,
                                  style: AppTextStyles.labelLg.copyWith(
                                    color: textColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  opt.$2,
                                  style: AppTextStyles.labelSm.copyWith(
                                    color: subColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_sortBy == opt.$1)
                            const Icon(
                              Icons.check_circle,
                              color: AppColors.primaryContainer,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showFarmFormSheet(
    BuildContext context, {
    FarmModel? existingFarm,
  }) async {
    final appState = AppStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.inverseSurface
        : AppColors.surfaceContainerLowest;
    final textColor = isDark ? AppColors.inverseOnSurface : AppColors.onSurface;
    final subColor = isDark
        ? AppColors.outlineVariant
        : AppColors.onSurfaceVariant;

    final nameCtrl = TextEditingController(text: existingFarm?.name ?? '');
    final locationCtrl = TextEditingController(
      text: existingFarm?.location ?? '',
    );
    final areaCtrl = TextEditingController(
      text: existingFarm != null ? existingFarm.areaHectares.toString() : '',
    );
    final notesCtrl = TextEditingController(text: existingFarm?.notes ?? '');
    String selectedCrop = existingFarm?.cropType ?? 'بن يمني أصيل';

    final cropOptions = [
      'بن يمني أصيل',
      'بن يمني دوائري',
      'بن يمني مطري',
      'عديني',
      'تفاحي',
      'برعي',
    ];

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: EdgeInsets.only(
                  right: 20,
                  left: 20,
                  top: 18,
                  bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                existingFarm == null
                                    ? 'إضافة مزرعة جديدة'
                                    : 'تعديل بيانات المزرعة',
                                style: AppTextStyles.headlineSm.copyWith(
                                  color: textColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                existingFarm == null
                                    ? 'أدخل بيانات مزرعة البن لتوثيقها وربط الحساسات'
                                    : 'تحديث بيانات المزرعة ومعلومات المحصول',
                                style: AppTextStyles.labelSm.copyWith(
                                  color: subColor,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(sheetContext).pop(),
                            icon: Icon(Icons.close, color: subColor),
                          ),
                        ],
                      ),
                      const Divider(height: 22),
                      Text(
                        'اسم المزرعة *',
                        style: AppTextStyles.labelMd.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(
                          hintText: 'مثال: مزرعة مدرجات حراز العليا',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'موقع المزرعة *',
                        style: AppTextStyles.labelMd.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: locationCtrl,
                        decoration: const InputDecoration(
                          hintText: 'المحافظة / المديرية / القرية',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'المساحة المزروعة بالبن (بالهكتار) *',
                        style: AppTextStyles.labelMd.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: areaCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'مثال: 2.5',
                          suffixText: 'هكتار',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'نوع المحصول *',
                        style: AppTextStyles.labelMd.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: cropOptions.map((crop) {
                          final isSelected = selectedCrop == crop;
                          return ChoiceChip(
                            label: Text(crop),
                            selected: isSelected,
                            selectedColor: AppColors.primaryContainer
                                .withValues(alpha: 0.16),
                            labelStyle: AppTextStyles.labelMd.copyWith(
                              color: isSelected
                                  ? AppColors.primaryContainer
                                  : textColor,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                            onSelected: (_) {
                              setSheetState(() {
                                selectedCrop = crop;
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'ملاحظات إضافية (اختياري)',
                        style: AppTextStyles.labelMd.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: notesCtrl,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText:
                              'اكتب أي تفاصيل عن المدرجات أو مصدر المياه...',
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                final name = nameCtrl.text.trim();
                                final loc = locationCtrl.text.trim();
                                final area =
                                    double.tryParse(areaCtrl.text.trim()) ??
                                    1.2;
                                if (name.isEmpty || loc.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'يرجى إدخال اسم المزرعة والموقع',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                if (existingFarm == null) {
                                  appState.addFarm(
                                    name: name,
                                    location: loc,
                                    areaHectares: area,
                                    cropType: selectedCrop,
                                    notes: notesCtrl.text.trim(),
                                  );
                                } else {
                                  appState.updateFarm(
                                    existingFarm.id,
                                    name: name,
                                    location: loc,
                                    areaHectares: area,
                                    cropType: selectedCrop,
                                    notes: notesCtrl.text.trim(),
                                  );
                                }
                                Navigator.of(sheetContext).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      existingFarm == null
                                          ? 'تم حفظ المزرعة بنجاح'
                                          : 'تم تحديث بيانات المزرعة بنجاح',
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.check_circle_outline),
                              label: Text(
                                existingFarm == null
                                    ? 'حفظ المزرعة'
                                    : 'حفظ التعديلات',
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(sheetContext).pop(),
                              child: const Text('إلغاء'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Farm Details Bottom Sheet matching `agritech_12/code.html` lines 156-243.
  Future<void> _showFarmDetailsSheet(
    BuildContext context,
    FarmModel farm,
  ) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.inverseSurface
        : AppColors.surfaceContainerLowest;
    final cardLowBg = isDark
        ? AppColors.onSurface
        : AppColors.surfaceContainerLow;
    final textColor = isDark ? AppColors.inverseOnSurface : AppColors.onSurface;
    final subColor = isDark
        ? AppColors.outlineVariant
        : AppColors.onSurfaceVariant;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        final maxHeight = MediaQuery.of(sheetContext).size.height * 0.88;
        return Directionality(
          textDirection: TextDirection.rtl,
          child: ConstrainedBox(
            key: const Key('farm_details_modal'),
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Drag Handle + Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: AppColors.outlineVariant.withValues(
                            alpha: 0.7,
                          ),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.info_outline,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    farm.name,
                                    style: AppTextStyles.headlineSm.copyWith(
                                      color: textColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            key: const Key('farm_details_close_icon_button'),
                            onPressed: () => Navigator.of(sheetContext).pop(),
                            icon: Icon(Icons.close, color: subColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Scrollable Body
                Flexible(
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Banner Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              farm.bannerAsset,
                              height: 140,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Farm Attributes Card
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: cardLowBg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.outlineVariant.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _DetailLine(
                                  label: 'اسم المزرعة:',
                                  value: farm.name,
                                  textColor: AppColors.primary,
                                  subColor: subColor,
                                ),
                                const Divider(height: 18),
                                _DetailLine(
                                  label: 'الموقع:',
                                  value: farm.location,
                                  textColor: textColor,
                                  subColor: subColor,
                                ),
                                const SizedBox(height: 10),
                                _DetailLine(
                                  label: 'المساحة المزروعة بالبن:',
                                  value: '${farm.areaHectares} هكتار',
                                  textColor: textColor,
                                  subColor: subColor,
                                ),
                                const SizedBox(height: 10),
                                _DetailLine(
                                  label: 'نوع المحصول:',
                                  value: farm.cropType,
                                  textColor: textColor,
                                  subColor: subColor,
                                ),
                                const SizedBox(height: 10),
                                _DetailLine(
                                  label: 'عدد الحساسات المرتبطة:',
                                  value: '${farm.connectedSensors} حساسات',
                                  textColor: AppColors.primary,
                                  subColor: subColor,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'حالة اتصال الحساسات:',
                                      style: AppTextStyles.labelSm.copyWith(
                                        color: subColor,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: AppColors.primary,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'متصلة ونشطة',
                                          style: AppTextStyles.labelSm.copyWith(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(height: 18),
                                Text(
                                  'ملاحظات إضافية:',
                                  style: AppTextStyles.labelSm.copyWith(
                                    color: subColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  farm.notes.isNotEmpty
                                      ? farm.notes
                                      : 'لا توجد ملاحظات إضافية مسجلة.',
                                  style: AppTextStyles.bodySm.copyWith(
                                    color: textColor,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Connected Sensors Sub-list (`الحساسات الميدانية النشطة`)
                          Row(
                            children: [
                              const Icon(
                                Icons.sensors,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'الحساسات الميدانية النشطة',
                                style: AppTextStyles.labelLg.copyWith(
                                  color: textColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          for (final s in farm.registeredSensors) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: cardLowBg,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.outlineVariant.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(
                                          s.type == 'soil'
                                              ? Icons.water_drop_outlined
                                              : s.type == 'temp'
                                              ? Icons.device_thermostat
                                              : Icons.sensors,
                                          size: 18,
                                          color: s.type == 'temp'
                                              ? AppColors.secondary
                                              : AppColors.primary,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            s.name,
                                            style: AppTextStyles.bodySm
                                                .copyWith(
                                                  color: textColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(99),
                                    ),
                                    child: Text(
                                      s.statusLabel,
                                      style: AppTextStyles.labelSm.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                const Divider(height: 1),
                // Action Buttons
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(sheetContext).pop();
                            _showFarmFormSheet(context, existingFarm: farm);
                          },
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          label: const Text('تعديل بيانات المزرعة'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          key: const Key('farm_details_close_button'),
                          onPressed: () => Navigator.of(sheetContext).pop(),
                          child: const Text('إغلاق'),
                        ),
                      ),
                    ],
                  ),
                ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.onSurface
        : AppColors.authBannerBackground;
    final cardBg = isDark
        ? AppColors.onSurface
        : AppColors.surfaceContainerLowest;
    final textColor = isDark ? AppColors.inverseOnSurface : AppColors.onSurface;
    final subColor = isDark
        ? AppColors.outlineVariant
        : AppColors.onSurfaceVariant;

    final sortedFarms = _sortedFarms(appState.farms);
    final totalArea = appState.farms.fold<double>(
      0,
      (sum, f) => sum + f.areaHectares,
    );
    final totalSensors = appState.farms.fold<int>(
      0,
      (sum, f) => sum + f.connectedSensors,
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        body: Column(
          children: [
            const AgriTechInternalHeader(
              title: 'مزارعي',
              subtitle: 'إدارة مزارع البن ومعلوماتها',
            ),
            AgriTechWhiteSheetContainer(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Agricultural Overview Card (`نظرة عامة على الرقعة الزراعية`)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: AppColors.outlineVariant.withValues(alpha: 0.35),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'نظرة عامة على الرقعة الزراعية',
                                style: AppTextStyles.labelLg.copyWith(
                                  color: textColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'تم تحديث إحصائيات المزارع والحساسات',
                                    ),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.inverseSurface
                                      : AppColors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.sync,
                                  size: 18,
                                  color: AppColors.primaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: _OverviewStatTile(
                                value: '${appState.farms.length}',
                                label: 'مزارع مسجلة',
                                isDark: isDark,
                                textColor: textColor,
                                subColor: subColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _OverviewStatTile(
                                value: totalArea.toStringAsFixed(1),
                                label: 'هكتار بن',
                                isDark: isDark,
                                textColor: AppColors.primaryContainer,
                                subColor: subColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _OverviewStatTile(
                                value: '$totalSensors',
                                label: 'حساس نشط',
                                isDark: isDark,
                                textColor: textColor,
                                subColor: subColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 2. Primary CTA Button: `إضافة مزرعة جديدة`
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryContainer,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                    onPressed: () => _showFarmFormSheet(context),
                    icon: const Icon(Icons.add_circle_outline, size: 22),
                    label: Text(
                      'إضافة مزرعة جديدة',
                      style: AppTextStyles.labelLg.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // 3. Section Header: `المزارع الموثقة (٣)` + Sort Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'المزارع الموثقة (${sortedFarms.length})',
                        style: AppTextStyles.headlineSm.copyWith(
                          color: textColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => _showSortSheet(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.outlineVariant.withValues(
                                alpha: 0.45,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.sort,
                                size: 16,
                                color: AppColors.primaryContainer,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'ترتيب حسب $_sortBy',
                                style: AppTextStyles.labelSm.copyWith(
                                  color: AppColors.primaryContainer,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 4. Farm Cards List
                  for (final farm in sortedFarms) ...[
                    _FarmCard(
                      farm: farm,
                      cardBg: cardBg,
                      textColor: textColor,
                      subColor: subColor,
                      isDark: isDark,
                      onViewDetails: () => _showFarmDetailsSheet(context, farm),
                      onEdit: () =>
                          _showFarmFormSheet(context, existingFarm: farm),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: const AgriTechBottomNav(
          currentTab: AgriTechNavTab.farms,
        ),
      ),
    );
  }
}

class _OverviewStatTile extends StatelessWidget {
  const _OverviewStatTile({
    required this.value,
    required this.label,
    required this.isDark,
    required this.textColor,
    required this.subColor,
  });

  final String value;
  final String label;
  final bool isDark;
  final Color textColor;
  final Color subColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.inverseSurface
            : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.headlineMd.copyWith(
              color: textColor,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelSm.copyWith(
              color: subColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FarmCard extends StatelessWidget {
  const _FarmCard({
    required this.farm,
    required this.cardBg,
    required this.textColor,
    required this.subColor,
    required this.isDark,
    required this.onViewDetails,
    required this.onEdit,
  });

  final FarmModel farm;
  final Color cardBg;
  final Color textColor;
  final Color subColor;
  final bool isDark;
  final VoidCallback onViewDetails;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Image Banner with overlay badges & title
          SizedBox(
            height: 145,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(farm.bannerAsset, fit: BoxFit.cover),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.15),
                        Colors.black.withValues(alpha: 0.72),
                      ],
                    ),
                  ),
                ),
                // Top-Right Active Badge (`● نشطة`)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '● نشطة',
                      style: AppTextStyles.labelSm.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                // Bottom Row: Farm Name (Right) + Feature Badge (Left)
                Positioned(
                  right: 14,
                  left: 14,
                  bottom: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          farm.name,
                          style: AppTextStyles.headlineSm.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Text(
                          farm.featureBadge,
                          style: AppTextStyles.labelSm.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Body: 3-column metrics + 2 action buttons
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _FarmMetricColumn(
                        icon: Icons.location_on_outlined,
                        label: 'الموقع',
                        value: farm.location,
                        textColor: textColor,
                        subColor: subColor,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 36,
                      color: AppColors.outlineVariant.withValues(alpha: 0.4),
                    ),
                    Expanded(
                      child: _FarmMetricColumn(
                        icon: Icons.straighten,
                        label: 'المساحة',
                        value: '${farm.areaHectares} هكتار',
                        textColor: textColor,
                        subColor: subColor,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 36,
                      color: AppColors.outlineVariant.withValues(alpha: 0.4),
                    ),
                    Expanded(
                      child: _FarmMetricColumn(
                        icon: Icons.sensors,
                        label: 'الحساسات',
                        value: '${farm.connectedSensors} متصلة',
                        textColor: AppColors.primaryContainer,
                        subColor: subColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        key: Key('farm_view_details_${farm.id}'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: onViewDetails,
                        icon: const Icon(Icons.visibility_outlined, size: 18),
                        label: Text(
                          'عرض التفاصيل',
                          style: AppTextStyles.labelMd.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: isDark
                              ? AppColors.inverseSurface
                              : AppColors.surfaceContainerLow,
                          foregroundColor: textColor,
                          minimumSize: const Size.fromHeight(44),
                          side: BorderSide(
                            color: AppColors.outlineVariant.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: onEdit,
                        icon: Icon(
                          Icons.edit_outlined,
                          size: 16,
                          color: textColor,
                        ),
                        label: Text(
                          'تعديل',
                          style: AppTextStyles.labelMd.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FarmMetricColumn extends StatelessWidget {
  const _FarmMetricColumn({
    required this.icon,
    required this.label,
    required this.value,
    required this.textColor,
    required this.subColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color textColor;
  final Color subColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: subColor),
            const SizedBox(width: 4),
            Text(label, style: AppTextStyles.labelSm.copyWith(color: subColor)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.labelMd.copyWith(
            color: textColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({
    required this.label,
    required this.value,
    required this.textColor,
    required this.subColor,
  });

  final String label;
  final String value;
  final Color textColor;
  final Color subColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelSm.copyWith(color: subColor)),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.left,
            style: AppTextStyles.labelMd.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
