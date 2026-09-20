import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/main/presentation/main_scaffold.dart';

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key, this.enableHomeMotion = true});

  final bool enableHomeMotion;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: MainScaffold(enableHomeMotion: enableHomeMotion),
    );
  }
}
