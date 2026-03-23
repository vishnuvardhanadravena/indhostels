import 'package:flutter/material.dart';
import 'package:indhostels/pages/bookings/booking_details.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBox extends StatelessWidget {
  final double height;
  final double width;
  final double radius;

  const ShimmerBox({
    super.key,
    required this.height,
    required this.width,
    this.radius = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE6E6E6),
      highlightColor: const Color(0xFFF5F5F5),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

class BookingDetailShimmer extends StatelessWidget {
  const BookingDetailShimmer({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
            child: Cardwrapwer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerBox(height: 14, width: 160),
                  const SizedBox(height: 8),
                  const ShimmerBox(height: 12, width: 90),  
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ShimmerBox(height: 70, width: 78, radius: 10),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            ShimmerBox(height: 14, width: 200),
                            SizedBox(height: 8),
                            ShimmerBox(height: 12, width: 140),
                            SizedBox(height: 8),
                            ShimmerBox(height: 14, width: 90),
                          ],
                        ),
                      ),

                      const ShimmerBox(height: 14, width: 40),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Map
                  const ShimmerBox(
                    height: 130,
                    width: double.infinity,
                    radius: 10,
                  ),

                  const SizedBox(height: 16),

                  /// Address
                  const ShimmerBox(height: 12, width: double.infinity),

                  const SizedBox(height: 24),

                  /// Booking details rows
                  ...List.generate(
                    5,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: const [
                          ShimmerBox(height: 16, width: 16),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShimmerBox(height: 12, width: 120),
                                SizedBox(height: 6),
                                ShimmerBox(height: 12, width: 200),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Divider(),

                  const SizedBox(height: 16),

                  /// Payment rows
                  ...List.generate(
                    4,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          ShimmerBox(height: 12, width: 120),
                          ShimmerBox(height: 12, width: 60),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),

        /// Bottom buttons
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: const [
              Expanded(child: ShimmerBox(height: 46, width: double.infinity)),
              SizedBox(width: 16),
              Expanded(child: ShimmerBox(height: 46, width: double.infinity)),
            ],
          ),
        ),
      ],
    );
  }
}
