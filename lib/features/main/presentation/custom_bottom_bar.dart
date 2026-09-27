import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' as liquid;

import '../../../core/theme/app_colors.dart';
import 'navigation_provider.dart';

const _bottomTabs = <liquid.GlassTab>[
  liquid.GlassTab(
    icon: Icon(Icons.dashboard_outlined),
    activeIcon: Icon(Icons.dashboard_rounded),
    label: 'Dashboard',
    semanticLabel: 'Dashboard',
  ),
  liquid.GlassTab(
    icon: Icon(Icons.home_outlined),
    activeIcon: Icon(Icons.home_rounded),
    label: 'Home',
    semanticLabel: 'Home',
  ),
  liquid.GlassTab(
    icon: Icon(Icons.grid_view_outlined),
    activeIcon: Icon(Icons.grid_view_rounded),
    label: 'Projects',
    semanticLabel: 'Projects',
  ),
  liquid.GlassTab(
    icon: Icon(Icons.auto_awesome_outlined),
    activeIcon: Icon(Icons.auto_awesome_rounded),
    label: 'Skills',
    semanticLabel: 'Skills',
  ),
  liquid.GlassTab(
    icon: Icon(Icons.mail_outline_rounded),
    activeIcon: Icon(Icons.mail_rounded),
    label: 'Contact',
    semanticLabel: 'Contact',
  ),
];

/// Package-native liquid-glass navigation with a draggable indicator.
///
/// Holding and dragging across the bar moves the indicator with the pointer;
/// releasing it snaps to and selects the nearest destination.
class CustomBottomBar extends ConsumerWidget {
  const CustomBottomBar({super.key, this.onActionPressed});

  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(navigationProvider);
    final compact = MediaQuery.sizeOf(context).width <= 360;

    return liquid.GlassTabBar.bottom(
      key: const ValueKey('liquid-glass-bottom-bar'),
      tabs: _bottomTabs,
      selectedIndex: activeTab.index,
      onTabSelected: (index) {
        final tab = MainTab.values[index];
        if (tab == MainTab.dashboard && onActionPressed != null) {
          onActionPressed!();
          return;
        }
        ref.read(navigationProvider.notifier).select(tab);
      },
      horizontalPadding: 0,
      verticalPadding: 0,
      barHeight: compact ? 50 : 58,
      barBorderRadius: 32,
      tabPadding: const EdgeInsets.symmetric(horizontal: 1),
      iconLabelSpacing: compact ? 1 : 2,
      iconSize: compact ? 19 : 21,
      labelFontSize: compact ? 9 : 10,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
      indicatorPinchStrength: .42,
      indicatorExpansion: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 4,
      ),
      magnification: 1.08,
      quality: liquid.GlassQuality.standard,
      backgroundQuality: liquid.GlassQuality.standard,
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
