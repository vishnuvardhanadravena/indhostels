

import 'package:flutter/material.dart';
import 'package:indhostels/data/models/accomodation/room_card_model.dart';
import 'package:indhostels/pages/profile/profile.dart';
import 'package:indhostels/utils/widgets/room_card.dart';



class RoomDetailScreen extends StatelessWidget {
  final RoomModel room;
  final String? pgName;
  final String? location;
  final String? checkInTime;
  final String? cancellationPolicy;
  final VoidCallback? onBookNow;

  const RoomDetailScreen({
    super.key,
    required this.room,
    this.pgName,
    this.location,
    this.checkInTime,
    this.cancellationPolicy,
    this.onBookNow,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final r = R(constraints.maxWidth);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: RoomsAppBar(title: 'Room Details', r: r),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: r.bottomBarHeight + 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.screenPadH,
                        vertical: r.screenPadV,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _DetailTitle(room: room, pgName: pgName, r: r),
                          SizedBox(height: r.fieldGap * 0.5),

                          Text(
                            room.roomDescription,
                            style: TextStyle(
                              fontSize: r.detailBodyFont,
                              color: const Color(0xFF555555),
                              height: 1.55,
                            ),
                          ),
                          SizedBox(height: r.fieldGap * 0.8),

                          _StatusBadges(room: room, r: r),
                          SizedBox(height: r.fieldGap),
                        ],
                      ),
                    ),

                    _RoomImageFull(room: room, r: r),
                    SizedBox(height: r.sectionGap),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: r.screenPadH),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _RoomFeaturesCard(room: room, r: r),
                          SizedBox(height: r.sectionGap),

                          _SectionTitle(title: 'Room Details', r: r),
                          SizedBox(height: r.fieldGap * 0.7),
                          _RoomDetailsGrid(
                            room: room,
                            location: location,
                            checkInTime: checkInTime,
                            r: r,
                          ),
                          SizedBox(height: r.sectionGap),

                          _SectionTitle(title: 'Common Facilities', r: r),
                          SizedBox(height: r.fieldGap * 0.7),
                          _FacilitiesWrap(amenities: room.parsedAmenities, r: r),
                          SizedBox(height: r.fieldGap),

                          _CancellationPolicyChip(
                            policy: cancellationPolicy ?? 'Before 48 hrs',
                            r: r,
                          ),
                          SizedBox(height: r.sectionGap),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _BottomBookBar(room: room, r: r, onBookNow: onBookNow),
              ),
            ],
          ),
        );
      },
    );
  }
}


class _DetailTitle extends StatelessWidget {
  final RoomModel room;
  final String? pgName;
  final R r;
  const _DetailTitle({required this.room, required this.pgName, required this.r});

  @override
  Widget build(BuildContext context) {
    final title = pgName != null
        ? '$pgName – ${room.roomTypeLabel}'
        : room.roomTypeLabel;
    return Text(
      title,
      style: TextStyle(
        fontSize: r.detailTitleFont,
        fontWeight: FontWeight.w800,
        color: Colors.black87,
        height: 1.3,
      ),
    );
  }
}

// 2. Status badges row
class _StatusBadges extends StatelessWidget {
  final RoomModel room;
  final R r;
  const _StatusBadges({required this.room, required this.r});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: [
        RoomBadge(
          label: 'PGS',
          r: r,
          backgroundColor: const Color(0xFFE8EAF6),
          textColor: const Color(0xFF3949AB),
        ),
        RoomBadge(
          label: '${room.roomsAvailable} Rooms Available',
          r: r,
          backgroundColor: const Color(0xFFE8F5E9),
          textColor: const Color(0xFF2E7D32),
        ),
        RoomBadge(
          label: 'Verified',
          r: r,
          backgroundColor: const Color(0xFFFFF8E1),
          textColor: const Color(0xFFF57F17),
        ),
      ],
    );
  }
}

