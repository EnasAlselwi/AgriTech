import 'package:flutter/material.dart';

import '../../core/config/app_state.dart';
import '../../core/localization/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../routes/app_routes.dart';

/// Shows the Logout confirmation dialog from `agritech_13` & `agritech_1`.
Future<void> showAgriTechLogoutDialog(BuildContext context) async {
  final strings = AppStrings.of(context);
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final cardBg = isDark
      ? AppColors.inverseSurface
      : AppColors.surfaceContainerLowest;
  final textColor = isDark ? AppColors.inverseOnSurface : AppColors.onSurface;
  final subColor = isDark
      ? AppColors.outlineVariant
      : AppColors.onSurfaceVariant;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return Directionality(
        textDirection: strings.textDirection,
        child: Dialog(
          backgroundColor: cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: AppColors.errorSoftBackground,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout,
                    color: Color(0xFFB91C1C),
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  strings.logoutTitle,
                  style: AppTextStyles.headlineMd.copyWith(
                    fontSize: 20,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  strings.logoutConfirmQuestion,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMd.copyWith(color: subColor),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: textColor,
                          minimumSize: const Size.fromHeight(46),
                          side: BorderSide(
                            color: isDark
                                ? AppColors.onSurfaceVariant
                                : AppColors.outlineVariant,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: Text(
                          strings.cancelLabel,
                          style: AppTextStyles.labelMd.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB91C1C),
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            AppRoutes.login,
                            (route) => false,
                          );
                        },
                        icon: const Icon(Icons.check, size: 18),
                        label: Text(
                          strings.logoutConfirmButton,
                          style: AppTextStyles.labelMd.copyWith(
                            color: Colors.white,
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
        ),
      );
    },
  );
}

/// Shows the User Guide (`دليل المستخدم` / `User Guide`) modal from
/// `agritech_1/code.html` and `agritech_15/code.html`.
Future<void> showAgriTechUserGuideSheet(BuildContext context) async {
  final strings = AppStrings.of(context);
  await _showPolicyOrGuideModal(
    context,
    keyPrefix: 'user_guide_modal',
    title: strings.userGuideTitle,
    icon: Icons.menu_book_outlined,
    sections: strings.userGuideSections,
    confirmLabel: strings.understoodLabel,
  );
}

/// Shows the Privacy Policy (`سياسة الخصوصية` / `Privacy Policy`) modal
/// matching `agritech_1/code.html` (line 351) and `agritech_15/code.html`.
Future<void> showAgriTechPrivacyModal(BuildContext context) async {
  final strings = AppStrings.of(context);
  await _showPolicyOrGuideModal(
    context,
    keyPrefix: 'privacy_policy_modal',
    title: strings.privacyPolicyTitle,
    icon: Icons.policy_outlined,
    sections: strings.privacySections,
    confirmLabel: strings.understoodLabel,
  );
}

/// Shows the Terms of Use (`شروط الاستخدام` / `Terms of Use`) modal
/// matching `agritech_1/code.html` (line 353) and `agritech_15/code.html`.
Future<void> showAgriTechTermsModal(BuildContext context) async {
  final strings = AppStrings.of(context);
  await _showPolicyOrGuideModal(
    context,
    keyPrefix: 'terms_of_use_modal',
    title: strings.termsOfUseTitle,
    icon: Icons.gavel_outlined,
    sections: strings.termsSections,
    confirmLabel: strings.understoodLabel,
  );
}

