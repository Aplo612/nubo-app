import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nubo/models/profile.dart';
import 'package:nubo/config/constants/enviroments.dart';

class StatsCards extends StatelessWidget {
  final Stats stats;
  const StatsCards({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _StatCard(
            title: 'Nubo Coins',
            value: stats.nuboCoinsCurrent.toString(),
            color: warningActive,
            leading: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: warningLight,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                nuboCoinSvg,
                width: 18,
                height: 18,
                colorFilter: const ColorFilter.mode(
                  warningActive,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          _StatCard(
            title: 'Racha',
            value: '${stats.streakDays}d',
            color: warningActive,
            leading: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: warningLight,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                streakSvg,
                width: 18,
                height: 18,
                colorFilter: const ColorFilter.mode(warningActive, BlendMode.srcIn),
              ),
            ),
          ),
          _StatCard(
            title: 'Misiones',
            value: stats.missionsCompleted.toString(),
            color: lightblue,
            leading: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: lightblueLight,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.emoji_events_rounded, color: lightblue, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final Widget leading;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
    required this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            leading,
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F233D),
                fontFamily: robotoBold,
              ),
            ),
            const SizedBox(height: 2),
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
      ),
    );
  }
}

