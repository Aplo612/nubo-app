import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nubo/config/config.dart';
import 'package:nubo/presentation/utils/generic_button/generic_button.dart';
import 'package:nubo/presentation/utils/generic_textfield/g_passwordtextfield.dart';
import 'package:nubo/presentation/utils/generic_textfield/g_textfield.dart';
import 'package:nubo/services/auth_service.dart';

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

    return SafeArea(
      child: SingleChildScrollView(
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
                "Iniciar Sesión",
                style: textTheme.headlineMedium?.copyWith(
                  fontFamily: robotoBold,
                  color: Colors.black87,
                  fontSize: 28,
                ),
              ),

              const SizedBox(height: 36),

              // Campo de correo con validación
              UserField(
                controller: _correoController,
                icon: Icons.email_outlined,
                hintText: "Correo",
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

              const SizedBox(height: 16),

              // Olvidaste tu contraseña
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    _showPasswordResetDialog();
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
                text: _isLoading ? "Iniciando sesión..." : "Iniciar Sesión",
                width: double.infinity,
                padding: 14,
                color: const Color(0xFF3C82C3),
                colorHover: const Color(0xFF2E6EAC),
                colorText: Colors.white,
                fontsizeText: 18,
                enabled: !_isLoading,
                onPressed: _isLoading ? null : () async {
                  if (_formKey.currentState!.validate()) {
                    await _signInWithEmailAndPassword();
                  } else {
                    AuthService.showErrorSnackBar(
                      context,
                      'Por favor, corrige los errores antes de continuar',
                    );
                  }
                },
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
                    onTap: () => context.push('/register'),
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
                        color: Colors.blueGrey,
                      ),
                      hasBorder: true,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
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
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Footer
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
        AuthService.showSuccessSnackBar(context, '¡Inicio de sesión exitoso!');
        context.pushReplacement('/home');
      }
    } catch (e) {
      if (mounted) {
        AuthService.showErrorSnackBar(context, e.toString());
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
                    if (mounted) {
                      Navigator.of(context).pop();
                      AuthService.showSuccessSnackBar(
                        context,
                        'Se ha enviado un enlace de recuperación a tu correo.',
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      AuthService.showErrorSnackBar(context, e.toString());
                    }
                  }
                } else {
                  AuthService.showErrorSnackBar(context, 'Por favor, ingresa tu correo electrónico.');
                }
              },
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    );
  }
}
