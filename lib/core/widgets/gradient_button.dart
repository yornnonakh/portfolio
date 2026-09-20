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
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: outlined ? null : AppGradients.primary,
        color: outlined ? Colors.white.withValues(alpha: .04) : null,
        borderRadius: BorderRadius.circular(20),
        border: outlined ? Border.all(color: AppColors.glassBorder) : null,
        boxShadow: outlined
            ? null
            : [
                BoxShadow(
                  color: AppColors.blue.withValues(alpha: .16),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: outlined ? AppColors.textPrimary : AppColors.ink,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
          minimumSize: const Size(48, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
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
