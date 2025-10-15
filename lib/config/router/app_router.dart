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
    )
  ],
);
