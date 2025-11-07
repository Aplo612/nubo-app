import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'reset_password_page.dart';

class IngresarCodigoPage extends StatefulWidget {
  final String email;
  const IngresarCodigoPage({super.key, required this.email});

  @override
  State<IngresarCodigoPage> createState() => _IngresarCodigoPageState();
}

class _IngresarCodigoPageState extends State<IngresarCodigoPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();
  bool _isChecking = false;

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  String? _codeValidator(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Ingrese el código';
    if (value.length != 4) return 'Código de 4 dígitos';
    return null;
  }

  Future<void> _verificar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isChecking = true);
    await Future.delayed(const Duration(milliseconds: 250)); // micro delay visual

    final code = _codeCtrl.text.trim();
    if (!mounted) return;

    if (code == '1234') {
      // Navega a la pantalla de cambio de contraseña
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ResetPasswordPage(email: widget.email),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Código inválido.')),
      );
    }

    if (mounted) setState(() => _isChecking = false);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        title: const Text('Verificar código'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Hemos enviado un código al correo:',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(color: Colors.black54),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.email,
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3E6EB),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextFormField(
                            controller: _codeCtrl,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              letterSpacing: 6,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                            validator: _codeValidator,
                            decoration: const InputDecoration(
                              hintText: '____',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton(
                            onPressed: _isChecking ? null : _verificar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3C82C3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              elevation: 0,
                            ),
                            child: _isChecking
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text(
                                    'Verificar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                  Text(
                    'Nubo ©Copyright 2025',
                    style: textTheme.bodySmall?.copyWith(color: Colors.black45),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
