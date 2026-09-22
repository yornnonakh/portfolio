import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class TimelineCard extends StatelessWidget {
  const TimelineCard({
    super.key,
    required this.accent,
    required this.child,
    this.highlighted = false,
    this.onTap,
    this.semanticLabel,
  });

  final Color accent;
  final Widget child;
  final bool highlighted;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(18);
    final content = Padding(padding: const EdgeInsets.all(20), child: child);
    return Semantics(
      button: onTap == null ? null : true,
      label: semanticLabel,
      child: Material(
        color: const Color(0xFF121827),
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                accent.withValues(alpha: highlighted ? .08 : .04),
                Colors.transparent,
              ],
            ),
            border: Border.all(
              color: highlighted
                  ? accent.withValues(alpha: .3)
                  : AppColors.textPrimary.withValues(alpha: .09),
            ),
          ),
          child: onTap == null
              ? content
              : InkWell(
                  onTap: onTap,
                  borderRadius: radius,
                  hoverColor: accent.withValues(alpha: .05),
                  focusColor: accent.withValues(alpha: .08),
                  splashColor: accent.withValues(alpha: .12),
                  child: content,
                ),
        ),
      ),
    );
  }
}

class TimelineTags extends StatelessWidget {
  const TimelineTags(this.tags, {super.key});

  final List<String> tags;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 6,
    runSpacing: 6,
    children: [
      for (final tag in tags)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.textPrimary.withValues(alpha: .045),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            tag,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
    ],
  );
}
