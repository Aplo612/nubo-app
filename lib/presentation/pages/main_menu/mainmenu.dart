import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const String name = 'home_page';
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: List.generate(
          20,
          (i) => Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: const Icon(Icons.eco_rounded),
              title: Text('Módulo de inicio #$i'),
              subtitle: const Text('Misiones, logros y banners'),
            ),
          ),
        ),
      ),
    );
  }
}