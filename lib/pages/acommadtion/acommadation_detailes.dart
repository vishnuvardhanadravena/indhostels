import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indhostels/bloc/accommodation/accommodation_bloc.dart';
import 'package:indhostels/bloc/review/review_bloc.dart';
import 'package:indhostels/data/models/accomodation/accomodation_details_res.dart';
import 'package:indhostels/data/models/accomodation/room_card_model.dart';
import 'package:indhostels/pages/acommadtion/rooms.dart';
import 'package:indhostels/pages/profile/profile.dart';
import 'package:indhostels/pages/reviews/reviews_Screen.dart';
import 'package:indhostels/routing/app_roter.dart';
import 'package:indhostels/routing/route_constants.dart';
import 'package:indhostels/utils/helpers/app_toast.dart';
import 'package:indhostels/utils/shimmers/details_Screen.dart';
import 'package:url_launcher/url_launcher.dart';

class AcommadationDetailesScreen extends StatefulWidget {
  final String id;
  const AcommadationDetailesScreen({super.key, required this.id});

  @override
  State<AcommadationDetailesScreen> createState() => _HotelDetailsScreenState();
}

class _HotelDetailsScreenState extends State<AcommadationDetailesScreen> {
  bool _isFavorite = false;
  bool _isDescriptionExpanded = false;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccommodationBloc>().add(
        AcommodationDetailesRequested(id: widget.id),
      );
      context.read<ReviewBloc>().add(
        ReviewsRequested(propertyId: widget.id, limit: 10, page: 0),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final r = R(size.width);
    final hotel = context.watch<AccommodationBloc>().state.acommodationdetailes;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Details")),
      body: BlocConsumer<AccommodationBloc, AccommodationState>(
        listener: (context, state) {
          if (state.acommodationdetailesError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.acommodationdetailesError!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.acommodationdetailesLoading) {
            return const HotelDetailsShimmer();
          }

          if (state.acommodationdetailesError != null) {
            return Center(
              child: Text(
                state.acommodationdetailesError!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (state.acommodationdetailes != null) {
            final hotel = state.acommodationdetailes;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroImage(
                    images: hotel?.imagesUrl ?? [],
                    height: r.isTablet ? size.width * 0.38 : size.width * 0.55,
                  ),
                  SizedBox(height: r.fieldGap),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: r.screenPadH),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _HotelHeader(hotel: hotel, r: r),
                        SizedBox(height: r.fieldGap / 2),

                        _LocationRow(
                          text: hotel?.location?.address ?? "",
                          r: r,
                        ),
                        const _HDivider(),

                        _FacilitiesSection(hotel: hotel, r: r),
                        const _HDivider(),

                        SizedBox(height: r.fieldGap),
                        _DescriptionSection(
                          hotel: hotel,
                          r: r,
                          expanded: _isDescriptionExpanded,
                          onToggle: () => setState(
                            () => _isDescriptionExpanded =
                                !_isDescriptionExpanded,
                          ),
                        ),
                        SizedBox(height: r.sectionGap),
                      ],
                    ),
                  ),

                  // _PreviewSection(
                  //   hotel: dummyHotel,
                  //   r: r,
                  //   screenWidth: size.width,
                  // ),
                  SizedBox(height: r.sectionGap),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: r.screenPadH),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _MapSection(
                          address: hotel?.location?.address ?? "",
                          mapUrl: hotel?.location?.locationurl ?? "",
                          r: r,
                          screenWidth: size.width,
                        ),
                        SizedBox(height: r.sectionGap),
                        const _HDivider(),
                        SizedBox(height: r.fieldGap),
                        _SectionHeader(
                          title: 'Reviews',
                          r: r,
                          actionLabel: 'See All',
                          onAction: () {
                            context.push(
                              RouteList.reviews,
                              extra: {"id": widget.id},
                            );
                          },
                        ),
                        BlocConsumer<ReviewBloc, ReviewState>(
                          listener: (context, state) {
                            if (state.reviewsError != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.reviewsError!)),
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state.reviewsLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (state.reviews.isEmpty) {
                              return const Center(
                                child: Text("No Reviews Found"),
                              );
                            }
                            return ReviewList(
                              reviews: state.reviews,
                              r: r,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                            );
                          },
                        ),
                        SizedBox(
                          height:
                              r.logoutH +
                              MediaQuery.of(context).padding.bottom +
                              r.logoutPadB * 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return SizedBox();
        },
      ),
      bottomNavigationBar: _BottomBar(hotel: hotel, r: r),
    );
  }
}

class _HeroImage extends StatefulWidget {
  final List<String> images;
  final double height;

  const _HeroImage({required this.images, required this.height});

  @override
  State<_HeroImage> createState() => _HeroImageState();
}

