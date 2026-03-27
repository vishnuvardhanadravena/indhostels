import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:indhostels/bloc/profile/profile_bloc.dart';
import 'package:indhostels/bloc/profile/profile_event.dart';
import 'package:indhostels/routing/route_constants.dart';
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
    if (location.startsWith(RouteList.bookings)) return 2;
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
        context.go(RouteList.bookings);
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  Future<bool?> _showExitBottomSheet({String? imageAsset, String? imageUrl}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (ctx) {
        final screenHeight = MediaQuery.of(ctx).size.height;

        final sheet = Container(
          height: isTablet ? 480 : screenHeight * 0.5,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          decoration: const BoxDecoration(color: Colors.white),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Text(
                        "Are you sure you want\nto exit the app?",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx, false),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _buildImage(
                      imageAsset: imageAsset,
                      imageUrl: imageUrl,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      SystemNavigator.pop();
                      // Navigator.pop(ctx, true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Exit",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

        if (isTablet) {
          return Center(child: SizedBox(width: 420, child: sheet));
        }

        return sheet;
      },
    );
  }

  Widget _buildImage({String? imageAsset, String? imageUrl}) {
    if (imageAsset != null) {
      final isSvg = imageAsset.toLowerCase().endsWith('.svg');
      if (isSvg) {
        return SvgPicture.asset(
          imageAsset,
          fit: BoxFit.contain,
          width: double.infinity,
          placeholderBuilder: (_) => _placeholderImage(),
        );
      }
      return Image.asset(
        imageAsset,
        fit: BoxFit.contain,
        width: double.infinity,
      );
    }
    if (imageUrl != null) {
      final isSvg = imageUrl.toLowerCase().contains('.svg');
      if (isSvg) {
        return SvgPicture.network(
          imageUrl,
          fit: BoxFit.contain,
          width: double.infinity,
          placeholderBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
        );
      }
      return Image.network(
        imageUrl,
        fit: BoxFit.contain,
        width: double.infinity,
        loadingBuilder: (_, child, progress) => progress == null
            ? child
            : const Center(child: CircularProgressIndicator()),
        errorBuilder: (ctx, e, s) => _placeholderImage(),
      );
    }
    return _placeholderImage();
  }

  Widget _placeholderImage() {
    return Container(
      color: Colors.grey.shade100,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 48,
          color: Colors.grey,
        ),
      ),
    );
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (currentIndex != 0) {
          context.go('/home');
          return;
        }
        await _showExitBottomSheet(
          // imageAsset: "assets/exist2.svg",
          imageUrl:
              "https://img.freepik.com/premium-vector/photo-vector-illustration-happy-face-sad-face-funny-face-expression-with-tears_763111-106679.jpg?semt=ais_hybrid&w=740&q=80",
          // "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRCcXdVOFYRpH-Bd1WV50YDFftBhPvff3oqXQ&s",

          // imageUrl:
          //     "https://market-resized.envatousercontent.com/previews/files/345160807/preview.jpg?w=590&h=590&cf_fit=crop&crop=top&format=auto&q=85&s=6a6a5e559fc499ffad80b0fcfdc6fe4b5058fd68891cc7f6b592b65d37542acf",
        );
        // if (shouldExit == true) {
        //   SystemNavigator.pop();
        // }
      },
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (i) => _onTap(context, i),
          type: BottomNavigationBarType.fixed,

          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.black,

          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),

          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),

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
