import 'package:flutter/material.dart';
import 'package:nubo/config/config.dart';
import 'package:nubo/presentation/utils/card_custom/card_custom.dart';

class RecyclingSummaryCard extends StatelessWidget {
  const RecyclingSummaryCard({
    super.key,
    required this.kgThisMonth,          
    required this.bottlesApprox,       
    required this.impactPoints,         
    required this.location,            
    required this.iconAsset,
    this.onTap,
    this.enableShadow = true,
    this.onAction,
  });

  final double kgThisMonth;
  final int bottlesApprox;
  final int impactPoints;
  final String location;
  final String iconAsset;
  final VoidCallback? onTap;
  final bool enableShadow;
  final VoidCallback? onAction;

@override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CardCustom(
      onAction: onAction,
      enableShadow: false,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icono circular verde
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFE7F8E9), // fondo suave
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Image.asset(
                recycleGreen,
                width: 99, // un poco más grande
                fit: BoxFit.contain,
                semanticLabel: 'Reciclaje verde',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Este mes llevas',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF22324D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_trimZeros(kgThisMonth)} kg reciclados',
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 28,
                      color: const Color(0xFF0F233D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '(≈ $bottlesApprox botellas)',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF8A97A8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Text(
          'Reduciste - $impactPoints puntos de contaminación en $location',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF22324D),
          ),
        ),
      ],
    );
  }

  String _trimZeros(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(1);
  }
}
