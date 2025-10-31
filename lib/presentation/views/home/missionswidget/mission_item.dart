import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MissionItemCard extends StatelessWidget {
  const MissionItemCard({
    super.key,
    required this.iconAsset,
    this.title,
    this.subtitle,
    this.onTap,
    this.radius = 20,
    this.bgColor = const Color(0xFFE6EDF8),
    this.circleColor = const Color(0xFF004FB7),
    this.iconSize = 44,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
  });

  final String iconAsset;
  final String? title;
  final String? subtitle;
  final VoidCallback? onTap;

  final double radius;
  final Color bgColor;
  final Color circleColor;
  final double iconSize;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ícono circular
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  iconAsset,
                  width: iconSize,
                  height: iconSize,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              
              // Título (si existe)
              if (title != null && title!.isNotEmpty)
                Text(
                  title!,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    height: 1.15,
                    color: const Color(0xFF0E1A2B),
                  ),
                ),

              // Espaciado entre título y subtítulo
              if (title != null &&
                  title!.isNotEmpty &&
                  subtitle != null &&
                  subtitle!.isNotEmpty)
                const SizedBox(height: 6),

              // Subtítulo (si existe)
              if (subtitle != null && subtitle!.isNotEmpty)
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    height: 1.15,
                    color: const Color(0xFF4C5A6B),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
