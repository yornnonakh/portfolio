import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(22),
    this.borderRadius = 26,
    this.blur = 12,
    this.onTap,
    this.semanticLabel,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double blur;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppGradients.glass,
            borderRadius: radius,
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: onTap == null
                ? Padding(padding: padding, child: child)
                : Semantics(
                    button: true,
                    label: semanticLabel,
                    child: InkWell(
                      onTap: onTap,
                      borderRadius: radius,
                      hoverColor: Colors.white.withValues(alpha: .06),
                      splashColor: AppColors.primary.withValues(alpha: .12),
                      child: Padding(padding: padding, child: child),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