// 3. Full-width room image with page indicator dots
class _RoomImageFull extends StatefulWidget {
  final RoomModel room;
  final R r;
  const _RoomImageFull({required this.room, required this.r});

  @override
  State<_RoomImageFull> createState() => _RoomImageFullState();
}

class _RoomImageFullState extends State<_RoomImageFull> {
  int _current = 0;
  late final PageController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = PageController();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.room.roomImagesUrl;
    if (images.isEmpty) {
      return Container(
        height: widget.r.detailImageHeight,
        color: const Color(0xFFF0F0F0),
        child: const Center(
          child: Icon(Icons.bed_outlined, size: 60, color: Color(0xFFBDBDBD)),
        ),
      );
    }

    return SizedBox(
      height: widget.r.detailImageHeight,
      child: Stack(
        children: [
          PageView.builder(
            controller: _ctrl,
            itemCount: images.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (_, i) => Image.network(
              images[i],
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFFF0F0F0),
                child: const Center(
                    child: Icon(Icons.broken_image_outlined,
                        size: 48, color: Color(0xFFBDBDBD))),
              ),
            ),
          ),
          // Dots
          if (images.length > 1)
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _current == i ? 18 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: _current == i
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RoomFeaturesCard extends StatelessWidget {
  final RoomModel room;
  final R r;
  const _RoomFeaturesCard({required this.room, required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(r.featureCardPad),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EFFF),
        borderRadius: BorderRadius.circular(r.featureCardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Room Features',
            style: TextStyle(
              fontSize: r.detailSectionTitle,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF3730A3),
            ),
          ),
          SizedBox(height: r.fieldGap * 0.5),
          Text(
            room.roomDescription,
            style: TextStyle(
              fontSize: r.detailBodyFont,
              color: const Color(0xFF555577),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// 5. Section title
class _SectionTitle extends StatelessWidget {
  final String title;
  final R r;
  const _SectionTitle({required this.title, required this.r});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: r.detailSectionTitle,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    );
  }
}

// 6. Room details grid (2 columns × 2 rows)
class _RoomDetailsGrid extends StatelessWidget {
  final RoomModel room;
  final String? location;
  final String? checkInTime;
  final R r;

  const _RoomDetailsGrid({
    required this.room,
    required this.location,
    required this.checkInTime,
    required this.r,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _GridItem(
        icon: Icons.people_outline_rounded,
        label: 'Occupancy',
        value: '${room.noOfGuests} guests · ${room.bedsAvailable} beds',
      ),
      _GridItem(
        icon: Icons.door_front_door_outlined,
        label: 'Availability',
        value: '${room.roomsAvailable} rooms available',
      ),
      _GridItem(
        icon: Icons.location_on_outlined,
        label: 'Location',
        value: location ?? 'Not specified',
      ),
      _GridItem(
        icon: Icons.schedule_rounded,
        label: 'Check-in Time',
        value: checkInTime ?? 'Flexible',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final colWidth = (constraints.maxWidth - r.fieldGap) / 2;
        return Wrap(
          spacing: r.fieldGap,
          runSpacing: r.fieldGap,
          children: items
              .map((item) => SizedBox(
                    width: colWidth,
                    child: _DetailGridCell(item: item, r: r),
                  ))
              .toList(),
        );
      },
    );
  }
}

class _GridItem {
  final IconData icon;
  final String label;
  final String value;
  const _GridItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class _DetailGridCell extends StatelessWidget {
  final _GridItem item;
  final R r;
  const _DetailGridCell({required this.item, required this.r});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(item.icon, size: r.detailGridIconSize, color: const Color(0xFF6B7280)),
        SizedBox(width: r.fieldGap * 0.4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.label,
                style: TextStyle(
                  fontSize: r.detailGridLabelFont,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                item.value,
                style: TextStyle(
                  fontSize: r.detailGridValueFont,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// 7. Facilities chips wrap
class _FacilitiesWrap extends StatelessWidget {
  final List<String> amenities;
  final R r;
  const _FacilitiesWrap({required this.amenities, required this.r});

  static const Map<String, IconData> _icons = {
    'ac': Icons.ac_unit_rounded,
    'wifi': Icons.wifi_rounded,
    'wi-fi': Icons.wifi_rounded,
    'tv': Icons.tv_rounded,
    'swimming pool': Icons.pool_rounded,
    'pool': Icons.pool_rounded,
    'gym': Icons.fitness_center_rounded,
    'parking': Icons.local_parking_rounded,
    'geyser': Icons.water_drop_outlined,
    'refrigerator': Icons.kitchen_rounded,
    'fridge': Icons.kitchen_rounded,
    'mini fridge': Icons.kitchen_rounded,
    'fan': Icons.air_rounded,
    'wardrobe': Icons.door_sliding_outlined,
    'desk': Icons.desk_rounded,
    'balcony': Icons.balcony_outlined,
    'washing machine': Icons.local_laundry_service_rounded,
    'jacuzzi': Icons.bathtub_outlined,
    'locker': Icons.lock_outline_rounded,
    'study table': Icons.table_restaurant_outlined,
    'workspace': Icons.work_outline_rounded,
    'room service': Icons.room_service_outlined,
    'kitchenette': Icons.microwave_outlined,
  };

  IconData _iconFor(String amenity) {
    final key = amenity.toLowerCase();
    for (final entry in _icons.entries) {
      if (key.contains(entry.key)) return entry.value;
    }
    return Icons.check_circle_outline_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final list = amenities.isNotEmpty
        ? amenities
        : ['AC', 'Wi-Fi', 'Swimming Pool'];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: list
          .map((a) => _FacilityChip(label: a, icon: _iconFor(a), r: r))
          .toList(),
    );
  }
}

class _FacilityChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final R r;
  const _FacilityChip({required this.label, required this.icon, required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.facilityChipPadH,
        vertical: r.facilityChipPadV,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(r.badgeRadius),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: r.facilityChipIconSize, color: const Color(0xFF4B5563)),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: r.facilityChipFont,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }
}

// 8. Cancellation policy chip
class _CancellationPolicyChip extends StatelessWidget {
  final String policy;
  final R r;
  const _CancellationPolicyChip({required this.policy, required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: r.featureCardPad,
        vertical: r.featureCardPad * 0.75,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(r.featureCardRadius),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Icon(Icons.policy_outlined,
              size: r.detailGridIconSize + 2, color: const Color(0xFF6B7280)),
          SizedBox(width: r.fieldGap * 0.5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cancellation Policy',
                style: TextStyle(
                  fontSize: r.detailGridLabelFont,
                  color: const Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                policy,
                style: TextStyle(
                  fontSize: r.detailGridValueFont,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 9. Sticky bottom bar: price + Book Now
class _BottomBookBar extends StatelessWidget {
  final RoomModel room;
  final R r;
  final VoidCallback? onBookNow;

  const _BottomBookBar({
    required this.room,
    required this.r,
    this.onBookNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: r.bottomBarHeight,
      padding: EdgeInsets.symmetric(
        horizontal: r.screenPadH,
        vertical: r.screenPadV * 0.6,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Price
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    room.priceAmount,
                    style: TextStyle(
                      fontSize: r.detailPriceFont,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    room.priceSuffix,
                    style: TextStyle(
                      fontSize: r.detailPriceSufFont,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Spacer(),

          // Book Now button
          SizedBox(
            height: r.bottomBarHeight * 0.65,
            child: ElevatedButton(
              onPressed: onBookNow,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(r.bookBtnRadius),
                ),
                padding: EdgeInsets.symmetric(horizontal: r.bookBtnPadH),
              ),
              child: Text(
                'Book Now',
                style: TextStyle(
                  fontSize: r.bookBtnFont,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}