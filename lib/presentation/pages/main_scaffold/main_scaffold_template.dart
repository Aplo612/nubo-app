import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nubo/config/config.dart';

class MainMenuScaffold extends StatelessWidget {
  final Widget child;
  const MainMenuScaffold({super.key, required this.child});

  int _calculateIndex(String location) {
    if (location.startsWith('/missions')) return 1;
    if (location.startsWith('/rewards')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0; // /home (default)
    }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0: context.go('/home'); break;
      case 1: context.go('/missions'); break;
      case 2: context.go('/rewards'); break;
      case 3: context.go('/profile'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _calculateIndex(location);

    return Scaffold(
      body: child,
      backgroundColor: background,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => _onTap(context, i),
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedLabelStyle: const TextStyle(
          fontFamily: robotoMedium, // usa tu fuente declarada en pubspec.yaml
          fontWeight: FontWeight.w400,
          letterSpacing: 0.2,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: robotoMedium,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.2,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bolt_rounded),
            label: 'Misiones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_rounded),
            label: 'Recompensas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
