import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obtener el usuario actual
  static User? get currentUser => _auth.currentUser;

  // Stream del estado de autenticación
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Método para iniciar sesión con email y contraseña
  static Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);

      final uid = cred.user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'lastLoginAt': FieldValue.serverTimestamp(),
        'updatedAt'  : FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return cred;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  // Método para registrar usuario con email y contraseña
  static Future<UserCredential?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (displayName != null && displayName.isNotEmpty) {
        await cred.user?.updateDisplayName(displayName);
      }

      final uid = cred.user!.uid;
      final doc = FirebaseFirestore.instance.collection('users').doc(uid);

      await doc.set({
        'displayName': displayName ?? '',
        'email': cred.user!.email ?? '',
        'phone': cred.user!.phoneNumber,
        'gender': null,
        'location': {'department': null, 'province': null, 'district': null},
        'wallet': {'coins': 30, 'updatedAt': DateTime.now()},
        'currentStreak': 0,     
        'maxStreak': 0,          
        'lastMissionDate': null, 
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await seedFakeMissionDaysAndState(uid);
      await seedFakeUserAchievements(uid);
      await seedFakeLeaderboards(uid);

      return cred;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  static Future<bool> emailExists(String email) async {
    // Normaliza: recorta, quita espacios invisibles y pasa a minúsculas
    String normalized = email
        .replaceAll('\u200B', '')   // zero-width space
        .replaceAll('\u200C', '')
        .replaceAll('\u200D', '')
        .replaceAll('\uFEFF', '')
        .trim()
        .toLowerCase();

    try {
      final List<String> methods =
      //TODO - CAMBIAR FUNCION DEPRECADA
          await _auth.fetchSignInMethodsForEmail(normalized);

      debugPrint('🔎 fetchSignInMethodsForEmail("$normalized") -> $methods');

      // Si hay cualquier proveedor (password, google.com, etc.) => existe
      return methods.isNotEmpty;
    } on FirebaseAuthException catch (e) {
      // invalid-email u otro => trátalo como no existe
      debugPrint('⚠️ emailExists error: ${e.code} ${e.message}');
      return false;
    }
  }
  // Método para cerrar sesión
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
  }

  // Método para enviar email de verificación
  static Future<void> sendEmailVerification() async {
    try {
      _auth.setLanguageCode('es');
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      throw Exception('Error al enviar verificación: $e');
    }
  }

  // Método para restablecer contraseña
  static Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.setLanguageCode('es'); // 👈 idioma del correo
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  // Método para actualizar perfil del usuario
  static Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        if (photoURL != null) {
          await user.updatePhotoURL(photoURL);
        }
      }
    } catch (e) {
      throw Exception('Error al actualizar perfil: $e');
    }
  }
  

  // Método para manejar excepciones de Firebase Auth
  static String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No se encontró un usuario con este correo electrónico.';
      case 'wrong-password':
        return 'Contraseña incorrecta.';
      case 'email-already-in-use':
        return 'Ya existe una cuenta con este correo electrónico.';
      case 'weak-password':
        return 'La contraseña es muy débil.';
      case 'invalid-email':
        return 'El correo electrónico no es válido.';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada.';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde.';
      case 'operation-not-allowed':
        return 'Esta operación no está permitida.';
      case 'invalid-credential':
        return 'Las credenciales son inválidas.';
      default:
        return 'Error de autenticación: ${e.message}';
    }
  }
  
}

