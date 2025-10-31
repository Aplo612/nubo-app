import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nubo/config/config.dart';
import 'package:nubo/presentation/utils/generic_button/generic_button.dart';
import 'package:nubo/presentation/utils/generic_textfield/g_passwordtextfield.dart';
import 'package:nubo/presentation/utils/generic_textfield/g_textfield.dart';
import 'package:nubo/services/auth_service.dart';
import 'package:nubo/presentation/utils/navegation_router_utils/safe_navegation.dart';
import 'package:nubo/presentation/utils/snackbar/snackbar.dart';

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
  bool _isLoading = false;

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
                onPressed: () => NavigationHelper.safePop(context), // vuelve al login
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
                      ..onTap = () => NavigationHelper.safePop(context), // vuelve al login
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
              text: _isLoading ? "Registrando..." : "Registrarse",
              enabled: _termsAccepted && !_isLoading, // controla si el botón se ve activo o gris
              onPressed: () {
                // si no está habilitado, salimos sin hacer nada
                if (!_termsAccepted || _isLoading) return;

                if (_formKey.currentState!.validate()) {
                  _registerWithEmailAndPassword();
                } else {
                  SnackbarUtil.showSnack(context, message: 'Corrige los errores antes de continuar');
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

  // Método para registrar usuario con Firebase Auth
  Future<void> _registerWithEmailAndPassword() async {
    if (_isLoading) return; // evita taps dobles

    final email = _emailController.text.trim();
    final pass  = _passController.text;
    final user  = _userController.text.trim();

    // Validación rápida
    if (email.isEmpty || pass.isEmpty || user.isEmpty) {
      SnackbarUtil.showSnack(
        context,
        message: 'Completa email, contraseña y nombre de usuario.',
        backgroundColor: Colors.red.shade600,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {  
      // 1) Crear usuario
      await AuthService.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      // 2) Actualizar perfil
      await AuthService.updateUserProfile(displayName: user);

      // 3) Enviar verificación
      await AuthService.sendEmailVerification();

      // Tras los awaits, proteger el BuildContext que vas a usar
      if (!context.mounted) return;

      SnackbarUtil.showSnack(
        context,
        message: '¡Registro exitoso! Revisa tu correo para verificar tu cuenta.',
        backgroundColor: Colors.green.shade600,
        duration: const Duration(seconds: 10),
      );

      // Navega “seguro” (pop si puede, o tu fallback)
      NavigationHelper.safePop(context);
    } catch (e) {
      if(!context.mounted) return;
      SnackbarUtil.showSnack(context, message: e.toString() , backgroundColor: Colors.red.shade600, duration: const Duration(seconds: 3));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
