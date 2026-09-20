import 'package:flutter/material.dart';
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
      borderRadius: compact ? 24 : 28,
      blur: 22,
      padding: EdgeInsets.all(compact ? 5 : 7),
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
    final foreground = selected
        ? AppColors.ink
        : AppColors.textSecondary.withValues(alpha: .82);
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
          gradient: selected ? AppGradients.primary : null,
          borderRadius: radius,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            key: ValueKey('nav-${tab.name}'),
            onTap: () => ref.read(navigationProvider.notifier).select(tab),
            borderRadius: radius,
            splashColor: AppColors.primary.withValues(alpha: .16),
            highlightColor: Colors.white.withValues(alpha: .05),
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
          selected ? Icons.person_rounded : Icons.person_outline_rounded,
        MainTab.project =>
          selected ? Icons.group_rounded : Icons.group_outlined,
        MainTab.skill =>
          selected ? Icons.grid_view_rounded : Icons.grid_view_outlined,
        MainTab.contact =>
          selected ? Icons.mail_rounded : Icons.mail_outline_rounded,
      };
    }
    return switch (tab) {
      MainTab.home => selected ? Icons.home_rounded : Icons.home_outlined,
      MainTab.project =>
        selected ? Icons.grid_view_rounded : Icons.grid_view_outlined,
      MainTab.skill =>
        selected ? Icons.auto_awesome_rounded : Icons.auto_awesome_outlined,
      MainTab.contact =>
        selected
            ? Icons.chat_bubble_rounded
            : Icons.chat_bubble_outline_rounded,
    };
  }
}
