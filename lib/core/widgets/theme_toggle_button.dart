import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/theme_provider.dart';

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final (icon, label) = switch (themeMode) {
      ThemeMode.system => (
        CupertinoIcons.device_phone_portrait,
        'Theme: System',
      ),
      ThemeMode.light => (CupertinoIcons.sun_max_fill, 'Theme: Light'),
      ThemeMode.dark => (CupertinoIcons.moon_stars_fill, 'Theme: Dark'),
    };

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: '$label (Tap to switch)',
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: const ValueKey('theme-toggle-button'),
          onTap: () => ref.read(themeModeProvider.notifier).cycleTheme(),
          child: Container(
            padding: EdgeInsets.all(compact ? 8 : 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? Colors.white.withValues(alpha: .08)
                  : Colors.black.withValues(alpha: .05),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: .12)
                    : Colors.black.withValues(alpha: .08),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: compact ? 17 : 19,
                  color: isDark ? const Color(0xFF64D2FF) : const Color(0xFF007AFF),
                ),
                if (!compact) ...[
                  const SizedBox(width: 6),
                  Text(
                    switch (themeMode) {
                      ThemeMode.system => 'Auto',
                      ThemeMode.light => 'Light',
                      ThemeMode.dark => 'Dark',
                    },
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? const Color(0xFFF5F5F7)
                          : const Color(0xFF1C1C1E),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
