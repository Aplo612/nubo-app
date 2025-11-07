// lib/services/email_sender.dart
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

/// Envía un correo con el código provisional "1234" al destinatario.
/// Devuelve true si se envió correctamente.
Future<bool> enviarCodigoProvisional(String toEmail) async {
  // ⚠️ CREDENCIALES EMBEBIDAS — SOLO TEMPORAL (mueve esto a backend ASAP)
  // ====== Opción 1: Gmail (recomendado para POC) ======
  const smtpUser = 'aldhair.ordonez@usil.pe';        // <-- tu correo remitente
  const smtpAppPassword = 'Almaster17:)';  // <-- App Password (con 2FA)
  final smtpServer = gmail(smtpUser, smtpAppPassword);

  // ====== Opción 2: Office365/Outlook (comenta arriba y usa esto) ======
  // final smtpServer = SmtpServer(
  //   'smtp.office365.com',
  //   port: 587, // STARTTLS
  //   ssl: false,
  //   username: 'tu@dominio.com',
  //   password: 'tu-pass-o-app-password',
  // );

  const codigo = '1234';

  final message = Message()
    ..from = Address(smtpUser, 'Soporte Nubo')
    ..recipients.add(toEmail)
    ..subject = 'Recuperación de contraseña - Código provisional'
    ..text = 'Hola,\n\nTu código provisional es: $codigo\n\n— Equipo Nubo';

  try {
    await send(message, smtpServer);
    return true;
  } on MailerException {
    return false;
  } catch (_) {
    return false;
  }
}
