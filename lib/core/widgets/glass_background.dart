import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GlassBackground extends StatelessWidget {
  const GlassBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: AppColors.background),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned.fill(
            child: RepaintBoundary(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(-.95, -.95),
                    radius: 1.08,
                    colors: [
                      Color(0x78645CDD),
                      Color(0x3C615BC7),
                      Color(0x00615BC7),
                    ],
                    stops: [0, .35, 1],
                  ),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(1.15, .55),
                      radius: .95,
                      colors: [Color(0x7821B8A6), Color(0x0021B8A6)],
                    ),
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment(-.65, 1.2),
                        radius: .75,
                        colors: [Color(0x55C56D61), Color(0x00C56D61)],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
