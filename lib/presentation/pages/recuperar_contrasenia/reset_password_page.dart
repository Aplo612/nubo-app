import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  const ResetPasswordPage({super.key, required this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _pwdCtrl = TextEditingController();
  final _pwd2Ctrl = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _validStrong = false;

  @override
  void dispose() {
    _pwdCtrl.dispose();
    _pwd2Ctrl.dispose();
    super.dispose();
  }

  bool _esFuerte(String v) {
    final value = v.trim();
    if (value.length < 8) return false;
    final hasLower = RegExp(r'[a-z]').hasMatch(value);
    final hasUpper = RegExp(r'[A-Z]').hasMatch(value);
    final hasDigit = RegExp(r'\d').hasMatch(value);
    final hasSpecial = RegExp(r'[^\w\s]').hasMatch(value);
    return hasLower && hasUpper && hasDigit && hasSpecial;
  }

  String? _pwdValidator(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Ingrese una contraseña';
    if (!_esFuerte(value)) {
      return 'Debe tener 8+ caracteres, mayúscula, minúscula, número y símbolo.';
    }
    return null;
  }

  String? _pwd2Validator(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Repita la contraseña';
    if (value != _pwdCtrl.text.trim()) return 'Las contraseñas no coinciden';
    return null;
  }

  void _onCambiosPwd(String v) {
    final strong = _esFuerte(v);
    if (strong != _validStrong) {
      setState(() => _validStrong = strong);
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    // Aquí enviarías al backend el cambio real de contraseña.
    // Por ahora, solo mostramos éxito y retrocedemos.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contraseña actualizada correctamente.')),
    );
    Navigator.of(context).popUntil((route) => route.isFirst); // vuelve al inicio del flujo
  }

  Widget _buildRequisitos() {
    final v = _pwdCtrl.text.trim();
    bool len = v.length >= 8;
    bool lower = RegExp(r'[a-z]').hasMatch(v);
    bool upper = RegExp(r'[A-Z]').hasMatch(v);
    bool digit = RegExp(r'\d').hasMatch(v);
    bool special = RegExp(r'[^\w\s]').hasMatch(v);

    Widget item(String label, bool ok) => Row(
      children: [
        Icon(ok ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16, color: ok ? Colors.green : Colors.black38),
        const SizedBox(width: 6),
        Expanded(child: Text(label, style: TextStyle(color: ok ? Colors.black87 : Colors.black54))),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        item('Al menos 8 caracteres', len),
        const SizedBox(height: 6),
        item('Una minúscula (a–z)', lower),
        const SizedBox(height: 6),
        item('Una mayúscula (A–Z)', upper),
        const SizedBox(height: 6),
        item('Un número (0–9)', digit),
        const SizedBox(height: 6),
        item('Un símbolo (!@#…)', special),
      ],
    );
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
        title: const Text('Nueva contraseña'),
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
                    'Ingrese una nueva contraseña para:',
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
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Nueva contraseña
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3E6EB),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextFormField(
                            controller: _pwdCtrl,
                            obscureText: _obscure1,
                            onChanged: _onCambiosPwd,
                            validator: _pwdValidator,
                            decoration: InputDecoration(
                              hintText: 'Nueva contraseña',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              suffixIcon: IconButton(
                                icon: Icon(_obscure1 ? Icons.visibility_off : Icons.visibility),
                                onPressed: () => setState(() => _obscure1 = !_obscure1),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _validStrong ? 'Contraseña fuerte' : 'Contraseña débil',
                            style: TextStyle(
                              color: _validStrong ? Colors.green : Colors.redAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildRequisitos(),
                        const SizedBox(height: 16),
                        // Repetir contraseña
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3E6EB),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextFormField(
                            controller: _pwd2Ctrl,
                            obscureText: _obscure2,
                            validator: _pwd2Validator,
                            decoration: InputDecoration(
                              hintText: 'Repetir contraseña',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              suffixIcon: IconButton(
                                icon: Icon(_obscure2 ? Icons.visibility_off : Icons.visibility),
                                onPressed: () => setState(() => _obscure2 = !_obscure2),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton(
                            onPressed: _guardar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3C82C3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Guardar nueva contraseña',
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
                    'Consejo: No reutilices contraseñas de otros servicios.',
                    style: textTheme.bodySmall?.copyWith(color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
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
