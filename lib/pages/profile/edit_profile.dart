import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indhostels/bloc/profile/profile_bloc.dart';
import 'package:indhostels/bloc/profile/profile_event.dart';
import 'package:indhostels/bloc/profile/profile_state.dart';
import 'package:indhostels/pages/profile/profile.dart';
import 'package:indhostels/utils/helpers/app_toast.dart';
import 'package:indhostels/utils/widgets/authwidgts.dart';
import 'package:indhostels/utils/widgets/file_pickers.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final user = UserSession();
  File? _pickedImage;
  late final _nameController = TextEditingController();
  late final _emailController = TextEditingController();
  late final _phoneController = TextEditingController();
  String _gender = 'Female';
  final Map<String, String?> _errors = {
    'name': null,
    'email': null,
    'phone': null,
  };
  @override
  void initState() {
    super.initState();
    _nameController.text = user.user?.fullname ?? " enter user name";
    _emailController.text = user.user?.email ?? " example@gmail.com";
    _phoneController.text = user.user?.phone ?? "1234567890";
    _gender = user.user?.gender ?? "Male";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _validate() {
    final errors = <String, String?>{};

    if (_nameController.text.trim().isEmpty) {
      errors['name'] = 'Full name is required';
    }

    final email = _emailController.text.trim();
    if (email.isEmpty) {
      errors['email'] = 'Email address is required';
    } else if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      errors['email'] = 'Enter a valid email address';
    }

    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      errors['phone'] = 'Phone number is required';
    } else if (phone.length < 7) {
      errors['phone'] = 'Enter a valid phone number';
    }

    setState(() {
      _errors['name'] = errors['name'];
      _errors['email'] = errors['email'];
      _errors['phone'] = errors['phone'];
    });

    return errors.isEmpty;
  }

  Future<void> _onSave() async {
    if (!_validate()) return;
    context.read<ProfileBloc>().add(
      ProfileUpdateEvent(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        gender: _gender.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isProfileLoading =
        context.watch<ProfileBloc>().state is ProfileImgLoading;
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          AppToast.error(state.message);
        }
        if (state is ProfileUpdateSuccess) {
          AppToast.success(state.message);
        }
        if (state is ProfileImgLoading) {}
        if (state is ProfileImgError) {
          setState(() {
            _pickedImage = null;
          });
          AppToast.error(state.message);
        }
        if (state is ProfileImgLoaded) {
          AppToast.success("Profle image updated");
          context.read<ProfileBloc>().add(ProfileLoadEvent());
        }
        if (state is ProfileLoaded) {
          setState(() {});
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              final r = R(constraints.maxWidth);
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFDDD6F0),
                      Color(0xFFEEEBF7),
                      Color(0xFFF5F3FB),
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
                child: SafeArea(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: r.screenPadH,
                              vertical: r.screenPadV,
                            ),
                            child: _AppBar(r: r),
                          ),

                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                horizontal: r.screenPadH,
                              ),
                              child: Column(
                                children: [
                                  AvatarWidget(
                                    r: r,
                                    heroTag: "profile_avatar",
                                    fileImage: _pickedImage,
                                    imageUrl: user.user?.profileUrl,
                                    onEditTap: () async {
                                      final file = await ImagePickerSheet.show(
                                        context,
                                      );
                                      if (file == null) return;
                                      setState(() {
                                        _pickedImage = file;
                                      });
                                      if (!context.mounted) return;
                                      context.read<ProfileBloc>().add(
                                        ProfileImgUpdateEvent(img: file),
                                      );
                                    },
                                  ),
                                  SizedBox(height: r.avatarGap),

                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: r.cardPadH,
                                      vertical: r.cardPadV,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                        r.cardRadius,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF4B3FC8,
                                          ).withValues(alpha: 0.07),
                                          blurRadius: 24,
                                          offset: const Offset(0, 8),
                                        ),
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.03,
                                          ),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomTextField(
                                          label: 'Full Name',
                                          hintText: 'Enter your full name',
                                          controller: _nameController,
                                          keyboardType: TextInputType.name,
                                          errorText: _errors['name'],
                                          textInputAction: TextInputAction.next,
                                        ),
                                        SizedBox(height: r.fieldGap),

                                        CustomTextField(
                                          label: 'Email Address',
                                          hintText: 'Enter your email address',
                                          controller: _emailController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          errorText: _errors['email'],
                                          textInputAction: TextInputAction.next,
                                        ),
                                        SizedBox(height: r.fieldGap),

                                        CustomTextField(
                                          label: 'Phone Number',
                                          hintText: 'Enter your phone number',
                                          controller: _phoneController,
                                          keyboardType: TextInputType.phone,
                                          errorText: _errors['phone'],
                                          textInputAction: TextInputAction.done,
                                        ),
                                        SizedBox(height: r.fieldGap),

                                        _GenderSelector(
                                          r: r,
                                          selected: _gender,
                                          onChanged: (val) =>
                                              setState(() => _gender = val),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: r.sectionGap),

                                  SizedBox(
                                    width: double.infinity,
                                    child: PrimaryButton(
                                      text: 'Save Changes',
                                      isLoading:
                                          state is ProfileInitial ||
                                          state is ProfileupdateLoading,
                                      onPressed:
                                          state is ProfileInitial ||
                                              state is ProfileupdateLoading
                                          ? null
                                          : _onSave,
                                    ),
                                  ),

                                  SizedBox(height: r.sectionGap),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (isProfileLoading)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.4),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _AppBar extends StatelessWidget {
  final R r;
  const _AppBar({required this.r});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Icon(
              Icons.arrow_back_rounded,
              size: r.backIconSize,
              color: const Color(0xFF1A1340),
            ),
          ),
        ),
        Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: r.titleFontSize,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1340),
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final R r;
  final String selected;
  final ValueChanged<String> onChanged;

  const _GenderSelector({
    required this.r,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: TextStyle(
            fontSize: r.genderFontSize + 1,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1340),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _GenderOption(
              r: r,
              label: 'Male',
              value: 'Male',
              groupValue: selected,
              onChanged: onChanged,
            ),
            SizedBox(width: r.radioGap),
            _GenderOption(
              r: r,
              label: 'Female',
              value: 'Female',
              groupValue: selected,
              onChanged: onChanged,
            ),
          ],
        ),
      ],
    );
  }
}

class _GenderOption extends StatelessWidget {
  final R r;
  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  const _GenderOption({
    required this.r,
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: r.genderIconSize,
            height: r.genderIconSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF4B3FC8)
                    : const Color(0xFFCBC3E8),
                width: isSelected ? 5.5 : 1.8,
              ),
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: r.genderFontSize,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? const Color(0xFF4B3FC8)
                  : const Color(0xFF1A1340).withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }
}
