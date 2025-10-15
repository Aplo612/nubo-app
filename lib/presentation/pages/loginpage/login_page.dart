import 'package:flutter/material.dart';
import 'package:nubo/presentation/views/login/login_view.dart';
import 'package:nubo/presentation/views/login/correo_contra_datos_view.dart';

class LoginPage extends StatefulWidget {
  static const String name = "login_page";
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _mostrarCorreoContraDatos = false; // Controla qué vista mostrar

  void _irACorreoContraDatos() {
    debugPrint('➡️ _irACorreoContraDatos()');
    setState(() => _mostrarCorreoContraDatos = true);
  }

  void _volverALoginButtons() {
    debugPrint('⬅️ _volverALoginButtons()');
    setState(() => _mostrarCorreoContraDatos = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                final offsetAnim = Tween<Offset>(
                  begin: const Offset(0.1, 0), end: Offset.zero,
                ).animate(animation);
                return SlideTransition(position: offsetAnim, child: child);
              },
              child: _mostrarCorreoContraDatos
                  ? LoginForm(
                      key: const ValueKey('correo_contra_datos'),
                      onBack: _volverALoginButtons,
                    )
                  : LoginButtons(
                      key: const ValueKey('login_buttons'),
                      onLoginPressed: _irACorreoContraDatos,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
