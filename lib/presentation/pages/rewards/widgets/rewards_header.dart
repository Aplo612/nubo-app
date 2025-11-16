import 'package:flutter/material.dart';
import 'package:nubo/config/constants/enviroments.dart';
import 'package:go_router/go_router.dart';

class RewardsHeader extends StatelessWidget {
  const RewardsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        Expanded(
          child: Text(
            'Recompensas',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: robotoBold,
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 48), // Balance para centrar el título
      ],
    );
  }
}

