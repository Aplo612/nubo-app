import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nubo/config/config.dart';
import 'package:nubo/presentation/utils/generic_button/generic_button.dart';
import 'package:nubo/presentation/utils/generic_textfield/g_passwordtextfield.dart';
import 'package:nubo/presentation/utils/generic_textfield/g_textfield.dart';

class LoginForm extends StatelessWidget {
  final VoidCallback onBack;
  const LoginForm({super.key,  required this.onBack});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Flecha de retroceso
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: onBack,
                ),
              ),

              // Título principal
              Text(
                "Iniciar Sesión",
                style: textTheme.headlineMedium?.copyWith(
                  fontFamily: robotoBold,
                  color: Colors.black87,
                  fontSize: 28,
                ),
              ),

              const SizedBox(height: 36),

              // Campos de texto
              const UserField(icon: Icons.email_outlined, hintText: "Correo"),
              const SizedBox(height: 20),
              const PasswordField(backgroundColor: Colors.white, hintText: "Contraseña"),

              const SizedBox(height: 16),

              // Olvidaste tu contraseña
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    // TODO: Navegar a recuperación
                  },
                  child: Text(
                    "¿Olvidaste tu contraseña?",
                    style: textTheme.bodyMedium?.copyWith(
                        fontFamily: robotoBold,
                        color: Colors.black87,
                        decoration: TextDecoration.underline,
                      ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Botón principal de inicio de sesión
              ButtonCustom(
                text: "Iniciar Sesión",
                onPressed: () {
                  // TODO: Acción de login
                },
                width: double.infinity,
                padding: 14,
                color: const Color(0xFF3C82C3),
                colorHover: const Color(0xFF2E6EAC),
                colorText: Colors.white,
                fontsizeText: 18,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Texto de registro
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "¿Aún no tienes una cuenta?",
                    style: textTheme.headlineMedium?.copyWith(
                      fontFamily: robotoCondensedMedium,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      // TODO: Navegar a registro
                    },
                    child: Text(
                      "Regístrate",
                      style: textTheme.bodyMedium?.copyWith(
                        fontFamily: robotoBold,
                        color: Colors.black87,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              const Divider(thickness: 1),
              const SizedBox(height: 24),

              // Botones sociales
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ButtonCustom(
                      icon: FontAwesomeIcons.google,
                      iconColor: Colors.red,
                      onPressed: () {
                        // TODO: Login con Google
                      },
                      padding: 12,
                      color: Colors.white,
                      colorHover: Colors.grey.shade200,
                      textStyle: const TextStyle(
                        fontFamily: robotoBold,
                        fontSize: 16,
                        letterSpacing: 0.2,
                        color: Colors.blueGrey, // hack
                      ),
                      hasBorder: true,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ButtonCustom(
                      icon: FontAwesomeIcons.facebookF,
                      iconColor: Colors.blueAccent,
                      onPressed: () {
                        // TODO: Login con Facebook
                      },
                      padding: 12,
                      color: Colors.white,
                      colorHover: Colors.grey.shade200,
                      hasBorder: true,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Copyright
              const Text(
                "Nubo @Copyright 2025",
                style: TextStyle(
                  fontFamily: robotoMedium,
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
  }
}
