import 'package:nubo/config/config.dart';
import 'package:flutter/material.dart';
import 'config/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
