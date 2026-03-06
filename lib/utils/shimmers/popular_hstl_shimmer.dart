import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// ─── Shimmer Skeleton for _PopularHotelCard ───────────────────────────────────

class PopularHotelCardShimmer extends StatelessWidget {
  const PopularHotelCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Card(
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ── IMAGE AREA
          Expanded(
            flex: isTablet ? 5 : 6,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Full image shimmer
                const _ShimmerBox(
                  width: double.infinity,
                  height: double.infinity,
                  borderRadius: BorderRadius.zero,
                ),

                // Rating badge (bottom-left)
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: _ShimmerBox(
                    width: 52,
                    height: 22,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                // Favourite icon (top-right)
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

          /// ── CONTENT AREA
          Expanded(
            flex: isTablet ? 4 : 5,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel name
                  _ShimmerBox(
                    width: double.infinity,
                    height: 13,
                    borderRadius: BorderRadius.circular(6),
                  ),

                  const SizedBox(height: 6),

                  // Location
                  _ShimmerBox(
                    width: 100,
                    height: 11,
                    borderRadius: BorderRadius.circular(6),
                  ),

                  const SizedBox(height: 8),

                  // Price
                  _ShimmerBox(
                    width: 90,
                    height: 14,
                    borderRadius: BorderRadius.circular(6),
                  ),

                  const SizedBox(height: 10),

                  // Amenity chips
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
          ),
        ],
      ),
    );
  }
}

// ─── Animated Shimmer Box ─────────────────────────────────────────────────────

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
      builder: (_, __) => Container(
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


class PGListTileShimmer extends StatelessWidget {
  const PGListTileShimmer({super.key});

  Widget _box({
    double width = double.infinity,
    double height = 12,
    double radius = 6,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      period: const Duration(milliseconds: 1400),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [

            /// IMAGE
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            const SizedBox(width: 12),

            /// TEXT CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// TITLE
                  Row(
                    children: [
                      Expanded(child: _box(height: 14)),
                      const SizedBox(width: 8),
                      _box(width: 35, height: 12, radius: 20),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// LOCATION
                  _box(width: 120, height: 12),

                  const SizedBox(height: 10),

                  /// PRICE
                  _box(width: 80, height: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}