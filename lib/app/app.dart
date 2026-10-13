import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/app/router/app_router.dart';
import 'package:saydaliati/app/sync/data_sync_controller.dart';
import 'package:saydaliati/core/constants/app_constants.dart';
import 'package:saydaliati/core/theme/app_theme.dart';
/// The root widget. Applies the app theme and forces Arabic / RTL app-wide via
/// the Arabic locale + Material localizations (which set `TextDirection.rtl` for
/// the whole widget tree — no manual `Directionality` needed).
class SaydaliatiApp extends ConsumerWidget {
  const SaydaliatiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    // Instantiate the offline sync orchestrator so it pushes queued writes and
    // re-pulls catalogs on startup and whenever connectivity returns (keepAlive
    // keeps it running for the whole session).
    ref.watch(dataSyncControllerProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }
}
