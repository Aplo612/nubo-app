import 'package:flutter/material.dart';

class CardCustom extends StatelessWidget {
  const CardCustom({
    super.key,
    this.title,
    required this.children,
    this.actionText,
    this.onAction,
    this.backgroundColor,
    this.margin,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 16,
    this.boxShadow,
    this.spacing = 16,
    this.enableShadow = true,
  });

  final String? title;
  final String? actionText;
  final VoidCallback? onAction;

  final List<Widget> children;

  final Color? backgroundColor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;
  final double spacing;
  final bool enableShadow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Calculamos sombra efectiva solo si está habilitada
    final List<BoxShadow>? effectiveShadow =
        enableShadow ? (boxShadow ?? _defaultShadow(context)) : null;

    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: effectiveShadow,
      ),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: título + acción opcional
            if ((title != null && title!.isNotEmpty) || actionText != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Título
                  if (title != null && title!.isNotEmpty)
                    Expanded(
                      child: Text(
                        title!,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F233D),
                        ),
                      ),
                    )
                  else
                    const Spacer(),

                  // Acción clickeable
                  if (actionText != null)
                    InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: onAction,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            actionText!,
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF004FB7),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 20,
                            color: Color(0xFF004FB7),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

            // Espaciado solo si hay header
            if ((title != null && title!.isNotEmpty) || actionText != null)
              const SizedBox(height: 12),

            // Cuerpo del contenido
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: children,
            ),
          ],
        ),
      ),
    );
  }

  List<BoxShadow> _defaultShadow(BuildContext context) {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.50),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ];
  }
}
