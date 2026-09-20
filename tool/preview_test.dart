// Run with: flutter test tool/preview_test.dart
// Captures actual Flutter renders in build/previews for visual review.
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/app.dart';
import 'package:portfolio/features/about/presentation/about_screen.dart';
import 'package:portfolio/features/experience/presentation/experience_screen.dart';
import 'package:portfolio/features/main/presentation/navigation_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final manifest =
        jsonDecode(await rootBundle.loadString('FontManifest.json'))
            as List<dynamic>;
    for (final entry in manifest.cast<Map<String, dynamic>>()) {
      final loader = FontLoader(entry['family'] as String);
      for (final font
          in (entry['fonts'] as List<dynamic>).cast<Map<String, dynamic>>()) {
        loader.addFont(rootBundle.load(font['asset'] as String));
      }
      await loader.load();
    }
  });

  testWidgets('render mobile screens and desktop home', (tester) async {
    final boundaryKey = GlobalKey();
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        child: RepaintBoundary(
          key: boundaryKey,
          child: const PortfolioApp(enableHomeMotion: false),
        ),
      ),
    );
    await tester.pumpAndSettle();

    Future<void> capture(String name) async {
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final boundary =
          boundaryKey.currentContext!.findRenderObject()!
              as RenderRepaintBoundary;
      await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 2);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        final file = File('build/previews/$name.png');
        await file.parent.create(recursive: true);
        await file.writeAsBytes(bytes!.buffer.asUint8List());
        image.dispose();
      });
    }

    await capture('home');
    tester.view.physicalSize = const Size(366, 697);
    await capture('home_compact');
    tester.view.physicalSize = const Size(390, 844);
    for (final tab in [
      MainTab.dashboard,
      MainTab.projects,
      MainTab.skills,
      MainTab.contact,
    ]) {
      await tester.tap(find.byKey(ValueKey('nav-${tab.name}')));
      await capture(tab.name);
    }
    await tester.tap(find.byKey(const ValueKey('nav-home')));
    await tester.pumpAndSettle();
    for (final (name, page) in [
      ('about', const AboutScreen()),
      ('experience', const ExperienceScreen()),
    ]) {
      Navigator.of(
        tester.element(find.byType(Scaffold).first),
      ).push(MaterialPageRoute<void>(builder: (_) => page));
      await capture(name);
      Navigator.of(tester.element(find.byType(page.runtimeType))).pop();
      await tester.pumpAndSettle();
    }
    tester.view.physicalSize = const Size(1440, 1000);
    await capture('desktop');
  });
}
