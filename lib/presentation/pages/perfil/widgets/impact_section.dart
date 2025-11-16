import 'package:flutter/material.dart';
import 'package:nubo/models/profile.dart';
import 'package:nubo/config/constants/enviroments.dart';
import 'package:nubo/presentation/utils/card_custom/card_custom.dart';

class ImpactSection extends StatelessWidget {
  final Stats stats;
  const ImpactSection({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return CardCustom(
      title: 'Tu impacto ambiental',
      enableShadow: false,
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(child: _ImpactTile(title: 'kg reciclados', value: '${stats.kgRecycled} kg')),
            const SizedBox(width: 12),
            Expanded(child: _ImpactTile(title: 'botellas salvadas', value: '${stats.bottlesSaved}')),
          ],
        ),
      ],
    );
  }
}

class _ImpactTile extends StatelessWidget {
  final String title;
  final String value;
  const _ImpactTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: gray50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              fontFamily: robotoBold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: gray600,
              fontWeight: FontWeight.w500,
              fontFamily: robotoMedium,
            ),
          ),
        ],
      ),
    );
  }
}

