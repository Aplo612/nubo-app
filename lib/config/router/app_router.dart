import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nubo/presentation/pages/pages.dart';

final _rootKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootKey,
  initialLocation: '/login',
  routes: [
    // ---------- Auth ----------
    GoRoute(
      path: '/login',
      name: LoginPage.name,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/login-form',
      name: LoginFormPage.name,
      builder: (context, state) => const LoginFormPage(),
    ),
    GoRoute(
      path: '/register',
      name: RegisterFormPage.name,
      builder: (context, state) => const RegisterFormPage(),
    ),

    // aqui pongan las partes que necesitan el menu persistentes de abajo
    ShellRoute(
      navigatorKey: _shellKey,
      builder: (context, state, child) => MainMenuScaffold(child: child),
      routes: [
        GoRoute(
          path: '/home',
          name: HomePage.name,
          pageBuilder: (_, __) => const NoTransitionPage(child: HomePage()),
        ),
        GoRoute(
          path: '/missions',
          name: MissionsPage.name,
          pageBuilder: (_, __) => const NoTransitionPage(child: MissionsPage()),
        ),
        GoRoute(
          path: '/rewards',
          name: RewardsPage.name,
          pageBuilder: (_, __) => const NoTransitionPage(child: RewardsPage()),
        ),
        GoRoute(
          path: '/profile',
          name: ProfilePage.name,
          pageBuilder: (_, __) => const NoTransitionPage(child: ProfilePage()),
        ),
      ],
    ),

    GoRoute(
      path: '/404',
      name: NotFoundPage.name,
      builder: (context, state) => const NotFoundPage(),
    ),
  ],
  errorBuilder: (_, __) => const NotFoundPage(),
);