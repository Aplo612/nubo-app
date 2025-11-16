import 'package:flutter/material.dart';
import 'package:nubo/models/profile.dart';
import 'package:nubo/config/constants/enviroments.dart';

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
    final titleStyle = TextStyle(
      fontFamily: robotoBlack,
      fontSize: 28,
      height: 1.05,
      letterSpacing: -0.2,
      color: Colors.black,
    );

    final subtitleStyle = TextStyle(
      fontFamily: robotoLight,
      fontSize: 16,
      height: 1.25,
      color: gray400,
    );

    return Stack(
      children: [
        // Degradado superior (como login)
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 70,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFBFE6FF), Colors.white],
              ),
            ),
          ),
        ),

        // Nubes decorativas inferiores (como login)
        Positioned(
          left: -170,
          bottom: -190,
          child: _cloud(340, const Color(0xff6ecaf4)),
        ),
        Positioned(
          left: 40,
          right: 40,
          bottom: -160,
          child: _cloud(280, const Color(0xffb4e2ff)),
        ),
        Positioned(
          right: -170,
          bottom: -190,
          child: _cloud(340, const Color(0xbb6ecaf4)),
        ),

        // Contenido
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 56),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: onSettingsTap,
                  icon: const Icon(Icons.settings, color: Colors.black87),
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
                          backgroundColor: NuboColors.sky400,
                          child: profile.user.avatar == null
                              ? Text(
                                  profile.user.username.isNotEmpty
                                      ? profile.user.username.substring(0, 1).toUpperCase()
                                      : 'U',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28,
                                    fontFamily: robotoBold,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: warningActive,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.emoji_events, color: Colors.white, size: 16),
                              const SizedBox(width: 4),
                              Text('#${profile.ranking}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: robotoBold,
                                    fontSize: 12,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profile.user.username,
                    style: titleStyle,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.military_tech, color: warningActive, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'Nivel ${profile.level.current} • ${profile.level.points} pts',
                        style: subtitleStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _LevelProgress(level: profile.level),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _cloud(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 6),
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
            backgroundColor: gray200,
            valueColor: const AlwaysStoppedAnimation<Color>(warningActive),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${level.points}/${level.nextLevelPoints} hacia el siguiente nivel',
          style: TextStyle(
            color: gray400,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: robotoMedium,
          ),
        )
      ],
    );
  }
}

