import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'liquid_glass_surface.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(22),
    this.borderRadius = 24,
    this.blur = 28,
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
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final radius = BorderRadius.circular(borderRadius);

    return LiquidGlassSurface(
      borderRadius: borderRadius,
      frost: blur / 4,
      elevated: true,
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
                  hoverColor: isDark
                      ? Colors.white.withValues(alpha: .04)
                      : Colors.black.withValues(alpha: .03),
                  splashColor: isDark
                      ? AppColors.primary.withValues(alpha: .12)
                      : AppColors.primaryLight.withValues(alpha: .12),
                  child: Padding(padding: padding, child: child),
                ),
              ),
      ),
    );
  }
}
