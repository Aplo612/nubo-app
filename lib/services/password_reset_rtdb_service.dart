import 'dart:math';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class PasswordResetRTDBService {
  static final _auth = FirebaseAuth.instance;
  static final _db = FirebaseDatabase.instance;

  // RTDB no permite '.' en keys. Usamos base64 URL-safe del email en minúsculas.
  static String _keyFromEmail(String email) {
    final e = email.trim().toLowerCase();
    return base64Url.encode(utf8.encode(e));
  }

  static String _genCode() {
    final rnd = Random.secure();
    return (100000 + rnd.nextInt(900000)).toString();
  }

  /// Verifica si el correo existe en Firebase Auth (gratis)
  static Future<bool> emailExists(String email) async {
    //TODO - CAMBIAR FUNCION DEPRECADA
    final methods = await _auth.fetchSignInMethodsForEmail(email.trim());
    return methods.isNotEmpty;
  }

  /// Crea/renueva OTP: invalida el anterior y guarda uno nuevo con expiración de 5 minutos
  static Future<String> createOtpForEmail(String email) async {
    final key = _keyFromEmail(email);
    final ref = _db.ref('password_resets/$key');

    final code = _genCode();
    final expiresAtMs = DateTime.now().add(const Duration(minutes: 5)).millisecondsSinceEpoch;

    // Guardamos un único registro por email (sencillo y suficiente para tu flujo)
    await ref.set({
      'email': email.trim().toLowerCase(),
      'code': code,
      'status': 'active', // 'active' | 'used' | 'expired' | 'invalid'
      'expiresAt': expiresAtMs,
      'updatedAt': ServerValue.timestamp,
    });

    return code;
  }

  /// Valida OTP activo y no vencido
  static Future<bool> validateOtp(String email, String code) async {
    final key = _keyFromEmail(email);
    final ref = _db.ref('password_resets/$key');
    final snap = await ref.get();
    if (!snap.exists) return false;

    final data = Map<String, dynamic>.from(snap.value as Map);
    if ((data['status'] as String?) != 'active') return false;
    if ((data['code'] as String?)?.trim() != code.trim()) return false;

    final expiresAt = (data['expiresAt'] as int?) ?? 0;
    if (DateTime.now().millisecondsSinceEpoch > expiresAt) {
      await ref.update({'status': 'expired', 'updatedAt': ServerValue.timestamp});
      return false;
    }
    return true;
  }

  /// Marca el código como usado (llámalo tras validar correctamente)
  static Future<void> consumeOtp(String email) async {
    final key = _keyFromEmail(email);
    final ref = _db.ref('password_resets/$key');
    await ref.update({'status': 'used', 'updatedAt': ServerValue.timestamp});
  }

  /// Invalida manualmente (si implementas “Reenviar”)
  static Future<void> invalidateOtp(String email) async {
    final key = _keyFromEmail(email);
    final ref = _db.ref('password_resets/$key');
    await ref.update({'status': 'invalid', 'updatedAt': ServerValue.timestamp});
  }
}
