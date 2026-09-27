import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' as liquid;

/// The app's reusable liquid-glass surface.
///
/// Keeping package configuration here gives navigation, headers, and content
/// cards the same rendering quality, tint, shape, and accessibility behavior.
class LiquidGlassSurface extends StatelessWidget {
  const LiquidGlassSurface({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.borderRadius = 24,
    this.frost = 7,
    this.elevated = false,
  }) : circular = false;

  const LiquidGlassSurface.circular({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.frost = 7,
    this.elevated = false,
  }) : borderRadius = 0,
       circular = true;

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double frost;
  final bool elevated;
  final bool circular;

  @override
  Widget build(BuildContext context) {
    return liquid.GlassContainer(
      useOwnLayer: true,
      quality: liquid.GlassQuality.standard,
      padding: padding,
      clipBehavior: Clip.antiAlias,
      allowElevation: elevated,
      glowIntensity: elevated ? .14 : .06,
      shape: circular
          ? const liquid.LiquidOval()
          : liquid.LiquidRoundedSuperellipse(
              borderRadius: borderRadius,
            ),
      settings: liquid.LiquidGlassSettings(
        blur: frost.clamp(2, 10),
        thickness: elevated ? 24 : 20,
        shadowElevation: elevated ? 1.15 : .45,
      ),
      child: child,
    );
  }
}
