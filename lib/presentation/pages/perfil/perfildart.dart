import 'package:flutter/material.dart';
import 'package:nubo/models/profile.dart';
import 'package:nubo/presentation/utils/snackbar/snackbar.dart';
import 'package:nubo/services/profile_repository.dart';
import 'package:nubo/services/profile_service.dart';
import 'package:nubo/services/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:nubo/presentation/pages/perfil/widgets/profile_header_simple.dart';
import 'package:nubo/presentation/pages/perfil/widgets/personal_info_section.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFF7FCFC),
      body: FutureBuilder<UserProfile>(
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
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Header con flecha, título y foto de perfil
                    ProfileHeaderSimple(profile: profile),
                    const SizedBox(height: 24),
                    
                    // Información personal
                    PersonalInfoSection(
                      fullName: 'Armando Guerra Arroyo',
                      phoneNumber: '+51 904 089 518',
                      email: profile.user.email,
                      city: 'Ate',
                      birthDate: '25/06/2002',
                    ),
                    const SizedBox(height: 16),
                    
                    // Impacto ambiental
                    ImpactSection(stats: profile.stats),
                    const SizedBox(height: 16),
                    
                    // Insignias
                    BadgesGrid(
                      badges: profile.badges,
                      onViewAll: () {},
                    ),
                    const SizedBox(height: 16),
                    
                    // Actividad reciente
                    RecentActivity(activities: profile.activities),
                    const SizedBox(height: 16),
                    
                    // Botones de acción
                    ActionButtons(
                      onRewards: () {
                        context.push('/rewards');
                      },
                      onStats: () {
                        context.push('/rankings');
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Configuración
                    SettingsSection(
                      onLogout: () async {
                        try {
                          await AuthService.signOut();
                          if (context.mounted) {
                            context.go('/login');
                          }
                        } catch (e) {
                          if (context.mounted) {
                            SnackbarUtil.showSnack(context, message: 'No se pudo cerrar sesión: $e');
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  UserProfile _mockProfile() {
    return UserProfile(
      user: const User(id: '1', username: 'Armando Guerra', email: 'marco.arroyo@gmail.com'),
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
        ProfileBadge(id: 'b1', title: 'Primer reciclaje', unlocked: true, emoji: '♻️'),
        ProfileBadge(id: 'b2', title: 'Racha 7 días', unlocked: true, emoji: '🔥'),
        ProfileBadge(id: 'b3', title: '10 Misiones', unlocked: true, emoji: '🏆'),
        ProfileBadge(id: 'b4', title: '50 Botellas', unlocked: false, emoji: '🥤'),
        ProfileBadge(id: 'b5', title: '1000 NuboCoins', unlocked: false, emoji: '🪙'),
        ProfileBadge(id: 'b6', title: 'Eco Héroe', unlocked: false, emoji: '🌿'),
      ],
      activities: [
        Activity(id: 'a1', title: 'Reciclaste 3 botellas', date: DateTime.now(), points: 80),
        Activity(id: 'a2', title: 'Completaste misión "Plástico"', date: DateTime.now().subtract(const Duration(days: 1)), points: 40),
        Activity(id: 'a3', title: 'Recolectaste recompensa diaria', date: DateTime.now().subtract(const Duration(days: 2)), points: 10),
      ],
    );
  }
}