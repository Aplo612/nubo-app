import 'package:flutter/material.dart';

class UserProfile {
  final User user;
  final Level level;
  final Stats stats;
  final List<ProfileBadge> badges;
  final List<Activity> activities;
  final int ranking;

  const UserProfile({
    required this.user,
    required this.level,
    required this.stats,
    required this.badges,
    required this.activities,
    required this.ranking,
  });
}

class User {
  final String id;
  final String username;
  final String email;
  final String? avatar;

  const User({
    required this.id,
    required this.username,
    required this.email,
    this.avatar,
  });
}

class Level {
  final String current; // 'Bronce' | 'Plata' | 'Oro' | 'Platino' | 'Diamante'
  final int points;
  final int nextLevelPoints;

  const Level({
    required this.current,
    required this.points,
    required this.nextLevelPoints,
  });
}

class Stats {
  final int nuboCoinsCurrent;
  final int streakDays;
  final int missionsCompleted;
  final int kgRecycled;
  final int bottlesSaved;

  const Stats({
    required this.nuboCoinsCurrent,
    required this.streakDays,
    required this.missionsCompleted,
    required this.kgRecycled,
    required this.bottlesSaved,
  });
}

class ProfileBadge {
  final String id;
  final String title;
  final bool unlocked;
  final String emoji;

  const ProfileBadge({
    required this.id,
    required this.title,
    required this.unlocked,
    required this.emoji,
  });
}

class Activity {
  final String id;
  final String title;
  final DateTime date;
  final int points;

  const Activity({
    required this.id,
    required this.title,
    required this.date,
    required this.points,
  });
}

// Helpers de estilo (colores de la paleta)
class NuboColors {
  static const Color blue400 = Color(0xFF60A5FA);
  static const Color blue500 = Color(0xFF3B82F6);
  static const Color blue100 = Color(0xFFDBEAFE);
  static const Color sky100 = Color(0xFFE0F2FE);
  static const Color sky400 = Color(0xFF38BDF8);
  static const Color orange400 = Color(0xFFFB923C);
  static const Color amber400 = Color(0xFFFBBF24);
  static const Color green400 = Color(0xFF4ADE80);
  static const Color green500 = Color(0xFF22C55E);
  static const Color yellow300 = Color(0xFFFDE047);
}