Future<void> _showPolicyOrGuideModal(
  BuildContext context, {
  required String keyPrefix,
  required String title,
  required IconData icon,
  required List<(String, String)> sections,
  required String confirmLabel,
}) async {
  final strings = AppStrings.of(context);
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final bgColor = isDark
      ? AppColors.inverseSurface
      : AppColors.surfaceContainerLowest;
  final textColor = isDark ? AppColors.inverseOnSurface : AppColors.onSurface;
  final subColor = isDark
      ? AppColors.outlineVariant
      : AppColors.onSurfaceVariant;
  final sectionBg = isDark
      ? AppColors.onSurface
      : AppColors.surfaceContainerLow;
  final headingColor = isDark ? AppColors.inversePrimary : AppColors.primary;

  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      final maxHeight = MediaQuery.of(dialogContext).size.height * 0.82;
      return Directionality(
        textDirection: strings.textDirection,
        child: Dialog(
          key: Key(keyPrefix),
          backgroundColor: bgColor,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: AppColors.outlineVariant.withValues(alpha: 0.35),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight, maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Row
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.onSurface
                                    : AppColors.surfaceContainer,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(icon, color: headingColor, size: 19),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                title,
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
                        key: Key('${keyPrefix}_close_button'),
                        tooltip: strings.closeLabel,
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        icon: Icon(Icons.close, color: subColor, size: 20),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  color: isDark
                      ? AppColors.onSurfaceVariant.withValues(alpha: 0.4)
                      : AppColors.surfaceContainer,
                ),

                // Internally Scrollable Sections
                Flexible(
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (var i = 0; i < sections.length; i++) ...[
                            Container(
                              padding: const EdgeInsets.all(13),
                              decoration: BoxDecoration(
                                color: sectionBg,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: headingColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          sections[i].$1,
                                          style: AppTextStyles.labelMd.copyWith(
                                            color: headingColor,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    sections[i].$2,
                                    style: AppTextStyles.bodySm.copyWith(
                                      color: subColor,
                                      height: 1.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (i < sections.length - 1)
                              const SizedBox(height: 12),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                Divider(
                  height: 1,
                  color: isDark
                      ? AppColors.onSurfaceVariant.withValues(alpha: 0.4)
                      : AppColors.surfaceContainer,
                ),
                // Confirmation Footer Button ("فهمت" / "Understood")
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                  child: ElevatedButton(
                    key: Key('${keyPrefix}_confirm_button'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(46),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: Text(
                      confirmLabel,
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
        ),
      );
    },
  );
}

/// Shows the functional Support & Privacy Team modal (`فريق الدعم والخصوصية`)
/// matching `agritech_1/code.html` (lines 434-509) and `agritech_15/code.html`.
Future<void> showAgriTechSupportSheet(BuildContext context) async {
  final appState = AppStateScope.maybeOf(context);
  final strings = AppStrings.of(context);
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final bgColor = isDark
      ? AppColors.inverseSurface
      : AppColors.surfaceContainerLowest;
  final textColor = isDark ? AppColors.inverseOnSurface : AppColors.onSurface;
  final subColor = isDark
      ? AppColors.outlineVariant
      : AppColors.onSurfaceVariant;
  final fieldBg = isDark ? AppColors.onSurface : AppColors.surfaceContainerLow;
  final headingColor = isDark ? AppColors.inversePrimary : AppColors.primary;

  final titleController = TextEditingController();
  final detailsController = TextEditingController();
  String? selectedRequestType;
  String selectedContactMethod = 'email'; // 'email' | 'phone'
  String? validationErrorBanner;
  String? typeFieldError;
  String? titleFieldError;
  String? detailsFieldError;
  String? contactFieldError;
  bool submittedLocally = false;

  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          final viewInsets = MediaQuery.of(dialogContext).viewInsets;
          final maxHeight = MediaQuery.of(dialogContext).size.height * 0.86;

          void handleSubmit() {
            final reqTitle = titleController.text.trim();
            final reqDetails = detailsController.text.trim();
            final registeredEmail =
                appState?.userEmail.trim() ?? 'user@agritech.ye';
            final registeredPhone =
                appState?.userPhone.trim() ?? '+967 77X XXX XXX';

            final isTypeMissing =
                selectedRequestType == null || selectedRequestType!.isEmpty;
            final isTitleMissing = reqTitle.isEmpty;
            final isDetailsMissing = reqDetails.isEmpty;
            final isContactValid = selectedContactMethod == 'email'
                ? (registeredEmail.isNotEmpty && registeredEmail.contains('@'))
                : (registeredPhone.isNotEmpty && registeredPhone.length >= 7);

            setModalState(() {
              typeFieldError = isTypeMissing
                  ? strings.supportValidationTypeRequired
                  : null;
              titleFieldError = isTitleMissing
                  ? strings.supportValidationTitleRequired
                  : null;
              detailsFieldError = isDetailsMissing
                  ? strings.supportValidationDetailsRequired
                  : null;
              contactFieldError = !isContactValid
                  ? strings.supportValidationContactInvalid
                  : null;

              if (isTypeMissing ||
                  isTitleMissing ||
                  isDetailsMissing ||
                  !isContactValid) {
                validationErrorBanner = strings.supportValidationAllRequired;
                submittedLocally = false;
                return;
              }

              validationErrorBanner = null;
              submittedLocally = true;
            });

            if (!submittedLocally) return;

            appState?.submitLocalSupportRequest(
              requestType: selectedRequestType!,
              title: reqTitle,
              description: reqDetails,
              contactMethod: selectedContactMethod,
              contactValue: selectedContactMethod == 'email'
                  ? registeredEmail
                  : registeredPhone,
            );

            titleController.clear();
            detailsController.clear();
            setModalState(() {
              selectedRequestType = null;
            });
          }

          return Directionality(
            textDirection: strings.textDirection,
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 150),
              padding: EdgeInsets.only(bottom: viewInsets.bottom),
              child: Dialog(
                key: const Key('support_modal'),
                backgroundColor: bgColor,
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: AppColors.outlineVariant.withValues(alpha: 0.35),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: maxHeight,
                    maxWidth: 420,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Modal Header
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.onSurface
                                          : AppColors.surfaceContainer,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.support_agent,
                                      color: headingColor,
                                      size: 19,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      strings.supportTeamTitle,
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
                              key: const Key('support_modal_close_button'),
                              tooltip: strings.closeLabel,
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(),
                              icon: Icon(
                                Icons.close,
                                color: subColor,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: isDark
                            ? AppColors.onSurfaceVariant.withValues(alpha: 0.4)
                            : AppColors.surfaceContainer,
                      ),

                      // Scrollable Form Content
                      Flexible(
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  strings.supportIntroText,
                                  style: AppTextStyles.bodySm.copyWith(
                                    color: textColor,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Local Submission Confirmation Banner
                                if (submittedLocally) ...[
                                  Container(
                                    key: const Key(
                                      'support_local_success_banner',
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F5E9),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFFA7E78B),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.check_circle,
                                          color: AppColors.primaryContainer,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            strings
                                                .supportLocalConfirmationBanner,
                                            style: AppTextStyles.labelMd
                                                .copyWith(
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                ],

                                // Validation Error Banner
                                if (validationErrorBanner != null) ...[
                                  Container(
                                    key: const Key('support_error_banner'),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.errorContainer,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.error_outline,
                                          color: AppColors.error,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            validationErrorBanner!,
                                            style: AppTextStyles.labelMd
                                                .copyWith(
                                                  color: AppColors
                                                      .onErrorContainer,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                ],

                                // Field 1: Request Type Dropdown
                                Text(
                                  strings.supportRequestTypeLabel,
                                  style: AppTextStyles.labelMd.copyWith(
                                    color: textColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  key: const Key('support_type_dropdown'),
                                  value: selectedRequestType,
                                  isExpanded: true,
                                  dropdownColor: bgColor,
                                  style: AppTextStyles.bodySm.copyWith(
                                    color: textColor,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: fieldBg,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 11,
                                    ),
                                    errorText: typeFieldError,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppColors.outlineVariant
                                            .withValues(alpha: 0.6),
                                      ),
                                    ),
                                  ),
                                  hint: Text(
                                    strings.supportRequestTypePlaceholder,
                                    style: AppTextStyles.bodySm.copyWith(
                                      color: subColor,
                                    ),
                                  ),
                                  items: strings.supportRequestTypeOptions
                                      .map(
                                        (opt) => DropdownMenuItem<String>(
                                          value: opt.$1,
                                          child: Text(
                                            opt.$2,
                                            style: AppTextStyles.bodySm
                                                .copyWith(color: textColor),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (val) {
                                    setModalState(() {
                                      selectedRequestType = val;
                                      typeFieldError = null;
                                      submittedLocally = false;
                                    });
                                  },
                                ),
                                const SizedBox(height: 12),

                                // Field 2: Request Title
                                Text(
                                  strings.supportTitleLabel,
                                  style: AppTextStyles.labelMd.copyWith(
                                    color: textColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextField(
                                  key: const Key('support_title_field'),
                                  controller: titleController,
                                  onChanged: (_) {
                                    if (titleFieldError != null) {
                                      setModalState(
                                        () => titleFieldError = null,
                                      );
                                    }
                                  },
                                  style: AppTextStyles.bodySm.copyWith(
                                    color: textColor,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: fieldBg,
                                    hintText: strings.supportTitleHint,
                                    errorText: titleFieldError,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 11,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Field 3: Detailed Description
                                Text(
                                  strings.supportDetailsLabel,
                                  style: AppTextStyles.labelMd.copyWith(
                                    color: textColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextField(
                                  key: const Key('support_details_field'),
                                  controller: detailsController,
                                  maxLines: 3,
                                  onChanged: (_) {
                                    if (detailsFieldError != null) {
                                      setModalState(
                                        () => detailsFieldError = null,
                                      );
                                    }
                                  },
                                  style: AppTextStyles.bodySm.copyWith(
                                    color: textColor,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: fieldBg,
                                    hintText: strings.supportDetailsHint,
                                    errorText: detailsFieldError,
                                    contentPadding: const EdgeInsets.all(12),
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Field 4: Preferred Contact Method
                                Text(
                                  strings.supportContactMethodLabel,
                                  style: AppTextStyles.labelMd.copyWith(
                                    color: textColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        key: const Key('support_contact_email'),
                                        borderRadius: BorderRadius.circular(10),
                                        onTap: () {
                                          setModalState(() {
                                            selectedContactMethod = 'email';
                                            contactFieldError = null;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                selectedContactMethod == 'email'
                                                    ? Icons.radio_button_checked
                                                    : Icons.radio_button_off,
                                                size: 19,
                                                color:
                                                    selectedContactMethod ==
                                                        'email'
                                                    ? AppColors.primaryContainer
                                                    : subColor,
                                              ),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                child: Text(
                                                  strings.supportContactEmail,
                                                  style: AppTextStyles.bodySm
                                                      .copyWith(
                                                        color: textColor,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: InkWell(
                                        key: const Key('support_contact_phone'),
                                        borderRadius: BorderRadius.circular(10),
                                        onTap: () {
                                          setModalState(() {
                                            selectedContactMethod = 'phone';
                                            contactFieldError = null;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                selectedContactMethod == 'phone'
                                                    ? Icons.radio_button_checked
                                                    : Icons.radio_button_off,
                                                size: 19,
                                                color:
                                                    selectedContactMethod ==
                                                        'phone'
                                                    ? AppColors.primaryContainer
                                                    : subColor,
                                              ),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                child: Text(
                                                  strings.supportContactPhone,
                                                  style: AppTextStyles.bodySm
                                                      .copyWith(
                                                        color: textColor,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (contactFieldError != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    contactFieldError!,
                                    style: AppTextStyles.labelSm.copyWith(
                                      color: AppColors.error,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 8),

                                // Privacy Policy Note + Link
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      strings.supportPrivacyPrefix,
                                      style: AppTextStyles.bodySm.copyWith(
                                        color: subColor,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () =>
                                          showAgriTechPrivacyModal(context),
                                      child: Text(
                                        strings.privacyPolicyTitle,
                                        style: AppTextStyles.bodySm.copyWith(
                                          color: AppColors.primaryContainer,
                                          fontWeight: FontWeight.w700,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      strings.supportPrivacySuffix,
                                      style: AppTextStyles.bodySm.copyWith(
                                        color: subColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),

                                // Submit Button
                                ElevatedButton(
                                  key: const Key('support_submit_button'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryContainer,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size.fromHeight(46),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: handleSubmit,
                                  child: Text(
                                    strings.supportSubmitButton,
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
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
