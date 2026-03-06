import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indhostels/bloc/profile/profile_bloc.dart';
import 'package:indhostels/bloc/profile/profile_event.dart';
import 'package:indhostels/utils/theame/app_themes.dart';

class MainNavBarScreen extends StatefulWidget {
  final Widget child;

  const MainNavBarScreen({super.key, required this.child});

  @override
  State<MainNavBarScreen> createState() => _MainNavBarScreenState();
}

class _MainNavBarScreenState extends State<MainNavBarScreen> {
  int _getIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/search')) return 1;
    if (location.startsWith('/bookings')) return 2;
    if (location.startsWith('/profile')) return 3;

    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/bookings');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<ProfileBloc>().add(ProfileLoadEvent());
  });
}

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getIndex(context);
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => _onTap(context, i),
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          fontSize: 14,
        ),
        unselectedItemColor: Colors.black,
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 14,
        ),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AssetIconWithFallback(
                assetPath: "assets/icons/bottom_home.png",
                fallbackIcon: Icons.home,
                color: currentIndex == 0 ? AppColors.primary : Colors.black,
              ),
            ),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AssetIconWithFallback(
                assetPath: "assets/icons/proicons_search.png",
                fallbackIcon: Icons.search,
                color: currentIndex == 1 ? AppColors.primary : Colors.black,
              ),
            ),
            label: "Search",
          ),

          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AssetIconWithFallback(
                assetPath: "assets/icons/proicons_calendar.png",
                fallbackIcon: Icons.book,
                color: currentIndex == 2 ? AppColors.primary : Colors.black,
              ),
            ),
            label: "Bookings",
          ),

          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AssetIconWithFallback(
                assetPath: "assets/icons/proicons_profile.png",
                fallbackIcon: Icons.person,
                color: currentIndex == 3 ? AppColors.primary : Colors.black,
              ),
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

class AssetIconWithFallback extends StatelessWidget {
  final String assetPath;
  final IconData fallbackIcon;
  final double size;
  final Color? color;

  const AssetIconWithFallback({
    super.key,
    required this.assetPath,
    required this.fallbackIcon,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      color: color,
      errorBuilder: (context, error, stackTrace) {
        return Icon(fallbackIcon, size: size, color: color);
      },
    );
  }
}
