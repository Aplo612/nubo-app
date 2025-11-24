import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nubo/presentation/pages/pages.dart';
import '../../presentation/views/home/rankings/rankings_view.dart';


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
      path: '/recuperar',
      builder: (context, state) => const RecuperarContrasenaPage(),
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
        GoRoute(
          path: '/collection-points',
          name: 'collectionPoints',
          pageBuilder: (_, __) => const NoTransitionPage(
            child: CollectionPointsPage(),
          ),
        ),
      ],
    ),

    GoRoute(
      path: '/rankings',
      name: RankingsPage.routeName,
      builder: (_, __) => const RankingsPage(),
    ),

    GoRoute(
      path: '/agent-val',
      name: AgentValidateMissionPage.name,
      builder: (_, __) => const AgentValidateMissionPage(),
    ),

    GoRoute(
      path: '/validator',
      name: ValidatorPage.name,
      builder: (_, __) => const ValidatorPage(),
    ),

    GoRoute(
      path: '/404',
      name: NotFoundPage.name,
      builder: (context, state) => const NotFoundPage(),
    ),
    GoRoute(
      path: '/collection-points/filter',
      name: 'collectionPointsFilter',
      pageBuilder: (context, state) {
        final initialFilter = state.extra as CollectionPointFilter?;
        return CustomTransitionPage(
          child: CollectionPointsFilterPage(initialFilter: initialFilter),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final offset = Tween(begin: const Offset(0, 0.1), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeOutCubic))
                .animate(animation);
            return SlideTransition(position: offset, child: FadeTransition(opacity: animation, child: child));
          },
        );
      },
    ),
  ],
  errorBuilder: (_, __) => const NotFoundPage(),
);