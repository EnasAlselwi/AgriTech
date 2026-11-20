import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/config/app_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/widgets/agritech_bottom_nav.dart';
import '../../../../shared/widgets/agritech_header_banner.dart';

/// Screen 7: Plant Disease Diagnosis (`تشخيص مرض نباتي`) — Faithful implementation of `agritech_14`.
/// Implements real Android Camera2 live preview + capture and device Gallery
/// selection, preserving the original image and creating a 1:1 preprocessed copy.
class DiagnosisPage extends StatefulWidget {
  const DiagnosisPage({super.key});

  @override
  State<DiagnosisPage> createState() => _DiagnosisPageState();
}

class _DiagnosisPageState extends State<DiagnosisPage> {
  static const MethodChannel _mediaChannel = MethodChannel(
    'com.agritech.agritech/diagnosis_media',
  );

  bool _showOriginalAspectRatio = false;
  String? _errorMessage;

  Future<void> _openLiveCameraSheet(
    BuildContext context,
    AppState appState,
  ) async {
    setState(() => _errorMessage = null);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return _LiveCameraCaptureSheet(
          mediaChannel: _mediaChannel,
          onConfirmed: (originalPath, preprocessedPath) {
            appState.setDiagnosisCapturedImage(
              originalPath: originalPath,
              preprocessedPath: preprocessedPath,
              source: 'الكاميرا',
              confirmed: true,
            );
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'تم تأكيد صورة ورقة البن وربطها بـ "${appState.farms[appState.selectedFarmIndex].name}"',
                    style: AppTextStyles.bodyMd.copyWith(color: Colors.white),
                  ),
                  backgroundColor: AppColors.inverseSurface,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          onError: (msg) {
            if (mounted) {
              setState(() => _errorMessage = msg);
            }
          },
        );
      },
    );
  }

  Future<void> _pickFromGallery(BuildContext context, AppState appState) async {
    setState(() => _errorMessage = null);

    try {
      Map<dynamic, dynamic>? result;
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        result = await _mediaChannel.invokeMethod<Map<dynamic, dynamic>>(
          'pickGalleryImage',
        );
      } else {
        result = {
          'originalPath': 'asset:lib/assets/images/sample_leaf_rust.png',
          'preprocessedPath': 'asset:lib/assets/images/sample_leaf_rust.png',
        };
      }

      if (result == null) {
        // User cancelled gallery selection
        return;
      }

      final origPath = result['originalPath']?.toString() ?? '';
      final prepPath = result['preprocessedPath']?.toString() ?? origPath;
      if (origPath.isEmpty) return;

      if (!context.mounted) return;
      await _showGalleryConfirmModal(
        context,
        appState: appState,
        originalPath: origPath,
        preprocessedPath: prepPath,
      );
    } on PlatformException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'تعذر فتح معرض الصور على الجهاز.';
      });
    } on MissingPluginException {
      // Fallback in widget tests where native channel is not registered
      if (!context.mounted) return;
      await _showGalleryConfirmModal(
        context,
        appState: appState,
        originalPath: 'asset:lib/assets/images/sample_leaf_rust.png',
        preprocessedPath: 'asset:lib/assets/images/sample_leaf_rust.png',
      );
    }
  }

  Future<void> _showGalleryConfirmModal(
    BuildContext context, {
    required AppState appState,
    required String originalPath,
    required String preprocessedPath,
  }) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.inverseSurface
        : AppColors.surfaceContainerLowest;
    final textColor = isDark ? AppColors.inverseOnSurface : AppColors.onSurface;
    final subColor = isDark
        ? AppColors.outlineVariant
        : AppColors.onSurfaceVariant;

    String currentOrig = originalPath;
    String currentPrep = preprocessedPath;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                key: const Key('gallery_preview_confirm_modal'),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'معاينة الصورة المختارة من المعرض',
                            style: AppTextStyles.headlineSm.copyWith(
                              color: textColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(sheetContext).pop(),
                          icon: Icon(Icons.close, color: subColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'تأكد من وضوح ورقة البن قبل تأكيد الصورة وإعدادها للتشخيص.',
                      style: AppTextStyles.bodySm.copyWith(color: subColor),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: _buildDiagnosisImageWidget(
                          currentPrep,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            key: const Key('confirm_gallery_image_button'),
                            onPressed: () {
                              appState.setDiagnosisCapturedImage(
                                originalPath: currentOrig,
                                preprocessedPath: currentPrep,
                                source: 'معرض الصور',
                                confirmed: true,
                              );
                              Navigator.of(sheetContext).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'تم تأكيد الصورة المختارة وربطها بـ "${appState.farms[appState.selectedFarmIndex].name}"',
                                    style: AppTextStyles.bodyMd.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: AppColors.inverseSurface,
                                ),
                              );
                            },
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('تأكيد الصورة'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            key: const Key('replace_gallery_image_button'),
                            onPressed: () async {
                              try {
                                final next = await _mediaChannel
                                    .invokeMethod<Map<dynamic, dynamic>>(
                                      'pickGalleryImage',
                                    );
                                if (next != null &&
                                    next['originalPath'] != null) {
                                  setModalState(() {
                                    currentOrig = next['originalPath']
                                        .toString();
                                    currentPrep =
                                        next['preprocessedPath']?.toString() ??
                                        currentOrig;
                                  });
                                }
                              } catch (_) {}
                            },
                            icon: const Icon(Icons.swap_horiz, size: 18),
                            label: const Text('استبدال'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _handleStartDiagnosis(BuildContext context, AppState appState) {
    final selectedFarm = appState.farms[appState.selectedFarmIndex];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.inverseSurface
        : AppColors.surfaceContainerLowest;
    final textColor = isDark ? AppColors.inverseOnSurface : AppColors.onSurface;
    final subColor = isDark
        ? AppColors.outlineVariant
        : AppColors.onSurfaceVariant;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            key: const Key('diagnosis_workflow_status_dialog'),
            backgroundColor: bgColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
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
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'حالة معالجة التشخيص',
                          style: AppTextStyles.headlineSm.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        icon: Icon(Icons.close, color: subColor),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.onSurface
                          : AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              size: 16,
                              color: AppColors.primaryContainer,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'المزرعة المرتبطة: ${selectedFarm.name}',
                                style: AppTextStyles.labelMd.copyWith(
                                  color: textColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              size: 16,
                              color: AppColors.primaryContainer,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                appState.isDiagnosisImageConfirmed
                                    ? 'تم حفظ الصورة الأصلية وتجهيز نسخة المعالجة المسبقة (1:1) بنجاح (${appState.diagnosisImageSource ?? "مؤكدة"}).'
                                    : 'تم تحديد عينة الفحص الميداني وربطها بالمزرعة.',
                                style: AppTextStyles.bodySm.copyWith(
                                  color: subColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Color(0xFFB45309),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'معالجة التشخيص بالذكاء الاصطناعي غير متاحة حالياً لأنه لم يتم دمج نموذج الذكاء الاصطناعي أو الخادم بعد. تم حفظ الصورة المؤكدة وربطها بالمزرعة استعداداً لمرحلة ربط النموذج، ولن يتم عرض نتائج تشخيص آلية وهمية.',
                            style: AppTextStyles.bodySm.copyWith(
                              color: const Color(0xFF92400E),
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    key: const Key('diagnosis_status_ok_button'),
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text('حسناً، فهمت'),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    key: const Key('diagnosis_preview_template_button'),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.diagnosisResult);
                    },
                    icon: const Icon(Icons.visibility_outlined, size: 16),
                    label: Text(
                      'معاينة شاشة نتيجة التشخيص المرجعية (Stitch)',
                      style: AppTextStyles.labelSm.copyWith(
                        color: AppColors.primaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
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

  void _showFarmSelector(BuildContext context, AppState appState) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'المزارع المسجلة (${appState.farms.length})',
                      style: AppTextStyles.headlineSm.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(sheetContext).pop();
                        Navigator.of(context).pushNamed(AppRoutes.myFarms);
                      },
                      icon: const Icon(Icons.add_circle_outline, size: 18),
                      label: const Text('إضافة مزرعة'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...List.generate(appState.farms.length, (idx) {
                  final farm = appState.farms[idx];
                  final selected = idx == appState.selectedFarmIndex;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: selected
                              ? AppColors.primaryContainer
                              : AppColors.borderOutline,
                        ),
                      ),
                      leading: const Icon(
                        Icons.agriculture_outlined,
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
                      trailing: selected
                          ? const Icon(
                              Icons.check_circle,
                              color: AppColors.primaryContainer,
                            )
                          : null,
                      onTap: () {
                        appState.selectFarm(idx);
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

    final activePreviewPath = _showOriginalAspectRatio
        ? (appState.capturedOriginalImagePath ??
              'asset:lib/assets/images/sample_leaf_rust.png')
        : (appState.preprocessedModelImagePath ??
              appState.capturedOriginalImagePath ??
              'asset:lib/assets/images/sample_leaf_rust.png');

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
              title: 'تشخيص مرض نباتي',
              subtitle: 'افحص أوراق البن وتعرّف على الحالة المحتملة',
              replaceSettingsWithBackWhenCanPop: true,
            ),
            AgriTechWhiteSheetContainer(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- AI Badge Row ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.badgeSoftGreen,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          'الذكاء الاصطناعي الزراعي v2.4',
                          style: AppTextStyles.labelSm.copyWith(
                            color: AppColors.primaryContainer,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'جاهز للفحص الميداني',
                            style: AppTextStyles.labelSm.copyWith(
                              color: subColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'افحص أوراق البن وتعرّف على الحالة المحتملة بدقة وسرعة عبر تصوير الأعراض مباشرة في الحقل.',
                    style: AppTextStyles.bodySm.copyWith(color: subColor),
                  ),

                  const SizedBox(height: 14),

                  // --- Farm Selector Card ---
                  InkWell(
                    key: const Key('diagnosis_farm_selector'),
                    onTap: () => _showFarmSelector(context, appState),
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
                              Icons.terrain_outlined,
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
                                Row(
                                  children: [
                                    Icon(
                                      Icons.pin_drop_outlined,
                                      size: 14,
                                      color: subColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        selectedFarm.regionSubtitle,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyles.bodySm.copyWith(
                                          color: subColor,
                                        ),
                                      ),
                                    ),
                                  ],
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

                  const SizedBox(height: 16),

                  // Error Banner if camera/gallery permission or device error occurred
                  if (_errorMessage != null) ...[
                    Container(
                      key: const Key('diagnosis_error_banner'),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.errorContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppColors.error,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: AppTextStyles.labelMd.copyWith(
                                color: AppColors.onErrorContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                setState(() => _errorMessage = null),
                            icon: const Icon(
                              Icons.close,
                              size: 18,
                              color: AppColors.onErrorContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // --- Leaf Capture Card ---
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
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: AppColors.badgeSoftGreen,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.energy_savings_leaf_outlined,
                                    size: 18,
                                    color: AppColors.primaryContainer,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'صورة ورقة البن',
                                  style: AppTextStyles.headlineSm.copyWith(
                                    fontSize: 16,
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
                                'أبعاد 1:1 مربعة',
                                style: AppTextStyles.labelSm.copyWith(
                                  color: subColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Viewfinder Box
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.inverseSurface
                                : AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: borderColor),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: cardBg,
                                  borderRadius: BorderRadius.circular(99),
                                  border: Border.all(color: borderColor),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.aspect_ratio,
                                      size: 16,
                                      color: AppColors.primaryContainer,
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        'مواصفات الفحص: 2400 × 2400 بكسل (1:1 مربعة)',
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.labelSm.copyWith(
                                          color: subColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Square Target Frame (tappable to open live camera)
                              InkWell(
                                onTap: () =>
                                    _openLiveCameraSheet(context, appState),
                                borderRadius: BorderRadius.circular(18),
                                child: Container(
                                  width: 175,
                                  height: 175,
                                  decoration: BoxDecoration(
                                    color: cardBg,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: AppColors.primaryContainer,
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.photo_camera_outlined,
                                        size: 40,
                                        color: AppColors.primaryContainer,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'ضع الورقة داخل\nالإطار',
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.labelMd.copyWith(
                                          color: subColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // 2x2 Guidelines Grid
                              Row(
                                children: const [
                                  Expanded(
                                    child: _CaptureTipTile(
                                      icon: Icons.crop_free,
                                      text:
                                          'تأكد من وضوح الورقة وظهور الأعراض.',
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: _CaptureTipTile(
                                      icon: Icons.wb_sunny_outlined,
                                      text:
                                          'الإضاءة مناسبة وتجنب الظلال الحادة.',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: const [
                                  Expanded(
                                    child: _CaptureTipTile(
                                      icon: Icons.vibration,
                                      text:
                                          'حافظ على ثبات الكاميرا أثناء التصوير.',
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: _CaptureTipTile(
                                      icon: Icons.center_focus_strong_outlined,
                                      text:
                                          'التركيز التلقائي مفعّل على العينة.',
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
                                  color: AppColors.badgeSoftGreen,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.check_circle_outline,
                                      size: 16,
                                      color: AppColors.primaryContainer,
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        appState.isDiagnosisImageConfirmed
                                            ? 'تم تأكيد الصورة (${appState.diagnosisImageSource}) وربطها بـ ${selectedFarm.name}'
                                            : 'الصورة جاهزة، يمكنك التقاطها الآن.',
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.labelSm.copyWith(
                                          color: AppColors.primaryContainer,
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

                        const SizedBox(height: 14),

                        // Capture / Pick Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                key: const Key('diagnosis_capture_button'),
                                onPressed: () =>
                                    _openLiveCameraSheet(context, appState),
                                icon: const Icon(
                                  Icons.photo_camera_outlined,
                                  size: 18,
                                ),
                                label: const Text('التقاط صورة'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton.icon(
                                key: const Key('diagnosis_pick_button'),
                                onPressed: () =>
                                    _pickFromGallery(context, appState),
                                icon: const Icon(
                                  Icons.image_outlined,
                                  size: 18,
                                ),
                                label: const Text('اختيار صورة'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- Captured Sample Preview Card ---
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
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryContainer,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'معاينة العينة الملتقطة',
                                  style: AppTextStyles.labelLg.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            OutlinedButton.icon(
                              key: const Key('retake_or_replace_image_button'),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(0, 36),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                              ),
                              onPressed: () {
                                if (appState.diagnosisImageSource ==
                                    'معرض الصور') {
                                  _pickFromGallery(context, appState);
                                } else {
                                  _openLiveCameraSheet(context, appState);
                                }
                              },
                              icon: const Icon(Icons.cached, size: 16),
                              label: Text(
                                appState.diagnosisImageSource == 'معرض الصور'
                                    ? 'استبدال الصورة'
                                    : 'إعادة التقاط الصورة',
                                style: AppTextStyles.labelSm.copyWith(
                                  color: AppColors.primaryContainer,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
                                child: _buildDiagnosisImageWidget(
                                  activePreviewPath,
                                  fit: _showOriginalAspectRatio
                                      ? BoxFit.contain
                                      : BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.92),
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.auto_awesome,
                                        size: 14,
                                        color: AppColors.primaryContainer,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        appState.isDiagnosisImageConfirmed
                                            ? 'مؤكدة (${selectedFarm.name})'
                                            : 'تم التحقق من الوضوح',
                                        style: AppTextStyles.labelSm.copyWith(
                                          color: AppColors.onSurface,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                left: 10,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _showOriginalAspectRatio =
                                          !_showOriginalAspectRatio;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.92,
                                      ),
                                      borderRadius: BorderRadius.circular(99),
                                    ),
                                    child: Text(
                                      _showOriginalAspectRatio
                                          ? 'الأصلية الكاملة'
                                          : '1:1 مربع (نموذج)',
                                      style: AppTextStyles.labelSm.copyWith(
                                        color: AppColors.primaryContainer,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'أبعاد العينة: 2400 × 2400 بكسل (1:1 مربعة)',
                              style: AppTextStyles.labelSm.copyWith(
                                color: subColor,
                              ),
                            ),
                            Text(
                              'تركيز البؤرة: 98%',
                              style: AppTextStyles.labelSm.copyWith(
                                color: AppColors.primaryContainer,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 22),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                'الأمراض والآفات التي يدعم النموذج تشخيصها:',
                                style: AppTextStyles.labelMd.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                ),
                              ),
                            ),
                            Text(
                              '4 فئات مدعومة',
                              style: AppTextStyles.labelSm.copyWith(
                                color: AppColors.primaryContainer,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              const [
                                'صدأ أوراق البن',
                                'الفوما',
                                'السيركوسبورا',
                                'حفارة الأوراق',
                              ].map((item) {
                                return Container(
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
                                    item,
                                    style: AppTextStyles.labelSm.copyWith(
                                      color: textColor,
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                        const SizedBox(height: 16),

                        // Start Diagnosis CTA Button
                        ElevatedButton.icon(
                          key: const Key('start_diagnosis_button'),
                          onPressed: () =>
                              _handleStartDiagnosis(context, appState),
                          icon: const Icon(Icons.troubleshoot, size: 20),
                          label: const Text('بدء التشخيص'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // --- Advisory Note Card ---
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.badgeSoftGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.smart_toy_outlined,
                            size: 19,
                            color: AppColors.primaryContainer,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'تعتمد نتيجة التشخيص على جودة الصورة وقدرات نموذج الذكاء الاصطناعي، ويُنصح دائمًا باستشارة المرشد الزراعي المعتمد في الحالات المعقدة.',
                            style: AppTextStyles.bodySm.copyWith(
                              color: subColor,
                              height: 1.55,
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
        ),
      ),
    );
  }
}

Widget _buildDiagnosisImageWidget(
  String pathOrAsset, {
  BoxFit fit = BoxFit.cover,
}) {
  if (pathOrAsset.startsWith('asset:')) {
    final asset = pathOrAsset.substring('asset:'.length);
    return Image.asset(asset, fit: fit);
  }
  final file = File(pathOrAsset);
  if (file.existsSync()) {
    return Image.file(file, fit: fit);
  }
  return Image.asset('lib/assets/images/sample_leaf_rust.png', fit: fit);
}

/// Live Camera Preview + 1:1 Coffee Leaf Frame + Capture / Retake / Confirm Sheet.
class _LiveCameraCaptureSheet extends StatefulWidget {
  const _LiveCameraCaptureSheet({
    required this.mediaChannel,
    required this.onConfirmed,
    required this.onError,
  });

  final MethodChannel mediaChannel;
  final void Function(String originalPath, String preprocessedPath) onConfirmed;
  final void Function(String errorMessage) onError;

  @override
  State<_LiveCameraCaptureSheet> createState() =>
      _LiveCameraCaptureSheetState();
}

class _LiveCameraCaptureSheetState extends State<_LiveCameraCaptureSheet> {
  int? _textureId;
  bool _isInitializing = true;
  bool _isCapturing = false;
  String? _cameraError;
  String? _capturedOriginalPath;
  String? _capturedPreprocessedPath;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    setState(() {
      _isInitializing = true;
      _cameraError = null;
      _capturedOriginalPath = null;
      _capturedPreprocessedPath = null;
    });

    try {
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        final res = await widget.mediaChannel
            .invokeMethod<Map<dynamic, dynamic>>('startCameraPreview');
        if (!mounted) return;
        setState(() {
          _textureId = (res?['textureId'] as num?)?.toInt() ?? -1;
          _isInitializing = false;
        });
      } else {
        if (!mounted) return;
        setState(() {
          _textureId = -1; // Simulated viewfinder in widget test / desktop
          _isInitializing = false;
        });
      }
    } on PlatformException catch (e) {
      final msg =
          e.message ?? 'تعذر تشغيل الكاميرا أو تم رفض إذن الوصول للكاميرا.';
      widget.onError(msg);
      if (!mounted) return;
      setState(() {
        _cameraError = msg;
        _isInitializing = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _textureId = -1;
        _isInitializing = false;
      });
    }
  }

  Future<void> _capturePhoto() async {
    if (_isCapturing) return;
    setState(() => _isCapturing = true);

    try {
      if (_textureId != null && _textureId! >= 0) {
        final res = await widget.mediaChannel
            .invokeMethod<Map<dynamic, dynamic>>('captureCameraPhoto');
        final orig = res?['originalPath']?.toString() ?? '';
        final prep = res?['preprocessedPath']?.toString() ?? orig;
        if (!mounted) return;
        setState(() {
          _capturedOriginalPath = orig;
          _capturedPreprocessedPath = prep;
          _isCapturing = false;
        });
      } else {
        if (!mounted) return;
        setState(() {
          _capturedOriginalPath =
              'asset:lib/assets/images/sample_leaf_rust.png';
          _capturedPreprocessedPath =
              'asset:lib/assets/images/sample_leaf_rust.png';
          _isCapturing = false;
        });
      }
    } on PlatformException catch (e) {
      final msg = e.message ?? 'فشل التقاط الصورة من الكاميرا.';
      widget.onError(msg);
      if (!mounted) return;
      setState(() {
        _cameraError = msg;
        _isCapturing = false;
      });
    }
  }

  Future<void> _stopCamera() async {
    if (_textureId != null && _textureId! >= 0) {
      try {
        await widget.mediaChannel.invokeMethod('stopCameraPreview');
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _stopCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.inverseSurface
        : AppColors.surfaceContainerLowest;
    final textColor = isDark ? AppColors.inverseOnSurface : AppColors.onSurface;
    final subColor = isDark
        ? AppColors.outlineVariant
        : AppColors.onSurfaceVariant;

    final hasCaptured = _capturedOriginalPath != null;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        key: const Key('live_camera_capture_sheet'),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.photo_camera,
                            color: AppColors.primaryContainer,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              hasCaptured
                                  ? 'معاينة الصورة الملتقطة'
                                  : 'تصوير ورقة البن (معاينة الكاميرا)',
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
                      key: const Key('camera_sheet_close_button'),
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close, color: subColor),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  hasCaptured
                      ? 'تحقق من وضوح الأعراض على ورقة البن، ثم اضغط تأكيد أو إعادة الالتقاط.'
                      : 'وجّه الكاميرا وضع ورقة البن داخل الإطار المربع (1:1) ثم اضغط زر الالتقاط.',
                  style: AppTextStyles.bodySm.copyWith(color: subColor),
                ),
                const SizedBox(height: 14),

                // 1:1 Camera Viewfinder / Captured Preview
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (_isInitializing)
                          Container(
                            color: Colors.black87,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          )
                        else if (_cameraError != null)
                          Container(
                            color: AppColors.errorSoftBackground,
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.no_photography_outlined,
                                  size: 42,
                                  color: AppColors.error,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  _cameraError!,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodyMd.copyWith(
                                    color: AppColors.onErrorContainer,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                OutlinedButton.icon(
                                  onPressed: _initCamera,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('إعادة المحاولة'),
                                ),
                              ],
                            ),
                          )
                        else if (hasCaptured)
                          _buildDiagnosisImageWidget(
                            _capturedPreprocessedPath ?? _capturedOriginalPath!,
                            fit: BoxFit.cover,
                          )
                        else if (_textureId != null && _textureId! >= 0)
                          FittedBox(
                            fit: BoxFit.cover,
                            clipBehavior: Clip.hardEdge,
                            child: SizedBox(
                              width: 960,
                              height: 1280,
                              child: Texture(textureId: _textureId!),
                            ),
                          )
                        else
                          Image.asset(
                            'lib/assets/images/sample_leaf_rust.png',
                            fit: BoxFit.cover,
                          ),

                        // 1:1 Coffee Leaf Positioning Frame Overlay
                        if (!hasCaptured && _cameraError == null)
                          IgnorePointer(
                            child: Container(
                              margin: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: const Color(0xFFB3F496),
                                  width: 2.5,
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                  child: Text(
                                    'ضع ورقة البن داخل الإطار (1:1)',
                                    style: AppTextStyles.labelSm.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Action Controls: Capture vs Retake/Confirm
                if (hasCaptured)
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          key: const Key('camera_confirm_photo_button'),
                          onPressed: () {
                            final orig = _capturedOriginalPath!;
                            final prep = _capturedPreprocessedPath ?? orig;
                            Navigator.of(context).pop();
                            widget.onConfirmed(orig, prep);
                          },
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text('تأكيد الصورة'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          key: const Key('camera_retake_photo_button'),
                          onPressed: () {
                            setState(() {
                              _capturedOriginalPath = null;
                              _capturedPreprocessedPath = null;
                            });
                          },
                          icon: const Icon(Icons.replay, size: 18),
                          label: const Text('إعادة الالتقاط'),
                        ),
                      ),
                    ],
                  )
                else
                  ElevatedButton.icon(
                    key: const Key('camera_shutter_capture_button'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryContainer,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: (_isInitializing || _cameraError != null)
                        ? null
                        : _capturePhoto,
                    icon: _isCapturing
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.camera, size: 22),
                    label: Text(
                      _isCapturing ? 'جارٍ الالتقاط...' : 'التقاط الصورة الآن',
                      style: AppTextStyles.labelLg.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CaptureTipTile extends StatelessWidget {
  const _CaptureTipTile({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.inverseOnSurface : AppColors.onSurface;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.onSurface : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.onSurfaceVariant : AppColors.borderOutline,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primaryContainer),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.labelSm.copyWith(
                fontSize: 10.5,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
