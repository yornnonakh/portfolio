import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import 'navigation_provider.dart';

const _dashboardAccent = Color.fromARGB(255, 29, 144, 226);

const _bottomDestinations = <_BottomDestination>[
  _BottomDestination(
    tab: MainTab.home,
    label: 'Home',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_rounded,
  ),
  _BottomDestination(
    tab: MainTab.project,
    label: 'Projects',
    icon: Icons.grid_view_outlined,
    selectedIcon: Icons.grid_view_rounded,
  ),
  _BottomDestination(
    tab: MainTab.skill,
    label: 'Skills',
    icon: Icons.auto_awesome_outlined,
    selectedIcon: Icons.auto_awesome_rounded,
  ),
  _BottomDestination(
    tab: MainTab.contact,
    label: 'Contact',
    icon: Icons.mail_outline_rounded,
    selectedIcon: Icons.mail_rounded,
  ),
];

/// A floating navigation cluster with a frosted destination pill and a
/// deliberately separate primary action.
class CustomBottomBar extends ConsumerWidget {
  const CustomBottomBar({super.key, this.onActionPressed});

  /// Called by the standalone dashboard button. Embedders can provide their own
  /// dashboard action when the default navigation behavior is not suitable.
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(navigationProvider);
    final compact = MediaQuery.sizeOf(context).width <= 360;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _DashboardButton(
          compact: compact,
          selected: activeTab == MainTab.dashboard,
          onPressed:
              onActionPressed ??
              () => ref
                  .read(navigationProvider.notifier)
                  .select(MainTab.dashboard),
        ),
        SizedBox(width: compact ? 8 : 12),
        Expanded(
          child: _FrostedPill(
            child: Row(
              children: [
                for (final destination in _bottomDestinations)
                  Expanded(
                    flex: activeTab == destination.tab ? 2 : 1,
                    child: _BottomNavigationItem(
                      destination: destination,
                      selected: activeTab == destination.tab,
                      compact: compact,
                      onTap: () => ref
                          .read(navigationProvider.notifier)
                          .select(destination.tab),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FrostedPill extends StatelessWidget {
  const _FrostedPill({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = BorderRadius.circular(32);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? .28 : .12),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: isDark ? .06 : .55),
            blurRadius: 12,
            offset: const Offset(-4, -4),
          ),
        ],
      ),
      child: ClipRRect(
        key: const ValueKey('bottom-navigation-pill'),
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF202126).withValues(alpha: .78)
                  : Colors.white.withValues(alpha: .72),
              borderRadius: radius,
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: .12)
                    : Colors.white.withValues(alpha: .88),
              ),
            ),
            child: Padding(padding: const EdgeInsets.all(5), child: child),
          ),
        ),
      ),
    );
  }
}

class _BottomNavigationItem extends StatelessWidget {
  const _BottomNavigationItem({
    required this.destination,
    required this.selected,
    required this.compact,
    required this.onTap,
  });

  final _BottomDestination destination;
  final bool selected;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final foreground = selected
        ? theme.colorScheme.primary
        : AppColors.textSecondaryFor(theme.brightness);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final radius = BorderRadius.circular(24);

    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: AnimatedContainer(
          duration: reduceMotion
              ? Duration.zero
              : const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: selected
                ? theme.colorScheme.primary.withValues(
                    alpha: isDark ? .16 : .10,
                  )
                : Colors.transparent,
            borderRadius: radius,
            border: Border.all(
              color: selected
                  ? theme.colorScheme.primary.withValues(
                      alpha: isDark ? .24 : .16,
                    )
                  : Colors.transparent,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: .10),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : const [],
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              key: ValueKey('nav-${destination.tab.name}'),
              onTap: onTap,
              borderRadius: radius,
              splashColor: foreground.withValues(alpha: .08),
              highlightColor: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 6 : 10,
                  vertical: compact ? 11 : 13,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSwitcher(
                      duration: reduceMotion
                          ? Duration.zero
                          : const Duration(milliseconds: 180),
                      switchInCurve: Curves.easeOutBack,
                      switchOutCurve: Curves.easeIn,
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(scale: animation, child: child),
                      ),
                      child: Icon(
                        selected ? destination.selectedIcon : destination.icon,
                        key: ValueKey(selected),
                        size: compact ? 19 : 21,
                        color: foreground,
                      ),
                    ),
                    if (selected) ...[
                      SizedBox(width: compact ? 5 : 7),
                      Flexible(
                        child: Text(
                          destination.label,
                          key: ValueKey('nav-label-${destination.tab.name}'),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: TextStyle(
                            color: foreground,
                            fontSize: compact ? 12 : 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -.1,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardButton extends StatelessWidget {
  const _DashboardButton({
    required this.compact,
    required this.selected,
    required this.onPressed,
  });

  final bool compact;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 50.0 : 58.0;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Semantics(
      button: true,
      label: 'Dashboard',
      child: Tooltip(
        message: 'Dashboard',
        child: AnimatedContainer(
          key: const ValueKey('dashboard-button'),
          duration: reduceMotion
              ? Duration.zero
              : const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: selected
                ? _dashboardAccent
                : (isDark
                      ? const Color(0xFF202126).withValues(alpha: .88)
                      : Colors.white.withValues(alpha: .88)),
            shape: BoxShape.circle,
            border: Border.all(
              color: selected
                  ? _dashboardAccent
                  : _dashboardAccent.withValues(alpha: isDark ? .42 : .28),
            ),
            boxShadow: [
              BoxShadow(
                color: selected
                    ? _dashboardAccent.withValues(alpha: .34)
                    : Colors.black.withValues(alpha: isDark ? .20 : .10),
                blurRadius: selected ? 22 : 16,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: .16),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              key: const ValueKey('nav-dashboard'),
              onTap: onPressed,
              child: SizedBox.square(
                dimension: size,
                child: AnimatedSwitcher(
                  duration: reduceMotion
                      ? Duration.zero
                      : const Duration(milliseconds: 180),
                  child: Icon(
                    selected
                        ? Icons.dashboard_rounded
                        : Icons.dashboard_outlined,
                    key: ValueKey(selected),
                    color: selected ? Colors.white : _dashboardAccent,
                    size: compact ? 24 : 27,
                  ),
                ),
              ),
            ),
          ),
        ),
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

class _BottomDestination {
  const _BottomDestination({
    required this.tab,
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final MainTab tab;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
