import 'package:app/shared/shared.dart';
import 'package:flutter/material.dart';

class Alert {
  static void showSnackBar(
    String message, {
    Duration? duration,
    Color backgroundColor = Colors.white,
    Color textColor = Colors.black,
  }) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: textColor),
      ),
      duration: duration ?? const Duration(seconds: 2),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(AppRouter.rootContext).showSnackBar(snackBar);
  }
}
