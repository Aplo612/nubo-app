import 'package:flutter/material.dart';
import 'package:nubo/config/constants/enviroments.dart';
import 'package:nubo/presentation/pages/rewards/widgets/rewards_header.dart';
import 'package:nubo/presentation/pages/rewards/widgets/nubo_coin_balance.dart';
import 'package:nubo/presentation/pages/rewards/widgets/flash_reward_section.dart';
import 'package:nubo/presentation/pages/rewards/widgets/reward_category_filters.dart';
import 'package:nubo/presentation/pages/rewards/widgets/reward_card.dart';

class RewardsPage extends StatefulWidget {
  static const String name = 'rewards_page';
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  String selectedCategory = 'Todo';
  final List<String> categories = ['Todo', 'Ripley', 'Eventos', 'Spa'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con flecha y título
              const RewardsHeader(),
              const SizedBox(height: 24),

              // Balance de NuboCoin
              const NuboCoinBalance(balance: 1500),
              const SizedBox(height: 24),

              // Sección de Recompensa Flash
              FlashRewardSection(
                title: 'Cupón 50% OFF',
                brand: 'Starbuckery',
                description: 'Capuchincal',
                details: 'Válido en todas las sucursales',
                discount: 50,
                cost: 30,
                timerText: '26:02:45',
                onClaim: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Recompensa flash reclamada exitosamente')),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Filtros de categorías
              RewardCategoryFilters(
                categories: categories,
                selectedCategory: selectedCategory,
                onCategorySelected: (category) {
                  setState(() {
                    selectedCategory = category;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Título de la sección de recompensas
              Text(
                'Recompensas',
                style: TextStyle(
                  fontFamily: robotoBold,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // Lista de recompensas
              RewardCard(
                title: 'Cupón 75% descuento',
                brand: 'Dominos',
                description: 'Solo pizzas americanas',
                cost: 80,
                discount: 75,
                icon: Icons.inventory_2,
                onClaim: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Recompensa reclamada exitosamente')),
                  );
                },
              ),
              RewardCard(
                title: '20% OFF',
                brand: 'H&M',
                cost: 80,
                discount: 20,
                icon: Icons.inventory_2,
                onClaim: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Recompensa reclamada exitosamente')),
                  );
                },
              ),
              RewardCard(
                title: 'Cupón 30% descuento',
                brand: 'Cinemark',
                description: 'Válido para estrenos',
                cost: 50,
                discount: 30,
                icon: Icons.local_movies,
                onClaim: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Recompensa reclamada exitosamente')),
                  );
                },
              ),
              RewardCard(
                title: '15% OFF',
                brand: 'Ripley',
                description: 'En toda la tienda',
                cost: 60,
                discount: 15,
                icon: Icons.shopping_bag,
                onClaim: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Recompensa reclamada exitosamente')),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}