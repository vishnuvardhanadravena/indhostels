
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLogin();
    });
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));

    final storage = sl<AppSecureStorage>();

    final token = await storage.readString("token");
    final isLoggedIn = await storage.readBool("login") ?? false;

    if (!mounted) return;

    if (token != null && token.isNotEmpty && isLoggedIn) {
      context.go(RouteList.home);
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
          final isTablet = screenWidth >= 600;

          return Center(
            child: SizedBox(
              width: isTablet ? screenWidth * 0.25 : screenWidth * 0.4,
              child: Image.asset(ImageConstants.appicon, fit: BoxFit.contain),
            ),
          );
        },
      ),
    );
  }
}
