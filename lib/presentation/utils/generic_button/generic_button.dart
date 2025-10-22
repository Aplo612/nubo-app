import 'package:flutter/material.dart';

/// Controlador externo para manipular el botón desde fuera.
class ButtonController extends ChangeNotifier {
  bool _enabled = true;
  String? _text;

  bool get enabled => _enabled;
  String? get text => _text;

  /// Cambia el texto del botón y notifica
  void changeText(String newText) {
    _text = newText;
    notifyListeners();
  }

  /// Habilita o deshabilita el botón
  void setEnabled(bool value) {
    _enabled = value;
    notifyListeners();
  }

  /// Ejecuta manualmente la acción del botón (si está habilitado)
  VoidCallback? _externalOnPressed;
  void attach(VoidCallback? onPressed) => _externalOnPressed = onPressed;
  void press() {
    if (_enabled && _externalOnPressed != null) {
      _externalOnPressed!.call();
    }
  }
}

class ButtonCustom extends StatefulWidget {
  final String? text;
  final VoidCallback? onPressed;
  final bool enabled;
  final ButtonController? controller;

  final IconData? icon;
  final TextStyle? textStyle;
  final double? iconSize;
  final Color? iconColor;
  final double gap;
  final double? width;
  final double? height;
  final double padding;
  final Color color;
  final Color colorHover;
  final Color? colorText;
  final double? fontsizeText;
  final bool hasBorder;
  final Color? colorBorder;
  final List<BoxShadow>? boxShadow;
  final Color? disabledColor;
  final Color? disabledTextColor;
  final Color? disabledBorderColor;

  const ButtonCustom({
    super.key,
    required this.padding,
    required this.color,
    required this.colorHover,
    this.text,
    this.onPressed,
    this.enabled = true,
    this.controller,
    this.icon,
    this.textStyle,
    this.iconSize,
    this.iconColor,
    this.gap = 8.0,
    this.width,
    this.height,
    this.colorText,
    this.fontsizeText,
    this.colorBorder,
    this.boxShadow,
    this.hasBorder = false,
    this.disabledColor,
    this.disabledTextColor,
    this.disabledBorderColor,
  }) : assert(text != null || icon != null,
            'Debes proveer al menos texto o icono.');

  @override
  State<ButtonCustom> createState() => _ButtonCustomState();
}

class _ButtonCustomState extends State<ButtonCustom> {
  bool _isHovered = false;
  String? _displayText;

  @override
  void initState() {
    super.initState();
    _displayText = widget.text;

    // Si tiene controller, lo conectamos
    widget.controller?.attach(widget.onPressed);
    widget.controller?.addListener(() {
      setState(() {
        _displayText =
            widget.controller!.text ?? widget.text; // usa el nuevo texto si hay
      });
    });
  }

  bool get _isDisabled => !widget.enabled;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // Colores efectivos según estado
    final Color effectiveBase = _isDisabled
        ? (widget.disabledColor ?? Colors.grey.shade400)
        : widget.color;

    final Color effectiveHover = _isDisabled
        ? (widget.disabledColor ?? Colors.grey.shade400)
        : widget.colorHover;

    final Color effectiveTextColor = _isDisabled
        ? (widget.disabledTextColor ?? Colors.grey.shade200)
        : (widget.colorText ?? Colors.white);

    final Color? effectiveBorderColor = widget.hasBorder
        ? (_isDisabled
            ? (widget.disabledBorderColor ?? Colors.grey.shade300)
            : (widget.colorBorder ?? Colors.transparent))
        : null;

    // Estilo de texto
    final TextStyle effectiveTextStyle = widget.textStyle ??
        (textTheme.displayMedium ?? const TextStyle()).copyWith(
          color: effectiveTextColor,
          fontSize: widget.fontsizeText ?? 16,
          fontWeight: FontWeight.w600,
        );

    // Contenido
    final List<Widget> content = [];
    if (widget.icon != null) {
      content.add(Icon(
        widget.icon,
        size: widget.iconSize ?? 20,
        color: widget.iconColor ?? effectiveTextStyle.color ?? Colors.black,
      ));
    }
    if (_displayText != null && _displayText!.isNotEmpty) {
      if (widget.icon != null) content.add(SizedBox(width: widget.gap));
      content.add(Text(_displayText!, style: effectiveTextStyle));
    }
    final Widget inner = content.length == 1
        ? content.first
        : Row(mainAxisSize: MainAxisSize.min, children: content);

    return MouseRegion(
      onEnter: (_) {
        if (!_isDisabled) setState(() => _isHovered = true);
      },
      onExit: (_) {
        if (!_isDisabled) setState(() => _isHovered = false);
      },
      child: InkWell(
        onTap: _isDisabled ? null : widget.onPressed, 
        borderRadius: BorderRadius.circular(8),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: _isHovered ? effectiveHover : effectiveBase,
            border: widget.hasBorder && effectiveBorderColor != null
                ? Border.all(
                    color: effectiveBorderColor,
                    width: 1.5,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  )
                : null,
            boxShadow: widget.boxShadow,
          ),
          width: widget.width,
          height: widget.height ?? 52,
          padding: EdgeInsets.all(widget.padding),
          child: Center(child: inner),
        ),
      ),
    );
  }
}
