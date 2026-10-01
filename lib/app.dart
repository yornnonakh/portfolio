import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' as liquid;
import 'core/motion/app_motion.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/main/presentation/main_scaffold.dart';

class PortfolioApp extends ConsumerWidget {
  const PortfolioApp({
    super.key,
    bool enableHomeMotion = true,
    bool? enableMotion,
  }) : enableMotion = enableMotion ?? enableHomeMotion;

  /// Global animation switch. The older [enableHomeMotion] constructor
  /// argument remains supported so existing embeds and tests keep working.
  final bool enableMotion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MotionScope(
      enabled: enableMotion,
      child: MaterialApp(
        title: 'Yorn Nona · Flutter Engineer',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        themeAnimationDuration: enableMotion
            ? AppMotion.contentSwap
            : Duration.zero,
        themeAnimationCurve: AppMotion.enterCurve,
        builder: (context, child) {
          final brightness = Theme.of(context).brightness;
          final dark = brightness == Brightness.dark;
          final reduceMotion =
              !enableMotion || MediaQuery.disableAnimationsOf(context);
          return liquid.GlassAccessibilityScope(
            reduceMotion: reduceMotion,
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: dark
                    ? Brightness.light
                    : Brightness.dark,
                statusBarBrightness: dark ? Brightness.dark : Brightness.light,
                systemNavigationBarColor: Colors.transparent,
                systemNavigationBarDividerColor: Colors.transparent,
                systemNavigationBarIconBrightness: dark
                    ? Brightness.light
                    : Brightness.dark,
                systemStatusBarContrastEnforced: false,
                systemNavigationBarContrastEnforced: false,
              ),
              child: child ?? const SizedBox.shrink(),
            ),
          );
        },
        home: MainScaffold(motionEnabled: enableMotion),
      ),
    );
  }
}
