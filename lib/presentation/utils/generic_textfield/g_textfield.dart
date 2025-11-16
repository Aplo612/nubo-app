import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserField extends StatefulWidget {
  const UserField({
    super.key,
    this.labeltext,
    this.hintText,
    this.icon,
    this.text,
    this.listinput,
    this.validador,
    this.controller,
    this.focusNode,
    this.initialValue,
    this.onChanged,
    this.onFieldSubmitted,
    this.enabled = true,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.none,
    this.maxLength,
    this.backgroundColor = Colors.white,
  });

  // Existentes
  final String? labeltext;
  final String? hintText;
  final IconData? icon;
  final TextInputType? text;
  final List<TextInputFormatter>? listinput;
  final String? Function(String?)? validador;

  // Nuevos (controller / focus / comportamiento)
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? initialValue; // solo si no hay controller
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final bool enabled;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final int? maxLength;
  final Color backgroundColor;

  @override
  State<UserField> createState() => _UserFieldState();
}

class _UserFieldState extends State<UserField> {
  late final TextEditingController _controller;
  late final bool _ownsController;

  late final FocusNode _focusNode;
  late final bool _ownsFocusNode;

  @override
  void initState() {
    super.initState();

    // Controller
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? TextEditingController();
    if (_ownsController && widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }

    // Focus
    _ownsFocusNode = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const kFieldTextStyle   = TextStyle(fontSize: 16, height: 1.2, color: Colors.black87);
    const kHintStyle        = TextStyle(color: Colors.black54, fontSize: 16, height: 1.2);
    const kContentPadding   = EdgeInsets.symmetric(vertical: 14, horizontal: 16);
    const kIconConstraints  = BoxConstraints(minWidth: 48, minHeight: 48);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((widget.labeltext ?? '').isNotEmpty) ...[
          Text(
            widget.labeltext!,
            style: textTheme.displayMedium?.copyWith(color: Colors.black54),
          ),
          const SizedBox(height: 6),
        ],

        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          keyboardType: widget.text,
          inputFormatters: widget.listinput,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          maxLength: widget.maxLength,
          style: kFieldTextStyle,
          decoration: InputDecoration(
            counterText: widget.maxLength != null ? null : '', // oculta contador si no hay maxLength
            floatingLabelBehavior: FloatingLabelBehavior.never,
            hintText: widget.hintText,
            hintStyle: kHintStyle,
            filled: true,
            fillColor: widget.backgroundColor,
            isDense: false,
            prefixIcon: widget.icon != null
                ? Icon(widget.icon, size: 24, color: Colors.black54)
                : null,
            prefixIconConstraints: kIconConstraints,
            suffixIcon: const SizedBox.shrink(),
            suffixIconConstraints: kIconConstraints,
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
          validator: widget.validador,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
        ),
      ],
    );
  }
}
