import 'package:nubo/models/profile.dart';
import 'package:nubo/services/profile_repository.dart';

class ProfileService {
  final ProfileRepository repository;
  const ProfileService({required this.repository});

  Future<UserProfile> loadProfile(String userId) async {
    final profile = await repository.fetchUserProfile(userId: userId);
    return profile;
  }

  double progressToNextLevel(UserProfile p) {
    if (p.level.nextLevelPoints == 0) return 0;
    return (p.level.points / p.level.nextLevelPoints).clamp(0.0, 1.0);
  }
}

