import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BookingCardSkeleton extends StatelessWidget {
  const BookingCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: const Color(0xFFE7E7E7),
        highlightColor: const Color(0xFFF5F5F5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _box(width: 140, height: 12),
                  _box(width: 60, height: 18, radius: 20),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _box(width: 84, height: 82, radius: 10),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _box(width: double.infinity, height: 14),
                        const SizedBox(height: 8),
                        _box(width: 120, height: 10),
                        const SizedBox(height: 8),

                        Row(
                          children: [
                            _box(width: 80, height: 14),
                            const Spacer(),
                            _box(width: 50, height: 18, radius: 6),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(child: _box(height: 42)),
                  const SizedBox(width: 12),
                  Expanded(child: _box(height: 42)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _box({
    double width = double.infinity,
    required double height,
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
}
