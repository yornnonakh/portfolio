import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class TagChip extends StatelessWidget {
  const TagChip(this.label, {super.key, this.compact = false});
  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 12 : 17,
          vertical: compact ? 6 : 10,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: compact ? 13 : 15,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class TagList extends StatelessWidget {
  const TagList(this.tags, {super.key, this.compact = false});
  final List<String> tags;
  final bool compact;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 10,
    children: [for (final tag in tags) TagChip(tag, compact: compact)],
  );
}
