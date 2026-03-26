import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indhostels/routing/route_constants.dart';

// ─── Data Model ────────────────────────────────────────────────────────────────

class OnboardingData {
  final String imagePath; // Replace with your asset path or NetworkImage URL
  final String networkImage; // Placeholder network image
  final String title;
  final String subtitle;

  const OnboardingData({
    required this.imagePath,
    required this.networkImage,
    required this.title,
    required this.subtitle,
  });
}

final List<OnboardingData> onboardingPages = [
  OnboardingData(
    imagePath: 'assets/landing1.png',
    networkImage:
        'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&q=80',
    title: 'Find Your Perfect Stay',
    subtitle: 'Book hotels, PGs, and hostels all in one place.',
  ),
  OnboardingData(
    imagePath: 'assets/landing2.png',
    networkImage:
        'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800&q=80',
    title: 'Choose Rooms Your Way',
    subtitle:
        'Select AC or Non-AC rooms with single, double, or shared options—just the way you need.',
  ),
  OnboardingData(
    imagePath: 'assets/landing3.png',
    networkImage:
        'https://images.unsplash.com/photo-1540518614846-7eded433c457?w=800&q=80',
    title: 'Book Easy, Stay Happy',
    subtitle:
        'Compare prices, check amenities, and book your stay in just a few taps.',
  ),
];

// ─── Onboarding Screen ─────────────────────────────────────────────────────────

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // static const Color _primaryColor = Color(0xFF5B4CDB);
  // static const Color _white = Colors.white;

  void _nextPage() {
    if (_currentPage < onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _onGetStarted();
    }
  }

  void _onSkip() {
    _pageController.animateToPage(
      onboardingPages.length - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _onGetStarted() {
    context.go(RouteList.login);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ── Responsive breakpoint ──────────────────────────────────────────────
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    return Scaffold(
      backgroundColor: Colors.black,
      body: isTablet ? _buildTabletLayout() : _buildMobileLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (i) => setState(() => _currentPage = i),
          itemCount: onboardingPages.length,
          itemBuilder: (context, index) =>
              _OnboardingPage(data: onboardingPages[index]),
        ),
        _buildOverlayControls(isMobile: true),
      ],
    );
  }

  Widget _buildTabletLayout() {
    // final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (i) => setState(() => _currentPage = i),
          itemCount: onboardingPages.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Expanded(
                  flex: 5,
                  child: _OnboardingImagePanel(data: onboardingPages[index]),
                ),
                Expanded(
                  flex: 4,
                  child: _OnboardingContentPanel(
                    data: onboardingPages[index],
                    currentPage: _currentPage,
                    totalPages: onboardingPages.length,
                    isLastPage: _currentPage == onboardingPages.length - 1,
                    onNext: _nextPage,
                    onSkip: _onSkip,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildOverlayControls({required bool isMobile}) {
    if (!isMobile) return const SizedBox.shrink();

    final isLast = _currentPage == onboardingPages.length - 1;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withValues(alpha:0.85)],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingPages.length,
                (i) => _Dot(isActive: i == _currentPage),
              ),
            ),
            const SizedBox(height: 24),
            isLast
                ? _PrimaryButton(
                    width: double.infinity,
                    label: 'Get Started',
                    onTap: _nextPage,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: _onSkip,
                        child: Text(
                          'Skip',
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      _PrimaryButton(
                        width: MediaQuery.of(context).size.width * 0.4,
                        label: 'Next',
                        onTap: _nextPage,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const _OnboardingPage({required this.data});

  Widget buildImage(OnboardingData data) {
    final path = data.imagePath.isNotEmpty ? data.imagePath : data.networkImage;

    final isNetwork = path.startsWith("http");
    final isSvg = path.toLowerCase().endsWith(".svg");

    if (isNetwork && isSvg) {
      return SvgPicture.network(
        path,
        fit: BoxFit.cover,
        placeholderBuilder: (_) => Container(
          color: const Color(0xFF1A1A2E),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    if (isNetwork) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, url, error) => _errorWidget(),
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return _loadingWidget();
        },
      );
    }

    /// ASSET SVG
    if (isSvg) {
      return SvgPicture.asset(path, fit: BoxFit.cover);
    }

    /// ASSET IMAGE
    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (context, url, error) => _errorWidget(),
    );
  }

  Widget _loadingWidget() {
    return Container(
      color: const Color(0xFF1A1A2E),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  Widget _errorWidget() {
    return Container(
      color: const Color(0xFF1A1A2E),
      child: const Icon(Icons.hotel, color: Colors.white30, size: 80),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        buildImage(data),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.3, 0.65, 1.0],
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha:0.5),
                Colors.black.withValues(alpha:0.92),
              ],
            ),
          ),
        ),
        Positioned(
          left: 24,
          right: 24,
          bottom: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                data.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                data.subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Tablet: Image Panel (Left) ────────────────────────────────────────────────

class _OnboardingImagePanel extends StatelessWidget {
  final OnboardingData data;

  const _OnboardingImagePanel({required this.data});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          data.networkImage,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: const Color(0xFF1A1A2E),
            child: const Icon(Icons.hotel, color: Colors.white30, size: 120),
          ),
          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;
            return Container(
              color: const Color(0xFF1A1A2E),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            );
          },
        ),
        // Subtle right-side gradient to blend with content panel
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: 80,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Color(0xFF0D0D1A)],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Tablet: Content Panel (Right) ────────────────────────────────────────────

class _OnboardingContentPanel extends StatelessWidget {
  final OnboardingData data;
  final int currentPage;
  final int totalPages;
  final bool isLastPage;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const _OnboardingContentPanel({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.isLastPage,
    required this.onNext,
    required this.onSkip,
  });

  static const Color _primaryColor = Color(0xFF5B4CDB);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D0D1A),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo / App name
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.hotel, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              const Text(
                'StayEasy',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Title
          Text(
            data.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          // Subtitle
          Text(
            data.subtitle,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 16,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 48),
          // Dot indicators
          Row(
            children: List.generate(
              totalPages,
              (i) => _Dot(isActive: i == currentPage),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: _PrimaryButton(
                  width: double.infinity,
                  label: isLastPage ? 'Get Started' : 'Next',
                  onTap: onNext,
                ),
              ),
            ],
          ),

          if (!isLastPage) ...[
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: onSkip,
                child: const Text(
                  'Skip',
                  style: TextStyle(color: Colors.white38, fontSize: 15),
                ),
              ),
            ),
          ],
          const Spacer(),
        ],
      ),
    );
  }
}

// ─── Reusable Widgets ──────────────────────────────────────────────────────────

class _Dot extends StatelessWidget {
  final bool isActive;

  const _Dot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: isActive ? 10 : 0,
          height: isActive ? 10 : 0,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final double width;
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.width,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.06,
      width: width,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5B4CDB),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}
