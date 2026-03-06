import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:indhostels/bloc/auth/auth_event.dart';
import 'package:indhostels/pages/auth/change_password.dart';
import 'package:indhostels/pages/auth/forgotpass.dart';
import 'package:indhostels/pages/auth/login.dart';
import 'package:indhostels/pages/auth/otpverifyScreen.dart';
import 'package:indhostels/pages/category/category_screen.dart';
import 'package:indhostels/pages/dashbord/bookings.dart';
import 'package:indhostels/pages/dashbord/dashbord.dart';
import 'package:indhostels/pages/dashbord/home.dart';
import 'package:indhostels/pages/profile/edit_profile.dart';
import 'package:indhostels/pages/profile/profile.dart';
import 'package:indhostels/pages/dashbord/search.dart';
import 'package:indhostels/on_boardingScreen.dart';
import 'package:indhostels/spalshScreen.dart';
import 'package:indhostels/routing/route_constants.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GoRouter appRouter = GoRouter(
  initialLocation: RouteList.splash,
  navigatorKey: rootNavigatorKey,
  routes: [
    GoRoute(
      path: RouteList.splash,
      builder: (context, state) => const SplashScreen(),
    ),

    GoRoute(
      path: RouteList.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),

    GoRoute(
      path: RouteList.login,
      builder: (context, state) => const LoginScreen(),
    ),

    ShellRoute(
      builder: (context, state, child) {
        return MainNavBarScreen(child: child);
      },
      routes: [
        GoRoute(
          path: RouteList.home,
          name: RouteList.home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: RouteList.search,
          name: RouteList.search,
          builder: (context, state) => const SearchScreen(),
        ),
        GoRoute(
          path: RouteList.bookings,
          name: RouteList.bookings,
          builder: (context, state) => const BookingsScreen(),
        ),
        GoRoute(
          path: RouteList.profile,
          name: RouteList.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: RouteList.otp,
      name: RouteList.otp,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        final phone = data["phone"] as String;
        final type = data["type"] as LoginType;

        return Otpverifyscreen(phone: phone, type: type);
      },
    ),
    GoRoute(
      path: RouteList.forgotPassWord,
      name: RouteList.forgotPassWord,
      builder: (context, state) => const Forgotpassword(),
    ),
    GoRoute(
      path: RouteList.change_password,
      name: RouteList.change_password,
      builder: (context, state) => const ChangePasswordScreen(),
    ),
    GoRoute(
      path: RouteList.edit_profile,
      name: RouteList.edit_profile,
      builder: (context, state) => const EditProfileScreen(),
    ),

    GoRoute(
      path: RouteList.categoryScreen,
      name: RouteList.categoryScreen,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        final title = data["title"] as String;

        return HotelsScreen(title: title ?? "Hotels");
      },
    ),
  ],
);
