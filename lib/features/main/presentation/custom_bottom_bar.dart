import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import 'navigation_provider.dart';

class CustomBottomBar extends ConsumerWidget {
  const CustomBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compact = MediaQuery.sizeOf(context).width <= 380;
    return GlassCard(
      borderRadius: 30,
      blur: 32,
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          for (final tab in MainTab.values)
            Expanded(
              child: NavigationItem(tab: tab, compact: compact),
            ),
        ],
      ),
    );
  }
}

class NavigationItem extends ConsumerWidget {
  const NavigationItem({
    super.key,
    required this.tab,
    this.horizontal = false,
    this.compact = false,
  });

  final MainTab tab;
  final bool horizontal;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(navigationProvider) == tab;
    final icon = _iconFor(tab, selected: selected, compact: compact);
    final foreground = selected ? Colors.white : AppColors.textMuted;
    final label = tab.label;
    final radius = BorderRadius.circular(
      horizontal
          ? 16
          : compact
          ? 19
          : 22,
    );

    return Semantics(
      button: true,
      selected: selected,
      label: tab.label,
      child: AnimatedContainer(
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: radius,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            key: ValueKey('nav-${tab.name}'),
            onTap: () => ref.read(navigationProvider.notifier).select(tab),
            borderRadius: radius,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontal
                    ? 16
                    : compact
                    ? 7
                    : 5,
                vertical: horizontal
                    ? 12
                    : compact
                    ? 7
                    : 9,
              ),
              child: horizontal
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 19, color: foreground),
                        const SizedBox(width: 8),
                        Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: foreground,
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Icon(
                        icon,
                        size: compact ? 20 : 24,
                        color: foreground,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconFor(
    MainTab tab, {
    required bool selected,
    required bool compact,
  }) {
    if (compact) {
      return switch (tab) {
        MainTab.home =>
          selected ? CupertinoIcons.house_fill : CupertinoIcons.house,
        MainTab.project =>
          selected
              ? CupertinoIcons.square_grid_2x2_fill
              : CupertinoIcons.square_grid_2x2,
        MainTab.skill =>
          selected ? CupertinoIcons.sparkles : CupertinoIcons.wand_stars,
        MainTab.contact =>
          selected
              ? CupertinoIcons.chat_bubble_fill
              : CupertinoIcons.chat_bubble,
      };
    }
    return switch (tab) {
      MainTab.home =>
        selected ? CupertinoIcons.house_fill : CupertinoIcons.house,
      MainTab.project =>
        selected
            ? CupertinoIcons.square_grid_2x2_fill
            : CupertinoIcons.square_grid_2x2,
      MainTab.skill => CupertinoIcons.sparkles,
      MainTab.contact =>
        selected ? CupertinoIcons.chat_bubble_fill : CupertinoIcons.chat_bubble,
    };
  }
}
