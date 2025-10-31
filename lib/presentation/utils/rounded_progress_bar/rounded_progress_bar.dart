import 'package:flutter/material.dart';

class RoundedProgressBar extends StatelessWidget {
  const RoundedProgressBar({
    super.key,
    this.value,                 // 0..1
    this.percentage,            // 0..100
    this.height = 10,
    this.backgroundColor = const Color(0xFFE9EEF3),
    this.fillColor = const Color(0xFF4BA7E0),
    this.radius = 999,
    this.animationDuration = const Duration(milliseconds: 350),
    this.showPercentage = false,
    this.textStyle,
    this.percentageTextColor,
  }) : assert(value != null || percentage != null,
       'Debe especificar value (0..1) o percentage (0..100)');

  final double? value;
  final double? percentage;
  final double height;
  final Color backgroundColor;
  final Color fillColor;
  final double radius;
  final Duration animationDuration;

  final bool showPercentage;
  final TextStyle? textStyle;
  final Color? percentageTextColor;

  Color _bestTextColor(Color bg) {
    final lum = bg.computeLuminance();      // 0 oscuro .. 1 claro
    return lum < 0.5 ? Colors.white : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final double progress =
        (percentage != null ? (percentage! / 100) : (value ?? 0)).clamp(0.0, 1.0);

    // ¿El centro está sobre la parte llena? Si progress >= 0.5, sí.
    final Color centerBg = progress >= 0.5 ? fillColor : backgroundColor;
    final Color autoTextColor = _bestTextColor(centerBg);

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              return Stack(
                children: [
                  Container(
                    height: height,
                    width: width,
                    color: backgroundColor,
                  ),
                  AnimatedContainer(
                    duration: animationDuration,
                    curve: Curves.easeOut,
                    height: height,
                    width: width * progress,
                    color: fillColor,
                  ),
                ],
              );
            },
          ),
        ),

        if (showPercentage)
          Positioned.fill(
            child: Center(
              child: Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: (textStyle ??
                        Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ))
                    ?.copyWith(color: percentageTextColor ?? autoTextColor),
              ),
            ),
          ),
      ],
    );
  }
}
