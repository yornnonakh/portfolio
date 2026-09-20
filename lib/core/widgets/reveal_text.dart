import 'package:flutter/material.dart';

/// Reveals a label from left to right as its parent animation progresses.
class RevealText extends StatelessWidget {
  const RevealText({
    super.key,
    required this.text,
    required this.progress,
    required this.style,
    this.textAlign = TextAlign.left,
  });

  final String text;
  final double progress;
  final TextStyle style;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final fraction = progress.clamp(0.0, 1.0);
    final visibleCharacters = (text.length * fraction).floor();
    final visibleText = text.substring(0, visibleCharacters);
    final cursor = progress > 0 && progress < 1 ? '▌' : '';

    return Semantics(
      label: text,
      child: ExcludeSemantics(
        child: Text('$visibleText$cursor', textAlign: textAlign, style: style),
      ),
    );
  }
}
