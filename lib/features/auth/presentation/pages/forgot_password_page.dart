import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/widgets/agritech_header_banner.dart';

/// Screen 3: Forgot Password (`استعادة كلمة المرور`) — Faithful implementation of `agritech_11`.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSendResetLink() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم إرسال رابط إعادة تعيين كلمة المرور إلى ${_emailController.text.trim()}',
            style: AppTextStyles.bodyMd.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.inverseSurface,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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
    final inputFillColor = isDark
        ? AppColors.onSurface
        : AppColors.surfaceContainerLow;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AgriTechAuthHeader(
              title: 'استعادة كلمة المرور',
              subtitle:
                  'أدخل بريدك الإلكتروني المسجل لإعادة تعيين كلمة المرور.',
            ),
            AgriTechWhiteSheetContainer(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'البريد الإلكتروني',
                      style: AppTextStyles.labelMd.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      key: const Key('forgot_email_field'),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.right,
                      style: AppTextStyles.bodyMd.copyWith(color: textColor),
                      decoration: InputDecoration(
                        fillColor: inputFillColor,
                        hintText: 'example@agritech.com',
                        hintTextDirection: TextDirection.ltr,
                        suffixIcon: const Icon(
                          Icons.alternate_email,
                          size: 20,
                          color: AppColors.outlineVariant,
                        ),
                      ),
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (text.isEmpty || !text.contains('@')) {
                          return 'يرجى إدخال بريد إلكتروني صحيح';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Primary Button: إرسال رابط إعادة التعيين
                    ElevatedButton(
                      key: const Key('forgot_submit_button'),
                      onPressed: _handleSendResetLink,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'إرسال رابط إعادة التعيين',
                            style: AppTextStyles.labelLg.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.send_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Divider: أو
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'أو',
                            style: AppTextStyles.labelMd.copyWith(
                              color: subColor,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Outlined Button: العودة إلى تسجيل الدخول
                    OutlinedButton(
                      key: const Key('forgot_back_to_login_button'),
                      onPressed: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed(AppRoutes.login);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'العودة إلى تسجيل الدخول',
                            style: AppTextStyles.labelMd.copyWith(
                              color: isDark
                                  ? AppColors.inversePrimary
                                  : AppColors.primaryContainer,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            size: 18,
                            color: isDark
                                ? AppColors.inversePrimary
                                : AppColors.primaryContainer,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    Text(
                      'تطبيق AgriTech للزراعة الذكية',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySm.copyWith(
                        fontSize: 13,
                        color: subColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
