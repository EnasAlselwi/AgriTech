import 'package:flutter/material.dart';

import '../../../../core/config/app_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/widgets/agritech_header_banner.dart';
import '../../../../shared/widgets/social_auth_buttons.dart';

/// Screen 2: Create Account (`إنشاء حساب جديد`) — Faithful implementation of `agritech_2`.
/// Enforces registration security: self-registered accounts are created with
/// the standard Farmer (`مزارع`) role and cannot self-assign administrator privileges.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegistration() {
    if (_formKey.currentState?.validate() ?? false) {
      final appState = AppStateScope.maybeOf(context);
      if (appState != null) {
        appState.userFullName = _nameController.text.trim();
        appState.userEmail = _emailController.text.trim();
        // Security enforcement: self-registration always assigns Farmer role.
        appState.userRole = 'مزارع';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم إنشاء حسابك بنجاح! مرحباً بك في AgriTech',
            style: AppTextStyles.bodyMd.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.inverseSurface,
          behavior: SnackBarBehavior.floating,
        ),
      );
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
            const AgriTechAuthHeader(
              title: 'إنشاء حساب جديد',
              subtitle: 'أنشئ حسابك للبدء في استخدام تطبيق AgriTech',
            ),
            AgriTechWhiteSheetContainer(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Field 1: Full Name
                    Text(
                      'الاسم الكامل',
                      style: AppTextStyles.labelMd.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      key: const Key('register_name_field'),
                      controller: _nameController,
                      style: AppTextStyles.bodyMd.copyWith(color: textColor),
                      decoration: InputDecoration(
                        fillColor: inputFillColor,
                        hintText: 'أدخل اسمك الكامل الثلاثي',
                        suffixIcon: const Icon(
                          Icons.badge_outlined,
                          size: 20,
                          color: AppColors.outlineVariant,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال الاسم الكامل';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Field 2: Email
                    Text(
                      'البريد الإلكتروني',
                      style: AppTextStyles.labelMd.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      key: const Key('register_email_field'),
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

                    const SizedBox(height: 16),

                    // Field 3: Password
                    Text(
                      'كلمة المرور',
                      style: AppTextStyles.labelMd.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      key: const Key('register_password_field'),
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: AppTextStyles.bodyMd.copyWith(color: textColor),
                      decoration: InputDecoration(
                        fillColor: inputFillColor,
                        hintText: 'أدخل كلمة المرور',
                        suffixIcon: IconButton(
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
                        if (value == null || value.length < 8) {
                          return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(
                        '8 أحرف على الأقل، مع حرف كبير وحرف صغير ورقم.',
                        style: AppTextStyles.bodySm.copyWith(color: subColor),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Field 4: Confirm Password
                    Text(
                      'تأكيد كلمة المرور',
                      style: AppTextStyles.labelMd.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      key: const Key('register_confirm_password_field'),
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      style: AppTextStyles.bodyMd.copyWith(color: textColor),
                      decoration: InputDecoration(
                        fillColor: inputFillColor,
                        hintText: 'أعد إدخال كلمة المرور',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 20,
                            color: AppColors.outline,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'كلمتا المرور غير متطابقتين';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Primary CTA Button: إنشاء حساب + person_add
                    ElevatedButton(
                      key: const Key('register_submit_button'),
                      onPressed: _handleRegistration,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'إنشاء حساب',
                            style: AppTextStyles.labelLg.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.person_add_alt_1_outlined,
                            size: 22,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Divider: أو أنشئ حسابك باستخدام
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'أو أنشئ حسابك باستخدام',
                            style: AppTextStyles.labelSm.copyWith(
                              color: AppColors.outline,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),

                    const SizedBox(height: 18),

                    SocialAuthButtons(
                      onGoogleTap: () => _showSocialToast('Google'),
                      onFacebookTap: () => _showSocialToast('Facebook'),
                    ),

                    const SizedBox(height: 24),

                    // Footer Link: لديك حساب بالفعل؟ تسجيل الدخول
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'لديك حساب بالفعل؟',
                          style: AppTextStyles.bodyMd.copyWith(color: subColor),
                        ),
                        const SizedBox(width: 6),
                        InkWell(
                          key: const Key('back_to_login_link'),
                          onTap: () {
                            if (Navigator.of(context).canPop()) {
                              Navigator.of(context).pop();
                            } else {
                              Navigator.of(
                                context,
                              ).pushReplacementNamed(AppRoutes.login);
                            }
                          },
                          child: Text(
                            'تسجيل الدخول',
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
