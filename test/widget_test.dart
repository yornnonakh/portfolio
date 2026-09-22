import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/app.dart';
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
  await tester.tap(find.byKey(ValueKey('nav-${tab.name}')));
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

  testWidgets(
    'primary navigation, filters, empty state and project contact flow work',
    (tester) async {
      await pumpPortfolio(tester);
      await selectTab(tester, MainTab.home);
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
      await tester.tap(find.text('Open source'));
      await tester.pumpAndSettle();
      expect(find.text('More good things are on the way.'), findsOneWidget);
      await tester.tap(find.text('Show all projects'));
      await tester.pumpAndSettle();
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

  testWidgets('about and experience open and return home', (tester) async {
    await pumpPortfolio(tester);
    for (final (label, expected) in [
      ('About me', 'Education'),
      ('Experience', 'Nimbus Labs · 2023 — Present'),
    ]) {
      await Scrollable.ensureVisible(
        tester.element(find.text(label)),
        alignment: .5,
        duration: Duration.zero,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text(label));
      if (label == 'Experience') {
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 1200));
      } else {
        await tester.pumpAndSettle();
      }
      expect(find.text(expected), findsOneWidget);
      if (label == 'Experience') {
        expect(find.text('ACTIVE'), findsOneWidget);
      }
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.text('Portfolio'), findsOneWidget);
    }
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
