import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.outlined = false,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final isDark = brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;

    final outlinedBg = isDark
        ? Colors.white.withValues(alpha: .06)
        : Colors.black.withValues(alpha: .04);

    final foreground = outlined
        ? theme.colorScheme.onSurface
        : Colors.white;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: outlined ? outlinedBg : primaryColor,
        borderRadius: BorderRadius.circular(16),
        border: outlined
            ? Border.all(color: AppColors.glassBorderFor(brightness))
            : null,
        boxShadow: outlined
            ? null
            : [
                BoxShadow(
                  color: primaryColor.withValues(alpha: .22),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: foreground,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          minimumSize: const Size(48, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: Text(label, textAlign: TextAlign.center)),
            if (icon != null) ...[
              const SizedBox(width: 10),
              Icon(icon, size: 19),
            ],
          ],
        ),
      ),
    );
  }
}
