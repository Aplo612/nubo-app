import 'package:flutter/material.dart';
import 'package:nubo/models/profile.dart';
import 'package:nubo/config/constants/enviroments.dart';
import 'package:nubo/presentation/utils/card_custom/card_custom.dart';

class BadgesGrid extends StatelessWidget {
  final List<ProfileBadge> badges;
  final VoidCallback onViewAll;
  const BadgesGrid({super.key, required this.badges, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final display = badges.take(6).toList();
    return CardCustom(
      title: 'Mis insignias',
      actionText: 'Ver todas',
      onAction: onViewAll,
      enableShadow: false,
      padding: const EdgeInsets.all(16),
      children: [
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: display.length,
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemBuilder: (_, i) {
            final b = display[i];
            return _BadgeTile(badge: b);
          },
        ),
      ],
    );
  }
}

class _BadgeTile extends StatelessWidget {
  final ProfileBadge badge;
  const _BadgeTile({required this.badge});

  @override
  Widget build(BuildContext context) {
    final bool unlocked = badge.unlocked;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: unlocked
            ? const LinearGradient(colors: [Color(0xFFFFF3C4), Color(0xFFFFE08A)])
            : null,
        color: unlocked ? null : Colors.grey.shade200,
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              unlocked ? badge.emoji : '🔒',
              style: const TextStyle(fontSize: 28),
            ),
          ),
          Positioned(
            left: 8,
            right: 8,
            bottom: 8,
            child:               Text(
                badge.title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: unlocked ? Colors.black87 : gray400,
                  fontFamily: robotoMedium,
                ),
              ),
          ),
        ],
      ),
    );
  }
}

