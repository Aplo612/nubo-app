import 'package:cloud_functions/cloud_functions.dart';

class PasswordResetService {
  static final FirebaseFunctions _fns = FirebaseFunctions.instance;

  static Future<void> requestResetCode(String email) async {
    final callable = _fns.httpsCallable('requestResetCode');
    await callable.call({'email': email});
  }

  static Future<void> resendResetCode(String email) async {
    final callable = _fns.httpsCallable('resendResetCode');
    await callable.call({'email': email});
  }

  static Future<void> confirmResetCode({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    final callable = _fns.httpsCallable('confirmResetCode');
    await callable.call({'email': email, 'code': code, 'newPassword': newPassword});
  }
}
