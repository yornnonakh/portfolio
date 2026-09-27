import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' as liquid;

import '../../../core/theme/app_colors.dart';
import 'navigation_provider.dart';

const _bottomTabs = <liquid.GlassTab>[
  liquid.GlassTab(
    icon: Icon(Icons.dashboard_outlined),
    activeIcon: Icon(Icons.dashboard_rounded),
    semanticLabel: 'Dashboard',
  ),
  liquid.GlassTab(
    icon: Icon(Icons.home_outlined),
    activeIcon: Icon(Icons.home_rounded),
    semanticLabel: 'Home',
  ),
  liquid.GlassTab(
    icon: Icon(Icons.grid_view_outlined),
    activeIcon: Icon(Icons.grid_view_rounded),
    semanticLabel: 'Projects',
  ),
  liquid.GlassTab(
    icon: Icon(Icons.auto_awesome_outlined),
    activeIcon: Icon(Icons.auto_awesome_rounded),
    semanticLabel: 'Skills',
  ),
  liquid.GlassTab(
    icon: Icon(Icons.mail_outline_rounded),
    activeIcon: Icon(Icons.mail_rounded),
    semanticLabel: 'Contact',
  ),
];

/// Package-native liquid-glass navigation with a draggable indicator.
///
/// Holding and dragging across the bar moves the indicator with the pointer;
/// releasing it snaps to and selects the nearest destination.
class CustomBottomBar extends ConsumerWidget {
  const CustomBottomBar({super.key, this.onActionPressed, this.scrollController});

  final VoidCallback? onActionPressed;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(navigationProvider);

    return liquid.GlassTabBar.bottom(
      key: const ValueKey('liquid-glass-bottom-bar'),
      tabs: _bottomTabs,
      selectedIndex: activeTab.index,
      scrollController: scrollController,
      onTabSelected: (index) {
        final tab = MainTab.values[index];
        if (tab == MainTab.dashboard && onActionPressed != null) {
          onActionPressed!();
          return;
        }
        ref.read(navigationProvider.notifier).select(tab);
      },
      quality: liquid.GlassQuality.standard,
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
    final foreground = selected
        ? Colors.white
        : AppColors.textSecondaryFor(Theme.of(context).brightness);
    final radius = BorderRadius.circular(horizontal ? 16 : 22);

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
          color: selected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_desktopIconFor(tab), size: 19, color: foreground),
                  const SizedBox(width: 8),
                  Text(
                    tab.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: foreground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _desktopIconFor(MainTab tab) => switch (tab) {
    MainTab.dashboard => Icons.dashboard_outlined,
    MainTab.home => Icons.home_outlined,
    MainTab.project => Icons.grid_view_outlined,
    MainTab.skill => Icons.auto_awesome_outlined,
    MainTab.contact => Icons.mail_outline_rounded,
  };
}
