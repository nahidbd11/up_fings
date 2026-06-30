import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'routes.dart';

void main() {
  runApp(const UpFingsApp());
}

class UpFingsApp extends StatelessWidget {
  const UpFingsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'UP@Fingertips',
      theme: AppTheme.light,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
