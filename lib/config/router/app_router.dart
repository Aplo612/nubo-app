import 'package:go_router/go_router.dart';
import 'package:nubo/presentation/pages/pages.dart';

// GoRouter configuration
final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
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
      path: '/register-form',
      name: RegisterFormPage.name,
      builder: (context, state) => const RegisterFormPage(),
    ),
    GoRoute(
      path: '/404',
      name: NotFoundPage.name,
      builder: (context, state) => const NotFoundPage(),
    )
  ],
  errorBuilder: (context, state) {
    return const NotFoundPage(); 
  },

  // (opcional) transición y/o page-level:
  // errorPageBuilder: (context, state) => MaterialPage(
  //   key: state.pageKey,
  //   child: const NotFoundPage(),
  // ),
);
