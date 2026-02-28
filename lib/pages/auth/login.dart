import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indhostels/bloc/auth/auth_bloc.dart';
import 'package:indhostels/bloc/auth/auth_event.dart';
import 'package:indhostels/bloc/auth/auth_state.dart';
import 'package:indhostels/pages/auth/signup.dart';
import 'package:indhostels/utils/helpers/app_toast.dart';
import 'package:indhostels/utils/widgets/auth_header.dart';
import 'package:indhostels/utils/widgets/authwidgts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _selectedTab = 0;

  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _rememberMe = false;

  Map<String, String?> _errors = {};

  bool _isValidEmail(String v) =>
      RegExp(r'^[\w.%+-]+@[\w.-]+\.[a-zA-Z]{2,}$').hasMatch(v);

  bool _isValidPhone(String v) => RegExp(r'^[0-9]{10}$').hasMatch(v);

  void _onPasswordLogin() {
    final errors = <String, String?>{};

    final email = _phoneController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      errors['email'] = '*Phone number is required';
    }

    if (password.isEmpty) {
      errors['password'] = '*Password is required';
    }

    setState(() => _errors = errors);
    if (errors.isNotEmpty) return;

    context.read<AuthBloc>().add(
      LoginRequested(phone: email, password: password),
    );
  }

  Future<void> _onGetOtp() async {
    final errors = <String, String?>{};
    final phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      errors['phone'] = '*Phone number is required';
    } else if (!_isValidPhone(phone))
      errors['phone'] = '*Enter valid 10-digit number';

    setState(() => _errors = errors);
    if (errors.isNotEmpty) return;

    // TODO: call your auth provider
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          AppToast.success(context, "Login Successful");
        }

        if (state is AuthError) {
          AppToast.error(context, state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF7F8FF),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthHeader(
                    title: 'Welcome Back!',
                    subtitle:
                        'Log in to manage your bookings and explore new stays',
                  ),

                  const SizedBox(height: 32),

                  AuthTabSwitcher(
                    selectedIndex: _selectedTab,
                    tabs: const ['Password Login', 'OTP Login'],
                    onTabSelected: (i) => setState(() {
                      _selectedTab = i;
                      _errors = {};
                    }),
                  ),

                  const SizedBox(height: 28),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _selectedTab == 0
                        ? _passwordLoginContent(
                            context.watch<AuthBloc>().state is AuthLoading,
                          )
                        : _otpLoginContent(
                            context.watch<AuthBloc>().state is AuthLoading,
                          ),
                  ),

                  const SizedBox(height: 28),

                  AuthFooterLink(
                    normalText: "Don't have an account? ",
                    linkText: 'Sign Up',
                    onLinkTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SignUpScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _passwordLoginContent(bool isLoading) {
    return Column(
      key: const ValueKey('password'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: 'Phone Number',
          hintText: 'Enter your phone number',
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          errorText: _errors['phone'],
          textInputAction: TextInputAction.next,
        ),

        const SizedBox(height: 16),

        CustomTextField(
          label: 'Password',
          hintText: 'Enter your password',
          controller: _passwordController,
          isPassword: true,
          errorText: _errors['password'],
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _onPasswordLogin(),
        ),

        const SizedBox(height: 14),

        Row(
          children: [
            SizedBox(
              height: 22,
              width: 22,
              child: Checkbox(
                value: _rememberMe,
                onChanged: (v) => setState(() => _rememberMe = v ?? false),
                activeColor: const Color(0xFF3D3BF3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                side: const BorderSide(color: Color(0xFFD1D5DB), width: 1.5),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Remember Me',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                // TODO: navigate to forgot password
              },
              child: const Text(
                'Forgot Password',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF3D3BF3),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        PrimaryButton(
          text: 'Sign In',
          isLoading: isLoading,
          onPressed: isLoading ? null : _onPasswordLogin,
        ),
      ],
    );
  }

  Widget _otpLoginContent(bool isLoading) {
    return Column(
      key: const ValueKey('otp'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PhoneInputField(
          label: 'Phone Number',
          controller: _phoneController,
          errorText: _errors['phone'],
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          text: 'Get OTP',
          isLoading: isLoading,
          onPressed: isLoading ? null : _onGetOtp,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
