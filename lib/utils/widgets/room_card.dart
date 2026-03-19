import 'package:flutter/material.dart';
import 'package:indhostels/data/models/accomodation/room_card_model.dart';
import 'package:indhostels/pages/profile/profile.dart';

class RoomsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final R r;
  final VoidCallback? onBack;

  const RoomsAppBar({
    super.key,
    required this.title,
    required this.r,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: GestureDetector(
        onTap: onBack ?? () => Navigator.of(context).maybePop(),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: r.backIconSize,
          color: Colors.black87,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: r.titleFontSize,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
          letterSpacing: -0.3,
        ),
      ),
    );
  }
}

class RoomBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final R r;

  const RoomBadge({
    super.key,
    required this.label,
    required this.r,
    this.backgroundColor = const Color(0xFFE8F5E9),
    this.textColor = const Color(0xFF2E7D32),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.badgePadH,
        vertical: r.badgePadV,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(r.badgeRadius),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: r.badgeFontSize,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

class RatingChip extends StatelessWidget {
  final double rating;
  final R r;

  const RatingChip({super.key, required this.rating, required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFFD600), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            color: const Color(0xFFFFB300),
            size: r.ratingIconSize,
          ),
          const SizedBox(width: 3),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: r.ratingFont,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF795548),
            ),
          ),
        ],
      ),
    );
  }
}

class RoomImageWidget extends StatefulWidget {
  final String? imageUrl;
  final R r;
  final double rating;

  const RoomImageWidget({
    super.key,
    required this.imageUrl,
    required this.r,
    this.rating = 4.0,
  });

  @override
  State<RoomImageWidget> createState() => _RoomImageWidgetState();
}

class _RoomImageWidgetState extends State<RoomImageWidget> {
  bool _isFaved = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(widget.r.cardRadius),
          ),
          child: SizedBox(
            width: double.infinity,
            height: widget.r.roomImageHeight,
            child: widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                ? Image.network(
                    widget.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(),
                    loadingBuilder: (_, child, progress) =>
                        progress == null ? child : _shimmer(),
                  )
                : _placeholder(),
          ),
        ),

        Positioned(
          top: 10,
          left: 10,
          child: RatingChip(rating: widget.rating, r: widget.r),
        ),

        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => setState(() => _isFaved = !_isFaved),
            child: Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                _isFaved
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                size: 18,
                color: _isFaved ? Colors.redAccent : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _placeholder() => Container(
    color: const Color(0xFFF0F0F0),
    child: const Center(
      child: Icon(Icons.bed_outlined, size: 40, color: Color(0xFFBDBDBD)),
    ),
  );

  Widget _shimmer() => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.grey.shade200,
          Colors.grey.shade100,
          Colors.grey.shade200,
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
    ),
  );
}

class AmenitiesRow extends StatelessWidget {
  final List<String> amenities;
  final R r;

  const AmenitiesRow({super.key, required this.amenities, required this.r});

  @override
  Widget build(BuildContext context) {
    if (amenities.isEmpty) return const SizedBox.shrink();

    return Row(
      children: [
        Icon(
          Icons.check_circle_outline_rounded,
          size: r.amenityFont + 2,
          color: const Color(0xFF43A047),
        ),
        const SizedBox(width: 4),
        Text(
          'All amenities included',
          style: TextStyle(
            fontSize: r.amenityFont,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF555555),
          ),
        ),
      ],
    );
  }
}

class RoomCard extends StatelessWidget {
  final RoomModel room;
  final bool taxenable;
  final int taxamount;
  final R r;
  final VoidCallback? onTap;

  const RoomCard({
    super.key,
    required this.room,
    required this.r,
    this.onTap,
    required this.taxamount,
    required this.taxenable,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(r.cardRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RoomImageWidget(imageUrl: room.primaryImage, r: r, rating: 4.0),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: r.cardPadH,
                vertical: r.cardPadV,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.roomTypeLabel,
                    style: TextStyle(
                      fontSize: r.roomTitleFont,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: r.fieldGap * 0.3),

                  Text(
                    room.roomDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: r.roomDescFont,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: r.fieldGap * 0.6),

                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      RoomBadge(
                        label: '${room.bedsAvailable} beds available',
                        r: r,
                        backgroundColor: const Color(0xFFE3F2FD),
                        textColor: const Color(0xFF1565C0),
                      ),
                      RoomBadge(
                        label: 'Max ${room.noOfGuests} guests per room',
                        r: r,
                        backgroundColor: const Color(0xFFF3E5F5),
                        textColor: const Color(0xFF6A1B9A),
                      ),
                    ],
                  ),
                  SizedBox(height: r.fieldGap * 0.7),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        room.priceAmount,
                        style: TextStyle(
                          fontSize: r.roomPriceFont,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        room.priceSuffix,
                        style: TextStyle(
                          fontSize: r.roomPriceSufFont,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: r.fieldGap * 0.4),

                  AmenitiesRow(amenities: room.parsedAmenities, r: r),
                  SizedBox(height: r.fieldGap * 0.25),
                  if (taxenable)
                    Text(
                      "+ ${taxamount.toString()}-tax",
                      style: TextStyle(
                        fontSize: r.taxFont,
                        color: const Color(0xFF43A047),
                        fontWeight: FontWeight.w500,
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

class EmptyRoomsWidget extends StatelessWidget {
  final R r;
  final String title;
  final String subtitle;
  final VoidCallback? onRetry;

  const EmptyRoomsWidget({
    super.key,
    required this.r,
    this.title = 'No Rooms Found',
    this.subtitle =
        'There are no rooms available right now.\nPlease try again later.',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: r.screenPadH * 1.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: r.emptyIconSize * 1.6,
              height: r.emptyIconSize * 1.6,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bed_outlined,
                size: r.emptyIconSize,
                color: const Color(0xFFBDBDBD),
              ),
            ),
            SizedBox(height: r.sectionGap),

            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: r.emptyTitleFont,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: r.fieldGap * 0.5),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: r.emptySubFont,
                color: Colors.grey.shade500,
                height: 1.5,
              ),
            ),

            if (onRetry != null) ...[
              SizedBox(height: r.sectionGap),
              SizedBox(
                height: r.logoutH,
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(r.logoutRadius),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: r.cardPadH),
                  ),
                  icon: Icon(Icons.refresh_rounded, size: r.logoutIcon),
                  label: Text(
                    'Retry',
                    style: TextStyle(
                      fontSize: r.logoutFont,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
