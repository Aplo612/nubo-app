import 'package:flutter/material.dart';
import 'package:nubo/config/config.dart';
import 'package:nubo/presentation/utils/generic_button/generic_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginButtons extends StatelessWidget {
  const LoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Logo arriba
        Image.asset(
          "assets/logo/nubo_logo_login.png",
          height: 202,
        ),
        const SizedBox(height: 32),
        ButtonCustom(
          text: "Ingresar",
          onPressed: () {
            // TODO: acción de login
          },
          width: double.infinity,
          textStyle: const TextStyle(
            fontFamily: robotoBold,
            fontSize: 16,
            letterSpacing: 0.2,
            color: Color.fromARGB(255, 71, 71, 71), // hack
          ),
          padding: 12,
          color: Colors.white,
          colorHover: Colors.grey.shade200,
          hasBorder: true,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Botón Registrarse
         ButtonCustom(
          text: "Registrarse",
          onPressed: () {
            // TODO: acción de login
          },
          width: double.infinity,
          colorText: Colors.grey.shade700,
          textStyle: const TextStyle(
            fontFamily: robotoBold,
            fontSize: 16,
            letterSpacing: 0.2,
            color: Color.fromARGB(255, 71, 71, 71), // hack
          ),
          padding: 12,
          color: Colors.white,
          colorHover: Colors.grey.shade200,
          hasBorder: true,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Línea separadora
        const Divider(thickness: 1),

        const SizedBox(height: 24),

        // Botones sociales (Google y Facebook)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ButtonCustom(
                icon: FontAwesomeIcons.google,
                iconColor: Colors.red,
                onPressed: () {
                  // TODO: login con Google
                },
                padding: 8,
                color: Colors.white,
                colorHover: Colors.grey.shade200,
                hasBorder: true,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ButtonCustom(
                icon: FontAwesomeIcons.facebook, // placeholder
                onPressed: () {
                  // TODO: login con Facebook
                },
                padding: 8,
                color: Colors.white,
                colorHover: Colors.grey.shade200,
                iconColor: Colors.blue,
                colorText: Colors.black,
                fontsizeText: 18,
                hasBorder: true,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
