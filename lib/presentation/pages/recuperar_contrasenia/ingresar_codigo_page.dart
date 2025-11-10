import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nubo/services/password_reset_rtdb_service.dart';
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
  bool _loading = false;

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _continuar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final ok = await PasswordResetRTDBService
          .validateOtp(widget.email, _codeCtrl.text);

      if (!ok) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Código inválido o vencido')),
        );
        return;
      }

      // Marca como usado para que no se reutilice
      await PasswordResetRTDBService.consumeOtp(widget.email);

      if (!mounted) return;
      // Aquí normalmente llamarías a tu backend (Admin SDK) para cambiar la contraseña.
      // Por ahora solo pasamos a la pantalla para ingresar la nueva contraseña.
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ResetPasswordPage(email: widget.email),
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Ingresar código')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Hemos generado un código para ${widget.email}. '
                'Tiene una duración de 5 minutos.',
                style: tt.bodyMedium,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _codeCtrl,
                autofocus: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                decoration: const InputDecoration(
                  labelText: 'Código de 6 dígitos',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final s = (v ?? '').trim();
                  if (s.isEmpty) return 'Ingrese el código';
                  if (s.length != 6) return 'Debe tener 6 dígitos';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _loading ? null : _continuar,
                child: Text(_loading ? 'Validando...' : 'Continuar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
