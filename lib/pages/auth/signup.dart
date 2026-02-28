import 'package:flutter/material.dart';
import 'package:indhostels/utils/widgets/auth_header.dart';
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
  bool _isLoading = false;
  Map<String, String?> _errors = {};

  // ─── Validation ────────────────────────────────────────────────────────────

  bool _isValidEmail(String v) =>
      RegExp(r'^[\w.%+-]+@[\w.-]+\.[a-zA-Z]{2,}$').hasMatch(v);

  bool _isValidPhone(String v) => RegExp(r'^[0-9]{10}$').hasMatch(v);

  // ─── Sign Up Handler ───────────────────────────────────────────────────────

  Future<void> _onSignUp() async {
    final errors = <String, String?>{};

    final name = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    if (name.isEmpty)
      errors['name'] = '*Full name is required';
    else if (name.length < 2)
      errors['name'] = '*Enter a valid name';

    if (email.isEmpty)
      errors['email'] = '*Email is required';
    else if (!_isValidEmail(email))
      errors['email'] = '*Enter a valid email';

    if (phone.isEmpty)
      errors['phone'] = '*Phone number is required';
    else if (!_isValidPhone(phone))
      errors['phone'] = '*Enter valid 10-digit number';

    if (password.isEmpty)
      errors['password'] = '*Password is required';
    else if (password.length < 6)
      errors['password'] = '*Minimum 6 characters';

    if (confirm.isEmpty)
      errors['confirm'] = '*Please confirm your password';
    else if (confirm != password)
      errors['confirm'] = '*Passwords do not match';

    if (!_termsAccepted) errors['terms'] = '*Please accept terms & conditions';

    setState(() => _errors = errors);
    if (errors.isNotEmpty) return;

    setState(() => _isLoading = true);
    // TODO: call your auth provider
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────────
              const AuthHeader(
                showBackButton: true,
                title: 'Create an Account',
                subtitle:
                    'Join IndHostel to book stays, manage favorites, and more',
              ),

              const SizedBox(height: 32),

              // ── Full Name ────────────────────────────────────────────────
              CustomTextField(
                label: 'Full Name',
                hintText: 'Enter your full name',
                controller: _fullNameController,
                keyboardType: TextInputType.name,
                errorText: _errors['name'],
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 16),

              // ── Email ────────────────────────────────────────────────────
              CustomTextField(
                label: 'Email Address',
                hintText: 'Enter your email address',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                errorText: _errors['email'],
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 16),

              // ── Phone ────────────────────────────────────────────────────
              PhoneInputField(
                label: 'Phone Number',
                controller: _phoneController,
                errorText: _errors['phone'],
              ),

              const SizedBox(height: 16),

              // ── Password ─────────────────────────────────────────────────
              CustomTextField(
                label: 'Password',
                hintText: 'Enter your password',
                controller: _passwordController,
                isPassword: true,
                errorText: _errors['password'],
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 16),

              // ── Confirm Password ─────────────────────────────────────────
              CustomTextField(
                label: 'Confirm Password',
                hintText: 'Confirm your password',
                controller: _confirmPasswordController,
                isPassword: true,
                errorText: _errors['confirm'],
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _onSignUp(),
              ),

              const SizedBox(height: 20),

              // ── Terms Checkbox ───────────────────────────────────────────
              TermsCheckbox(
                value: _termsAccepted,
                onChanged: (v) => setState(() => _termsAccepted = v ?? false),
                onLinkTap: () {
                  // TODO: open terms & conditions
                },
              ),

              if (_errors['terms'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 32),
                  child: Text(
                    _errors['terms']!,
                    style: TextStyle(color: Colors.red.shade500, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 24),

              // ── Sign Up Button ───────────────────────────────────────────
              PrimaryButton(
                text: 'Sign Up',
                isLoading: _isLoading,
                onPressed: _onSignUp,
              ),

              const SizedBox(height: 20),

              // ── Footer ───────────────────────────────────────────────────
              AuthFooterLink(
                normalText: 'Already have an account? ',
                linkText: 'Sign In',
                onLinkTap: () {
                  Navigator.pop(context);
                  // or: Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                },
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
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