class _HeroImageState extends State<_HeroImage> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: double.infinity,
          height: widget.height,
          child: Stack(
            children: [
              /// IMAGE SLIDER
              PageView.builder(
                controller: _controller,
                itemCount: widget.images.length,
                onPageChanged: (i) {
                  setState(() {
                    _currentIndex = i;
                  });
                },
                itemBuilder: (_, index) {
                  final url = widget.images[index];

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,

                        placeholder: (context, url) => Container(
                          color: const Color(0xFFE8EAF0),
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),

                        errorWidget: (context, url, error) => Container(
                          color: const Color(0xFFE8EAF0),
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 48,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),

                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.center,
                            colors: [
                              Color.fromARGB(120, 0, 0, 0),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              /// DOT INDICATOR
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.images.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentIndex == index ? 18 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _currentIndex == index
                            ? Colors.white
                            : Colors.white54,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final R r;
  final bool isFavorite;
  final VoidCallback onBack;
  final VoidCallback onFavorite;

  const _TopBar({
    required this.r,
    required this.isFavorite,
    required this.onBack,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.only(
          top: topPad + 8,
          bottom: 8,
          left: r.screenPadH - 8,
          right: r.screenPadH - 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _CircleBtn(
              icon: Icons.arrow_back_ios_new_rounded,
              iconSize: r.backIconSize,
              onTap: onBack,
            ),
            Text(
              'Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: r.titleFontSize - 4,
                fontWeight: FontWeight.w600,
                shadows: const [Shadow(blurRadius: 6, color: Colors.black45)],
              ),
            ),
            _CircleBtn(
              icon: isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              iconSize: r.backIconSize,
              iconColor: isFavorite ? Colors.redAccent : Colors.black87,
              bgColor: Colors.white,
              onTap: onFavorite,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Hotel header ──────────────────────────────

class _HotelHeader extends StatelessWidget {
  final Acommodation? hotel;
  final R r;
  const _HotelHeader({required this.hotel, required this.r});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            hotel?.propertyName ?? "",
            style: TextStyle(
              fontSize: r.titleFontSize,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
              height: 1.2,
            ),
          ),
        ),
        SizedBox(width: r.iconGap),
        _RatingBadge(rating: hotel?.avgRating ?? 0.0, r: r),
      ],
    );
  }
}

class _LocationRow extends StatelessWidget {
  final String text;
  final R r;
  const _LocationRow({required this.text, required this.r});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.location_on_rounded,
          color: const Color(0xFF4F46E5),
          size: r.iconSize - 2,
        ),
        SizedBox(width: r.iconGap / 2),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: r.emailFontSize,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _FacilitiesSection extends StatelessWidget {
  final Acommodation? hotel;
  final R r;
  const _FacilitiesSection({required this.hotel, required this.r});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Common Facilities', r: r),
        SizedBox(height: r.fieldGap / 1.5),
        Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: (hotel?.amenities ?? []).map((f) {
                    return Padding(
                      padding: EdgeInsets.only(right: r.iconGap),
                      child: _FacilityChip(label: f, r: r),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(width: r.iconGap / 2),
            Container(
              width: r.iconBox - 4,
              height: r.iconBox - 4,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F8),
                borderRadius: BorderRadius.circular(r.iconBoxRadius),
              ),
              child: Icon(
                Icons.chevron_right_rounded,
                size: r.chevronSize - 4,
                color: const Color(0xFF4F46E5),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  final Acommodation? hotel;
  final R r;
  final bool expanded;
  final VoidCallback onToggle;

  const _DescriptionSection({
    required this.hotel,
    required this.r,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Description', r: r),
        SizedBox(height: r.fieldGap / 1.5),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 250),
          crossFadeState: expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: Text(
            hotel?.propertyDescription ?? "",
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: r.emailFontSize,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
          secondChild: Text(
            hotel?.propertyDescription ?? "",
            style: TextStyle(
              fontSize: r.emailFontSize,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: onToggle,
          child: Text(
            expanded ? 'Show Less' : 'Read More..',
            style: TextStyle(
              color: const Color(0xFF4F46E5),
              fontWeight: FontWeight.w600,
              fontSize: r.genderFontSize,
            ),
          ),
        ),
      ],
    );
  }
}

class _MapSection extends StatelessWidget {
  final String address;
  final String mapUrl;
  final R r;
  final double screenWidth;

  const _MapSection({
    required this.address,
    required this.mapUrl,
    required this.r,
    required this.screenWidth,
  });

  Future<void> openMap(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch map");
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapH = r.isTablet ? screenWidth * 0.25 : screenWidth * 0.44;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Location',
          r: r,
          actionLabel: 'Open Map',
          onAction: () => openMap(mapUrl),
        ),

        SizedBox(height: r.fieldGap / 1.5),

        GestureDetector(
          onTap: () async {
            await launchUrl(
              Uri.parse(mapUrl),
              mode: LaunchMode.externalApplication,
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(r.cardRadius),
            child: SizedBox(
              height: mapH,
              width: double.infinity,
              child: _MapPlaceholder(address: address, r: r),
            ),
          ),
        ),

        SizedBox(height: r.fieldGap / 1.5),

        _LocationRow(text: address, r: r),
      ],
    );
  }
}
class _BottomBar extends StatelessWidget {
  final Acommodation? hotel;
  final R r;
  const _BottomBar({required this.hotel, required this.r});
  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(
        r.screenPadH,
        r.logoutPadB,
        r.screenPadH,
        bottomPad + r.logoutPadB,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      '₹${hotel?.roomId?.first.pricingId?.pricing?.first.price}',
                  style: TextStyle(
                    fontSize: r.nameFontSize + 2,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                TextSpan(
                  text:
                      '/${hotel?.roomId?.first.pricingId?.pricing?.first.priceType}',
                  style: TextStyle(
                    fontSize: r.emailFontSize - 1,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            child: ElevatedButton(
              onPressed: () {
                final rooms = (hotel?.roomId ?? [])
                    .map((e) => RoomModel.fromRoomId(e))
                    .toList();
                context.pushNamed(
                  RouteList.rooms,
                  extra: RoomsArgs(
                    rooms: rooms,
                    pgName: hotel?.propertyName,
                    location: hotel?.location?.address ?? "",
                    checkInTime: 'Before 48 hrs',
                    cancellationPolicy: 'Before 48 hrs',
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: r.cardPadH),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(r.logoutRadius),
                ),
              ),
              child: Text(
                'View Rooms',
                style: TextStyle(
                  fontSize: r.logoutFont,
                  fontWeight: FontWeight.w600,
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final R r;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SectionHeader({
    required this.title,
    required this.r,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: r.labelFontSize,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A2E),
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: TextStyle(
                fontSize: r.genderFontSize,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF4F46E5),
              ),
            ),
          ),
      ],
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final double rating;
  final R r;
  const _RatingBadge({required this.rating, required this.r});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star_rounded,
          color: const Color(0xFFFFC107),
          size: r.iconSize,
        ),
        const SizedBox(width: 3),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: r.emailFontSize,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }
}

class _FacilityChip extends StatelessWidget {
  final String label;
  final R r;

  const _FacilityChip({required this.label, required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.itemPadH / 2,
        vertical: r.itemPadV / 2.5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F8),
        borderRadius: BorderRadius.circular(r.iconBoxRadius),
        border: Border.all(color: const Color(0xFFE0E0F0)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: r.genderFontSize,
          color: const Color(0xFF3D3D5C),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// class _ReviewCard extends StatelessWidget {
//   final ReviewModel review;
//   final R r;
//   const _ReviewCard({required this.review, required this.r});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CircleAvatar(
//           radius: r.avatarRadius / 2,
//           backgroundImage: NetworkImage(review.avatarUrl),
//           backgroundColor: const Color(0xFFE8EAF0),
//         ),
//         SizedBox(width: r.avatarGap / 2),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       review.name,
//                       style: TextStyle(
//                         fontSize: r.emailFontSize + 0.5,
//                         fontWeight: FontWeight.w600,
//                         color: const Color(0xFF1A1A2E),
//                       ),
//                     ),
//                   ),
//                   _RatingBadge(rating: review.rating, r: r),
//                 ],
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 review.date,
//                 style: TextStyle(
//                   fontSize: r.emailFontSize - 1.5,
//                   color: Colors.grey[400],
//                 ),
//               ),
//               SizedBox(height: r.fieldGap / 4),
//               Text(
//                 review.comment,
//                 style: TextStyle(
//                   fontSize: r.emailFontSize,
//                   color: Colors.grey[700],
//                   height: 1.5,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback? onTap;

  const _CircleBtn({
    required this.icon,
    required this.iconSize,
    this.bgColor = Colors.white,
    this.iconColor = Colors.black87,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: iconSize + 14,
        height: iconSize + 14,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: iconSize - 4, color: iconColor),
      ),
    );
  }
}

class _HDivider extends StatelessWidget {
  const _HDivider();

  @override
  Widget build(BuildContext context) =>
      const Divider(thickness: 1, color: Color.fromARGB(255, 214, 212, 212));
}

class _MapPlaceholder extends StatelessWidget {
  final String address;
  final R r;
  const _MapPlaceholder({required this.address, required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFDDE8F0),
      child: Stack(
        children: [
          CustomPaint(size: Size.infinite, painter: _GridPainter()),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFF4F46E5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_on_rounded,
                    color: Colors.white,
                    size: r.iconSize + 4,
                  ),
                ),
                SizedBox(height: r.fieldGap / 2),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: r.cardPadH / 2,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(r.logoutRadius),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Text(
                    address,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: r.emailFontSize - 1,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC8D8E8)
      ..strokeWidth = 1;
    const step = 32.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
