import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/main/presentation/main_scaffold.dart';

class PortfolioApp extends ConsumerWidget {
  const PortfolioApp({super.key, this.enableHomeMotion = true});

  final bool enableHomeMotion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'Portfolio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: MainScaffold(enableHomeMotion: enableHomeMotion),
    );
  }
}
