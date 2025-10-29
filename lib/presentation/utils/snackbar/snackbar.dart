import 'package:flutter/material.dart';
import 'package:nubo/config/config.dart';

class SnackbarUtil {
  static void showSnack(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: robotoRegular,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        duration: duration,
        backgroundColor: backgroundColor ?? Colors.black,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.startToEnd,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
