import 'package:go_router/go_router.dart';
import 'package:indhostels/pages/auth/login.dart';
import 'package:indhostels/pages/dashbord/bookings.dart';
import 'package:indhostels/pages/dashbord/dashbord.dart';
import 'package:indhostels/pages/dashbord/home.dart';
import 'package:indhostels/pages/dashbord/profile.dart';
import 'package:indhostels/pages/dashbord/search.dart';
import 'package:indhostels/pages/on_boardingScreen.dart';
import 'package:indhostels/pages/spalshScreen.dart';
import 'package:indhostels/routing/route_constants.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteList.splash,
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
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: RouteList.search,
          builder: (context, state) => const SearchScreen(),
        ),
        GoRoute(
          path: RouteList.bookings,
          builder: (context, state) => const BookingsScreen(),
        ),
        GoRoute(
          path: RouteList.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
