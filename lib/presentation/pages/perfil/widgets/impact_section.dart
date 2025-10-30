import 'package:flutter/material.dart';
import 'package:nubo/models/profile.dart';
import 'package:nubo/config/constants/enviroments.dart';

class ImpactSection extends StatelessWidget {
  final Stats stats;
  const ImpactSection({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [NuboColors.green400.withOpacity(0.2), NuboColors.green500.withOpacity(0.25)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tu Impacto Ambiental',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF22324D),
              fontFamily: robotoMedium,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _ImpactTile(title: 'Kg reciclados', value: '${stats.kgRecycled} kg')),
              const SizedBox(width: 12),
              Expanded(child: _ImpactTile(title: 'Botellas salvadas', value: '${stats.bottlesSaved}')),
            ],
          ),
        ],
      ),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F233D),
              fontFamily: robotoBold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF8A97A8),
              fontWeight: FontWeight.w600,
              fontFamily: robotoMedium,
            ),
          ),
        ],
      ),
    );
  }
}

