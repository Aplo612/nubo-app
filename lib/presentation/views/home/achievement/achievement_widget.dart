import 'package:flutter/material.dart';
import 'package:nubo/presentation/utils/card_custom/card_custom.dart';
import 'package:nubo/presentation/utils/rounded_progress_bar/rounded_progress_bar.dart';

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({
    super.key,
    this.levelLabel = 'Nivel Plata',
    this.points = 75,
    this.progress = 0.62, // 0..1
    this.onSeeAll,
  });

  final String levelLabel;
  final int points;
  final double progress;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CardCustom(
      title: 'Logros',
      actionText: 'Ver todos mis logros',
      onAction: onSeeAll,
      enableShadow: false,
      children: [
        Row(
          children: [
            // trofeo suave
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFFE6F0F8),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.emoji_events_rounded,
                size: 18,
                color: Color(0xFF97B6D8),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '$levelLabel - $points puntos',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF22324D),
                ),
              ),
            ),
          ],
        ),
        // Barra de progreso
        RoundedProgressBar(
          value: progress.clamp(0, 1),
          height: 12,
          backgroundColor: const Color(0xFFE6ECF2), // gris claro
          fillColor: const Color(0xFF69B6E6),       // celeste (puedes usar tu primary)
        ),
      ],
    );
  }
}
