import 'package:flutter/material.dart';
import 'package:nubo/config/config.dart';

class SnackbarUtil {
  static void showSnack(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
    Color? letterColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontFamily: robotoRegular,
            fontSize: 16,
            color: letterColor ?? Colors.white,
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
