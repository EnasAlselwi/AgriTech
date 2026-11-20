import 'package:flutter/material.dart';

import '../../../../core/config/app_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/dialogs/agritech_modals.dart';
import '../../../../shared/widgets/agritech_bottom_nav.dart';
import '../../../../shared/widgets/agritech_header_banner.dart';

/// Screen 13 (`agritech_13` — My Account / `حسابي`).
/// Reproduces `design_reference/stitch_agritech_mobile_auth_redesign/agritech_13/screen.png`
/// and `code.html`.
class MyAccountPage extends StatelessWidget {
  const MyAccountPage({super.key});

  Future<void> _showEditProfileSheet(BuildContext context) async {
    final appState = AppStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.inverseSurface
        : AppColors.surfaceContainerLowest;
    final textColor = isDark ? AppColors.inverseOnSurface : AppColors.onSurface;
    final subColor = isDark
        ? AppColors.outlineVariant
        : AppColors.onSurfaceVariant;

    final nameCtrl = TextEditingController(text: appState.userFullName);
    final emailCtrl = TextEditingController(text: appState.userEmail);
    final phoneCtrl = TextEditingController(text: appState.userPhone);
    String selectedGov = appState.userGovernorate;
    String selectedDist = appState.userDistrict;

    final governorates = ['صنعاء', 'إب', 'ذمار', 'تعز', 'الحديدة'];
    final districts = [
      'مديرية بني حشيش',
      'مديرية مناخة',
      'مديرية بني مطر',
      'مديرية حراز',
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
                          Text(
                            'تعديل الملف الشخصي',
                            style: AppTextStyles.headlineSm.copyWith(
                              color: textColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(sheetContext).pop(),
                            icon: Icon(Icons.close, color: subColor),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Text(
                        'الاسم الكامل',
                        style: AppTextStyles.labelMd.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'البريد الإلكتروني',
                        style: AppTextStyles.labelMd.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: TextField(
                          controller: emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.mail_outline),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'رقم الهاتف',
                        style: AppTextStyles.labelMd.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: TextField(
                          controller: phoneCtrl,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.phone_outlined),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'المحافظة',
                        style: AppTextStyles.labelMd.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: governorates.map((gov) {
                          final sel = selectedGov == gov;
                          return ChoiceChip(
                            label: Text(gov),
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
                              setSheetState(() => selectedGov = gov);
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'المديرية',
                        style: AppTextStyles.labelMd.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: districts.map((dist) {
                          final sel = selectedDist == dist;
                          return ChoiceChip(
                            label: Text(dist),
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
                              setSheetState(() => selectedDist = dist);
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                appState.updateProfile(
                                  fullName: nameCtrl.text.trim().isEmpty
                                      ? appState.userFullName
                                      : nameCtrl.text.trim(),
                                  email: emailCtrl.text.trim().isEmpty
                                      ? appState.userEmail
                                      : emailCtrl.text.trim(),
                                  phone: phoneCtrl.text.trim().isEmpty
                                      ? appState.userPhone
                                      : phoneCtrl.text.trim(),
                                  governorate: selectedGov,
                                  district: selectedDist,
                                );
                                Navigator.of(sheetContext).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'تم حفظ تعديلات الملف الشخصي بنجاح',
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.check, size: 18),
                              label: const Text('حفظ التعديلات'),
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
    final cardBg = isDark
        ? AppColors.inverseSurface
        : AppColors.surfaceContainerLowest;
    final textColor = isDark ? AppColors.inverseOnSurface : AppColors.onSurface;
    final subColor = isDark
        ? AppColors.outlineVariant
        : AppColors.onSurfaceVariant;

    final totalSensors = appState.farms.fold<int>(
      0,
      (sum, f) => sum + f.connectedSensors,
    );

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.onSurface
          : AppColors.authBannerBackground,
      body: Column(
        children: [
          const AgriTechInternalHeader(
            title: 'حسابي',
            subtitle: 'إدارة بياناتك ومعلومات حسابك الزراعي',
            showBackButton: true,
          ),
          AgriTechWhiteSheetContainer(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Profile Hero Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.35),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Circular Avatar with Verified Badge
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 82,
                            height: 82,
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer.withValues(
                                alpha: 0.12,
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primaryContainer.withValues(
                                  alpha: 0.35,
                                ),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              size: 42,
                              color: AppColors.primaryContainer,
                            ),
                          ),
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer,
                                shape: BoxShape.circle,
                                border: Border.all(color: cardBg, width: 2),
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        appState.userFullName,
                        style: AppTextStyles.headlineSm.copyWith(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          appState.userEmail,
                          style: AppTextStyles.bodyMd.copyWith(color: subColor),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 3 Stat Tiles (`3 المزارع`, `12.5 هكتار المساحة`, `18 الحساسات`)
                      Row(
                        children: [
                          Expanded(
                            child: _AccountStatTile(
                              value: '${appState.farms.length}',
                              label: 'المزارع',
                              isDark: isDark,
                              textColor: textColor,
                              subColor: subColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _AccountStatTile(
                              value: '12.5 هكتار',
                              label: 'المساحة',
                              isDark: isDark,
                              textColor: AppColors.primaryContainer,
                              subColor: subColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _AccountStatTile(
                              value: '$totalSensors',
                              label: 'الحساسات',
                              isDark: isDark,
                              textColor: textColor,
                              subColor: subColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // `تعديل الملف الشخصي` Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryContainer,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () => _showEditProfileSheet(context),
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          label: Text(
                            'تعديل الملف الشخصي',
                            style: AppTextStyles.labelLg.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 2. Account Data Card (`بيانات الحساب`)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.35),
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
                              const Icon(
                                Icons.badge_outlined,
                                color: AppColors.primaryContainer,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'بيانات الحساب',
                                style: AppTextStyles.headlineSm.copyWith(
                                  color: textColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          TextButton.icon(
                            onPressed: () => Navigator.of(
                              context,
                            ).pushNamed(AppRoutes.settings),
                            icon: const Icon(
                              Icons.settings_outlined,
                              size: 16,
                              color: AppColors.primaryContainer,
                            ),
                            label: Text(
                              'الإعدادات',
                              style: AppTextStyles.labelSm.copyWith(
                                color: AppColors.primaryContainer,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      _AccountDataRow(
                        icon: Icons.person_outline,
                        label: 'الاسم الكامل',
                        value: appState.userFullName,
                        textColor: textColor,
                        subColor: subColor,
                      ),
                      const Divider(height: 20),
                      _AccountDataRow(
                        icon: Icons.mail_outline,
                        label: 'البريد الإلكتروني',
                        value: appState.userEmail,
                        isLtr: true,
                        textColor: textColor,
                        subColor: subColor,
                      ),
                      const Divider(height: 20),
                      _AccountDataRow(
                        icon: Icons.phone_outlined,
                        label: 'رقم الهاتف',
                        value: appState.userPhone,
                        isLtr: true,
                        textColor: textColor,
                        subColor: subColor,
                      ),
                      const Divider(height: 20),
                      Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.verified_user_outlined,
                              color: AppColors.primaryContainer,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'صفة الحساب',
                                  style: AppTextStyles.labelSm.copyWith(
                                    color: subColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryFixed,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '● ${appState.userRole}',
                                    style: AppTextStyles.labelSm.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      _AccountDataRow(
                        icon: Icons.location_on_outlined,
                        label: 'موقع المزارع',
                        value:
                            'محافظة ${appState.userGovernorate}، ${appState.userDistrict}',
                        textColor: textColor,
                        subColor: subColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // 3. Soft Red Logout Button (`تسجيل الخروج`)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.errorSoftBackground,
                    foregroundColor: const Color(0xFFB91C1C),
                    elevation: 0,
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: const Color(0xFFB91C1C).withValues(alpha: 0.25),
                      ),
                    ),
                  ),
                  onPressed: () => showAgriTechLogoutDialog(context),
                  icon: const Icon(Icons.logout, size: 20),
                  label: Text(
                    'تسجيل الخروج',
                    style: AppTextStyles.labelLg.copyWith(
                      color: const Color(0xFFB91C1C),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AgriTechBottomNav(
        currentTab: AgriTechNavTab.account,
      ),
    );
  }
}

class _AccountStatTile extends StatelessWidget {
  const _AccountStatTile({
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
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.onSurface : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.labelLg.copyWith(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
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

class _AccountDataRow extends StatelessWidget {
  const _AccountDataRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.textColor,
    required this.subColor,
    this.isLtr = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color textColor;
  final Color subColor;
  final bool isLtr;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.primaryContainer.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primaryContainer, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.labelSm.copyWith(color: subColor),
              ),
              const SizedBox(height: 2),
              isLtr
                  ? Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        value,
                        style: AppTextStyles.labelLg.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : Text(
                      value,
                      style: AppTextStyles.labelLg.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
