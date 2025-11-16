import 'package:flutter/material.dart';
import 'package:nubo/models/profile.dart';
import 'package:nubo/config/constants/enviroments.dart';
import 'package:nubo/presentation/utils/card_custom/card_custom.dart';

class RecentActivity extends StatelessWidget {
  final List<Activity> activities;
  const RecentActivity({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    final display = activities.take(3).toList();
    return CardCustom(
      title: 'Actividad Reciente',
      enableShadow: false,
      padding: const EdgeInsets.all(16),
      children: [
        ...display.map((a) => _ActivityTile(activity: a)).toList(),
      ],
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
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.recycling, color: primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: robotoBold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _dateString(activity.date),
                  style: TextStyle(
                    fontSize: 12,
                    color: gray400,
                    fontFamily: robotoRegular,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(Icons.monetization_on, color: warningActive, size: 18),
              const SizedBox(width: 4),
              Text(
                '+${activity.points}',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontFamily: robotoBold,
                  color: warningActive,
                ),
              ),
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

