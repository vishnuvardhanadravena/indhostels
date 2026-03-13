import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indhostels/bloc/auth/auth_bloc.dart';
import 'package:indhostels/bloc/auth/auth_event.dart';
import 'package:indhostels/bloc/auth/auth_state.dart';
import 'package:indhostels/pages/auth/signup.dart';
import 'package:indhostels/routing/route_constants.dart';
import 'package:indhostels/utils/helpers/app_toast.dart';
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

  // bool _isValidEmail(String v) =>
  //     RegExp(r'^[\w.%+-]+@[\w.-]+\.[a-zA-Z]{2,}$').hasMatch(v);

  bool _isValidPhone(String v) => RegExp(r'^[0-9]{10}$').hasMatch(v);

  void _onPasswordLogin() {
    final errors = <String, String?>{};

    final email = _phoneController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      errors['phone'] = '*Phone number is required';
    } else if (!_isValidPhone(email)) {
      errors['phone'] = '*Enter valid 10-digit number';
    }
    if (password.isEmpty) {
      errors['password'] = '*Password is required';
    }

    setState(() => _errors = errors);
    if (errors.isNotEmpty) return;

    context.read<AuthBloc>().add(
      LoginRequested(
        phone: email,
        password: password,
        type: LoginType.password,
      ),
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

    context.read<AuthBloc>().add(
      LoginRequested(phone: phone, type: LoginType.otp),
    );
  }

  Widget _buildContent(
    BuildContext context,
    double horizontalPadding,
    double verticalPadding,
    double sectionSpacing,
    bool isLoading,
    double height,
    bool isTab,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AuthHeader(
            title: 'Welcome Back!',
            subtitle: 'Log in to manage your bookings and explore new stays',
          ),

          SizedBox(height: sectionSpacing),

          AuthTabSwitcher(
            isTab: isTab,
            selectedIndex: _selectedTab,
            tabs: const ['Password Login', 'OTP Login'],
            onTabSelected: (i) => setState(() {
              _selectedTab = i;
              _errors = {};
            }),
          ),

          SizedBox(height: sectionSpacing),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _selectedTab == 0
                ? _passwordLoginContent(isLoading, height)
                : _otpLoginContent(isLoading, height),
          ),

          SizedBox(height: sectionSpacing),

          AuthFooterLink(
            normalText: "Don't have an account? ",
            linkText: 'Sign Up',
            onLinkTap: () {
               context.push(RouteList.signup);
             
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          AppToast.success("Login Successful", position: ToastPosition.bottom);
          context.goNamed(RouteList.home);
        }
        if (state is OtpSentSuccess) {
          AppToast.success(
            "OTP sent to ${state.phone}",
            position: ToastPosition.bottom,
          );
          context.pushNamed(
            RouteList.otp,
            extra: {"phone": state.phone.trim(), "type": LoginType.login},
          );
        }

        if (state is AuthError) {
          AppToast.error(state.message, position: ToastPosition.top);
        }
      },
      builder: (context, state) {
        final size = MediaQuery.of(context).size;
        final width = size.width;
        final height = size.height;

        final isTablet = width >= 600;

        final horizontalPadding = width * 0.06;
        final verticalPadding = height * 0.04;
        final sectionSpacing = height * 0.035;

        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: const Color(0xFFF7F8FF),
          body: SafeArea(
            child: isTablet
                ? Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: width * 0.65),
                      child: _buildContent(
                        context,
                        horizontalPadding,
                        verticalPadding,
                        sectionSpacing,
                        isLoading,
                        height,
                        isTablet,
                      ),
                    ),
                  )
                : _buildContent(
                    context,
                    horizontalPadding,
                    verticalPadding,
                    sectionSpacing,
                    isLoading,
                    height,
                    isTablet,
                  ),
          ),
        );
      },
    );
  }

  Widget _passwordLoginContent(bool isLoading, double height) {
    final fieldSpacing = height * 0.02;

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

        SizedBox(height: fieldSpacing),

        CustomTextField(
          label: 'Password',
          hintText: 'Enter your password',
          controller: _passwordController,
          isPassword: true,
          errorText: _errors['password'],
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _onPasswordLogin(),
        ),

        SizedBox(height: height * 0.02),

        Row(
          children: [
            SizedBox(
              height: 22,
              width: 22,
              child: Checkbox(
                value: _rememberMe,
                onChanged: (v) => setState(() => _rememberMe = v ?? false),
                activeColor: const Color(0xFF3D3BF3),
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
                context.pushNamed(RouteList.forgotPassWord);
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

        SizedBox(height: height * 0.035),

        SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            text: 'Sign In',
            isLoading: isLoading,
            onPressed: isLoading ? null : _onPasswordLogin,
          ),
        ),
      ],
    );
  }

  Widget _otpLoginContent(bool isLoading, double height) {
    // final fieldSpacing = height * 0.02;

    return Column(
      key: const ValueKey('otp'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PhoneInputField(
          label: 'Phone Number',
          controller: _phoneController,
          errorText: _errors['phone'],
        ),

        SizedBox(height: height * 0.035),

        SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            text: 'Get OTP',
            isLoading: isLoading,
            onPressed: isLoading ? null : _onGetOtp,
          ),
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
