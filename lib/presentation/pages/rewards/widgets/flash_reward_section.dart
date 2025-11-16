import 'package:flutter/material.dart';
import 'package:nubo/config/constants/enviroments.dart';
import 'package:nubo/presentation/pages/rewards/widgets/reward_detail_modal.dart';

class FlashRewardSection extends StatelessWidget {
  final String title;
  final String brand;
  final String description;
  final String details;
  final int discount;
  final int cost;
  final String timerText;
  final VoidCallback onClaim;

  const FlashRewardSection({
    super.key,
    required this.title,
    required this.brand,
    required this.description,
    required this.details,
    required this.discount,
    required this.cost,
    required this.timerText,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tarjeta naranja grande
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: warningActive,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Título "RECOMPENSA FLASH"
              Text(
                'RECOMPENSA FLASH',
                style: TextStyle(
                  fontFamily: robotoBold,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              // Timer
              Text(
                timerText,
                style: TextStyle(
                  fontFamily: robotoBold,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 16),
              // Tarjeta interna con la recompensa
              InkWell(
                onTap: () {
                  _showDetailModal(context);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge de descuento
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: warningActive,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$discount%',
                            style: TextStyle(
                              fontFamily: robotoBold,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Marca
                    Text(
                      brand,
                      style: TextStyle(
                        fontFamily: robotoMedium,
                        fontSize: 14,
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
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Descripción
                    Text(
                      description,
                      style: TextStyle(
                        fontFamily: robotoRegular,
                        fontSize: 12,
                        color: gray600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      details,
                      style: TextStyle(
                        fontFamily: robotoRegular,
                        fontSize: 12,
                        color: gray600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Costo y botón
                    Row(
                      children: [
                        Row(
                          children: [
                            Text(
                              '$cost',
                              style: TextStyle(
                                fontFamily: robotoBold,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Image.asset(
                              'assets/logo/nubo_coin.png',
                              width: 20,
                              height: 20,
                            ),
                          ],
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: onClaim,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: warningActive,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.store, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                'Reclamar',
                                style: TextStyle(
                                  fontFamily: robotoBold,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Indicadores de carousel
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Dot(selected: false),
            const SizedBox(width: 6),
            _Dot(selected: true),
            const SizedBox(width: 6),
            _Dot(selected: false),
          ],
        ),
      ],
    );
  }

  void _showDetailModal(BuildContext context) {
    RewardDetailModal.show(
      context,
      title: title,
      brand: brand,
      description: '¡Disfruta el sabor que despierta tus sentidos! Ven y prueba nuestros deliciosos Capuchinos, preparados con la mezcla perfecta de café y leche espumada.',
      details: details,
      discount: discount,
      cost: cost,
      benefits: [
        'Promoción exclusiva: Capuchinos al mejor precio',
        '¡Solo por tiempo limitado!',
        'No dejes pasar la oportunidad de consentirte con el café que tanto te gusta.',
      ],
      onClaim: onClaim,
    );
  }
}

class _Dot extends StatelessWidget {
  final bool selected;

  const _Dot({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: selected ? primary : gray200,
        shape: BoxShape.circle,
      ),
    );
  }
}

