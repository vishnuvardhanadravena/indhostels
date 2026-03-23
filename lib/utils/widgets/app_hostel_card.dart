import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppHotelCard extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final String? location;
  final double? rating;
  final String? price;
  final List<String>? amenities;
  final Widget? trailingWidget;
  final VoidCallback? onTap;

  const AppHotelCard({
    super.key,
    this.imageUrl,
    this.title,
    this.location,
    this.rating,
    this.price,
    this.amenities,
    this.trailingWidget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final isTablet = size.width > 600;
    final isLandscape = size.width > size.height;

    final aspectRatio = isTablet ? (isLandscape ? 4 / 3 : 16 / 10) : 16 / 9;

    final visibleAmenities = amenities?.take(isTablet ? 3 : 4).toList() ?? [];

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        clipBehavior: Clip.antiAlias,
        color: Colors.white,

        child: Column(
          mainAxisSize: MainAxisSize.min, // ✅ KEY FIX
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null && imageUrl!.isNotEmpty)
              AspectRatio(
                aspectRatio: aspectRatio,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: const Color(0xFFE8EAF0),
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (_, __, ___) => const Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                    if (rating != null)
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: RatingBadge(rating: rating!),
                      ),

                    if (trailingWidget != null)
                      Positioned(top: 8, right: 8, child: trailingWidget!),
                  ],
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title?.isNotEmpty == true)
                    Text(
                      title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: isTablet ? 15 : 13,
                        color: const Color(0xFF222222),
                      ),
                    ),

                  if (location?.isNotEmpty == true) ...[
                    const SizedBox(height: 4),
                    Text(
                      location!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isTablet ? 12 : 11,
                        color: const Color(0xFF888888),
                      ),
                    ),
                  ],

                  if (price?.isNotEmpty == true) ...[
                    const SizedBox(height: 6),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '₹$price',
                            style: TextStyle(
                              fontSize: isTablet ? 15 : 14,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF222222),
                            ),
                          ),
                          const TextSpan(
                            text: ' / night',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF888888),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  if (visibleAmenities.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: [
                        ...visibleAmenities.map((a) => AmenityChip(label: a)),

                        if ((amenities?.length ?? 0) > visibleAmenities.length)
                          AmenityChip(
                            label:
                                "+${amenities!.length - visibleAmenities.length}",
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RatingBadge extends StatelessWidget {
  final double rating;
  const RatingBadge({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 12, color: Color(0xFFF5A623)),
          const SizedBox(width: 2),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class AmenityChip extends StatelessWidget {
  final String label;
  const AmenityChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EBF9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Color(0xFF7B5EA7),
        ),
      ),
    );
  }
}
