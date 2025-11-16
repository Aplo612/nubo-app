import 'package:flutter/material.dart';
import 'package:nubo/models/profile.dart';
import 'package:nubo/config/constants/enviroments.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onRewards;
  final VoidCallback onStats;
  const ActionButtons({
    super.key,
    required this.onRewards,
    required this.onStats,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        children: [
          Expanded(child: _PrimaryButton(icon: Icons.card_giftcard, label: 'Mis Recompensas', color: warningActive, onTap: onRewards)),
          const SizedBox(width: 12),
          Expanded(child: _PrimaryButton(icon: Icons.emoji_events, label: 'Ranking', color: warningActive, onTap: onStats)),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _PrimaryButton({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontFamily: robotoBold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


