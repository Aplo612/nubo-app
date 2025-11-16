import 'package:flutter/material.dart';

/// Controlador para manejar el estado de visibilidad (obscure) y foco desde fuera.
class PasswordFieldController extends ChangeNotifier {
  bool _obscured;
  PasswordFieldController({bool initialObscured = true})
      : _obscured = initialObscured;

  bool get obscured => _obscured;

  void show() {
    if (!_obscured) return;
    _obscured = false;
    notifyListeners();
  }

  void hide() {
    if (_obscured) return;
    _obscured = true;
    notifyListeners();
  }

  void toggle() {
    _obscured = !_obscured;
    notifyListeners();
  }
}

class PasswordField extends StatefulWidget {
  /// Label arriba del input
  final String? label;

  /// Placeholder del TextFormField
  final String? hintText;

  /// Color del label
  final Color? colorText;

  /// Color de fondo del campo
  final Color? backgroundColor;

  /// Validador (Form)
  final String? Function(String?)? validator;

  /// Controller del texto (opcional). Si no se pasa, el widget crea uno interno.
  final TextEditingController? controller;

  /// Controller para visibilidad (opcional). Si no se pasa, el widget crea uno interno.
  final PasswordFieldController? visibilityController;

  /// Focus externo opcional (útil para mover el foco desde el padre)
  final FocusNode? focusNode;

  /// Callbacks opcionales
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;

  const PasswordField({
    super.key,
    this.label,
    this.hintText,
    this.colorText,
    this.backgroundColor,
    this.validator,
    this.controller,
    this.visibilityController,
    this.focusNode,
    this.onChanged,
    this.onFieldSubmitted,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  late final TextEditingController _textController;
  late final bool _ownsTextController;

  late final FocusNode _focusNode;
  late final bool _ownsFocusNode;

  late final PasswordFieldController _visibilityCtrl;
  late final bool _ownsVisibilityCtrl;

  @override
  void initState() {
    super.initState();

    // Text controller
    _ownsTextController = widget.controller == null;
    _textController = widget.controller ?? TextEditingController();

    // Focus
    _ownsFocusNode = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();

    // Visibility controller
    _ownsVisibilityCtrl = widget.visibilityController == null;
    _visibilityCtrl =
        widget.visibilityController ?? PasswordFieldController();

    // Escuchar cambios de visibilidad para redibujar
    _visibilityCtrl.addListener(_visibilityListener);
  }

  void _visibilityListener() {
    // Redibuja cuando cambie el estado (show/hide)
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _visibilityCtrl.removeListener(_visibilityListener);
    if (_ownsTextController) _textController.dispose();
    if (_ownsFocusNode) _focusNode.dispose();
    if (_ownsVisibilityCtrl) _visibilityCtrl.dispose();
    super.dispose();
  }

  void _toggleObscured() {
    _visibilityCtrl.toggle();
    // Mantener el foco en el campo al togglear
    if (!_focusNode.hasPrimaryFocus) {
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const kFieldTextStyle   = TextStyle(fontSize: 16, height: 1.2, color: Colors.black87);
    const kHintStyle        = TextStyle(color: Colors.black54, fontSize: 16, height: 1.2);
    const kContentPadding   = EdgeInsets.symmetric(vertical: 14, horizontal: 16);
    const kIconConstraints  = BoxConstraints(minWidth: 48, minHeight: 48);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null && widget.label!.isNotEmpty) ...[
          Text(
            widget.label!,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: widget.colorText ?? Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6)
        ],

        TextFormField(
          controller: _textController,
          focusNode: _focusNode,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          obscureText: _visibilityCtrl.obscured,
          enableSuggestions: false,
          autocorrect: false,
          autofillHints: const [AutofillHints.password],
          style: kFieldTextStyle,
          decoration: InputDecoration(
            hintText:
                (widget.hintText != null && widget.hintText!.isNotEmpty)
                    ? widget.hintText
                    : null,
            hintStyle: kHintStyle,
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            prefixIconColor: Colors.black54,
            prefixIconConstraints: kIconConstraints,
            suffixIcon: IconButton(
              onPressed: _toggleObscured,
              tooltip: _visibilityCtrl.obscured
                  ? 'Mostrar contraseña'
                  : 'Ocultar contraseña',
              icon: Icon(
                _visibilityCtrl.obscured
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
            suffixIconColor: Colors.black54,
            suffixIconConstraints: kIconConstraints,
            filled: true,
            fillColor: widget.backgroundColor ?? const Color(0xFFF1F4F8),
            isDense: false,
            contentPadding: kContentPadding,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Color(0xFF3C82C3), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            errorStyle: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
        ),
      ],
    );
  }
}
