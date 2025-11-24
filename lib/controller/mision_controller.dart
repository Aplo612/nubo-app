import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nubo/services/auth_service.dart';

class MissionController {
  final FirebaseFirestore _db;
  final String? _uid;

  MissionController()
      : _db = FirebaseFirestore.instance,
        _uid = AuthService.currentUser?.uid;

  /// Misiones activas del usuario:
  /// - status: available
  /// - status: in_progress
  ///
  /// Cada item es un Map con:
  ///  id, status, progress, target, periodKey, lastCompletedAt,
  ///  title, subtitle, coinsReward, active, frecuency, type, scope,
  ///  qrCode, qrStatus, qrCreatedAt
  
  Stream<List<Map<String, dynamic>>> availableMissionsStream() {
    final uid = _uid;
    if (uid == null) {
      return Stream.value(<Map<String, dynamic>>[]);
    }

    final baseStream = _db
        .collection('users')
        .doc(uid)
        .collection('missions_state')
        .where('status', whereIn: ['available', 'in_progress'])
        .snapshots();

    return baseStream.asyncMap(
      (QuerySnapshot<Map<String, dynamic>> statesSnap) async {
        final result = <Map<String, dynamic>>[];

        for (final stateDoc in statesSnap.docs) {
          final missionId = stateDoc.id;
          final stateData = stateDoc.data();

          // Catálogo global de misiones
          final missionSnap =
              await _db.collection('missions').doc(missionId).get();
          if (!missionSnap.exists) continue;

          final missionData =
              missionSnap.data() ?? {};
          final instructions =
              (missionData['instructions'] as Map<String, dynamic>?) ?? {};

          // Título y descripción con fallback
          final title =
              (missionData['title'] ?? instructions['title'] ?? '') as String;

          final subtitle =
              (missionData['description'] ??
                      instructions['description'] ??
                      '') as String;

          final type = instructions['type'] ?? missionData['type'];
          final scope = instructions['scope'] ?? missionData['scope'];

          result.add({
            'id': missionId,
            // Estado por usuario
            'status': stateData['status'],
            'progress': stateData['progress'],
            'target': stateData['target'],
            'lastCompletedAt': stateData['lastCompletedAt'],
            'periodKey': stateData['periodKey'],
            'qrCode': stateData['qrCode'],
            'qrStatus': stateData['qrStatus'],
            'qrCreatedAt': stateData['qrCreatedAt'],
            // Datos del catálogo
            'title': title,
            'subtitle': subtitle,
            'coinsReward': missionData['coinsReward'],
            'active': missionData['active'],
            'frecuency': missionData['frecuency'],
            'type': type,
            'scope': scope,
          });
        }

        return result;
      },
    );
  }

  /// Actualiza el status de una misión para el usuario logueado.
  Future<void> updateMissionStatus(String missionId, String status) async {
    final uid = _uid;
    if (uid == null) return;

    final ref = _db
        .collection('users')
        .doc(uid)
        .collection('missions_state')
        .doc(missionId);

    await ref.set(
      {
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  /// Genera un token QR único, crea el doc en `mission_tokens/{code}`
  /// y enlaza la misión del usuario con ese token via missions_state.
  ///
  /// Retorna el `code` para usarlo como payload del QR.
  Future<String> generateAndAttachQr({
    required String missionId,
    required String periodKey,
    Duration? ttl,
  }) async {
    final uid = _uid;
    if (uid == null) {
      throw Exception('No hay usuario autenticado.');
    }

    final tokensCol = _db.collection('mission_tokens');

    // 1) Generar un código corto único (docId en mission_tokens)
    String code;
    while (true) {
      code = _generateShortToken();
      final snap = await tokensCol.doc(code).get();
      if (!snap.exists) break; // no hay colisión, usar este código
    }

    // 2) Crear doc del token
    final tokenData = <String, dynamic>{
      'userId': uid,
      'missionId': missionId,
      'periodKey': periodKey,
      'status': 'pending_validation',
      'createdAt': FieldValue.serverTimestamp(),
    };

    if (ttl != null) {
      final now = DateTime.now();
      tokenData['expiresAt'] = Timestamp.fromDate(now.add(ttl));
    }

    await tokensCol.doc(code).set(tokenData);

    // 3) Enlazar en missions_state del usuario
    final missionStateRef = _db
        .collection('users')
        .doc(uid)
        .collection('missions_state')
        .doc(missionId);

    await missionStateRef.set(
      {
        'status': 'in_progress', // por seguridad/idempotencia
        'periodKey': periodKey,
        'qrCode': code,
        'qrStatus': 'pending_validation',
        'qrCreatedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    return code;
  }

  /// Stream para escuchar el token y reaccionar cuando el agente lo valide.
  ///
  /// Se usa en el frontend al mostrar el QR (QrStage.qrShown).
  Stream<Map<String, dynamic>?> watchQrToken(String code) {
    return _db
        .collection('mission_tokens')
        .doc(code)
        .snapshots()
        .map((snap) => snap.data());
  }

  /// Genera un token corto tipo código humano-legible (para QR).
  String _generateShortToken({int length = 6}) {
    const chars = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789'; // sin 0/O 1/I
    final rnd = Random();
    return List.generate(length, (_) => chars[rnd.nextInt(chars.length)]).join();
  }
}
