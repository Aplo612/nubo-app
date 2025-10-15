import 'package:flutter/material.dart';

class ButtonCustom extends StatefulWidget {
  /// Texto opcional. Si no usas texto, pasa null y usa [icon].
  final String? text;

  /// Callback de tap.
  final VoidCallback onPressed;

  /// Opcional: Icono a mostrar (si lo pasas sin texto, el botón será solo icono).
  final IconData? icon;

  /// Estilo del texto (sobrescribe color/size antiguos si lo pasas).
  final TextStyle? textStyle;

  /// Tamaño del icono (si [icon] != null).
  final double? iconSize;

  /// Color del icono (si [icon] != null).
  final Color? iconColor;

  /// Espacio entre icono y texto cuando ambos se usan.
  final double gap;

  final double? width;
  final double? height;
  final double padding;
  final Color color;
  final Color colorHover;
  final Color? colorText;      // compat: si no pasas textStyle, se usa este
  final double? fontsizeText;  // compat: si no pasas textStyle, se usa este
  final bool hasBorder;
  final Color? colorBorder;
  final List<BoxShadow>? boxShadow;

  const ButtonCustom({
    super.key,
    required this.onPressed,
    this.text,
    this.icon,
    this.textStyle,
    this.iconSize,
    this.iconColor,
    this.gap = 8.0,
    this.width,
    this.height,
    required this.padding,
    required this.color,
    required this.colorHover,
    this.colorText,
    this.fontsizeText,
    this.colorBorder,
    this.boxShadow,
    this.hasBorder = false,
  }) : assert(
          text != null || icon != null,
          'Debes proveer al menos texto o icono.',
        );

  @override
  State<ButtonCustom> createState() => _ButtonCustomState();
}

class _ButtonCustomState extends State<ButtonCustom> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // Estilo de texto final (respeta textStyle si viene; si no, usa tus props previas)
    final TextStyle effectiveTextStyle = widget.textStyle ??
        (textTheme.displayMedium ?? const TextStyle()).copyWith(
          color: widget.colorText,
          fontSize: widget.fontsizeText,
        );

    // Contenido central dinámico (icono, texto o ambos)
    final List<Widget> content = [];

    if (widget.icon != null) {
      content.add(Icon(
        widget.icon,
        size: widget.iconSize ?? 20,
        color: widget.iconColor ?? effectiveTextStyle.color ?? Colors.black,
      ));
    }

    final hasText = (widget.text != null && widget.text!.isNotEmpty);
    if (hasText) {
      if (widget.icon != null) content.add(SizedBox(width: widget.gap));
      content.add(Text(widget.text!, style: effectiveTextStyle));
    }

    // Si solo hay un hijo, evita Row para mantener centro correcto
    final Widget inner =
        content.length == 1 ? content.first : Row(mainAxisSize: MainAxisSize.min, children: content);
  
    return InkWell(
      onTap: widget.onPressed,
      onHover: (value) => setState(() => _isHovered = value),
      borderRadius: BorderRadius.circular(4),
      // Ripple notorio
      splashFactory: InkRipple.splashFactory,
      radius: 400,
      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.pressed)) {
          return widget.colorHover.withValues(alpha: 0.85);
        }
        if (states.contains(WidgetState.hovered)) {
          return widget.colorHover.withValues(alpha: 0.20);
        }
        if (states.contains(WidgetState.focused)) {
          return widget.colorHover.withValues(alpha: 0.80);
        }
        return null;
      }),
      highlightColor: widget.colorHover.withValues(alpha: 0.85),
      splashColor: widget.colorHover.withValues(alpha: 0.80),

      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: _isHovered ? widget.colorHover : widget.color,
          border: widget.hasBorder
              ? Border.all(
                  color: widget.colorBorder ?? Colors.grey.shade300,
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
    );
  }
}
