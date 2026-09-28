import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/availability_badge.dart';
import '../../../core/widgets/glass_background.dart';
import '../../../core/widgets/theme_toggle_button.dart';
import '../../../data/portfolio_providers.dart';
import '../../contact/presentation/contact_screen.dart';
import '../../dashboard/presentation/dashboard_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../projects/presentation/projects_screen.dart';
import '../../skills/presentation/skills_screen.dart';
import 'custom_bottom_bar.dart';
import 'navigation_provider.dart';

class MainScaffold extends ConsumerStatefulWidget {
  const MainScaffold({super.key, this.enableHomeMotion = true});

  final bool enableHomeMotion;

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showPage(MainTab tab) {
    if (!mounted || !_pageController.hasClients) return;
    if (_pageController.page?.round() == tab.index) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_pageController.hasClients) return;
      if (_pageController.page?.round() == tab.index) return;

      _pageController.animateToPage(
        tab.index,
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final tab = ref.watch(navigationProvider);
    final wide = MediaQuery.sizeOf(context).width >= 900;
    ref.listen(navigationProvider, (_, next) {
      if (!wide) {
        _showPage(next);
      }
    });

    return PopScope(
      canPop: tab == MainTab.dashboard,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          ref.read(navigationProvider.notifier).select(MainTab.dashboard);
        }
      },
      child: Scaffold(
        extendBody: true,
        bottomNavigationBar: wide
            ? null
            : SafeArea(
                minimum: EdgeInsets.fromLTRB(
                  MediaQuery.sizeOf(context).width <= 360 ? 16 : 24,
                  0,
                  MediaQuery.sizeOf(context).width <= 360 ? 16 : 24,
                  12,
                ),
                child: SizedBox(
                  height: CustomBottomBar.preferredHeight,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 430),
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
                child: wide
                    ? IndexedStack(index: tab.index, children: _pages(tab))
                    : PageView(
                        key: const ValueKey('section-page-view'),
                        controller: _pageController,
                        onPageChanged: (index) => ref
                            .read(navigationProvider.notifier)
                            .select(MainTab.values[index]),
                        children: _pages(tab),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _pages(MainTab tab) => [
    TickerMode(
      enabled: tab == MainTab.dashboard,
      child: DashboardScreen(motionEnabled: widget.enableHomeMotion),
    ),
    TickerMode(
      enabled: tab == MainTab.home,
      child: HomeScreen(motionEnabled: widget.enableHomeMotion),
    ),
    TickerMode(enabled: tab == MainTab.project, child: const ProjectsScreen()),
    TickerMode(enabled: tab == MainTab.skill, child: const SkillsScreen()),
    TickerMode(enabled: tab == MainTab.contact, child: const ContactScreen()),
  ];
}

class _DesktopHeader extends ConsumerWidget {
  const _DesktopHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 22),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: Row(
            children: [
              TextButton(
                onPressed: () => ref
                    .read(navigationProvider.notifier)
                    .select(MainTab.dashboard),
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
                NavigationItem(tab: tab),
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
