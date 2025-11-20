import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nubo/services/auth_service.dart';

class UserController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream en tiempo real para coins
  Stream<String> coinsStream() {
    final user = AuthService.currentUser;
    if (user == null) return Stream.value('0');

    return _db
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((doc) {
          if (!doc.exists) return '0';
          final wallet = doc.data()?['wallet'];
          if (wallet is Map<String, dynamic>) {
            final coins = wallet['coins'];
            return coins?.toString() ?? '0';
          }
          return '0';
        });
  }

  // TODO: FUERA DEL MVP, BUSCAR UNA MAPANERA DE CALCULAR ESTO MENOS SEGUIDO Y MAS EFICIENTE, EN VES DE TRAER 100000 DOCUMETNOS
  // TODO: UNTESTED - DATA NO EXISTE EN FIRESTORM
  Future<String> computeStreakAsString() async {
    final user = AuthService.currentUser;
    if (user == null) return '0';

    final snap = await _db
        .collection('users')
        .doc(user.uid)
        .get();

    if (!snap.exists) return '0';

    final data = snap.data();
    final streak = (data?['currentStreak'] ?? 0) as int;

    return streak.toString();
  }
}
