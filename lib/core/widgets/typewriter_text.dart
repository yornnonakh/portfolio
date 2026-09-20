import 'package:flutter/material.dart';

/// Repeats a typewriter-style text loop while keeping a complete semantic
/// label for screen readers.
class TypewriterText extends StatefulWidget {
  const TypewriterText({
    super.key,
    required this.text,
    required this.style,
    this.enabled = true,
    this.textAlign = TextAlign.center,
  });

  final String text;
  final TextStyle style;
  final bool enabled;
  final TextAlign textAlign;

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _reducedMotion = false;

  Duration get _cycleDuration {
    final typing = widget.text.length * 75;
    final holding = 1100;
    final erasing = widget.text.length * 45;
    return Duration(milliseconds: typing + holding + erasing + 250);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _cycleDuration);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reducedMotion = MediaQuery.disableAnimationsOf(context);
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _controller
        ..duration = _cycleDuration
        ..value = 0;
    }
    if (oldWidget.enabled != widget.enabled) _syncAnimation();
  }

  void _syncAnimation() {
    if (widget.enabled && !_reducedMotion) {
      if (!_controller.isAnimating) _controller.repeat();
    } else {
      _controller
        ..stop()
        ..value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final staticText = Semantics(
      label: widget.text,
      child: ExcludeSemantics(
        child: Text(
          widget.text,
          textAlign: widget.textAlign,
          style: widget.style,
        ),
      ),
    );
    if (!widget.enabled || _reducedMotion) return staticText;

    return Semantics(
      label: widget.text,
      child: ExcludeSemantics(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final elapsed = _controller.value * _cycleDuration.inMilliseconds;
            final typingDuration = widget.text.length * 75;
            final holdDuration = 1100;
            final erasingDuration = widget.text.length * 45;
            final endOfTyping = typingDuration;
            final endOfHold = endOfTyping + holdDuration;
            final endOfErasing = endOfHold + erasingDuration;

            var visibleCharacters = 0;
            if (elapsed < endOfTyping) {
              visibleCharacters = (elapsed / 75).floor();
            } else if (elapsed < endOfHold) {
              visibleCharacters = widget.text.length;
            } else if (elapsed < endOfErasing) {
              final erased = ((elapsed - endOfHold) / 45).floor();
              visibleCharacters = widget.text.length - erased;
            }
            visibleCharacters = visibleCharacters.clamp(0, widget.text.length);

            final cursorVisible = (elapsed ~/ 300).isEven;
            final visibleText = widget.text.substring(0, visibleCharacters);
            return Text(
              '$visibleText${cursorVisible ? '▌' : ' '}',
              textAlign: widget.textAlign,
              style: widget.style,
            );
          },
        ),
      ),
    );
  }
}
