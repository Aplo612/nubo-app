import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nubo/config/config.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((widget.labeltext ?? '').isNotEmpty) ...[
          Text(
            widget.labeltext!,
            style: textTheme.displayMedium?.copyWith(color: gray400),
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
          style: textTheme.headlineMedium,
          decoration: InputDecoration(
            counterText: widget.maxLength != null ? null : '', // oculta contador si no hay maxLength
            floatingLabelBehavior: FloatingLabelBehavior.never,
            hintText: widget.hintText,
            hintStyle: textTheme.displayMedium?.copyWith(color: gray400),
            filled: true,
            fillColor: widget.backgroundColor,
            isDense: false,
            prefixIcon: widget.icon != null
                ? Icon(widget.icon, size: 24, color: gray400)
                : null,
            suffixIcon: const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
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
