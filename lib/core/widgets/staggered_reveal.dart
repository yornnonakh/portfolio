import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../motion/app_motion.dart';

typedef StaggeredRevealBuilder =
    Widget Function(BuildContext context, List<Widget> children);

/// Reveals a small set of semantic content groups with one finite controller.
///
/// The animation waits until the surrounding [TickerMode] is active, replays
/// when a kept-alive screen becomes visible again, and resolves immediately
/// when Reduce Motion (or the app motion override) is enabled.
class StaggeredReveal extends StatefulWidget {
  const StaggeredReveal({
    super.key,
    required this.children,
    this.builder,
    this.enabled = true,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.offset = 14,
    this.replayKey,
  });

  final List<Widget> children;
  final StaggeredRevealBuilder? builder;
  final bool enabled;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;
  final double offset;

  /// Changing this value replays the reveal while the widget is visible.
  final Object? replayKey;

  @override
  State<StaggeredReveal> createState() => _StaggeredRevealState();
}

class _StaggeredRevealState extends State<StaggeredReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _active = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppMotion.screenEntrance,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncMotion();
  }

  @override
  void didUpdateWidget(covariant StaggeredReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    final shouldReplay = oldWidget.replayKey != widget.replayKey;
    _syncMotion(replay: shouldReplay);
  }

  void _syncMotion({bool replay = false}) {
    final motionEnabled = widget.enabled && AppMotion.enabledOf(context);
    final visible = TickerMode.valuesOf(context).enabled;

    if (!motionEnabled) {
      _controller
        ..stop()
        ..value = 1;
      _active = false;
      return;
    }

    if (!visible) {
      _controller
        ..stop()
        ..value = 0;
      _active = false;
      return;
    }

    if (!_active || replay) {
      _controller.forward(from: 0);
    }
    _active = true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final revealedChildren = <Widget>[];
    var revealIndex = 0;
    for (final child in widget.children) {
      if (child is SizedBox) {
        revealedChildren.add(child);
        continue;
      }
      revealedChildren.add(
        _RevealItem(
          animation: _controller,
          index: revealIndex++,
          offset: widget.offset,
          child: child,
        ),
      );
    }

    final builder = widget.builder;
    if (builder != null) return builder(context, revealedChildren);

    return Column(
      mainAxisAlignment: widget.mainAxisAlignment,
      mainAxisSize: widget.mainAxisSize,
      crossAxisAlignment: widget.crossAxisAlignment,
      textDirection: widget.textDirection,
      verticalDirection: widget.verticalDirection,
      textBaseline: widget.textBaseline,
      children: revealedChildren,
    );
  }
}

class _RevealItem extends StatelessWidget {
  const _RevealItem({
    required this.animation,
    required this.index,
    required this.offset,
    required this.child,
  });

  final Animation<double> animation;
  final int index;
  final double offset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final start = math.min(index * .085, .42);
    final end = math.min(start + .55, 1.0);
    final progress = CurvedAnimation(
      parent: animation,
      curve: Interval(start, end, curve: AppMotion.enterCurve),
    );

    return AnimatedBuilder(
      animation: progress,
      child: child,
      builder: (context, child) {
        final value = progress.value;
        return IgnorePointer(
          ignoring: value < .98,
          child: Opacity(
            opacity: value,
            alwaysIncludeSemantics: true,
            child: Transform.translate(
              offset: Offset(0, offset * (1 - value)),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
