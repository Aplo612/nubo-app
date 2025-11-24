import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nubo/presentation/utils/navegation_router_utils/safe_navegation.dart';
import 'package:nubo/presentation/utils/snackbar/snackbar.dart';
import 'package:nubo/services/mission_validation_service.dart';

class ValidatorController extends ChangeNotifier {
  final MissionValidationService service;
  final FirebaseFirestore db;

  ValidatorController({
    required this.service,
    required this.db,
  });

  String? tokenId;
  Map<String, dynamic>? tokenData;
  bool confirmed = false;
  bool isLoading = false;

  void setTokenId(String id) {
    tokenId = id;
    notifyListeners();
  }

  void setConfirmed(bool value) {
    confirmed = value;
    notifyListeners();
  }

  Future<void> loadToken() async {
    if (tokenId == null) return;

    final doc =
        await db.collection('mission_tokens').doc(tokenId!).get();

    if (!doc.exists) {
      tokenData = null;
      notifyListeners();
      throw Exception("El token no existe.");
    }

    tokenData = doc.data();
    notifyListeners();
  }

  Future<void> validate(BuildContext context) async {
    if (tokenId == null) return;

    try {
      isLoading = true;
      notifyListeners();

      await service.validateMissionToken(tokenId!);

      if (!context.mounted) return;
      SnackbarUtil.showSnack(context, message: "Misión validada correctamente.");

      Future.delayed(const Duration(milliseconds: 400), () {
        if (context.mounted) {
          NavigationHelper.safePushReplacement(context, '/home');
        }
      });
    } catch (e) {
      if (!context.mounted) return;
      SnackbarUtil.showSnack(context, message: "Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
