import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' as liquid;
import '../../../core/theme/app_colors.dart';
import 'navigation_provider.dart';

const _navigationDestinations = <_NavigationDestination>[
  _NavigationDestination(
    tab: MainTab.dashboard,colors: AppColors.primary,
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard_rounded,color: AppColors.primary,
  ),
  _NavigationDestination(
    tab: MainTab.home, colors: AppColors.primary,
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_rounded, color: AppColors.primary,
  ),
  _NavigationDestination(
    tab: MainTab.project, colors: AppColors.primary,
    icon: Icons.grid_view_outlined,
    selectedIcon: Icons.grid_view_rounded, color: AppColors.primary,
  ),
  _NavigationDestination(
    tab: MainTab.skill, colors: AppColors.primary,
    icon: Icons.auto_awesome_outlined,
    selectedIcon: Icons.auto_awesome_rounded,color: AppColors.primary
  ),
  _NavigationDestination(
    tab: MainTab.contact, colors: AppColors.primary,
    icon: Icons.mail_outline_rounded,
    selectedIcon: Icons.mail_rounded,color: AppColors.primary
  ),
];

final _bottomDestinations = _navigationDestinations
    .skip(1)
    .toList(growable: false);

/// Package-native liquid-glass navigation with a draggable indicator.
///
/// Holding and dragging across the bar moves the indicator with the pointer;
/// releasing it snaps to and selects the nearest destination.
class CustomBottomBar extends ConsumerWidget {
  const CustomBottomBar({super.key, this.onDashboardPressed});

  /// Matches the package's default 64 px pill and 20 px vertical insets.
  static const preferredHeight = 104.0;

  final VoidCallback? onDashboardPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(navigationProvider);
    final selectedIndex = _bottomDestinations.indexWhere(
      (destination) => destination.tab == activeTab,
    );
    final dashboardSelected = activeTab == MainTab.dashboard;

    void selectDashboard() {
      final callback = onDashboardPressed;
      if (callback != null) {
        callback();
      } else {
        ref.read(navigationProvider.notifier).select(MainTab.dashboard);
      }
    }

    return liquid.GlassTabBar.bottom(
      key: const ValueKey('liquid-glass-bottom-bar'),
      tabs: [
        for (final destination in _bottomDestinations)
          liquid.GlassTab(
            icon: Icon(
              destination.icon,
              key: ValueKey('nav-${destination.tab.name}'),
            ),
            activeIcon: Icon(destination.selectedIcon),
            semanticLabel: destination.tab.label,
          ),
      ],
      selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
      onTabSelected: (index) {
        ref
            .read(navigationProvider.notifier)
            .select(_bottomDestinations[index].tab);
      },
      extraButton: liquid.GlassTabBarExtraButton(
        icon: Icon(
          dashboardSelected
              ? _navigationDestinations.first.selectedIcon
              : _navigationDestinations.first.icon,
          key: const ValueKey('nav-dashboard'),
        ),
        iconColor: dashboardSelected
            ? Theme.of(context).colorScheme.primary
            : null,
        label: MainTab.dashboard.label,
        onTap: selectDashboard,
      ),
      enableBlend: true,
      blendAmount: 20,
      spacing: 6,
      indicatorPinchStrength: 0.55,
      showIndicator: !dashboardSelected,
      quality: liquid.GlassQuality.standard,
    );
  }
}

class NavigationItem extends ConsumerWidget {
  const NavigationItem({super.key, required this.tab});

  final MainTab tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(navigationProvider) == tab;
    final foreground = selected
        ? Colors.white
        : AppColors.textSecondaryFor(Theme.of(context).brightness);
    final radius = BorderRadius.circular(16);

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
                  Icon(_destinationFor(tab).icon, size: 19, color: foreground),
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
}

_NavigationDestination _destinationFor(MainTab tab) =>
    _navigationDestinations[tab.index];

class _NavigationDestination {
  const _NavigationDestination({
    required this.tab,
    required this.icon,
    required this.selectedIcon, required Color color, required Color colors,
  });

  final MainTab tab;
  final IconData icon;
  final IconData selectedIcon;
}
