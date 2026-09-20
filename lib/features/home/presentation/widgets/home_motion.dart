import 'dart:math' as math;
import 'package:flutter/material.dart';
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
  bool _motionConfigured = false;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    );
    _entrance = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_motionConfigured) return;
    _motionConfigured = true;
    if (!widget.enabled || MediaQuery.disableAnimationsOf(context)) {
      _entranceController.value = 1;
    } else {
      _entranceController.forward();
      _ambientController.repeat(reverse: true);
    }
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
