import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' as liquid;
import 'package:portfolio/app.dart';
import 'package:portfolio/core/motion/app_motion.dart';
import 'package:portfolio/core/widgets/glass_card.dart' as portfolio;
import 'package:portfolio/core/widgets/staggered_reveal.dart';
import 'package:portfolio/core/services/link_service.dart';
import 'package:portfolio/data/models/portfolio.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/features/about/presentation/about_screen.dart';
import 'package:portfolio/features/experience/presentation/experience_screen.dart';
import 'package:portfolio/features/main/presentation/navigation_provider.dart';
import 'package:portfolio/features/projects/presentation/projects_provider.dart';

class RecordingLinkService extends LinkService {
  final List<Uri> opened = [];
  bool succeeds = true;

  @override
  Future<bool> open(Uri uri) async {
    opened.add(uri);
    return succeeds;
  }
}

Future<void> pumpPortfolio(
  WidgetTester tester, {
  Size size = const Size(390, 844),
  double textScale = 1,
  RecordingLinkService? links,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        if (links != null) linkServiceProvider.overrideWithValue(links),
      ],
      child: const PortfolioApp(enableHomeMotion: false),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> selectTab(WidgetTester tester, MainTab tab) async {
  final destination = find.byKey(ValueKey('nav-${tab.name}'));
  if (destination.evaluate().isNotEmpty) {
    await tester.ensureVisible(destination);
    await tester.pumpAndSettle();
    await tester.tap(destination);
  } else {
    final bar = find.byType(liquid.GlassTabBar);
    if (bar.evaluate().isNotEmpty) {
      final rect = tester.getRect(bar);
      await tester.tapAt(
        Offset(
          rect.left + rect.width * (tab.index + .5) / MainTab.values.length,
          rect.center.dy,
        ),
      );
    }
  }
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final loader = FontLoader('Outfit');
    loader.addFont(rootBundle.load('assets/fonts/Outfit.ttf'));
    await loader.load();
  });
  test('category filtering and reset derive the right projects', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(container.read(filteredProjectsProvider), hasLength(2));
    container
        .read(projectFilterProvider.notifier)
        .select(ProjectCategory.productivity);
    expect(container.read(filteredProjectsProvider).single.id, 'piisiit-note');
    container
        .read(projectFilterProvider.notifier)
        .select(ProjectCategory.clientWork);
    expect(container.read(filteredProjectsProvider).single.id, 'taskflow');
    container
        .read(projectFilterProvider.notifier)
        .select(ProjectCategory.openSource);
    expect(container.read(filteredProjectsProvider), isEmpty);
    container.read(projectFilterProvider.notifier).select(ProjectCategory.all);
    expect(container.read(filteredProjectsProvider), hasLength(2));
  });

  testWidgets('app exposes its production title', (tester) async {
    await pumpPortfolio(tester);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).title,
      'Yorn Nona · Flutter Engineer',
    );
  });

  testWidgets('shared screen reveal staggers content and completes', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MotionScope(
        enabled: true,
        child: MaterialApp(
          home: Scaffold(
            body: StaggeredReveal(
              children: [Text('First'), Text('Second'), Text('Third')],
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final reveal = find.byType(StaggeredReveal);
    final opacity = find.descendant(of: reveal, matching: find.byType(Opacity));
    expect(
      tester.widgetList<Opacity>(opacity).any((item) => item.opacity < 1),
      isTrue,
    );

    await tester.pump(AppMotion.screenEntrance);

    expect(
      tester.widgetList<Opacity>(opacity).every((item) => item.opacity == 1),
      isTrue,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('global motion switch resolves reveals immediately', (
    tester,
  ) async {
    var pressed = false;
    await tester.pumpWidget(
      MotionScope(
        enabled: false,
        child: MaterialApp(
          home: Scaffold(
            body: StaggeredReveal(
              children: [
                TextButton(
                  onPressed: () => pressed = true,
                  child: const Text('Ready now'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final opacity = tester.widget<Opacity>(
      find.descendant(
        of: find.byType(StaggeredReveal),
        matching: find.byType(Opacity),
      ),
    );
    expect(opacity.opacity, 1);

    await tester.tap(find.text('Ready now'));
    expect(pressed, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('motion-enabled tabs animate only while active', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1440, 1000);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const ProviderScope(child: PortfolioApp(enableMotion: true)),
    );
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('nav-skill')));
    await tester.pump();
    expect(find.text('Languages & Frameworks'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1200));
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const ValueKey('nav-project')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1200));
    expect(find.text('TaskFlow'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'primary navigation, filters, empty state and project contact flow work',
    (tester) async {
      await pumpPortfolio(tester);
      await selectTab(tester, MainTab.dashboard);
      await tester.tap(find.text('View Projects'));
      await tester.pumpAndSettle();
      expect(find.text('TaskFlow'), findsOneWidget);
      await tester.tap(find.text('Productivity'));
      await tester.pumpAndSettle();
      expect(find.text('Piisiit Note'), findsOneWidget);
      expect(find.text('TaskFlow'), findsNothing);
      await selectTab(tester, MainTab.skill);
      expect(find.text('Languages & Frameworks'), findsOneWidget);
      await selectTab(tester, MainTab.project);
      expect(find.text('TaskFlow'), findsNothing);
      await tester.ensureVisible(find.text('Open source'));
      await tester.tap(find.text('Open source'));
      await tester.pumpAndSettle();
      expect(find.text('More good things are on the way.'), findsOneWidget);
      await tester.tap(find.text('Show all projects'));
      await tester.pumpAndSettle();
      expect(find.text('Hive'), findsOneWidget);
      await tester.tap(find.text('Piisiit Note'));
      await tester.pumpAndSettle();
      expect(find.text('Thoughtfully built'), findsOneWidget);
      await tester.ensureVisible(find.text('Discuss a similar project'));
      await tester.tap(find.text('Discuss a similar project'));
      await tester.pumpAndSettle();
      expect(find.text('Send a Message'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('dashboard is the default and scrolls through the portfolio', (
    tester,
  ) async {
    await pumpPortfolio(tester);

    expect(find.text('Dashboard'), findsWidgets);
    expect(find.byType(liquid.GlassTabBar), findsOneWidget);
    expect(
      tester.widget<liquid.GlassTabBar>(find.byType(liquid.GlassTabBar)).tabs,
      hasLength(4),
    );
    expect(
      tester
          .widget<liquid.GlassTabBar>(find.byType(liquid.GlassTabBar))
          .extraButton,
      isNotNull,
    );
    expect(find.text('Featured Work'), findsOneWidget);
    expect(find.text('TaskFlow'), findsOneWidget);
    expect(find.text('Skills and stack'), findsOneWidget);
    expect(find.text('Nimbus Labs · 2023 — Present'), findsOneWidget);

    final scrollable = find.byType(CustomScrollView).first;
    final before = tester
        .state<ScrollableState>(
          find
              .descendant(of: scrollable, matching: find.byType(Scrollable))
              .first,
        )
        .position
        .pixels;
    await tester.drag(scrollable, const Offset(0, -500));
    await tester.pumpAndSettle();
    final after = tester
        .state<ScrollableState>(
          find
              .descendant(of: scrollable, matching: find.byType(Scrollable))
              .first,
        )
        .position
        .pixels;

    expect(after, greaterThan(before));
    expect(tester.takeException(), isNull);
  });

  testWidgets('package-native bottom navigation stays synced with sections', (
    tester,
  ) async {
    await pumpPortfolio(tester);

    liquid.GlassTabBar bar() =>
        tester.widget<liquid.GlassTabBar>(find.byType(liquid.GlassTabBar));

    expect(find.byType(liquid.GlassTabBar), findsOneWidget);
    expect(bar().selectedIndex, MainTab.dashboard.index);
    expect(bar().indicatorPinchStrength, greaterThan(0));
    expect(bar().indicatorColor, isNull);
    expect(bar().selectedIconColor, isNull);
    expect(bar().selectedLabelColor, isNull);
    expect(bar().settings, isNull);
    expect(bar().indicatorSettings, isNull);

    await selectTab(tester, MainTab.home);
    expect(bar().selectedIndex, MainTab.home.index - 1);

    await selectTab(tester, MainTab.project);
    expect(bar().selectedIndex, MainTab.project.index - 1);

    await selectTab(tester, MainTab.dashboard);
    expect(find.text('Dashboard'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('mobile sections swipe horizontally and keep navigation synced', (
    tester,
  ) async {
    await pumpPortfolio(tester, size: const Size(320, 640));

    final pageView = find.byKey(const ValueKey('section-page-view'));
    expect(pageView, findsOneWidget);
    final bottomBar = find.byType(liquid.GlassTabBar);
    expect(bottomBar, findsOneWidget);

    final barBeforeScroll = tester.getRect(bottomBar);
    await tester.drag(
      find.byType(CustomScrollView).first,
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();
    final barAfterScroll = tester.getRect(bottomBar);
    expect(barAfterScroll.top, barBeforeScroll.top);

    await tester.drag(pageView, const Offset(-280, 0));
    await tester.pumpAndSettle();

    expect(
      tester.widget<liquid.GlassTabBar>(bottomBar).selectedIndex,
      MainTab.home.index - 1,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('liquid indicator follows a held drag and selects on release', (
    tester,
  ) async {
    await pumpPortfolio(tester, size: const Size(390, 844));

    final bar = find.byType(liquid.GlassTabBar);
    final rect = tester.getRect(bar);
    final start = Offset(rect.left + rect.width * .1, rect.center.dy);

    await tester.timedDragFrom(
      start,
      Offset(rect.width * .28, 0),
      const Duration(milliseconds: 800),
    );
    await tester.pumpAndSettle();

    expect(
      tester.widget<liquid.GlassTabBar>(bar).selectedIndex,
      MainTab.project.index - 1,
    );
    expect(find.text('Projects'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('project category header supports held horizontal dragging', (
    tester,
  ) async {
    await pumpPortfolio(tester, size: const Size(320, 640));
    await selectTab(tester, MainTab.project);

    final categoryHeader = find.byKey(
      const ValueKey('project-category-scroll'),
    );
    final segmentedControl = tester.widget<liquid.GlassSegmentedControl>(
      categoryHeader,
    );
    expect(segmentedControl.backgroundColor, isNull);
    expect(segmentedControl.indicatorColor, isNull);
    expect(segmentedControl.dragBehavior, liquid.SegmentDragBehavior.scroll);
    final categoryScroll = find.descendant(
      of: categoryHeader,
      matching: find.byType(Scrollable),
    );
    final position = tester.state<ScrollableState>(categoryScroll).position;
    expect(position.maxScrollExtent, greaterThan(0));

    final scrollConfiguration = tester.widget<ScrollConfiguration>(
      find
          .ancestor(
            of: categoryHeader,
            matching: find.byType(ScrollConfiguration),
          )
          .first,
    );
    expect(
      scrollConfiguration.behavior.dragDevices,
      containsAll({
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      }),
    );

    await tester.drag(categoryHeader, const Offset(-120, 0));
    await tester.pumpAndSettle();
    expect(position.pixels, greaterThan(0));
    expect(tester.takeException(), isNull);
  });

  testWidgets('content cards use the reusable liquid glass surface', (
    tester,
  ) async {
    await pumpPortfolio(tester);

    expect(find.byType(portfolio.GlassCard), findsWidgets);
    expect(find.byType(liquid.GlassContainer), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'contact uses correct URI, reports launch failures and copies email',
    (tester) async {
      final links = RecordingLinkService();
      String? copiedText;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            copiedText = (call.arguments as Map)['text'] as String;
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      await pumpPortfolio(tester, links: links);
      await selectTab(tester, MainTab.contact);
      await tester.tap(find.text('Send a Message'));
      await tester.pumpAndSettle();
      expect(links.opened.single.scheme, 'mailto');
      expect(links.opened.single.path, PortfolioContent.profile.email);
      expect(links.opened.single.query, contains('%20'));
      links.succeeds = false;
      await tester.tap(find.text('Send a Message'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Couldn’t open an app'), findsOneWidget);
      await tester.tap(find.text('Copy'));
      await tester.pumpAndSettle();
      expect(copiedText, PortfolioContent.profile.email);
      await tester.tap(find.byTooltip('Copy email address'));
      await tester.pumpAndSettle();
      expect(find.text('Email address copied.'), findsOneWidget);

      links.succeeds = true;
      await tester.tap(find.byTooltip('GitHub'));
      await tester.pumpAndSettle();
      expect(links.opened.last, Uri.parse('https://github.com/yornnonakh'));
      expect(find.byTooltip('LinkedIn · Coming soon'), findsOneWidget);
      expect(find.byTooltip('X · Coming soon'), findsOneWidget);
      expect(find.byTooltip('Dribbble · Coming soon'), findsOneWidget);
    },
  );

  testWidgets('page titles collapse into the top app bar while scrolling', (
    tester,
  ) async {
    await pumpPortfolio(tester);
    await selectTab(tester, MainTab.skill);

    final title = find.descendant(
      of: find.byType(SliverAppBar),
      matching: find.text('Skills'),
    );
    final expandedRect = tester.getRect(title);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -360));
    await tester.pumpAndSettle();

    final collapsedRect = tester.getRect(title);
    final viewportCenter = tester.getCenter(find.byType(CustomScrollView)).dx;
    expect(expandedRect.left, lessThan(40));
    expect(collapsedRect.center.dx, closeTo(viewportCenter, 1));
    expect(collapsedRect.bottom, lessThan(expandedRect.bottom));
    expect(collapsedRect.height, lessThan(expandedRect.height));
    expect(
      tester.widget<SliverAppBar>(find.byType(SliverAppBar)).backgroundColor,
      Colors.transparent,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('theme toggle switches between light and dark modes', (
    tester,
  ) async {
    await pumpPortfolio(tester);
    final toggleFinder = find
        .byKey(const ValueKey('theme-toggle-button'))
        .first;
    expect(toggleFinder, findsOneWidget);

    final startsDark =
        Theme.of(tester.element(toggleFinder)).brightness == Brightness.dark;
    expect(
      find.byTooltip(
        startsDark ? 'Switch to light mode' : 'Switch to dark mode',
      ),
      findsWidgets,
    );

    await tester.tap(toggleFinder);
    await tester.pumpAndSettle();
    expect(
      find.byTooltip(
        startsDark ? 'Switch to dark mode' : 'Switch to light mode',
      ),
      findsWidgets,
    );

    await tester.tap(toggleFinder);
    await tester.pumpAndSettle();
    expect(
      find.byTooltip(
        startsDark ? 'Switch to light mode' : 'Switch to dark mode',
      ),
      findsWidgets,
    );
  });

  for (final (size, scale) in [
    (const Size(320, 640), 1.0),
    (const Size(390, 844), 1.0),
    (const Size(768, 1024), 1.0),
    (const Size(1440, 1000), 1.0),
    (const Size(390, 844), 1.8),
  ]) {
    testWidgets(
      'screens fit ${size.width} × ${size.height} at text scale $scale',
      (tester) async {
        await pumpPortfolio(tester, size: size, textScale: scale);
        for (final tab in MainTab.values) {
          await selectTab(tester, tab);
          expect(
            tester.takeException(),
            isNull,
            reason: '${tab.label} must not overflow',
          );
        }
        for (final page in [const AboutScreen(), const ExperienceScreen()]) {
          final context = tester.element(find.byType(Scaffold).first);
          Navigator.of(
            context,
          ).push(MaterialPageRoute<void>(builder: (_) => page));
          if (page is ExperienceScreen) {
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 1200));
          } else {
            await tester.pumpAndSettle();
          }
          expect(tester.takeException(), isNull);
          Navigator.of(tester.element(find.byType(page.runtimeType))).pop();
          await tester.pumpAndSettle();
        }
      },
    );
  }
}
