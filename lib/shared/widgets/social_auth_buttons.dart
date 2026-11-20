import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Social login buttons ("المتابعة باستخدام Google" and "المتابعة باستخدام Facebook")
/// matching the exact SVG logos and containers in `agritech_8` and `agritech_2`.
class SocialAuthButtons extends StatelessWidget {
  const SocialAuthButtons({
    super.key,
    required this.onGoogleTap,
    required this.onFacebookTap,
  });

  final VoidCallback onGoogleTap;
  final VoidCallback onFacebookTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.onSurface
        : AppColors.surfaceContainerLow;
    final borderColor = isDark
        ? AppColors.onSurfaceVariant
        : AppColors.outlineVariant.withValues(alpha: 0.35);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SocialButtonTile(
          label: 'المتابعة باستخدام Google',
          bgColor: bgColor,
          borderColor: borderColor,
          leadingIcon: const SizedBox(
            width: 20,
            height: 20,
            child: CustomPaint(painter: _GoogleLogoPainter()),
          ),
          onTap: onGoogleTap,
        ),
        const SizedBox(height: 12),
        _SocialButtonTile(
          label: 'المتابعة باستخدام Facebook',
          bgColor: bgColor,
          borderColor: borderColor,
          leadingIcon: const Icon(
            Icons.facebook,
            size: 22,
            color: Color(0xFF1877F2),
          ),
          onTap: onFacebookTap,
        ),
      ],
    );
  }
}

class _SocialButtonTile extends StatelessWidget {
  const _SocialButtonTile({
    required this.label,
    required this.bgColor,
    required this.borderColor,
    required this.leadingIcon,
    required this.onTap,
  });

  final String label;
  final Color bgColor;
  final Color borderColor;
  final Widget leadingIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              leadingIcon,
              const SizedBox(width: 12),
              Text(
                label,
                style: AppTextStyles.labelMd.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  const _GoogleLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.22;
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    // Red top arc
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(rect, -2.5, 1.8, false, paint);

    // Yellow left arc
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(rect, 2.3, 1.3, false, paint);

    // Green bottom arc
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(rect, 0.8, 1.5, false, paint);

    // Blue right arc + crossbar
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(rect, -0.2, 1.0, false, paint);

    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.5,
        size.height * 0.41,
        size.width * 0.45,
        strokeWidth * 0.85,
      ),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
