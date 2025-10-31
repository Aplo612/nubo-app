import 'package:flutter/material.dart';
import 'package:nubo/presentation/utils/card_custom/card_custom.dart';

class RewardsSection extends StatelessWidget {
  const RewardsSection({
    super.key,
    this.onSeeAll,
    this.iconAsset = '', // PNG
    this.storeTitle = 'Tienda Nubo',
    this.storeSubtitle = '¡Hora de cambiar tus nubocoins!',
  });

  final VoidCallback? onSeeAll;
  final String iconAsset;
  final String storeTitle;
  final String storeSubtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CardCustom(
      title: 'Recompensas',
      actionText: 'Ver recompensas',
      enableShadow: false,
      onAction: onSeeAll,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icono PNG
            Image.asset(
              iconAsset,
              width: 72,
              height: 72,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 14),

            // Texto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    storeTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.orange, 
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Subtítulo
                  Text(
                    storeSubtitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF0F233D),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
