import 'package:flutter/material.dart';

import '../../core/localization/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../routes/app_routes.dart';

/// Enum representing the 5 tabs in the authenticated bottom navigation bar.
enum AgriTechNavTab { home, monitoring, diagnosis, farms, account }

/// The 5-tab bottom navigation bar matching the Stitch internal screen designs.
/// Appears ONLY on authenticated internal screens (never on Login, Register,
/// Forgot Password, Settings, or General Settings).
class AgriTechBottomNav extends StatelessWidget {
  const AgriTechBottomNav({super.key, required this.currentTab});

  final AgriTechNavTab currentTab;

  void _onTapTab(BuildContext context, AgriTechNavTab tab) {
    if (tab == currentTab) return;
    final String targetRoute;
    switch (tab) {
      case AgriTechNavTab.home:
        targetRoute = AppRoutes.home;
      case AgriTechNavTab.monitoring:
        targetRoute = AppRoutes.monitoring;
      case AgriTechNavTab.diagnosis:
        targetRoute = AppRoutes.diagnosis;
      case AgriTechNavTab.farms:
        targetRoute = AppRoutes.myFarms;
      case AgriTechNavTab.account:
        targetRoute = AppRoutes.myAccount;
    }
    // Preserve navigation history stack so the Back button can return to the
    // actual previous screen as required.
    Navigator.of(context).pushNamed(targetRoute);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.inverseSurface
        : AppColors.surfaceContainer;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(
            color: isDark
                ? AppColors.onSurfaceVariant
                : AppColors.borderOutline,
            width: 1,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.ambientShadow,
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavStandardItem(
                icon: Icons.yard_outlined,
                label: strings.navHome,
                isSelected: currentTab == AgriTechNavTab.home,
                onTap: () => _onTapTab(context, AgriTechNavTab.home),
              ),
              _NavStandardItem(
                icon: Icons.sensors,
                label: strings.navMonitoring,
                isSelected: currentTab == AgriTechNavTab.monitoring,
                onTap: () => _onTapTab(context, AgriTechNavTab.monitoring),
              ),
              _NavCenterCameraItem(
                label: strings.navDiagnosis,
                isSelected: currentTab == AgriTechNavTab.diagnosis,
                onTap: () => _onTapTab(context, AgriTechNavTab.diagnosis),
              ),
              _NavStandardItem(
                icon: Icons.terrain_outlined,
                label: strings.navMyFarms,
                isSelected: currentTab == AgriTechNavTab.farms,
                onTap: () => _onTapTab(context, AgriTechNavTab.farms),
              ),
              _NavStandardItem(
                icon: Icons.manage_accounts_outlined,
                label: strings.navMyAccount,
                isSelected: currentTab == AgriTechNavTab.account,
                onTap: () => _onTapTab(context, AgriTechNavTab.account),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavStandardItem extends StatelessWidget {
  const _NavStandardItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? AppColors.inversePrimary : AppColors.primary;
    final inactiveColor = isDark
        ? AppColors.outlineVariant
        : AppColors.onSurfaceVariant;
    final color = isSelected ? activeColor : inactiveColor;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 23, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.labelSm.copyWith(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavCenterCameraItem extends StatelessWidget {
  const _NavCenterCameraItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeTextColor = isDark
        ? AppColors.inversePrimary
        : AppColors.primary;
    final inactiveTextColor = isDark
        ? AppColors.outlineVariant
        : AppColors.onSurfaceVariant;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.tertiary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.photo_camera_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.labelSm.copyWith(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? activeTextColor : inactiveTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
