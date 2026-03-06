import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indhostels/bloc/profile/profile_bloc.dart';
import 'package:indhostels/bloc/profile/profile_event.dart';
import 'package:indhostels/bloc/profile/profile_state.dart';
import 'package:indhostels/routing/route_constants.dart';
import 'package:indhostels/services/database/app_secure_storage.dart';
import 'package:indhostels/services/init.dart';
import 'package:indhostels/utils/constants/image_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final storage = sl<AppSecureStorage>();

    final token = await storage.readString("token");
    final isLoggedIn = await storage.readBool("login") ?? false;

    if (token != null && token.isNotEmpty && isLoggedIn) {
      final bloc = context.read<ProfileBloc>();

      bloc.add(ProfileLoadEvent());

      final state = await bloc.stream.firstWhere(
        (state) => state is ProfileLoaded || state is ProfileError,
      );

      if (!mounted) return;

      if (state is ProfileLoaded) {
        context.go(RouteList.home);
      } else {
        context.go(RouteList.login);
      }
    } else {
      context.go(RouteList.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1800AC),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          final isTablet = screenWidth >= 600;

          return Center(
            child: SizedBox(
              width: isTablet
                  ? screenWidth *
                        0.25 // smaller on tablet
                  : screenWidth * 0.4, // bigger on mobile
              child: Image.asset(ImageConstants.appicon, fit: BoxFit.contain),
            ),
          );
        },
      ),
    );
  }
}
