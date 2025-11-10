import 'package:nubo/config/config.dart';
import 'package:flutter/material.dart';
import 'config/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  debugFirebase();
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

void debugFirebase() {
  final app = Firebase.app();
  // Nombre y opciones activas
  debugPrint('🔥 Firebase app: ${app.name}');
  final options = app.options;
  debugPrint('🔥 ProjectId: ${options.projectId}');
  debugPrint('🔥 ApiKey: ${options.apiKey}');
  debugPrint('🔥 AppId: ${options.appId}');
}