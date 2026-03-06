import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastPosition { top, middle, bottom }

class AppToast {
  static void success(
    String message, {
    ToastPosition position = ToastPosition.bottom,
  }) {
    _showToast(
      message,
      backgroundColor: Colors.green.shade600,
      position: position,
    );
  }

  static void error(
    String message, {
    ToastPosition position = ToastPosition.bottom,
  }) {
    _showToast(
      message,
      backgroundColor: Colors.red.shade600,
      position: position,
    );
  }

  static void warning(
    String message, {
    ToastPosition position = ToastPosition.bottom,
  }) {
    _showToast(
      message,
      backgroundColor: Colors.orange.shade700,
      position: position,
    );
  }

  static void _showToast(
    String message, {
    required Color backgroundColor,
    required ToastPosition position,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: _getGravity(position),
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 14,
    );
  }

  static ToastGravity _getGravity(ToastPosition position) {
    switch (position) {
      case ToastPosition.top:
        return ToastGravity.TOP;
      case ToastPosition.middle:
        return ToastGravity.CENTER;
      case ToastPosition.bottom:
      default:
        return ToastGravity.BOTTOM;
    }
  }
}
