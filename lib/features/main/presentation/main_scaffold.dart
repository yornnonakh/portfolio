import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/availability_badge.dart';
import '../../../core/widgets/glass_background.dart';
import '../../../core/widgets/theme_toggle_button.dart';
import '../../../data/portfolio_providers.dart';
import '../../contact/presentation/contact_screen.dart';

import '../../home/presentation/home_screen.dart';
import '../../projects/presentation/projects_screen.dart';
import '../../skills/presentation/skills_screen.dart';
import 'custom_bottom_bar.dart';
import 'navigation_provider.dart';

class MainScaffold extends ConsumerWidget {
  const MainScaffold({super.key, this.enableHomeMotion = true});

  final bool enableHomeMotion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(navigationProvider);
    final wide = MediaQuery.sizeOf(context).width >= 900;
    return PopScope(
      canPop: tab == MainTab.home,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) ref.read(navigationProvider.notifier).select(MainTab.home);
      },
      child: Scaffold(
        extendBody: true,
        bottomNavigationBar: wide
            ? null
            : SafeArea(
                minimum: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                child: SizedBox(
                  height: 66,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width <= 380
                            ? 220
                            : 420,
                      ),
                      child: const CustomBottomBar(),
                    ),
                  ),
                ),
              ),
        body: GlassBackground(
          child: Column(
            children: [
              if (wide) SafeArea(bottom: false, child: const _DesktopHeader()),
              Expanded(
                child: IndexedStack(
                  index: tab.index,
                  children: [
                    TickerMode(
                      enabled: tab == MainTab.home,
                      child: HomeScreen(motionEnabled: enableHomeMotion),
                    ),
                    const ProjectsScreen(),
                    const SkillsScreen(),
                    const ContactScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DesktopHeader extends ConsumerWidget {
  const _DesktopHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 22),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: Row(
            children: [
              TextButton(
                onPressed: () =>
                    ref.read(navigationProvider.notifier).select(MainTab.home),
                child: Text(
                  '${profile.initials.toLowerCase()}.',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              const Spacer(),
              for (final tab in MainTab.values) ...[
                NavigationItem(tab: tab, horizontal: true),
                const SizedBox(width: 6),
              ],
              const Spacer(),
              const ThemeToggleButton(),
              const SizedBox(width: 12),
              AvailabilityBadge(compact: true, available: profile.available),
            ],
          ),
        ),
      ),
    );
  }
}
