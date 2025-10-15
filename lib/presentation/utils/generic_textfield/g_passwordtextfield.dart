import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final Color? colorText;
  final Color? backgroundColor;
  final String? Function(String?)? validator;

  const PasswordField({
    super.key,
    this.label,
    this.hintText,
    this.colorText,
    this.backgroundColor,
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
        if (widget.label != null && widget.label!.isNotEmpty) ...[
          Text(
            widget.label!,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: widget.colorText ?? Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
        ],

        TextFormField(
          focusNode: _focusNode,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          obscureText: _obscured,
          enableSuggestions: false,
          autocorrect: false,
          autofillHints: const [AutofillHints.password],
          decoration: InputDecoration(

            hintText: widget.hintText?.isNotEmpty == true ? widget.hintText : null,
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              onPressed: _toggleObscured,
              tooltip: _obscured ? 'Mostrar contraseña' : 'Ocultar contraseña',
              icon: Icon(
                _obscured
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
            filled: true,
            fillColor: widget.backgroundColor ?? const Color(0xFFF1F4F8),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
          ),
          validator: widget.validator,
        ),
      ],
    );
  }
}
