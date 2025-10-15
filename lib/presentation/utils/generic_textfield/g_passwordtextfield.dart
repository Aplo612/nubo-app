import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final String label;
  final String hintText;
  final String? Function(String?)? validator;

  const PasswordField({
    super.key,
    this.label = 'Contraseña',
    required this.hintText,
    this.validator,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  final _focusNode = FocusNode();
  bool _obscured = true;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleObscured() {
    setState(() => _obscured = !_obscured);
    // Mantener el foco en el campo
    if (!_focusNode.hasPrimaryFocus) {
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withValues(),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          focusNode: _focusNode,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          obscureText: _obscured,
          enableSuggestions: false,
          autocorrect: false,
          autofillHints: const [AutofillHints.password],
          decoration: InputDecoration(
            // Deja que el tema controle el estilo; solo define lo necesario.
            hintText: widget.hintText,
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              onPressed: _toggleObscured,
              tooltip: _obscured ? 'Mostrar contraseña' : 'Ocultar contraseña',
              icon: Icon(
                _obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              ),
            ),
          ),
          validator: widget.validator,
        ),
      ],
    );
  }
}
