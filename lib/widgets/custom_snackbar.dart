import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomSnackbar {
  static showSuccessSnackbar(BuildContext context, String message) {
    final snackbar = SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.blue,
      behavior: !kIsWeb && Platform.isIOS
          ? SnackBarBehavior.fixed
          : SnackBarBehavior.floating, // Use fixed snackbar for iOS
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  static showFailureSnackbar(BuildContext context, String message) {
    final snackbar = SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.red,
      behavior: !kIsWeb && Platform.isIOS
          ? SnackBarBehavior.fixed
          : SnackBarBehavior.floating, // Use fixed snackbar for iOS
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
