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
                    center: Alignment(-1.2, -1.1),
                    radius: 1.15,
                    colors: [
                      Color(0x260A84FF),
                      Color(0x0A0A84FF),
                      Color(0x000A84FF),
                    ],
                    stops: [0, .35, 1],
                  ),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(1.15, .55),
                      radius: .95,
                      colors: [Color(0x145AC8FA), Color(0x005AC8FA)],
                    ),
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment(-.65, 1.2),
                        radius: .75,
                        colors: [Color(0x0FBF5AF2), Color(0x00BF5AF2)],
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
