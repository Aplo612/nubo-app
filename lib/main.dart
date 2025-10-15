import 'package:nubo/config/config.dart';
import 'package:flutter/material.dart';
import 'config/theme/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Nubo',
        routerConfig: appRouter,
        theme: AppTheme().getTheme(),
    );
  }
}
