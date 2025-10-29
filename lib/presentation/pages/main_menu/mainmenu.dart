import 'package:flutter/material.dart';
import 'package:nubo/config/constants/enviroments.dart';
import 'package:nubo/presentation/utils/navegation_router_utils/safe_navegation.dart';
import 'package:nubo/presentation/views/home/achievement/achievement_widget.dart';
import 'package:nubo/presentation/views/home/headerwidget.dart';
import 'package:nubo/presentation/views/home/missionswidget/mission_widget.dart';
import 'package:nubo/presentation/views/home/recyclewidget/recycle_widget.dart';
import 'package:nubo/presentation/views/home/rewards/rewards_widget.dart';

class HomePage extends StatelessWidget {
  static const String name = 'home_page';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // --- Header de saludo ---
            const HomeGreetingHeader(
            // TODO: Cambiar por whatever nos da el backend
              name: 'Armando', 
              streak: 10,
            ),
            MissionsSection(onSeeAll: () {
              NavigationHelper.safePush(context, '/missions');
            },),
            AchievementsSection(
              levelLabel: 'Nivel Plata',
              points: 75,
              progress: 0.64,
              onSeeAll: (){
                NavigationHelper.safePush(context, '/achievements');
              },
            ),
            RecyclingSummaryCard(
              kgThisMonth: 12,
              bottlesApprox: 200,
              impactPoints: 1000,
              location: 'Ate',
              iconAsset: recycleGreen,
            ),
            RewardsSection(
              onSeeAll: () {
                NavigationHelper.safePush(context, '/rewards');
              },
              iconAsset: rewardsOrange, // tu PNG
            ),
          ],
        ),
      ),
    );
  }
}
