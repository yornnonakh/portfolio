import 'package:flutter/material.dart';

/// Shared motion language for the portfolio.
///
/// Keeping timing and accessibility policy here makes every screen feel like
/// part of the same app and gives tests (and embedding surfaces) one reliable
/// way to turn animation off.
abstract final class AppMotion {
  static const Duration feedback = Duration(milliseconds: 160);
  static const Duration navigation = Duration(milliseconds: 280);
  static const Duration contentSwap = Duration(milliseconds: 320);
  static const Duration screenEntrance = Duration(milliseconds: 680);
  static const Duration skillProgress = Duration(milliseconds: 820);
  static const Duration timelineFlow = Duration(milliseconds: 3200);
  static const Duration ambient = Duration(seconds: 14);

  static const Curve enterCurve = Curves.easeOutCubic;
  static const Curve exitCurve = Curves.easeInCubic;

  static bool enabledOf(BuildContext context) {
    return MotionScope.enabledOf(context) &&
        !MediaQuery.disableAnimationsOf(context);
  }

  static Duration duration(BuildContext context, Duration duration) {
    return enabledOf(context) ? duration : Duration.zero;
  }
}

/// App-level animation override layered on top of the system Reduce Motion
/// preference consumed by [AppMotion.enabledOf].
class MotionScope extends InheritedWidget {
  const MotionScope({super.key, required this.enabled, required super.child});

  final bool enabled;

  static bool enabledOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MotionScope>()?.enabled ??
        true;
  }

  @override
  bool updateShouldNotify(MotionScope oldWidget) =>
      enabled != oldWidget.enabled;
}
