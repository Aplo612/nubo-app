import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nubo/config/config.dart';
import 'package:nubo/presentation/utils/generic_button/generic_button.dart';
import 'package:nubo/presentation/utils/generic_textfield/g_passwordtextfield.dart';
import 'package:nubo/presentation/utils/generic_textfield/g_textfield.dart';
import 'package:nubo/services/auth_service.dart';
import 'package:nubo/presentation/utils/navegation_router_utils/safe_navegation.dart';
import 'package:nubo/presentation/utils/snackbar/snackbar.dart';

import '../../utils/generic_button/social_button.dart';

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

    return SizedBox.expand(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
        // === Degradado superior ===
        Positioned(
        top: 0, left: 0, right: 0,
        child: Container(
          height: 70,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFBFE6FF), Colors.white],
            ),
          ),
        ),
      ),

      // === Nubes decorativas (no interactúan) ===
      IgnorePointer(
        child: Stack(
          children: [
            Positioned(left: -170, bottom: -240, child: _cloud(340, const Color(0xff6ecaf4))),
            Positioned(left: 40, right: 40, bottom: -210, child: _cloud(280, const Color(0xffb4e2ff))),
            Positioned(right: -170, bottom: -240, child: _cloud(340, const Color(0xbb6ecaf4))),
          ],
        ),
      ),

      // === Contenido con scroll y centrado adaptativo (igual que Login) ===
      LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          final bottomInset = MediaQuery.of(context).viewInsets.bottom;
          final insets = MediaQuery.of(context).viewInsets;
          final keyboardOpen = insets.bottom > 0;
          final double topBase = (height * 0.10).clamp(16.0, 88.0);

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24, 0, 24, bottomInset + 3),
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: height),
              child: Align(
                alignment: Alignment.topCenter,
                child: AnimatedPadding(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  padding: EdgeInsets.only(top: keyboardOpen ? 16 : topBase),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Flecha de retroceso (igual comportamiento que Login)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.black87),
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                await Future.delayed(const Duration(milliseconds: 80));
                                if (!context.mounted) return;
                                // ignore: use_build_context_synchronously
                                NavigationHelper.safePop(context);
                              },
                            ),
                          ),

                          // Título
                          Text(
                            "Regístrate",
                            textAlign: TextAlign.center,
                            style: textTheme.headlineMedium?.copyWith(
                              fontFamily: robotoBold,
                              fontSize: 28,
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

                          const SizedBox(height: 1),

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
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 14,
                                height: 1.25,
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withValues(alpha: 0.78),
                                letterSpacing: .1,
                              ),
                              children: [
                                const TextSpan(text: "¿Ya tienes cuenta? "),
                                TextSpan(
                                  text: "Inicia sesión",
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => context.pushReplacementNamed('login_form_page'),
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: .1,
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

                          const SizedBox(height: 22),
                          Opacity(
                            opacity: .5,
                            child: Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          const SizedBox(height: 18),

                          // === Botones sociales con SocialButton ===
                          Row(
                            children: [
                              Expanded(
                                child: SocialButton(
                                  label: 'Google',
                                  onTap: () {/* TODO: Google sign-in */},
                                  iconWidget: SvgPicture.asset(
                                    googleSvg,
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: SocialButton(
                                  label: 'Facebook',
                                  onTap: () {/* TODO: Facebook sign-in */},
                                  iconWidget: SvgPicture.asset(
                                    facebookSvg,
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
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
                  ),
                ),
              ),
            ),
          );
        },
      ),
        ],
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
        displayName:  user,
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
      if (!context.mounted) return;
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

Widget _cloud(double size, Color color) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 12,
          offset: Offset(0, 6),
        ),
      ],
    ),
  );
}