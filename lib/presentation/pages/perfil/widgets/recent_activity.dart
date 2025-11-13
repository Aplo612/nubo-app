import 'package:flutter/material.dart';
import 'package:nubo/models/profile.dart';

class RecentActivity extends StatelessWidget {
  final List<Activity> activities;
  const RecentActivity({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    final display = activities.take(5).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Actividad Reciente', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          ...display.map((a) => _ActivityTile(activity: a)).toList(),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final Activity activity;
  const _ActivityTile({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: NuboColors.blue100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.recycling, color: NuboColors.blue500, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(_dateString(activity.date), style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(Icons.monetization_on, color: NuboColors.amber400, size: 18),
              const SizedBox(width: 4),
              Text('+${activity.points}', style: const TextStyle(fontWeight: FontWeight.w800)),
            ],
          )
        ],
      ),
    );
  }

  String _dateString(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }
}

