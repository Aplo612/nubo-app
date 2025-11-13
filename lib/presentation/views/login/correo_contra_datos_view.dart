import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nubo/config/config.dart';
import 'package:nubo/presentation/utils/generic_button/generic_button.dart';
import 'package:nubo/presentation/utils/generic_textfield/g_passwordtextfield.dart';
import 'package:nubo/presentation/utils/generic_textfield/g_textfield.dart';
import 'package:nubo/services/auth_service.dart';
import 'package:nubo/presentation/utils/navegation_router_utils/safe_navegation.dart';
import 'package:nubo/presentation/utils/snackbar/snackbar.dart';
import 'package:nubo/presentation/utils/generic_button/pill_button.dart';
import 'package:nubo/presentation/utils/generic_button/social_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _correoController.dispose();
    _passwordController.dispose();
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

          // === Nubes (no interactúan) ===
          IgnorePointer(                    // ⟵ evita interceptar taps
            child: Stack(children: [
              Positioned(left: -170, bottom: -190, child: _cloud(340, const Color(0xff6ecaf4))),
              Positioned(left: 40, right: 40, bottom: -160, child: _cloud(280, const Color(0xffb4e2ff))),
              Positioned(right: -170, bottom: -190, child: _cloud(340, const Color(0xbb6ecaf4))),
            ]),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              // Altura disponible de la viewport
              final height = constraints.maxHeight;
              // Altura del teclado (para que no tape el botón)
              final bottomInset = MediaQuery.of(context).viewInsets.bottom;
              final bool keyboardOpen = bottomInset > 0;

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
                      // cuando NO hay teclado, simulamos centrado con ~18% de altura;
                      // cuando hay teclado, lo dejamos cerca del top (24 px)
                      padding: EdgeInsets.only(top: keyboardOpen ? 24 : height * 0.18),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Flecha de retroceso (se mantiene aquí dentro)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  await Future.delayed(const Duration(milliseconds: 80));
                                  NavigationHelper.safePop(context);
                                },
                              ),
                            ),

                            // Título principal
                            Text(
                              "Iniciar Sesión",
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontFamily: robotoBold,
                                color: Colors.black87,
                                fontSize: 28,
                              ),
                            ),
                            const SizedBox(height: 28),

                            // === Form ===
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  // Correo
                                  UserField(
                                    controller: _correoController,
                                    icon: Icons.email_outlined,
                                    hintText: "Correo",
                                    validador: (String? value) {
                                      if (value == null || value.isEmpty) return vacio;
                                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                      if (!emailRegex.hasMatch(value)) {
                                        return 'Ingrese un correo válido';
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 20),

                                  // Campo de contraseña con validación
                                  PasswordField(
                                    controller: _passwordController,
                                    backgroundColor: Colors.white,
                                    hintText: "Contraseña",
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) return vacio;
                                      if (value.length < 6) {
                                        return 'Debe tener al menos 6 caracteres';
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 12),

                                  // Olvidaste tu contraseña
                                  TextButton(
                                    onPressed: () {
                                      NavigationHelper.safePush(context, '/recuperar');
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

                                  const SizedBox(height: 12),

                                  // === Botón principal con PillButton ===
                                  SizedBox(
                                    width: double.infinity,
                                    child: PillButton(
                                      text: _isLoading ? "..." : "Iniciar Sesión",
                                      onTap: _isLoading
                                          ? null
                                          : () async {
                                        if (_formKey.currentState!.validate()) {
                                          await _signInWithEmailAndPassword();
                                        } else {
                                          SnackbarUtil.showSnack(
                                            context,
                                            message: "Corrige los errores antes de continuar",
                                          );
                                        }
                                      },
                                      // estilos opcionales:
                                      bg: const Color(0xFF3C82C3),
                                      fg: Colors.white,
                                      elevation: 4,
                                      borderColor: Colors.transparent,
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // ¿No tienes cuenta?
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "¿Aún no tienes una cuenta?",
                                        style: textTheme.headlineMedium?.copyWith(
                                          fontFamily: robotoCondensedMedium,
                                          color: Colors.black87,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      GestureDetector(
                                        onTap: () => context.pushReplacementNamed('register_form_page'),
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
                                            googleSvg, // tu asset multicolor
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

                                  const Text(
                                    "Nubo © 2025",
                                    style: TextStyle(
                                      fontFamily: robotoMedium,
                                      color: Colors.black87,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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

  // Método para iniciar sesión con Firebase Auth
  Future<void> _signInWithEmailAndPassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService.signInWithEmailAndPassword(
        email: _correoController.text.trim(),
        password: _passwordController.text,
      );

      // Si el login es exitoso, navegar al home
      if (mounted) {
        SnackbarUtil.showSnack(context, message: '¡Inicio de sesión exitoso!', backgroundColor: Colors.green.shade600);
        NavigationHelper.safePushReplacement(context,'/home');
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtil.showSnack(context, message: e.toString() , backgroundColor: Colors.red.shade600, duration: Duration(seconds: 3));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Método para mostrar diálogo de recuperación de contraseña
  void _showPasswordResetDialog() {
    final TextEditingController emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Recuperar Contraseña',
            style: TextStyle(
              fontFamily: robotoBold,
              fontSize: 18,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Ingresa tu correo electrónico para recibir un enlace de recuperación:',
                style: TextStyle(
                  fontFamily: robotoRegular,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (emailController.text.isNotEmpty) {
                  try {
                    await AuthService.sendPasswordResetEmail(emailController.text.trim());
                    if (!context.mounted) return;
                    NavigationHelper.safePop(context);
                    SnackbarUtil.showSnack(context, message: '¡Inicio de sesión exitoso!', backgroundColor: Colors.green.shade600);
                  } catch (e) {
                    if (!context.mounted) return;
                    SnackbarUtil.showSnack(context, message: e.toString() , backgroundColor: Colors.red.shade600, duration: const Duration(seconds: 3));
                  }
                } else {
                  SnackbarUtil.showSnack(context, message: 'Por favor, ingresa tu correo electrónico.' , backgroundColor: Colors.red.shade600, duration: const Duration(seconds: 3));
                }
              },
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    );
  }
  static Widget _cloud(double size, Color color) {
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
}
