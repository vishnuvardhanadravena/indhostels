import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indhostels/bloc/auth/auth_bloc.dart';
import 'package:indhostels/bloc/auth/auth_event.dart';
import 'package:indhostels/bloc/auth/auth_state.dart';
import 'package:indhostels/utils/helpers/app_toast.dart';
import 'package:indhostels/utils/widgets/authwidgts.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  final _emailController = TextEditingController();
  Map<String, String?> _errors = {};

  bool _isValidEmail(String v) =>
      RegExp(r'^[\w.%+-]+@[\w.-]+\.[a-zA-Z]{2,}$').hasMatch(v);

  void _validateAndSubmit() {
    final errors = <String, String?>{};
    final email = _emailController.text.trim();

    // ✅ Human mistake validation (UI only)
    if (email.isEmpty) {
      errors['email'] = '*Email is required';
    } else if (!_isValidEmail(email)) {
      errors['email'] = '*Enter valid email';
    }

    setState(() => _errors = errors);
    if (errors.isNotEmpty) return;

    context.read<AuthBloc>().add(ForgotPasswordRequested(email));
  }

  Widget _buildContent(
    BuildContext context,
    double horizontalPadding,
    double verticalPadding,
    double spacing,
    bool isLoading,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Column(
        children: [
          AuthHeader(
            showBackButton: true,
            title: 'Forgot Password',
            subtitle:
                'Enter your registered email to receive reset password link.',
          ),

          SizedBox(height: spacing),

          CustomTextField(
            label: 'Email',
            hintText: 'Enter your email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            errorText: _errors['email'],
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _validateAndSubmit(),
          ),

          SizedBox(height: spacing),

          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              text: 'Send Reset Link',
              isLoading: isLoading,
              onPressed: isLoading ? null : _validateAndSubmit,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          // In your BlocListener or wherever you handle state:
          showSuccessDialog(context, state.message);
        }

        if (state is ForgotPasswordError) {
          AppToast.error(state.message, position: ToastPosition.top);
        }
      },
      builder: (context, state) {
        final size = MediaQuery.of(context).size;
        final width = size.width;
        final height = size.height;

        final isTablet = width >= 600;

        final horizontalPadding = width * 0.06;
        final verticalPadding = height * 0.05;
        final spacing = height * 0.035;

        final isLoading = state is ForgotPasswordLoading;

        return Scaffold(
          backgroundColor: const Color(0xFFF7F8FF),
          body: SafeArea(
            child: isTablet
                ? Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: width * 0.6),
                      child: _buildContent(
                        context,
                        horizontalPadding,
                        verticalPadding,
                        spacing,
                        isLoading,
                      ),
                    ),
                  )
                : _buildContent(
                    context,
                    horizontalPadding,
                    verticalPadding,
                    spacing,
                    isLoading,
                  ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}

void showSuccessDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Green badge icon
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFF4CAF50),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width*0.4,
                    height: MediaQuery.of(context).size.width*0.4,
                    decoration: BoxDecoration(
                      // color: const Color(0xFF43A047),
                      borderRadius: BorderRadius.circular(16),
                      shape: BoxShape.rectangle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CustomPaint(
                        painter: _BadgePainter(),
                        child:  Center(
                          child: Image(
                            image: AssetImage('assets/check.png'),
                            width:MediaQuery.of(context).size.width*0.4,
                            height: MediaQuery.of(context).size.width*0.4,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Title
            const Text(
              "Success",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 10),

            // Subtitle
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // Continue button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4355B9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// Custom painter for the scalloped/badge shape
class _BadgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF43A047);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const numPoints = 12;
    const outerRadius = 1.0;
    const innerRadius = 0.88;

    final path = Path();
    for (int i = 0; i < numPoints * 2; i++) {
      final angle = (i * 3.14159265 / numPoints) - 3.14159265 / 2;
      final r = i.isEven ? radius * outerRadius : radius * innerRadius;
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}