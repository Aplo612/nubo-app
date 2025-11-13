import 'package:flutter/material.dart';
import 'package:nubo/models/profile.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback onSettingsTap;

  const ProfileHeader({
    super.key,
    required this.profile,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [NuboColors.blue400, NuboColors.blue500],
        ),
      ),
      padding: const EdgeInsets.only(top: 56, left: 24, right: 24, bottom: 88),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: onSettingsTap,
              icon: const Icon(Icons.settings, color: Colors.white),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: profile.user.avatar != null
                          ? NetworkImage(profile.user.avatar!)
                          : null,
                      child: profile.user.avatar == null
                          ? Text(
                              profile.user.username.isNotEmpty
                                  ? profile.user.username.substring(0, 1).toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            )
                          : null,
                      backgroundColor: NuboColors.sky400,
                    ),
                  ),
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: NuboColors.orange400,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.emoji_events, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text('#${profile.ranking}',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                profile.user.username,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.military_tech, color: Colors.white, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'Nivel ${profile.level.current} • ${profile.level.points} pts',
                    style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _LevelProgress(level: profile.level),
            ],
          ),
        ],
      ),
    );
  }
}

class _LevelProgress extends StatelessWidget {
  final Level level;
  const _LevelProgress({required this.level});

  @override
  Widget build(BuildContext context) {
    final double pct = level.nextLevelPoints == 0
        ? 0
        : (level.points / level.nextLevelPoints).clamp(0.0, 1.0);
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 8,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation<Color>(NuboColors.yellow300),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${level.points}/${level.nextLevelPoints} hacia el siguiente nivel',
          style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}

