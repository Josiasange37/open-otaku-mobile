import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'router/app_router.dart';

/// Root application widget.
class OpenOtakuApp extends StatelessWidget {
  const OpenOtakuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Open Otaku',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: appRouter,
    );
  }
}
