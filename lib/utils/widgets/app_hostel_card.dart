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

  const AppHotelCard({
    super.key,
    this.imageUrl,
    this.title,
    this.location,
    this.rating,
    this.price,
    this.amenities,
    this.trailingWidget,
  });

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
          /// IMAGE
          if (imageUrl != null && imageUrl!.isNotEmpty)
            Expanded(
              flex: isTablet ? 5 : 6,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover,

                    placeholder: (context, url) => Container(
                      color: const Color(0xFFE8EAF0),
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),

                    errorWidget: (context, url, error) => const Center(
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

          Expanded(
            flex: isTablet ? 4 : 5,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  if (title != null && title!.isNotEmpty)
                    Text(
                      title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: Color(0xFF222222),
                      ),
                    ),

                  if (location != null && location!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      location!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF888888),
                      ),
                    ),
                  ],

                  if (price != null && price!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '₹$price',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF222222),
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

                  if (amenities != null && amenities!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: (amenities ?? [])
                          .take(isTablet ? 3 : 4)
                          .map((a) => AmenityChip(label: a))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RatingBadge extends StatelessWidget {
  final double rating;
  final bool compact;
  const RatingBadge({required this.rating, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: compact ? Colors.transparent : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            size: compact ? 14 : 13,
            color: const Color(0xFFF5A623),
          ),
          const SizedBox(width: 2),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: compact ? 13 : 12,
              fontWeight: FontWeight.w700,
              color: compact
                  ? const Color(0xFFF5A623)
                  : const Color(0xFF333333),
            ),
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
