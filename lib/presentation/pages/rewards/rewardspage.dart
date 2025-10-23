import 'package:flutter/material.dart';

class RewardsPage extends StatelessWidget {
  static const String name = 'rewards_page';
  const RewardsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 8),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: const [
                Icon(Icons.monetization_on_rounded, size: 56),
                SizedBox(height: 8),
                Text('1500 nubo coin', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                SizedBox(height: 4),
                Text('Recompensa flash • 26:02:45'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(
          6,
          (i) => Card(
            child: ListTile(
              leading: const Icon(Icons.local_offer_rounded),
              title: Text('Cupón ${(i + 1) * 5}% OFF'),
              trailing: FilledButton(onPressed: () {}, child: const Text('Reclamar')),
            ),
          ),
        ),
      ],
    );
  }
}