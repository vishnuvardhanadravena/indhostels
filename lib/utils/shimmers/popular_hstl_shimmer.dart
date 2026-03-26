import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PopularHotelCardShimmer extends StatelessWidget {
  final bool showImage;
  final bool showBadge;
  final bool showFavIcon;
  final bool showTitle;
  final bool showSubtitle;
  final bool showPrice;
  final bool showAmenities;

  const PopularHotelCardShimmer({
    super.key,
    this.showImage = true,
    this.showBadge = true,
    this.showFavIcon = true,
    this.showTitle = true,
    this.showSubtitle = true,
    this.showPrice = true,
    this.showAmenities = true,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return SizedBox(
      height: isTablet ? 300 : 260,
      child: Card(
        elevation: 6,
        shadowColor: Colors.black.withValues(alpha:0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 IMAGE SECTION
            if (showImage)
              SizedBox(
                height: isTablet ? 160 : 140,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const _ShimmerBox(
                      width: double.infinity,
                      height: double.infinity,
                      borderRadius: BorderRadius.zero,
                    ),

                    if (showBadge)
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: _ShimmerBox(
                          width: 52,
                          height: 22,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                    if (showFavIcon)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: _ShimmerBox(
                          width: 28,
                          height: 28,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                  ],
                ),
              ),

            /// 🔥 CONTENT
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showTitle)
                    _ShimmerBox(
                      width: double.infinity,
                      height: 13,
                      borderRadius: BorderRadius.circular(6),
                    ),

                  if (showTitle) const SizedBox(height: 6),

                  if (showSubtitle)
                    _ShimmerBox(
                      width: 100,
                      height: 11,
                      borderRadius: BorderRadius.circular(6),
                    ),

                  if (showSubtitle) const SizedBox(height: 8),

                  if (showPrice)
                    _ShimmerBox(
                      width: 90,
                      height: 14,
                      borderRadius: BorderRadius.circular(6),
                    ),

                  if (showPrice) const SizedBox(height: 10),

                  if (showAmenities)
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: List.generate(
                        isTablet ? 3 : 4,
                        (i) => _ShimmerBox(
                          width: 52,
                          height: 20,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const _ShimmerBox({
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
  });

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _shimmer = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmer,
      builder: (context, child) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: const [0.0, 0.5, 1.0],
            colors: const [
              Color(0xFFE8ECF0),
              Color(0xFFF5F7FA),
              Color(0xFFE8ECF0),
            ],
            transform: _SweepTransform(_shimmer.value),
          ),
        ),
      ),
    );
  }
}

class _SweepTransform implements GradientTransform {
  final double offset;
  const _SweepTransform(this.offset);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * offset, 0, 0);
}

class PGListTileSkeleton extends StatelessWidget {
  const PGListTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          children: [
            /// IMAGE SKELETON
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
              child: Container(width: 90, height: 90, color: Colors.white),
            ),

            /// TEXT AREA
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TITLE + RATING
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        /// RATING BADGE
                        Container(
                          width: 32,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    /// LOCATION
                    Container(
                      width: 120,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// PRICE
                    Container(
                      width: 80,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TicketCardSkeleton extends StatelessWidget {
  const TicketCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 100, // same as your real ticket card
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon placeholder
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Subject placeholder
                  Container(
                    width: double.infinity,
                    height: 14,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 6),
                  // Last message placeholder
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 12,
                    color: Colors.grey.shade300,
                  ),
                  const Spacer(),
                  // Category + date placeholder
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 18,
                        color: Colors.grey.shade300,
                      ),
                      const Spacer(),
                      Container(
                        width: 40,
                        height: 12,
                        color: Colors.grey.shade300,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
