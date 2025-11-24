import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MissionValidationService {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  MissionValidationService(this._db, this._auth);

  /// Valida un token de misión. Todo se realiza dentro de una transacción
  /// para garantizar que la operación sea atómica.
  Future<void> validateMissionToken(String tokenId) async {
    final agent = _auth.currentUser;
    if (agent == null) {
      throw Exception("No hay un agente autenticado.");
    }

    final tokenRef = _db.collection('mission_tokens').doc(tokenId);

    return _db.runTransaction((transaction) async {
      final tokenSnap = await transaction.get(tokenRef);

      if (!tokenSnap.exists) {
        throw Exception("El token no existe.");
      }

      final data = tokenSnap.data() as Map<String, dynamic>;

      final status = data['status'] ?? '';
      if (status != "pending_validation") {
        throw Exception("El token no está pendiente de validación.");
      }

      final missionId = data['missionId'] as String;
      final userId = data['userId'] as String;
      final periodKey = data['periodKey'] as String;

      // Leer reward de la misión
      final missionRef = _db.collection('missions').doc(missionId);
      final missionSnap = await transaction.get(missionRef);
      if (!missionSnap.exists) {
        throw Exception("La misión asociada no existe.");
      }
      //final reward = missionSnap.get('reward') as int;

      // Determinar displayName del agente
      final agentUserRef = _db.collection('users').doc(agent.uid);
      final agentUserSnap = await transaction.get(agentUserRef);

      String agentName = agent.uid;
      if (agentUserSnap.exists) {
        agentName = agentUserSnap.data()?['displayName'] ?? agent.uid;
      }

      // 1) Actualizar token
      transaction.update(tokenRef, {
        'status': "validated",
        'validatedAt': FieldValue.serverTimestamp(),
        'validatedBy': agentName,
      });

      // 2) Actualizar missions_state global
      final stateId = "${userId}_${missionId}_$periodKey";
      final stateRef = _db.collection('missions_state').doc(stateId);

      transaction.set(stateRef, {
        'status': "completed",
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // 3) NUEVO: Actualizar missions_state dentro de users/{userId}
      final userScopedStateRef = _db
          .collection('users')
          .doc(userId)
          .collection('missions_state')
          .doc(missionId);

      transaction.set(userScopedStateRef, {
        'status': "completed",
        'updatedAt': FieldValue.serverTimestamp(),
        'periodKey': periodKey, // opcional, pero útil para trazabilidad
      }, SetOptions(merge: true));

      // 4) Actualizar wallet del usuario final
      //final userRef = _db.collection('users').doc(userId);
      //transaction.update(userRef, {
       // 'wallet.coins': FieldValue.increment(reward),
      //});
    });
  }
}