Future<void> seedFakeMissionDaysAndState(String uid) async {
  const missionId = 'recycle_plastic_v1';
  final db = FirebaseFirestore.instance;

  // Fechas de ejemplo
  final now = DateTime.now();
  final dates = <DateTime>[
    now.subtract(const Duration(days: 20)),
    now.subtract(const Duration(days: 11)),
    now.subtract(const Duration(days: 7)),
    now.subtract(const Duration(days: 5)),
    now.subtract(const Duration(days: 3)),
    now.subtract(const Duration(days: 1)),
    now,
  ];

  // --- 1) mission_days ---
  final batch = db.batch();
  for (final d in dates) {
    final dayId = DateFormat('yyyy-MM-dd').format(d.toUtc());
    final dayRef = db
        .collection('users').doc(uid)
        .collection('mission_days').doc(dayId);

    batch.set(dayRef, {
      'dayId'    : dayId,
      'hasMissions': true,
    }, SetOptions(merge: true));

    final missionRef = dayRef
        .collection('missions').doc(missionId);

    batch.set(missionRef, {
      'count'          : FieldValue.increment(1),
      'lastCompletedAt': Timestamp.fromDate(d),
      'missionId'      : missionId,
    }, SetOptions(merge: true));
  }

  // --- 2) missions_state (estado actual mínimo) ---
  final todayKey = DateFormat('yyyy-MM-dd').format(now.toUtc());
  final stateRef = db
      .collection('users').doc(uid)
      .collection('missions_state').doc(missionId);

  batch.set(stateRef, {
    'status'     : 'completed', // none | accepted | completed
    'progress'   : 1,
    'target'     : 1,
    'periodKey'  : todayKey,    // porque esta misión es daily
    'updatedAt'  : FieldValue.serverTimestamp(),
    'lastCompletedAt': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));

  await batch.commit();
}
Future<void> seedFakeUserAchievements(String uid) async {
  final db = FirebaseFirestore.instance;
  final col = db.collection('users').doc(uid).collection('achievements');

  // Usamos IDs que sí existen en tu catálogo global:
  // primer-paso, perfil-completo, racha-eco-3, categoria-plastico
  final now = FieldValue.serverTimestamp();

  final batch = db.batch();

  batch.set(col.doc('primer-paso'), {
    'progress': 1,
    'target': 1,
    'unlocked': true,
    'createdAt': now,
    'updatedAt': now,
  }, SetOptions(merge: true));

  batch.set(col.doc('perfil-completo'), {
    'progress': 0,
    'target': 4,           // ej: completar 4 campos del perfil
    'unlocked': false,
    'createdAt': now,
    'updatedAt': now,
  }, SetOptions(merge: true));

  batch.set(col.doc('racha-eco-3'), {
    'progress': 2,         // 2 días de racha de 3
    'target': 3,
    'unlocked': false,
    'createdAt': now,
    'updatedAt': now,
  }, SetOptions(merge: true));

  batch.set(col.doc('categoria-plastico'), {
    'progress': 0,         // aún no clasificó plástico
    'target': 1,
    'unlocked': false,
    'createdAt': now,
    'updatedAt': now,
  }, SetOptions(merge: true));

  await batch.commit();
}
Future<void> seedFakeLeaderboards(
    String uid, {
      int minCoins = 10,
      int maxCoins = 500,
      String region = 'lima',
    }) async {
  final db = FirebaseFirestore.instance;

  // Fechas/keys (usar UTC para que sea estable)
  final nowUtc      = DateTime.now().toUtc();
  final dailyKey    = DateFormat('yyyy-MM-dd').format(nowUtc);
  final monthlyKey  = DateFormat('yyyy-MM').format(nowUtc);
  // semana ISO
  final iso = _isoWeek(nowUtc);
  final weeklyKey = '${iso['year']}-W${iso['week']!.toString().padLeft(2, '0')}';

  // Coins aleatorios
  final rnd   = math.Random();
  final coins = minCoins + rnd.nextInt((maxCoins - minCoins) + 1);

  final entry = {
    'userId'   : uid,
    'coins'    : coins,
    'region'   : region,
    'createdAt': FieldValue.serverTimestamp(),
  };

  final batch = db.batch();

  // Stubs para que la consola muestre los períodos
  final dailyDoc   = db.collection('leaderboards_daily').doc(dailyKey);
  final weeklyDoc  = db.collection('leaderboards_weekly').doc(weeklyKey);
  final monthlyDoc = db.collection('leaderboards_monthly').doc(monthlyKey);

  batch.set(dailyDoc,   {'_createdAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
  batch.set(weeklyDoc,  {'_createdAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
  batch.set(monthlyDoc, {'_createdAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));

  // Entradas
  batch.set(dailyDoc.collection('entries').doc(uid),   entry, SetOptions(merge: true));
  batch.set(weeklyDoc.collection('entries').doc(uid),  entry, SetOptions(merge: true));
  batch.set(monthlyDoc.collection('entries').doc(uid), entry, SetOptions(merge: true));

  await batch.commit();
}

Map<String, int> _isoWeek(DateTime d) {
  final date = DateTime.utc(d.year, d.month, d.day);
  final thursday = date.add(Duration(days: 3 - ((date.weekday + 6) % 7)));
  final isoYear = thursday.year;

  final jan4 = DateTime.utc(isoYear, 1, 4);
  final firstThu = jan4.add(Duration(days: 3 - ((jan4.weekday + 6) % 7)));

  final week = 1 + (thursday.difference(firstThu).inDays ~/ 7);
  return {'year': isoYear, 'week': week};
}
