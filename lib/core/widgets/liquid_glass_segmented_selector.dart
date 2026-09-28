import 'dart:ui' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' as liquid;

/// A reusable, horizontally scrollable liquid-glass value selector.
///
/// Package defaults own the colors and indicator rendering so the control
/// automatically follows the active glass theme.
class LiquidGlassSegmentedSelector<T> extends StatelessWidget {
  const LiquidGlassSegmentedSelector({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.controlKey,
    this.height = 46,
    this.borderRadius = 14,
    this.labelPadding = const EdgeInsets.symmetric(horizontal: 14),
  });

  final List<LiquidGlassSelectorOption<T>> options;
  final T value;
  final ValueChanged<T> onChanged;
  final Key? controlKey;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry labelPadding;

  @override
  Widget build(BuildContext context) {
    assert(options.isNotEmpty, 'At least one selector option is required.');
    final selectedIndex = options.indexWhere((option) => option.value == value);
    assert(selectedIndex >= 0, 'The selected value must exist in options.');

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: const {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.stylus,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.unknown,
        },
        scrollbars: false,
      ),
      child: liquid.GlassSegmentedControl.scrollable(
        key: controlKey,
        segments: [
          for (final option in options)
            liquid.GlassSegment(
              id: option.value,
              icon: option.icon,
              label: option.label,
              semanticLabel: option.semanticLabel ?? option.label,
            ),
        ],
        selectedIndex: selectedIndex,
        onSegmentSelected: (index) => onChanged(options[index].value),
        useOwnLayer: true,
        quality: liquid.GlassQuality.standard,
        height: height,
        borderRadius: borderRadius,
        dragBehavior: liquid.SegmentDragBehavior.scroll,
        labelPadding: labelPadding,
      ),
    );
  }
}

class LiquidGlassSelectorOption<T> {
  const LiquidGlassSelectorOption({
    required this.value,
    required this.label,
    this.icon,
    this.semanticLabel,
  });

  final T value;
  final String label;
  final Widget? icon;
  final String? semanticLabel;
}
