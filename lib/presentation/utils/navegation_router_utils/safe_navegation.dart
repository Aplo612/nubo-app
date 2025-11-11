import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nubo/presentation/utils/snackbar/snackbar.dart';

class NavigationHelper {
  /// Hace un pop seguro; si no hay stack, redirige a [fallback].
  static void safePop(BuildContext context, {String fallback = '/login'}) {
    final router = GoRouter.of(context);
    if (router.canPop()) {
      router.pop();
    } else {
      // TODO: Limpiar TOKEN de auth, le estamos cerrando la sesión
      SnackbarUtil.showSnack(context, message: "Error fatal, cerrando sesión.");
      router.go(fallback);
    }
  }
  static Future<T?> safePush<T>(
    BuildContext context,
    String location, {
    Object? extra,
  }) {
    return GoRouter.of(context).push<T>(location, extra: extra);
  }
   static void safePushReplacement(BuildContext context, String page){
    // TODO: Implementar un safe pushReplacement, para evitar redundancia en la pila
    // chatgpt no ayuda y estoy muy cansado ahorita para viajar por documentacion
    final router = GoRouter.of(context);
    router.pushReplacement(page);
  }
}