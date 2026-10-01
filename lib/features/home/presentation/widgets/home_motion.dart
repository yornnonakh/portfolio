import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/motion/app_motion.dart';
import '../../../../core/theme/app_colors.dart';

/// Adds a restrained entrance and ambient light movement to the home screen.
/// The ambient loop pauses automatically when motion is disabled.
class HomeMotion extends StatefulWidget {
  const HomeMotion({super.key, required this.child, this.enabled = true});

  final Widget child;
  final bool enabled;

  @override
  State<HomeMotion> createState() => _HomeMotionState();
}

class _HomeMotionState extends State<HomeMotion> with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _ambientController;
  late final Animation<double> _entrance;
  bool _active = false;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: AppMotion.screenEntrance,
    );
    _ambientController = AnimationController(
      vsync: this,
      duration: AppMotion.ambient,
    );
    _entrance = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncMotion();
  }

  @override
  void didUpdateWidget(covariant HomeMotion oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncMotion();
  }

  void _syncMotion() {
    final motionEnabled = widget.enabled && AppMotion.enabledOf(context);
    final visible = TickerMode.valuesOf(context).enabled;

    if (!motionEnabled) {
      _entranceController
        ..stop()
        ..value = 1;
      _ambientController
        ..stop()
        ..value = 0;
      _active = false;
      return;
    }

    if (!visible) {
      _entranceController
        ..stop()
        ..value = 0;
      _ambientController
        ..stop()
        ..value = 0;
      _active = false;
      return;
    }

    if (!_active) {
      _entranceController.forward(from: 0);
      _ambientController.repeat(reverse: true);
    }
    _active = true;
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _ambientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _ambientController,
                builder: (context, child) => CustomPaint(
                  painter: _HomeAmbientPainter(_ambientController.value),
                  child: child,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: FadeTransition(
            opacity: _entrance,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, .025),
                end: Offset.zero,
              ).animate(_entrance),
              child: widget.child,
            ),
          ),
        ),
      ],
    );
  }
}

class _HomeAmbientPainter extends CustomPainter {
  const _HomeAmbientPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final wave = Curves.easeInOut.transform(progress);
    _drawGlow(
      canvas,
      center: Offset(
        size.width * (.08 + wave * .12),
        size.height * (.12 + math.sin(wave * math.pi) * .04),
      ),
      radius: size.width * .38,
      color: AppColors.purple,
      opacity: .055,
    );
    _drawGlow(
      canvas,
      center: Offset(
        size.width * (.94 - wave * .12),
        size.height * (.56 - math.sin(wave * math.pi) * .08),
      ),
      radius: size.width * .42,
      color: AppColors.primary,
      opacity: .06,
    );
    _drawGlow(
      canvas,
      center: Offset(
        size.width * (.28 + wave * .18),
        size.height * (.96 - wave * .08),
      ),
      radius: size.width * .34,
      color: AppColors.coral,
      opacity: .035,
    );
  }

  void _drawGlow(
    Canvas canvas, {
    required Offset center,
    required double radius,
    required Color color,
    required double opacity,
  }) {
    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: opacity),
          color.withValues(alpha: 0),
        ],
      ).createShader(rect);
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _HomeAmbientPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
