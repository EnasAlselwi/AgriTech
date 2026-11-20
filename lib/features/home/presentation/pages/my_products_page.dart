import 'package:flutter/material.dart';

import '../../../../core/config/app_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../models/agritech_models.dart';
import '../../../../shared/widgets/agritech_bottom_nav.dart';
import '../../../../shared/widgets/agritech_header_banner.dart';

/// Screen 12 (`agritech_5` — My Products Management / `إدارة منتجاتي`).
/// Reproduces `design_reference/stitch_agritech_mobile_auth_redesign/agritech_5/screen.png`
/// and `code.html`.
class MyProductsPage extends StatefulWidget {
  const MyProductsPage({super.key});

  @override
  State<MyProductsPage> createState() => _MyProductsPageState();
}

class _MyProductsPageState extends State<MyProductsPage> {
  String _selectedFilter =
      'الكل'; // 'الكل', 'منشور', 'بانتظار المراجعة', 'مسودة'
  bool _previewEmptyState = false;

  List<ProductModel> _filteredProducts(List<ProductModel> all) {
    if (_previewEmptyState) return const [];
    if (_selectedFilter == 'الكل') return all;
    return all.where((p) => p.status == _selectedFilter).toList();
  }

  Future<void> _showImageLightbox(
    BuildContext context,
    String assetPath,
    String caption,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            backgroundColor: Colors.black.withValues(alpha: 0.92),
            insetPadding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          caption,
                          style: AppTextStyles.labelLg.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
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
                      child: Image.asset(assetPath, fit: BoxFit.contain),
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

  /// Product Details Bottom Sheet matching `agritech_5/code.html` lines 476-591.
  Future<void> _showProductDetailsSheet(
    BuildContext context,
    ProductModel product,
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

    final gallery = product.allImages.isNotEmpty
        ? product.allImages
        : const ['lib/assets/images/product_thumb_harazi.png'];
    int selectedImgIndex = 0;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final currentImage = gallery[selectedImgIndex];
            final maxHeight = MediaQuery.of(sheetContext).size.height * 0.88;

            return Directionality(
              textDirection: TextDirection.rtl,
              child: ConstrainedBox(
                key: const Key('product_details_modal'),
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
                            width: 44,
                            height: 5,
                            decoration: BoxDecoration(
                              color: AppColors.outlineVariant.withValues(
                                alpha: 0.65,
                              ),
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                          const SizedBox(height: 12),
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
                                        color: const Color(0xFFEAF3EA),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.visibility_outlined,
                                        color: AppColors.primaryContainer,
                                        size: 19,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'تفاصيل المنتج الزراعي',
                                            style: AppTextStyles.headlineSm
                                                .copyWith(
                                                  color: textColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                          Text(
                                            'معلومات كاملة ومفصلة عن المحصول وحالته الحالية',
                                            style: AppTextStyles.labelSm
                                                .copyWith(color: subColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                key: const Key(
                                  'product_details_close_icon_button',
                                ),
                                onPressed: () =>
                                    Navigator.of(sheetContext).pop(),
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
                              // 1. Main Image + Zoom + Status Pill
                              ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: SizedBox(
                                  height: 195,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.asset(
                                        currentImage,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        top: 10,
                                        left: 10,
                                        child: InkWell(
                                          onTap: () => _showImageLightbox(
                                            context,
                                            currentImage,
                                            product.name,
                                          ),
                                          child: Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              color: Colors.black.withValues(
                                                alpha: 0.6,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.zoom_in,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        right: 10,
                                        child: _StatusPill(
                                          status: product.status,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Additional Images Thumbnails Strip
                              if (gallery.length > 1)
                                SizedBox(
                                  height: 60,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: gallery.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(width: 8),
                                    itemBuilder: (context, idx) {
                                      final isSel = idx == selectedImgIndex;
                                      return GestureDetector(
                                        onTap: () {
                                          setSheetState(() {
                                            selectedImgIndex = idx;
                                          });
                                        },
                                        child: Container(
                                          width: 64,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: isSel
                                                  ? AppColors.primaryContainer
                                                  : AppColors.outlineVariant,
                                              width: isSel ? 2.2 : 1,
                                            ),
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: Image.asset(
                                            gallery[idx],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              const SizedBox(height: 14),

                              // 2. Title & Category Card
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: cardLowBg,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.outlineVariant.withValues(
                                      alpha: 0.35,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            product.name,
                                            style: AppTextStyles.headlineSm
                                                .copyWith(
                                                  color: textColor,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700,
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
                                            color: AppColors.primaryContainer,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            product.category,
                                            style: AppTextStyles.labelSm
                                                .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      product.description,
                                      style: AppTextStyles.bodySm.copyWith(
                                        color: subColor,
                                        height: 1.55,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),

                              // 3. Key Metrics Grid: Quantity & Price
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: cardLowBg,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: AppColors.outlineVariant
                                              .withValues(alpha: 0.35),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFEAF3EA),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Icon(
                                              Icons.scale_outlined,
                                              color: AppColors.primaryContainer,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'الكمية المتاحة',
                                                  style: AppTextStyles.labelSm
                                                      .copyWith(
                                                        color: subColor,
                                                      ),
                                                ),
                                                Text(
                                                  '${product.quantity.toInt()} ${product.unit}',
                                                  style: AppTextStyles.labelLg
                                                      .copyWith(
                                                        color: textColor,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                ),
                                              ],
                                            ),
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
                                        color: cardLowBg,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: AppColors.outlineVariant
                                              .withValues(alpha: 0.35),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFEAF3EA),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Icon(
                                              Icons.payments_outlined,
                                              color: AppColors.primaryContainer,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'السعر للوحدة',
                                                  style: AppTextStyles.labelSm
                                                      .copyWith(
                                                        color: subColor,
                                                      ),
                                                ),
                                                Text(
                                                  '${product.price.toInt()} ${product.currency} / ${product.unit}',
                                                  style: AppTextStyles.labelLg
                                                      .copyWith(
                                                        color: AppColors
                                                            .primaryContainer,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // 4. Farm & Location Card
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: cardLowBg,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.outlineVariant.withValues(
                                      alpha: 0.35,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEAF3EA),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.agriculture_outlined,
                                            color: AppColors.primaryContainer,
                                            size: 18,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'المزرعة الموردة',
                                                style: AppTextStyles.labelSm
                                                    .copyWith(color: subColor),
                                              ),
                                              Text(
                                                product.farmName,
                                                style: AppTextStyles.labelMd
                                                    .copyWith(
                                                      color: textColor,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(height: 18),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: bgColor,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.location_on_outlined,
                                            color: subColor,
                                            size: 18,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'الموقع الجغرافي',
                                                style: AppTextStyles.labelSm
                                                    .copyWith(color: subColor),
                                              ),
                                              Text(
                                                product.location,
                                                style: AppTextStyles.labelMd
                                                    .copyWith(
                                                      color: textColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(height: 18),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'حالة النشر:',
                                          style: AppTextStyles.labelSm.copyWith(
                                            color: subColor,
                                          ),
                                        ),
                                        _StatusPill(status: product.status),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'تاريخ الإضافة:',
                                          style: AppTextStyles.labelSm.copyWith(
                                            color: subColor,
                                          ),
                                        ),
                                        Text(
                                          product.addedDate,
                                          style: AppTextStyles.labelSm.copyWith(
                                            color: textColor,
                                            fontWeight: FontWeight.w700,
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
                      ),
                    ),

                    const Divider(height: 1),
                    // Sticky Bottom Action Buttons
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(sheetContext).pop();
                                _showProductFormSheet(
                                  context,
                                  existingProduct: product,
                                );
                              },
                              icon: const Icon(Icons.edit_outlined, size: 18),
                              label: const Text('تعديل المنتج'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton(
                              key: const Key('product_details_close_button'),
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
      },
    );
  }

  Future<void> _showReservationsSheet(
    BuildContext context,
    ProductModel product,
  ) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.inverseSurface
        : AppColors.surfaceContainerLowest;
    final textColor = isDark ? AppColors.inverseOnSurface : AppColors.onSurface;
    final subColor = isDark
        ? AppColors.outlineVariant
        : AppColors.onSurfaceVariant;

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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الحجوزات والمشتريات',
                          style: AppTextStyles.headlineSm.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'قائمة طلبات الشراء والحجز الواردة من المشترين',
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
                const Divider(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'المنتج المحدد: ${product.name}',
                          style: AppTextStyles.labelMd.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        '${product.reservations.length} طلبات نشطة',
                        style: AppTextStyles.labelSm.copyWith(
                          color: AppColors.primaryContainer,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (product.reservations.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      'لا توجد حجوزات واردة لهذا المنتج حالياً.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMd.copyWith(color: subColor),
                    ),
                  )
                else
                  for (final res in product.reservations) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.onSurface
                            : AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.outlineVariant.withValues(
                            alpha: 0.4,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                res.buyerName,
                                style: AppTextStyles.labelLg.copyWith(
                                  color: textColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                res.quantityLabel,
                                style: AppTextStyles.labelMd.copyWith(
                                  color: subColor,
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
                              color: res.isConfirmed
                                  ? AppColors.primaryFixed
                                  : AppColors.secondaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              res.status,
                              style: AppTextStyles.labelSm.copyWith(
                                color: res.isConfirmed
                                    ? AppColors.primary
                                    : AppColors.secondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                const SizedBox(height: 6),
                ElevatedButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  child: const Text('إغلاق'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showProductFormSheet(
    BuildContext context, {
    ProductModel? existingProduct,
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

    final nameCtrl = TextEditingController(text: existingProduct?.name ?? '');
    final descCtrl = TextEditingController(
      text: existingProduct?.description ?? '',
    );
    final qtyCtrl = TextEditingController(
      text: existingProduct != null
          ? existingProduct.quantity.toInt().toString()
          : '80',
    );
    final priceCtrl = TextEditingController(
      text: existingProduct != null
          ? existingProduct.price.toInt().toString()
          : '50',
    );
    final locCtrl = TextEditingController(
      text: existingProduct?.location ?? 'مناخة، صنعاء، اليمن',
    );

    String selectedCategory = existingProduct?.category ?? 'بن مختص';
    String selectedUnit = existingProduct?.unit ?? 'كجم';
    String selectedCurrency = existingProduct?.currency ?? '\$';
    String selectedStatus = existingProduct?.status ?? 'منشور';
    String selectedFarm =
        existingProduct?.farmName ??
        (appState.farms.isNotEmpty
            ? appState.farms.first.name
            : 'مزرعة البن الرئيسية');

    final categories = [
      'بن أخضر مجفف',
      'بن محمص',
      'بن مختص',
      'حبوب نيئة',
      'بن مطحون',
    ];
    final units = ['كجم', 'طن', 'كيس 60 كجم', 'صندوق', 'قطعة'];

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
                                existingProduct == null
                                    ? 'إضافة منتج جديد'
                                    : 'تعديل بيانات المنتج',
                                style: AppTextStyles.headlineSm.copyWith(
                                  color: textColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'أدخل تفاصيل المحصول أو المنتج لعرضه في المنصة',
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
                      const Divider(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.onSurface
                              : AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.primaryContainer.withValues(
                              alpha: 0.4,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.add_photo_alternate_outlined,
                              color: AppColors.primaryContainer,
                              size: 26,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'صورة المنتج (معرض الصور)',
                                    style: AppTextStyles.labelMd.copyWith(
                                      color: textColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    'اضغط لاختيار صورة من الاستوديو (PNG, JPG)',
                                    style: AppTextStyles.labelSm.copyWith(
                                      color: subColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'اسم المنتج *',
                        style: AppTextStyles.labelMd.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(
                          hintText: 'مثال: بن حرازي مجفف طبيعي',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'صنف المنتج أو نوع المحصول *',
                        style: AppTextStyles.labelMd.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: categories.map((cat) {
                          final sel = selectedCategory == cat;
                          return ChoiceChip(
                            label: Text(cat),
                            selected: sel,
                            selectedColor: AppColors.primaryContainer
                                .withValues(alpha: 0.16),
                            labelStyle: AppTextStyles.labelSm.copyWith(
                              color: sel
                                  ? AppColors.primaryContainer
                                  : textColor,
                              fontWeight: sel
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                            onSelected: (_) {
                              setSheetState(() => selectedCategory = cat);
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'الكمية المتوفرة *',
                                  style: AppTextStyles.labelMd.copyWith(
                                    color: textColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: qtyCtrl,
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'السعر لكل وحدة *',
                                  style: AppTextStyles.labelMd.copyWith(
                                    color: textColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: priceCtrl,
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: units.map((u) {
                          final sel = selectedUnit == u;
                          return ChoiceChip(
                            label: Text(u),
                            selected: sel,
                            onSelected: (_) {
                              setSheetState(() => selectedUnit = u);
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'العملة:',
                            style: AppTextStyles.labelMd.copyWith(
                              color: textColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 10),
                          ChoiceChip(
                            label: const Text('دولار (\$)'),
                            selected: selectedCurrency == '\$',
                            onSelected: (_) {
                              setSheetState(() => selectedCurrency = '\$');
                            },
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text('ريال يمني (YER)'),
                            selected: selectedCurrency == 'ر.ي',
                            onSelected: (_) {
                              setSheetState(() => selectedCurrency = 'ر.ي');
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'وصف المنتج',
                        style: AppTextStyles.labelMd.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: descCtrl,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText: 'اكتب وصفاً موجزاً عن درجة الجودة والتحميص',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ChoiceChip(
                              label: const Text('نشر المنتج مباشرة'),
                              selected: selectedStatus == 'منشور',
                              onSelected: (_) {
                                setSheetState(() => selectedStatus = 'منشور');
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ChoiceChip(
                              label: const Text('حفظ كمسودة'),
                              selected: selectedStatus == 'مسودة',
                              onSelected: (_) {
                                setSheetState(() => selectedStatus = 'مسودة');
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                final name = nameCtrl.text.trim();
                                if (name.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('يرجى إدخال اسم المنتج'),
                                    ),
                                  );
                                  return;
                                }
                                final model = ProductModel(
                                  id:
                                      existingProduct?.id ??
                                      'prod_${DateTime.now().millisecondsSinceEpoch}',
                                  name: name,
                                  category: selectedCategory,
                                  originBadge:
                                      existingProduct?.originBadge ??
                                      'يمني أصيل',
                                  description: descCtrl.text.trim().isEmpty
                                      ? 'محصول بن يمني مختار بعناية من المدرجات الجبلية.'
                                      : descCtrl.text.trim(),
                                  quantity:
                                      double.tryParse(qtyCtrl.text.trim()) ??
                                      50,
                                  unit: selectedUnit,
                                  price:
                                      double.tryParse(priceCtrl.text.trim()) ??
                                      45,
                                  currency: selectedCurrency,
                                  farmName: selectedFarm,
                                  location: locCtrl.text.trim(),
                                  addedDate:
                                      existingProduct?.addedDate ?? 'اليوم',
                                  status: selectedStatus,
                                  imageAsset:
                                      existingProduct?.imageAsset ??
                                      'lib/assets/images/product_thumb_harazi.png',
                                  galleryAssets:
                                      existingProduct?.galleryAssets ??
                                      const [
                                        'lib/assets/images/product_thumb_harazi.png',
                                        'lib/assets/images/product_thumb_yafei.png',
                                      ],
                                  reservations:
                                      existingProduct?.reservations ?? const [],
                                );
                                if (existingProduct == null) {
                                  appState.addProduct(model);
                                } else {
                                  appState.updateProduct(model.id, model);
                                }
                                Navigator.of(sheetContext).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      existingProduct == null
                                          ? 'تم حفظ المنتج بنجاح'
                                          : 'تم تحديث بيانات المنتج بنجاح',
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.check_circle_outline),
                              label: Text(
                                existingProduct == null
                                    ? 'حفظ المنتج'
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

    final allProducts = appState.products;
    final publishedCount = allProducts.where((p) => p.status == 'منشور').length;
    final reviewCount = allProducts
        .where((p) => p.status == 'بانتظار المراجعة')
        .length;
    final draftCount = allProducts.where((p) => p.status == 'مسودة').length;
    final totalReservations = allProducts.fold<int>(
      0,
      (sum, p) => sum + p.reservations.length,
    );
    final visibleProducts = _filteredProducts(allProducts);

    final filterTabs = [
      ('الكل', allProducts.length),
      ('منشور', publishedCount),
      ('بانتظار المراجعة', reviewCount),
      ('مسودة', draftCount),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        body: Column(
          children: [
            const AgriTechInternalHeader(
              title: 'إدارة منتجاتي',
              subtitle:
                  'أضف منتجاتك وتابع المنتجات المنشورة والطلبات والحجوزات.',
              showBackButton: true,
            ),
            AgriTechWhiteSheetContainer(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Product Stats Card (`إحصائيات المنتجات`)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: AppColors.outlineVariant.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'إحصائيات المنتجات',
                              style: AppTextStyles.labelLg.copyWith(
                                color: textColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryFixed,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'محدّث تلقائيًا',
                                style: AppTextStyles.labelSm.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: _ProductStatBox(
                                value: '${allProducts.length}',
                                label: 'إجمالي المنتجات',
                                isDark: isDark,
                                textColor: textColor,
                                subColor: subColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _ProductStatBox(
                                value: '$publishedCount',
                                label: 'المنتجات المنشورة',
                                isDark: isDark,
                                textColor: AppColors.primaryContainer,
                                subColor: subColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _ProductStatBox(
                                value: '$totalReservations',
                                label: 'الطلبات الجديدة',
                                isDark: isDark,
                                textColor: AppColors.secondary,
                                subColor: subColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 2. Primary CTA Button: `إضافة منتج جديد`
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryContainer,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () => _showProductFormSheet(context),
                    icon: const Icon(Icons.add_box_outlined, size: 22),
                    label: Text(
                      'إضافة منتج جديد',
                      style: AppTextStyles.labelLg.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // 3. Section Header Row: `منتجاتي` + count badge + `معاينة الحالة الفارغة`
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'منتجاتي',
                            style: AppTextStyles.headlineSm.copyWith(
                              color: textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer.withValues(
                                alpha: 0.12,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${allProducts.length} منتجات',
                              style: AppTextStyles.labelSm.copyWith(
                                color: AppColors.primaryContainer,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _previewEmptyState = !_previewEmptyState;
                          });
                        },
                        child: Text(
                          _previewEmptyState
                              ? 'العودة إلى قائمة المنتجات'
                              : 'معاينة الحالة الفارغة',
                          style: AppTextStyles.labelSm.copyWith(
                            color: AppColors.primaryContainer,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // 4. Filter Chips (`الكل (3)`, `منشور (2)`, `بانتظار المراجعة (1)`, `مسودة (0)`)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: filterTabs.map((tab) {
                        final isSelected = _selectedFilter == tab.$1;
                        return Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              setState(() {
                                _selectedFilter = tab.$1;
                                _previewEmptyState = false;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryContainer
                                    : cardBg,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primaryContainer
                                      : AppColors.outlineVariant.withValues(
                                          alpha: 0.5,
                                        ),
                                ),
                              ),
                              child: Text(
                                '${tab.$1} (${tab.$2})',
                                style: AppTextStyles.labelMd.copyWith(
                                  color: isSelected ? Colors.white : textColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 5. Products List or Empty State
                  if (visibleProducts.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.outlineVariant.withValues(
                            alpha: 0.4,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer.withValues(
                                alpha: 0.1,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.inventory_2_outlined,
                              color: AppColors.primaryContainer,
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'لا توجد منتجات مضافة حالياً',
                            style: AppTextStyles.headlineSm.copyWith(
                              color: textColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'ابدأ بإضافة منتجات مزرعتك من البن والمحاصيل لعرضها ومتابعة الطلبات والحجوزات الواردة عليها.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMd.copyWith(
                              color: subColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => _showProductFormSheet(context),
                            icon: const Icon(Icons.add),
                            label: const Text('إضافة أول منتج'),
                          ),
                        ],
                      ),
                    )
                  else
                    for (final prod in visibleProducts) ...[
                      _ProductCard(
                        product: prod,
                        cardBg: cardBg,
                        textColor: textColor,
                        subColor: subColor,
                        isDark: isDark,
                        onDetails: () =>
                            _showProductDetailsSheet(context, prod),
                        onEdit: () => _showProductFormSheet(
                          context,
                          existingProduct: prod,
                        ),
                        onReservations: () =>
                            _showReservationsSheet(context, prod),
                      ),
                      const SizedBox(height: 14),
                    ],
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: const AgriTechBottomNav(
          currentTab: AgriTechNavTab.home,
        ),
      ),
    );
  }
}

class _ProductStatBox extends StatelessWidget {
  const _ProductStatBox({
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
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
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
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final isPublished = status == 'منشور';
    final isPending = status == 'بانتظار المراجعة';

    final bg = isPublished
        ? AppColors.primaryFixed
        : (isPending
              ? AppColors.secondaryContainer
              : AppColors.surfaceContainerHigh);
    final fg = isPublished
        ? AppColors.primary
        : (isPending ? AppColors.secondary : AppColors.onSurfaceVariant);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: AppTextStyles.labelSm.copyWith(
          color: fg,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.cardBg,
    required this.textColor,
    required this.subColor,
    required this.isDark,
    required this.onDetails,
    required this.onEdit,
    required this.onReservations,
  });

  final ProductModel product;
  final Color cardBg;
  final Color textColor;
  final Color subColor;
  final bool isDark;
  final VoidCallback onDetails;
  final VoidCallback onEdit;
  final VoidCallback onReservations;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
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
              // Right Thumbnail with Origin Badge (`حرازي` / `مطري` / `يافعي`)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: SizedBox(
                      width: 82,
                      height: 82,
                      child: product.imageAsset != null
                          ? Image.asset(product.imageAsset!, fit: BoxFit.cover)
                          : Container(
                              color: isDark
                                  ? AppColors.onSurface
                                  : AppColors.surfaceContainerHigh,
                              child: const Icon(
                                Icons.coffee_outlined,
                                color: AppColors.primaryContainer,
                                size: 32,
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        product.originBadge,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.labelSm.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),

              // Center/Left Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: AppTextStyles.labelLg.copyWith(
                              color: textColor,
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        _StatusPill(status: product.status),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.labelSm.copyWith(color: subColor),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
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
                          Text(
                            'الكمية: ${product.quantity.toInt()} ${product.unit}',
                            style: AppTextStyles.labelSm.copyWith(
                              color: textColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'السعر: ${product.price.toInt()} ${product.currency} / ${product.unit}',
                            style: AppTextStyles.labelSm.copyWith(
                              color: AppColors.primaryContainer,
                              fontWeight: FontWeight.w700,
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
          const SizedBox(height: 12),

          // Action Row: `عرض التفاصيل ←` | `تعديل` | `الحجوزات (X)`
          Row(
            children: [
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  key: Key('product_view_details_${product.id}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(38),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: onDetails,
                  child: Text(
                    'عرض التفاصيل ←',
                    style: AppTextStyles.labelSm.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: textColor,
                    minimumSize: const Size.fromHeight(38),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    side: BorderSide(
                      color: AppColors.outlineVariant.withValues(alpha: 0.6),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: onEdit,
                  child: Text(
                    'تعديل',
                    style: AppTextStyles.labelSm.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryContainer,
                    minimumSize: const Size.fromHeight(38),
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    side: BorderSide(
                      color: AppColors.primaryContainer.withValues(alpha: 0.45),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: onReservations,
                  icon: const Icon(Icons.bookmark_border, size: 15),
                  label: Text(
                    'الحجوزات (${product.reservations.length})',
                    style: AppTextStyles.labelSm.copyWith(
                      color: AppColors.primaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
