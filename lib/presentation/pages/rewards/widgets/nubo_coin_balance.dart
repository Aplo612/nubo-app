import 'package:flutter/material.dart';
import 'package:nubo/config/constants/enviroments.dart';

class NuboCoinBalance extends StatelessWidget {
  final int balance;

  const NuboCoinBalance({
    super.key,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Moneda grande
          Image.asset(
            'assets/logo/nubo_coin.png',
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 12),
          // Balance en texto
          Text(
            '$balance nubo coin',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: robotoBold,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: warningActive,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

