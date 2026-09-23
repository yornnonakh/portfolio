import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Shares the animated rail between the project and experience timelines.
class TimelineEntry extends StatelessWidget {
  const TimelineEntry({
    super.key,
    required this.index,
    required this.count,
    required this.progress,
    required this.flow,
    required this.spacing,
    required this.label,
    required this.accent,
    this.badge,
    required this.child,
  });

  final int index;
  final int count;
  final double progress;
  final Animation<double> flow;
  final double spacing;
  final String label;
  final Color accent;
  final String? badge;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final primaryColor = theme.colorScheme.primary;
    final surfaceColor = theme.colorScheme.surface;

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide =
            constraints.maxWidth / MediaQuery.textScalerOf(context).scale(1) >=
            620;
        final railLeft = wide ? 156.0 : 0.0;
        final contentLeft = railLeft + 44;
        final metadata = Opacity(
          opacity: progress,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textSecondaryFor(brightness),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: .4,
                ),
              ),
              if (badge != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: .09),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: accent.withValues(alpha: .2)),
                  ),
                  child: Text(
                    badge!,
                    style: TextStyle(
                      color: accent,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: .4,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
        return Stack(
          children: [
            Positioned(
              left: railLeft,
              top: 0,
              bottom: 0,
              width: 44,
              child: IgnorePointer(
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: _TimelineRailPainter(
                      index: index,
                      count: count,
                      progress: progress,
                      flow: flow,
                      accent: accent,
                      themeColor: primaryColor,
                      surfaceColor: surfaceColor,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: railLeft,
              top: 0,
              width: 28,
              height: 36,
              child: ExcludeSemantics(
                child: Center(
                  child: Opacity(
                    opacity: progress,
                    child: Text(
                      (index + 1).toString().padLeft(2, '0'),
                      textScaler: TextScaler.noScaling,
                      style: TextStyle(
                        color: accent,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: index == count - 1 ? 0 : spacing,
              ),
              child: wide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 144,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: metadata,
                          ),
                        ),
                        SizedBox(width: contentLeft - 144),
                        Expanded(child: child),
                      ],
                    )
                  : Padding(
                      padding: EdgeInsets.only(left: contentLeft),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 14),
                            child: metadata,
                          ),
                          child,
                        ],
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _TimelineRailPainter extends CustomPainter {
  _TimelineRailPainter({
    required this.index,
    required this.count,
    required this.progress,
    required this.flow,
    required this.accent,
    required this.themeColor,
    required this.surfaceColor,
  }) : super(repaint: flow);

  final int index;
  final int count;
  final double progress;
  final Animation<double> flow;
  final Color accent;
  final Color themeColor;
  final Color surfaceColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || progress == 0) return;

    final phase = Curves.easeInOutSine.transform(flow.value);
    final position = phase * math.max(1, count - 1);
    final intensity = (1 - (position - index).abs() / .6).clamp(0.0, 1.0);
    const center = Offset(14, 18);
    final start = Offset(center.dx, index == 0 ? center.dy : 0);
    final end = Offset(center.dx, index == count - 1 ? center.dy : size.height);

    canvas.save();
    canvas.clipRect(
      Rect.fromLTRB(0, 0, size.width, 18 + (size.height - 18) * progress),
    );
    canvas.drawLine(
      start,
      end,
      Paint()
        ..color = themeColor.withValues(alpha: .12 * progress)
        ..strokeWidth = 1.5,
    );

    final bandY = center.dy + (position - index) * size.height;
    final bandRadius = size.height * .28;
    final shader =
        LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            themeColor.withValues(alpha: 0),
            themeColor.withValues(alpha: .30 * progress),
            themeColor.withValues(alpha: .50 * progress),
            themeColor.withValues(alpha: .35 * progress),
            themeColor.withValues(alpha: 0),
          ],
          stops: const [0, .25, .5, .7, 1],
        ).createShader(
          Rect.fromLTRB(0, bandY - bandRadius, size.width, bandY + bandRadius),
        );
    canvas.drawLine(
      start,
      end,
      Paint()
        ..shader = shader
        ..strokeWidth = 3.5
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5),
    );
    canvas.drawLine(
      start,
      end,
      Paint()
        ..shader = shader
        ..strokeWidth = 1.2,
    );
    canvas.drawLine(
      const Offset(28, 18),
      Offset(size.width - 5, 18),
      Paint()
        ..color = accent.withValues(alpha: (.10 + intensity * .15) * progress)
        ..strokeWidth = 1,
    );
    canvas.restore();

    final marker = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 27, height: 27),
      const Radius.circular(9),
    );
    canvas.drawRRect(
      marker,
      Paint()
        ..color = accent.withValues(alpha: .08 * intensity * progress)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawRRect(
      marker,
      Paint()..color = surfaceColor.withValues(alpha: progress),
    );
    canvas.drawRRect(
      marker,
      Paint()..color = accent.withValues(alpha: .04 * progress),
    );
    canvas.drawRRect(
      marker,
      Paint()
        ..color = accent.withValues(alpha: (.20 + .30 * intensity) * progress)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant _TimelineRailPainter oldDelegate) =>
      oldDelegate.index != index ||
      oldDelegate.count != count ||
      oldDelegate.progress != progress ||
      oldDelegate.accent != accent ||
      oldDelegate.themeColor != themeColor ||
      oldDelegate.surfaceColor != surfaceColor ||
      oldDelegate.flow != flow;
}
