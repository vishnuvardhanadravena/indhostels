import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indhostels/bloc/auth/auth_bloc.dart';
import 'package:indhostels/bloc/auth/auth_event.dart';
import 'package:indhostels/bloc/auth/auth_state.dart';
import 'package:indhostels/routing/route_constants.dart';
import 'package:indhostels/utils/helpers/app_toast.dart';
import 'package:indhostels/utils/widgets/authwidgts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _termsAccepted = false;
  // bool _isLoading = false;
  Map<String, String?> _errors = {};

  bool _isValidEmail(String v) =>
      RegExp(r'^[\w.%+-]+@[\w.-]+\.[a-zA-Z]{2,}$').hasMatch(v);

  bool _isValidPhone(String v) => RegExp(r'^[0-9]{10}$').hasMatch(v);
  void _onSignUp() {
    final errors = <String, String?>{};

    final name = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    if (name.isEmpty) {
      errors['name'] = '*Full name is required';
    } else if (name.length < 2) {
      errors['name'] = '*Enter a valid name';
    }

    if (email.isEmpty) {
      errors['email'] = '*Email is required';
    } else if (!_isValidEmail(email)) {
      errors['email'] = '*Enter a valid email';
    }

    if (phone.isEmpty) {
      errors['phone'] = '*Phone number is required';
    } else if (!_isValidPhone(phone)) {
      errors['phone'] = '*Enter valid 10-digit number';
    }

    if (password.isEmpty) {
      errors['password'] = '*Password is required';
    } else if (password.length < 6) {
      errors['password'] = '*Minimum 6 characters';
    }

    if (confirm.isEmpty) {
      errors['confirm'] = '*Please confirm your password';
    } else if (confirm != password) {
      errors['confirm'] = '*Passwords do not match';
    }

    if (!_termsAccepted) {
      errors['terms'] = '*Please accept terms & conditions';
    }

    setState(() => _errors = errors);
    if (errors.isNotEmpty) return;

    context.read<AuthBloc>().add(
      SignUpRequested(
        fullName: name,
        email: email,
        phone: phone,
        password: password,
        confirmPassword: confirm,
        isTermsAccepted: _termsAccepted,
        type: LoginType.password,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          AppToast.success(
            state.message.message ?? "Signup Successful",
            position: ToastPosition.bottom,
          );

          context.pushNamed(
  RouteList.otp,
  extra: {
    "phone": _phoneController.text.trim(),
    "type": LoginType.signup, // or login
  },
);
        }

        if (state is SignUpError) {
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
        final fieldSpacing = height * 0.02;

        final isLoading = state is SignUpLoading;

        return Scaffold(
          backgroundColor: const Color(0xFFF7F8FF),
          body: SafeArea(
            child: isTablet
                ? Center(
                    child: _buildForm(
                      horizontalPadding,
                      verticalPadding,
                      fieldSpacing,
                      height,
                      isLoading,
                    ),
                  )
                : _buildForm(
                    horizontalPadding,
                    verticalPadding,
                    fieldSpacing,
                    height,
                    isLoading,
                  ),
          ),
        );
      },
    );
  }

  Widget _buildForm(
    double horizontalPadding,
    double verticalPadding,
    double fieldSpacing,
    double height,
    bool isLoading,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AuthHeader(
            showBackButton: true,
            title: 'Create an Account',
            subtitle:
                'Join IndHostel to book stays, manage favorites, and more',
          ),

          SizedBox(height: height * 0.04),

          CustomTextField(
            label: 'Full Name',
            hintText: 'Enter your full name',
            controller: _fullNameController,
            errorText: _errors['name'],
          ),

          SizedBox(height: fieldSpacing),

          CustomTextField(
            label: 'Email Address',
            hintText: 'Enter your email address',
            controller: _emailController,
            errorText: _errors['email'],
          ),

          SizedBox(height: fieldSpacing),

          PhoneInputField(
            label: 'Phone Number',
            controller: _phoneController,
            errorText: _errors['phone'],
          ),

          SizedBox(height: fieldSpacing),

          CustomTextField(
            label: 'Password',
            hintText: 'Enter your password',
            controller: _passwordController,
            isPassword: true,
            errorText: _errors['password'],
          ),

          SizedBox(height: fieldSpacing),

          CustomTextField(
            label: 'Confirm Password',
            hintText: 'Confirm your password',
            controller: _confirmPasswordController,
            isPassword: true,
            errorText: _errors['confirm'],
          ),

          SizedBox(height: height * 0.025),

          TermsCheckbox(
            value: _termsAccepted,
            onChanged: (v) => setState(() => _termsAccepted = v ?? false),
          ),

          if (_errors['terms'] != null)
            Padding(
              padding: EdgeInsets.only(top: 6, left: 8),
              child: Text(
                _errors['terms']!,
                style: TextStyle(color: Colors.red.shade500, fontSize: 12),
              ),
            ),

          SizedBox(height: height * 0.04),

          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              text: 'Sign Up',
              isLoading: isLoading,
              onPressed: isLoading ? null : _onSignUp,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
