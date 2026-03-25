import 'package:flutter/foundation.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  late final Razorpay _razorpay;

  Function(String paymentId, String orderId, String signature)? _onSuccess;
  Function(String error)? _onFailure;

  bool _isPaymentOpen = false;

  RazorpayService() {
    _init();
  }
  bool _isInitialized = false;
  // ───────────────── INIT ─────────────────
  void _init() {
    if (_isInitialized) return; 

    _razorpay = Razorpay();

    _razorpay.clear(); 

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    _isInitialized = true;

    _logBlue("Razorpay initialized ONCE");
  }

  void openCheckout({
    required String orderId,
    required int amount,
    required String name,
    required String email,
    required String contact,
    required Function(String paymentId, String orderId, String signature)
    onSuccess,
    required Function(String error) onFailure,
  }) {
    if (_isPaymentOpen) {
      _logWarning("Payment already in progress, ignoring duplicate call");
      return;
    }

    // ───── VALIDATIONS ─────
    if (orderId.isEmpty || amount <= 0) {
      _logError("Invalid orderId or amount");
      onFailure("Invalid payment configuration");
      return;
    }

    final cleanContact = contact.replaceAll(RegExp(r'\D'), '');

    if (cleanContact.length < 10) {
      _logWarning("Invalid phone number: $contact");
    }

    _onSuccess = onSuccess;
    _onFailure = onFailure;
    _isPaymentOpen = true;

    final options = {
      'key': "rzp_test_P7eTEWTbR1y2Sm",
      'amount': amount,
      'order_id': orderId,
      'name': "IndHostels",
      'description': "Room Booking",
      'prefill': {'contact': cleanContact, 'email': email},
      // 'retry': {'enabled': true, 'max_count': 1},
      'external': {
        'wallets': ['paytm'],
      },
      'theme': {'color': '#5B4BCC'},
    };

    _logBlue("Opening Razorpay Checkout");
    _logBlue("OrderId: $orderId");
    _logBlue("Amount: $amount");
    _logBlue("Email: $email");
    _logBlue("Contact: $cleanContact");

    try {
      _razorpay.open(options);
    } catch (e) {
      _isPaymentOpen = false;
      _logError("Razorpay open failed: $e");
      _onFailure?.call(e.toString());
    }
  }

  // ───────────────── SUCCESS ─────────────────
  void _handleSuccess(PaymentSuccessResponse response) {
    _isPaymentOpen = false;

    _logSuccess("Payment SUCCESS");
    _logSuccess("PaymentId: ${response.paymentId}");
    _logSuccess("OrderId: ${response.orderId}");

    _onSuccess?.call(
      response.paymentId ?? "",
      response.orderId ?? "",
      response.signature ?? "",
    );
  }

  // ───────────────── ERROR ─────────────────
  void _handleError(PaymentFailureResponse response) {
    _isPaymentOpen = false;

    _logError("Payment FAILED");
    _logError("Code: ${response.code}");
    _logError("Message: ${response.message}");

    _onFailure?.call(response.message ?? "Payment failed");
  }

  // ───────────────── CANCEL / WALLET ─────────────────
  void _handleExternalWallet(ExternalWalletResponse response) {
    _isPaymentOpen = false;

    _logWarning("Payment cancelled / external wallet");
    _logWarning("Wallet: ${response.walletName}");

    _onFailure?.call("Payment cancelled");
  }

  // ───────────────── DISPOSE ─────────────────
  void dispose() {
    _razorpay.clear();
    _logBlue("Razorpay disposed");
  }

  // ───────────────── LOGGING HELPERS ─────────────────

  void _logBlue(String message) {
    if (kDebugMode) {
      debugPrint("\x1B[34m[RAZORPAY] $message\x1B[0m"); // 🔵 Blue
    }
  }

  void _logSuccess(String message) {
    if (kDebugMode) {
      debugPrint("\x1B[32m[SUCCESS] $message\x1B[0m"); // 🟢 Green
    }
  }

  void _logWarning(String message) {
    if (kDebugMode) {
      debugPrint("\x1B[33m[WARNING] $message\x1B[0m"); // 🟡 Yellow
    }
  }

  void _logError(String message) {
    if (kDebugMode) {
      debugPrint("\x1B[31m[ERROR] $message\x1B[0m"); // 🔴 Red
    }
  }
}
