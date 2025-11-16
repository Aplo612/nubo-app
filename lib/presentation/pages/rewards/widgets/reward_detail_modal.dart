import 'package:flutter/material.dart';
import 'package:nubo/config/constants/enviroments.dart';

class RewardDetailModal extends StatelessWidget {
  final String title;
  final String brand;
  final String? description;
  final String? details;
  final int discount;
  final int cost;
  final List<String>? benefits;
  final VoidCallback onClaim;

  const RewardDetailModal({
    super.key,
    required this.title,
    required this.brand,
    this.description,
    this.details,
    required this.discount,
    required this.cost,
    this.benefits,
    required this.onClaim,
  });

  static void show(
    BuildContext context, {
    required String title,
    required String brand,
    String? description,
    String? details,
    required int discount,
    required int cost,
    List<String>? benefits,
    required VoidCallback onClaim,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RewardDetailModal(
        title: title,
        brand: brand,
        description: description,
        details: details,
        discount: discount,
        cost: cost,
        benefits: benefits,
        onClaim: onClaim,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: gray200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header con badge, marca, título y logo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge y texto a la izquierda
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge de descuento
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: warningActive,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$discount%',
                          style: TextStyle(
                            fontFamily: robotoBold,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Marca
                      Text(
                        brand,
                        style: TextStyle(
                          fontFamily: robotoMedium,
                          fontSize: 16,
                          color: gray600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Título del cupón
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: robotoBold,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                // Logo/ícono a la derecha
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.local_cafe,
                    color: primary,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Descripción detallada
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Descripción principal
                  if (description != null)
                    _DetailRow(
                      icon: '✨',
                      text: description!,
                    ),
                  
                  // Benefits
                  if (benefits != null)
                    ...benefits!.map((benefit) => _DetailRow(
                      icon: _getIconForBenefit(benefit),
                      text: benefit,
                    )),
                  
                  // Detalles adicionales
                  if (details != null)
                    _DetailRow(
                      icon: '📍',
                      text: details!,
                    ),
                  
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Footer con costo y botón de reclamar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: gray200, width: 1),
              ),
            ),
            child: Row(
              children: [
                // Costo en monedas
                Row(
                  children: [
                    Text(
                      '$cost',
                      style: TextStyle(
                        fontFamily: robotoBold,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: warningActive,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Image.asset(
                      'assets/logo/nubo_coin.png',
                      width: 24,
                      height: 24,
                    ),
                  ],
                ),
                const Spacer(),
                // Botón de reclamar
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onClaim();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: warningActive,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.shopping_bag, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Reclamar',
                        style: TextStyle(
                          fontFamily: robotoBold,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getIconForBenefit(String benefit) {
    if (benefit.contains('exclusiva') || benefit.contains('Promoción')) {
      return '📌';
    } else if (benefit.contains('tiempo') || benefit.contains('limite')) {
      return '⏰';
    } else if (benefit.contains('sucursal') || benefit.contains('ubicación')) {
      return '📍';
    }
    return '✨';
  }
}

class _DetailRow extends StatelessWidget {
  final String icon;
  final String text;

  const _DetailRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: robotoRegular,
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

