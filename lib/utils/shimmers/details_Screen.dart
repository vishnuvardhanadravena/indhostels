import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HotelDetailsShimmer extends StatelessWidget {
  const HotelDetailsShimmer({super.key});

  Widget box({double height = 20, double width = double.infinity}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Image shimmer
            Container(
              height: size.width * 0.55,
              width: double.infinity,
              color: Colors.white,
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Hotel Name
                  box(height: 22, width: 200),

                  const SizedBox(height: 12),

                  /// Location
                  box(height: 18, width: 250),

                  const SizedBox(height: 20),

                  /// Facilities row
                  Row(
                    children: [
                      box(height: 40, width: 80),
                      const SizedBox(width: 10),
                      box(height: 40, width: 80),
                      const SizedBox(width: 10),
                      box(height: 40, width: 80),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// Description
                  box(height: 16, width: double.infinity),
                  const SizedBox(height: 8),
                  box(height: 16, width: double.infinity),
                  const SizedBox(height: 8),
                  box(height: 16, width: 200),

                  const SizedBox(height: 30),

                  /// Map
                  Container(
                    height: 180,
                    width: double.infinity,
                    color: Colors.white,
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
