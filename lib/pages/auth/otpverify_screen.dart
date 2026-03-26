import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indhostels/bloc/auth/auth_bloc.dart';
import 'package:indhostels/bloc/auth/auth_event.dart';
import 'package:indhostels/bloc/auth/auth_state.dart';
import 'package:indhostels/routing/route_constants.dart';
import 'package:indhostels/utils/helpers/app_toast.dart';
import 'package:indhostels/utils/widgets/authwidgts.dart';
import 'package:go_router/go_router.dart';

class OtpInputWidget extends StatefulWidget {
  final int length;
  final double boxSize;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;

  const OtpInputWidget({
    super.key,
    this.length = 4,
    this.boxSize = 60,
    required this.onCompleted,
    this.onChanged,
  });

  @override
  State<OtpInputWidget> createState() => _OtpInputWidgetState();
}

class _OtpInputWidgetState extends State<OtpInputWidget> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _fullOtp => _controllers.map((c) => c.text).join();

  void _onChanged(String value, int index) {
    if (value.length == 1 && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    widget.onChanged?.call(_fullOtp);
    if (_fullOtp.length == widget.length) widget.onCompleted(_fullOtp);
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.boxSize;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (i) {
        final isFocused = _focusNodes[i].hasFocus;
        return Focus(
          onFocusChange: (_) => setState(() {}),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.symmetric(horizontal: s * 0.10),
            width: s,
            height: s,
            decoration: BoxDecoration(
              color: isFocused ? Colors.white : const Color(0xFFF0F0F5),
              borderRadius: BorderRadius.circular(s * 0.22),
              border: Border.all(
                color: isFocused ? const Color(0xFF3D3BF3) : Colors.transparent,
                width: 2,
              ),
              boxShadow: isFocused
                  ? [
                      BoxShadow(
                        color: const Color(0xFF3D3BF3).withValues(alpha:0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: TextField(
              controller: _controllers[i],
              focusNode: _focusNodes[i],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(
                fontSize: s * 0.38,
                fontWeight: FontWeight.w700,
                color: isFocused
                    ? const Color(0xFF1A1A2E)
                    : const Color(0xFF9CA3AF),
              ),
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
              ),
              onChanged: (v) => _onChanged(v, i),
            ),
          ),
        );
      }),
    );
  }
}

class Otpverifyscreen extends StatefulWidget {
  final String phone;
  final int otp;
  final LoginType type;
  const Otpverifyscreen({
    super.key,
    required this.phone,
    required this.type,
    required this.otp,
  });
  @override
  State<Otpverifyscreen> createState() => _OtpverifyscreenState();
}

class _OtpverifyscreenState extends State<Otpverifyscreen> {
  String _otp = '';
  void _onContinue() {
    if (_otp.length < 4) {
      AppToast.error(
        'Please enter the 4-digit OTP',
        position: ToastPosition.top,
      );
      return;
    }
    context.read<AuthBloc>().add(
      VerifyOtpRequested(phone: widget.phone, otp: _otp, type: widget.type),
    );
  }

  void _onResend() {
    context.read<AuthBloc>().add(
      LoginRequested(phone: widget.phone, type: LoginType.otp),
    );
    AppToast.success(
      'OTP resent to ${widget.phone}',
      position: ToastPosition.bottom,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is VerifyLoginOtpSuccess) {
          AppToast.success('Login Successful', position: ToastPosition.bottom);
          context.goNamed(RouteList.home);
        }
        if (state is VerifySSignupOtpSuccess) {
          AppToast.success('Signup Successful', position: ToastPosition.bottom);
          context.goNamed(RouteList.login);
        }
        if (state is VerifyOtpError) {
          AppToast.error(state.message, position: ToastPosition.top);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: const Color(0xFFF7F8FF),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final isTablet = width >= 600;

                final contentWidth = isTablet
                    ? (width * 0.58).clamp(400.0, 520.0)
                    : width;

                final horizontalPadding = isTablet ? 0.0 : 24.0;
                final verticalPadding = isTablet ? 40.0 : 20.0;

                final boxSize = isTablet ? 68.0 : ((width - 48) / 4) * 0.74;

                final content = SizedBox(
                  width: contentWidth,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: verticalPadding,
                    ),
                    child: Column(
                      children: [
                        AuthHeader(
                          title: 'Enter OTP',
                          subtitle:
                              'We have just sent you a 4-digit code via your phone number(${widget.otp})',
                          showBackButton: true,
                        ),

                        const SizedBox(height: 8),

                        Text(
                          widget.phone,
                          style: TextStyle(
                            fontSize: isTablet ? 16 : 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),

                        SizedBox(height: isTablet ? 48 : 36),

                        OtpInputWidget(
                          length: 4,
                          boxSize: boxSize,
                          onCompleted: (otp) => setState(() => _otp = otp),
                          onChanged: (otp) => setState(() => _otp = otp),
                        ),

                        SizedBox(height: isTablet ? 48 : 36),

                        PrimaryButton(
                          text: 'Continue',
                          isLoading: isLoading,
                          onPressed: isLoading ? null : _onContinue,
                        ),

                        const SizedBox(height: 20),

                        AuthFooterLink(
                          normalText: "Didn't receive code? ",
                          linkText: 'Resend Code',
                          onLinkTap: isLoading ? () {} : _onResend,
                        ),
                      ],
                    ),
                  ),
                );

                /// ===== RESPONSIVE WRAP =====
                return isTablet ? Center(child: content) : content;
              },
            ),
          ),
        );
      },
    );
  }
}
