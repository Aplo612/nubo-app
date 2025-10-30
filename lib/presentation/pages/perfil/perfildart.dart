import 'package:flutter/material.dart';
import 'package:nubo/models/profile.dart';
import 'package:nubo/services/profile_repository.dart';
import 'package:nubo/services/profile_service.dart';
import 'package:nubo/services/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:nubo/presentation/pages/perfil/widgets/profile_header.dart';
import 'package:nubo/presentation/pages/perfil/widgets/stats_cards.dart';
import 'package:nubo/presentation/pages/perfil/widgets/impact_section.dart';
import 'package:nubo/presentation/pages/perfil/widgets/badges_grid.dart';
import 'package:nubo/presentation/pages/perfil/widgets/recent_activity.dart';
import 'package:nubo/presentation/pages/perfil/widgets/action_buttons.dart';
import 'package:nubo/presentation/pages/perfil/widgets/settings_section.dart';

class ProfilePage extends StatelessWidget {
  static const String name = 'profile_page';
  final ProfileService? service;
  final String? userId;
  const ProfilePage({super.key, this.service, this.userId});

  @override
  Widget build(BuildContext context) {
    final ProfileService svc = service ?? ProfileService(repository: MockProfileRepository());
    final String uid = userId ?? '1';
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFEFF6FF), Colors.white],
        ),
      ),
      child: FutureBuilder<UserProfile>(
        future: svc.loadProfile(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Error al cargar el perfil'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () { (context as Element).markNeedsBuild(); },
                    child: const Text('Reintentar'),
                  )
                ],
              ),
            );
          }
          final profile = snapshot.data ?? _mockProfile();
          return RefreshIndicator(
            onRefresh: () async { await svc.loadProfile(uid); },
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ProfileHeader(
                        profile: profile,
                        onSettingsTap: () {},
                      ),
                      Positioned(
                        bottom: -36,
                        left: 0,
                        right: 0,
                        child: StatsCards(stats: profile.stats),
                      ),
                    ],
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 48)),
                SliverToBoxAdapter(child: ImpactSection(stats: profile.stats)),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverToBoxAdapter(
                  child: BadgesGrid(
                    badges: profile.badges,
                    onViewAll: () {},
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverToBoxAdapter(child: RecentActivity(activities: profile.activities)),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverToBoxAdapter(
                  child: ActionButtons(
                    onRewards: () {},
                    onStats: () {},
                    onInvite: () {},
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverToBoxAdapter(
                  child: SettingsSection(
                    onLogout: () async {
                      try {
                        await AuthService.signOut();
                        if (context.mounted) {
                          context.go('/login');
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('No se pudo cerrar sesión: $e')),
                          );
                        }
                      }
                    },
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          );
        },
      ),
    );
  }

  UserProfile _mockProfile() {
    return UserProfile(
      user: const User(id: '1', username: 'Armando', email: 'armando@nubo.com'),
      level: const Level(current: 'Plata', points: 75, nextLevelPoints: 100),
      stats: const Stats(
        nuboCoinsCurrent: 1500,
        streakDays: 10,
        missionsCompleted: 12,
        kgRecycled: 12,
        bottlesSaved: 24,
      ),
      ranking: 47,
      badges: const [
        ProfileBadge(id: 'b1', title: 'Primer Reciclaje', unlocked: true, emoji: '♻️'),
        ProfileBadge(id: 'b2', title: 'Racha 7 días', unlocked: true, emoji: '🔥'),
        ProfileBadge(id: 'b3', title: '10 Misiones', unlocked: true, emoji: '🏆'),
        ProfileBadge(id: 'b4', title: '50 Botellas', unlocked: false, emoji: '🥤'),
        ProfileBadge(id: 'b5', title: '1000 NuboCoins', unlocked: false, emoji: '🪙'),
        ProfileBadge(id: 'b6', title: 'Eco Héroe', unlocked: false, emoji: '🌿'),
      ],
      activities: [
        Activity(id: 'a1', title: 'Reciclaste 3 botellas', date: DateTime.now(), points: 20),
        Activity(id: 'a2', title: 'Completaste misión "Plástico"', date: DateTime.now().subtract(const Duration(days: 1)), points: 40),
        Activity(id: 'a3', title: 'Recolectaste recompensa diaria', date: DateTime.now().subtract(const Duration(days: 2)), points: 10),
      ],
    );
  }
}