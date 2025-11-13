import 'package:nubo/models/profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> fetchUserProfile({required String userId});
}

class MockProfileRepository implements ProfileRepository {
  @override
  Future<UserProfile> fetchUserProfile({required String userId}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return UserProfile(
      user: User(id: userId, username: 'Armando', email: 'armando@nubo.com'),
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

