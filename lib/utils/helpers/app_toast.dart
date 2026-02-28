// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// class AppToast {
//   static void success(String message) {
//     Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       backgroundColor: Colors.green.shade600,
//       textColor: Colors.white,
//       fontSize: 14,
//     );
//   }

//   static void error(String message) {
//     Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       backgroundColor: Colors.red.shade600,
//       textColor: Colors.white,
//       fontSize: 14,
//     );
//   }

//   static void warning(String message) {
//     Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       backgroundColor: Colors.orange.shade700,
//       textColor: Colors.white,
//       fontSize: 14,
//     );
//   }
// }
import 'package:flutter/material.dart';

class AppToast {
  static OverlayEntry? _overlayEntry;

  static void _show(BuildContext context, String message, Color color) {
    _overlayEntry?.remove();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 80,
        left: 24,
        right: 24,
        child: _ToastCard(message: message, color: color),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(const Duration(seconds: 2), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  static void success(BuildContext context, String message) {
    _show(context, message, Colors.green.shade600);
  }

  static void error(BuildContext context, String message) {
    _show(context, message, Colors.red.shade600);
  }

  static void warning(BuildContext context, String message) {
    _show(context, message, Colors.orange.shade700);
  }
}

class _ToastCard extends StatelessWidget {
  final String message;
  final Color color;

  const _ToastCard({required this.message, required this.color});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
