import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AvailabilityBadge extends StatelessWidget {
  const AvailabilityBadge({
    super.key,
    this.compact = false,
    this.available = true,
  });
  final bool compact;
  final bool available;

  @override
  Widget build(BuildContext context) {
    final color = available ? AppColors.primary : AppColors.textSecondary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 7 : 9,
          height: compact ? 7 : 9,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: .17),
                spreadRadius: compact ? 4 : 5,
                blurRadius: 2,
              ),
            ],
          ),
        ),
        const SizedBox(width: 11),
        Flexible(
          child: Text(
            available
                ? (compact ? 'Open to work' : 'Available for freelance work')
                : 'Currently building',
            style: TextStyle(
              color: color,
              fontSize: compact ? 11 : 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
