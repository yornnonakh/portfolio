import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/theme_provider.dart';

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final icon = isDark
        ? CupertinoIcons.moon_fill
        : CupertinoIcons.sun_max_fill;
    final nextMode = isDark ? ThemeMode.light : ThemeMode.dark;
    final label = isDark ? 'Switch to light mode' : 'Switch to dark mode';

    return IconButton(
      key: const ValueKey('theme-toggle-button'),
      onPressed: () =>
          ref.read(themeModeProvider.notifier).setThemeMode(nextMode),
      tooltip: label,
      padding: EdgeInsets.zero,
      iconSize: compact ? 19 : 21,
      color: isDark ? const Color(0xFF64D2FF) : const Color(0xFF007AFF),
      icon: Icon(icon),
    );
  }
}
