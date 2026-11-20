import 'package:flutter/material.dart';

import '../../../../core/config/app_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/widgets/agritech_header_banner.dart';
import '../../../../shared/widgets/social_auth_buttons.dart';

/// Screen 1: Login (`تسجيل الدخول`) — Faithful implementation of `agritech_8`.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      final appState = AppStateScope.maybeOf(context);
      final email = _emailController.text.trim();
      if (appState != null && email.isNotEmpty) {
        appState.userEmail = email;
      }
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    }
  }

  void _showSocialToast(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'جاري المتابعة باستخدام $provider...',
          style: AppTextStyles.bodyMd.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.inverseSurface,
        behavior: SnackBarBehavior.floating,
      ),
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
            // Top Agricultural Terrace Banner + Logo + Title (Fixed Header)
            const AgriTechAuthHeader(
              title: 'تسجيل الدخول',
              subtitle: 'سجّل دخولك لمتابعة مزرعتك',
            ),

            // Main White Form Sheet (rounded-t-[28px] — Scrollable Content Area)
            AgriTechWhiteSheetContainer(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Email Label
                    Row(
                      children: [
                        Icon(
                          Icons.mail_outline,
                          size: 16,
                          color: isDark
                              ? AppColors.inversePrimary
                              : AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'البريد الإلكتروني',
                          style: AppTextStyles.labelMd.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      key: const Key('login_email_field'),
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
                        if (text.isEmpty) {
                          return 'يرجى إدخال البريد الإلكتروني';
                        }
                        if (!text.contains('@')) {
                          return 'يرجى إدخال بريد إلكتروني صحيح';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Password Label
                    Row(
                      children: [
                        Icon(
                          Icons.lock_outline,
                          size: 16,
                          color: isDark
                              ? AppColors.inversePrimary
                              : AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'كلمة المرور',
                          style: AppTextStyles.labelMd.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      key: const Key('login_password_field'),
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: AppTextStyles.bodyMd.copyWith(color: textColor),
                      decoration: InputDecoration(
                        fillColor: inputFillColor,
                        hintText: 'أدخل كلمة المرور',
                        suffixIcon: IconButton(
                          key: const Key('login_password_visibility_toggle'),
                          tooltip: 'إظهار كلمة المرور',
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 20,
                            color: AppColors.outline,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال كلمة المرور';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 6),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: InkWell(
                        key: const Key('forgot_password_link'),
                        onTap: () => Navigator.of(
                          context,
                        ).pushNamed(AppRoutes.forgotPassword),
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 2,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'نسيت كلمة المرور؟',
                                style: AppTextStyles.bodySm.copyWith(
                                  color: isDark
                                      ? AppColors.inversePrimary
                                      : AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward,
                                size: 13,
                                color: isDark
                                    ? AppColors.inversePrimary
                                    : AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Primary Login CTA Button (#31691D)
                    ElevatedButton(
                      key: const Key('login_submit_button'),
                      onPressed: _handleLogin,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'تسجيل الدخول',
                            style: AppTextStyles.labelLg.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.login,
                            size: 20,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Divider: أو سجّل الدخول باستخدام
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'أو سجّل الدخول باستخدام',
                            style: AppTextStyles.labelSm.copyWith(
                              color: AppColors.outline,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Social Auth Buttons
                    SocialAuthButtons(
                      onGoogleTap: () => _showSocialToast('Google'),
                      onFacebookTap: () => _showSocialToast('Facebook'),
                    ),

                    const SizedBox(height: 24),

                    // Register Navigation Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ليس لديك حساب؟',
                          style: AppTextStyles.bodyMd.copyWith(color: subColor),
                        ),
                        const SizedBox(width: 6),
                        InkWell(
                          key: const Key('go_to_register_link'),
                          onTap: () => Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.register),
                          child: Text(
                            'إنشاء حساب جديد',
                            style: AppTextStyles.labelLg.copyWith(
                              color: isDark
                                  ? AppColors.inversePrimary
                                  : AppColors.primaryContainer,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                              decorationColor: isDark
                                  ? AppColors.inversePrimary
                                  : AppColors.primaryContainer,
                            ),
                          ),
                        ),
                      ],
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
