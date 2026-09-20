import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
    this.trailing,
  });
  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Icon(icon, size: 21, color: AppColors.primary),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
            ),
          ),
          ?trailing,
        ],
      ),
    );
    return onTap == null
        ? row
        : InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: row,
          );
  }
}
