import 'package:flutter/material.dart';
import 'package:nubo/config/constants/enviroments.dart';
import 'package:nubo/presentation/pages/rewards/widgets/reward_detail_modal.dart';

class RewardCard extends StatelessWidget {
  final String title;
  final String brand;
  final String? description;
  final int cost;
  final VoidCallback onClaim;
  final IconData? icon;
  final int? discount;

  const RewardCard({
    super.key,
    required this.title,
    required this.brand,
    this.description,
    required this.cost,
    required this.onClaim,
    this.icon,
    this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showDetailModal(context);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
        children: [
          // Ícono
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon ?? Icons.card_giftcard,
              color: primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          // Contenido
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: robotoBold,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  brand,
                  style: TextStyle(
                    fontFamily: robotoMedium,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: gray600,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    description!,
                    style: TextStyle(
                      fontFamily: robotoRegular,
                      fontSize: 12,
                      color: gray400,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Costo y botón
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$cost',
                    style: TextStyle(
                      fontFamily: robotoBold,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: warningActive,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Image.asset(
                    'assets/logo/nubo_coin.png',
                    width: 18,
                    height: 18,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: onClaim,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Reclamar',
                  style: TextStyle(
                    fontFamily: robotoBold,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  void _showDetailModal(BuildContext context) {
    RewardDetailModal.show(
      context,
      title: title,
      brand: brand,
      description: description ?? 'Aprovecha esta increíble oferta exclusiva para usuarios de NUBO.',
      details: description != null ? 'Válido según términos y condiciones.' : null,
      discount: discount ?? _extractDiscountFromTitle(title),
      cost: cost,
      benefits: description != null 
          ? ['Oferta especial disponible por tiempo limitado']
          : null,
      onClaim: onClaim,
    );
  }

  int _extractDiscountFromTitle(String title) {
    // Intentar extraer el descuento del título
    final regex = RegExp(r'(\d+)%');
    final match = regex.firstMatch(title);
    if (match != null) {
      return int.parse(match.group(1)!);
    }
    return 0;
  }
}

