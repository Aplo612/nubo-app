import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

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
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
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
  }) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
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

