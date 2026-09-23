import 'package:flutter/material.dart';

class GlassBackground extends StatelessWidget {
  const GlassBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryBlue = isDark
        ? const Color(0x260A84FF)
        : const Color(0x2E007AFF);
    final secondarySky = isDark
        ? const Color(0x145AC8FA)
        : const Color(0x1F007AFF);
    final accentPurple = isDark
        ? const Color(0x0FBF5AF2)
        : const Color(0x145856D6);

    return DecoratedBox(
      decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: RepaintBoundary(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(-1.2, -1.1),
                    radius: 1.15,
                    colors: [
                      primaryBlue,
                      primaryBlue.withValues(alpha: .25),
                      primaryBlue.withValues(alpha: 0),
                    ],
                    stops: const [0, .35, 1],
                  ),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(1.15, .55),
                      radius: .95,
                      colors: [secondarySky, secondarySky.withValues(alpha: 0)],
                    ),
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(-.65, 1.2),
                        radius: .75,
                        colors: [
                          accentPurple,
                          accentPurple.withValues(alpha: 0),
                        ],
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
