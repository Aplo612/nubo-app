import 'package:flutter/material.dart';

class RecuperarContrasenaPage extends StatefulWidget {
  const RecuperarContrasenaPage({super.key});

  @override
  State<RecuperarContrasenaPage> createState() => _RecuperarContrasenaPageState();
}

class _RecuperarContrasenaPageState extends State<RecuperarContrasenaPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  String? _emailValidator(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Ingrese su correo';
    final emailRx = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRx.hasMatch(value)) return 'Correo no válido';
    return null;
  }

  Future<void> _onContinuar() async {
    if (!_formKey.currentState!.validate()) return;
    // TODO: Llama a tu API de recuperación con _emailCtrl.text.trim()
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Si el correo existe, enviaremos un mensaje.')),
    );
  }

  void _onEnviarDeNuevo() {
    // TODO: Reintentar envío (si ya se solicitó antes).
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reenviando correo…')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final padding = MediaQuery.of(context).size.width > 420 ? 32.0 : 20.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB), // gris muy claro como la imagen
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: padding).copyWith(top: 8, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título grande
              Text(
                'Recuperar contraseña',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Descripción
              Text(
                'Escriba el correo de su cuenta,\nsi existe se le enviará un correo.',
                style: textTheme.bodyMedium?.copyWith(color: Colors.black54, height: 1.35),
              ),
              const SizedBox(height: 24),

              // Formulario
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Campo correo
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      validator: _emailValidator,
                      decoration: InputDecoration(
                        hintText: 'Correo',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide.none,
                        ),
                        // Sombra suave como chip
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Enviar de nuevo
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: _onEnviarDeNuevo,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black54,
                          padding: EdgeInsets.zero,
                          textStyle: const TextStyle(decoration: TextDecoration.underline),
                        ),
                        child: const Text('Enviar de nuevo'),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Botón Continuar
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _onContinuar,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('Continuar'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Footer centrado
              Center(
                child: Text(
                  'Nubo ©Copyright 2025',
                  style: textTheme.bodySmall?.copyWith(color: Colors.black45),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
