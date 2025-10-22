import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nubo/config/config.dart';
import 'package:nubo/presentation/utils/generic_button/generic_button.dart';
import 'package:nubo/presentation/utils/generic_textfield/g_passwordtextfield.dart';
import 'package:nubo/presentation/utils/generic_textfield/g_textfield.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  // Clave global del formulario
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto
  final _emailController = TextEditingController();
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final _repeatController = TextEditingController();

  bool _termsAccepted = false;

  @override
  void dispose() {
    _emailController.dispose();
    _userController.dispose();
    _passController.dispose();
    _repeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const String vacio = 'No puede dejar este campo vacío';

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Flecha de retroceso
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),

            // Título principal
            Text(
              "Regístrate",
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium?.copyWith(
                fontFamily: robotoBold,
                fontSize: 34,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 28),

            // Campo correo
            UserField(
              icon: Icons.email_outlined,
              hintText: "Correo",
              controller: _emailController,
              validador: (String? value) {
                if (value == null || value.isEmpty) return vacio;
                final emailRegex = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(value)) {
                  return 'Ingrese un correo válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Campo usuario
            UserField(
              icon: Icons.person_outline,
              hintText: "Usuario",
              controller: _userController,
              validador: (String? value) {
                if (value == null || value.isEmpty) return vacio;
                if (value.length < 3) return 'Debe tener al menos 3 caracteres';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Campo contraseña
            PasswordField(
              controller: _passController,
              backgroundColor: Colors.white,
              hintText: "Contraseña",
              validator: (String? value) {
                if (value == null || value.isEmpty) return vacio;
                if (value.length < 8) {
                  return 'Debe tener al menos 8 caracteres';
                }
                if (!RegExp(r'^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$&*~])')
                    .hasMatch(value)) {
                  return 'Debe incluir mayúscula, número y símbolo';
                }
                return null;
              },
            ),

            // Helper de contraseña
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: Text(
                  "12 caracteres (número, letras, símbolo)",
                  style: textTheme.bodySmall?.copyWith(
                    fontFamily: robotoMedium,
                    fontStyle: FontStyle.italic,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Campo repetir contraseña
            PasswordField(
              controller: _repeatController,
              backgroundColor: Colors.white,
              hintText: "Repetir contraseña",
              validator: (String? value) {
                if (value == null || value.isEmpty) return vacio;
                if (value != _passController.text) {
                  return 'Las contraseñas no coinciden';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            // ¿Ya tienes cuenta? Inicia sesión
            RichText(
              text: TextSpan(
                style: textTheme.bodyMedium?.copyWith(
                  fontFamily: robotoBold,
                  color: Colors.black87,
                ),
                children: [
                  const TextSpan(text: "¿Ya tienes cuenta? "),
                  TextSpan(
                    text: "Inicia sesión",
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => context.pop(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Checkbox de términos
            Row(
              children: [
                Checkbox(
                  value: _termsAccepted,
                  onChanged: (v) => setState(() => _termsAccepted = v ?? false),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  activeColor: const Color(0xFF3C82C3), 
                  checkColor: Colors.white,             
                  side: const BorderSide(
                    color: Colors.grey,                
                    width: 1.5,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    "Acepto los términos y condiciones",
                    style: textTheme.bodyLarge?.copyWith(
                      fontFamily: robotoMedium,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Botón principal Registrarse
            ButtonCustom(
              text: "Registrarse",
              enabled: _termsAccepted, // controla si el botón se ve activo o gris
              onPressed: () {
                // si no está habilitado, salimos sin hacer nada
                if (!_termsAccepted) return;

                if (_formKey.currentState!.validate()) {
                  // TODO: lógica real de registro (API, Supabase, etc.)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Registro exitoso'),
                      duration: Duration(seconds: 2),
                    ),
                  );

                  context.pop(); // vuelve al login
                } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Por favor, corrige los errores antes de continuar',
                        style: TextStyle(
                          fontFamily: robotoSemiCondensedLight, // 👈 tu fuente personalizada
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.black87, // opcional, más contraste
                      behavior: SnackBarBehavior.floating, // opcional, más moderno
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }
              },
              width: double.infinity,
              padding: 16,
              color: const Color(0xFF3C82C3),
              colorHover: const Color(0xFF2E6EAC),
              colorText: Colors.white,
              fontsizeText: 18,
              disabledColor: Colors.grey.shade400,
              disabledTextColor: Colors.grey.shade200,
              disabledBorderColor: Colors.grey.shade300,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 6),
                ),
              ],
            ),


            const SizedBox(height: 36),

            // Footer
            const Text(
              "Nubo © 2025",
              textAlign: TextAlign.center,
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
