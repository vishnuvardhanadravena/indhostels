import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indhostels/bloc/auth/auth_bloc.dart';
import 'package:indhostels/bloc/auth/auth_event.dart';
import 'package:indhostels/bloc/auth/auth_state.dart';
import 'package:indhostels/pages/profile/profile.dart';
import 'package:indhostels/utils/helpers/app_toast.dart';
import 'package:indhostels/utils/widgets/authwidgts.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final Map<String, String?> _errors = {
    'current': null,
    'new': null,
    'confirm': null,
  };

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _clearError(String key) {
    if (_errors[key] != null) setState(() => _errors[key] = null);
  }

  void _submit() {
    context.read<AuthBloc>().add(
      ChangePasswordRequested(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
        confirmPassword: _confirmPasswordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = R(MediaQuery.sizeOf(context).width);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ChangePasswordValidationError) {
          setState(() {
            _errors['current'] = state.currentPasswordError;
            _errors['new'] = state.newPasswordError;
            _errors['confirm'] = state.confirmPasswordError;
          });
          return;
        }
        if (state is ChangePasswordError) {
          AppToast.error(state.message, position: ToastPosition.bottom);
          return;
        }
        if (state is ChangePasswordSuccess) {
          AppToast.success(state.message, position: ToastPosition.bottom);
          context.read<AuthBloc>().add(AuthReset());
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, size: r.backIconSize),
            onPressed: () {
              context.read<AuthBloc>().add(AuthReset());
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Change Password',
            style: TextStyle(
              fontSize: r.titleFontSize,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            // padding: EdgeInsets.symmetric(
            //   horizontal: r.screenPadH,
            //   vertical: r.screenPadV,
            // ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: r.isTablet ? 560 : double.infinity,
                  ),
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is ChangePasswordLoading;

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        elevation: 6,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField(
                                label: 'Current Password',
                                hintText: 'Enter your password',
                                controller: _currentPasswordController,
                                isPassword: true,
                                errorText: _errors['current'],
                                textInputAction: TextInputAction.next,
                                onChanged: (_) => _clearError('current'),
                              ),
                              SizedBox(height: r.fieldGap),

                              CustomTextField(
                                label: 'New Password',
                                hintText: 'Enter your password',
                                controller: _newPasswordController,
                                isPassword: true,
                                errorText: _errors['new'],
                                textInputAction: TextInputAction.next,
                                onChanged: (_) => _clearError('new'),
                              ),
                              SizedBox(height: r.fieldGap),

                              CustomTextField(
                                label: 'Confirm New Password',
                                hintText: 'Enter your password',
                                controller: _confirmPasswordController,
                                isPassword: true,
                                errorText: _errors['confirm'],
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => _submit(),
                                onChanged: (_) => _clearError('confirm'),
                              ),
                              SizedBox(height: r.sectionGap),

                              SizedBox(
                                width: double.infinity,
                                child: PrimaryButton(
                                  text: 'Update Password',
                                  isLoading: isLoading,
                                  onPressed: isLoading ? null : _submit,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
