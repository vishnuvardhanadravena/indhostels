import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indhostels/bloc/review/review_bloc.dart';
import 'package:indhostels/data/models/Reviews/reviews_res.dart';
import 'package:indhostels/pages/profile/profile.dart';

class AppBackButton extends StatelessWidget {
  final R r;
  final VoidCallback? onTap;
  const AppBackButton({super.key, required this.r, this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap ?? () => Navigator.maybePop(context),
    child: Icon(Icons.arrow_back, size: r.backIconSize, color: Colors.black87),
  );
}

class AppBarTitle extends StatelessWidget {
  final String title;
  final R r;
  const AppBarTitle({super.key, required this.title, required this.r});

  @override
  Widget build(BuildContext context) => Text(
    title,
    style: TextStyle(
      fontSize: r.titleFontSize,
      fontWeight: FontWeight.w700,
      color: Colors.black,
      letterSpacing: -0.3,
    ),
  );
}

class UserAvatar extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final R r;
  final bool isReviewSize;

  const UserAvatar({
    super.key,
    required this.name,
    required this.r,
    this.avatarUrl,
    this.isReviewSize = false,
  });

  Color _color() {
    const palette = [
      Color(0xFF6C63FF),
      Color(0xFF00B894),
      Color(0xFFE17055),
      Color(0xFF0984E3),
      Color(0xFFD63031),
      Color(0xFF6D4C41),
    ];

    return name.isEmpty
        ? palette[0]
        : palette[name.codeUnitAt(0) % palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final radius = isReviewSize ? r.reviewAvatarRadius : r.avatarRadius;

    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: _color().withOpacity(0.15),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: avatarUrl!,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,

            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator(strokeWidth: 2)),

            errorWidget: (context, url, error) => _fallbackAvatar(radius),
          ),
        ),
      );
    }

    return _fallbackAvatar(radius);
  }

  Widget _fallbackAvatar(double radius) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: _color(),
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.7,
        ),
      ),
    );
  }
}

class StarRatingRow extends StatelessWidget {
  final double rating;
  final R r;
  const StarRatingRow({super.key, required this.rating, required this.r});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        Icons.star_rounded,
        color: const Color(0xFFFFC107),
        size: r.reviewStarSize,
      ),
      const SizedBox(width: 3),
      Text(
        rating.toStringAsFixed(1),
        style: TextStyle(
          fontSize: r.reviewRatingFont,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    ],
  );
}

class VerifiedBadge extends StatelessWidget {
  final R r;
  const VerifiedBadge({super.key, required this.r});

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(
      horizontal: r.reviewBadgePadH,
      vertical: r.reviewBadgePadV,
    ),
    decoration: BoxDecoration(
      color: const Color(0xFF00B894).withOpacity(0.12),
      borderRadius: BorderRadius.circular(r.reviewBadgeRadius),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.verified_rounded,
          size: r.reviewBadgeFont + 2,
          color: const Color(0xFF00B894),
        ),
        const SizedBox(width: 4),
        Text(
          'Verified Stay',
          style: TextStyle(
            fontSize: r.reviewBadgeFont,
            color: const Color(0xFF00B894),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

class RoomTypeBadge extends StatelessWidget {
  final String roomType;
  final R r;
  const RoomTypeBadge({super.key, required this.roomType, required this.r});

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(
      horizontal: r.reviewBadgePadH,
      vertical: r.reviewBadgePadV,
    ),
    decoration: BoxDecoration(
      color: const Color(0xFF6C63FF).withOpacity(0.10),
      borderRadius: BorderRadius.circular(r.reviewBadgeRadius),
    ),
    child: Text(
      roomType,
      style: TextStyle(
        fontSize: r.reviewBadgeFont,
        color: const Color(0xFF6C63FF),
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class ReviewCard extends StatelessWidget {
  final ReviewModel review;
  final R r;
  const ReviewCard({super.key, required this.review, required this.r});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: r.screenPadH,
        vertical: r.reviewItemGapV,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvatar(
            name: review.user.fullname,
            avatarUrl: review.user.profileUrl,
            r: r,
            isReviewSize: true,
          ),
          SizedBox(width: r.reviewAvatarContentGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        review.user.fullname,
                        style: TextStyle(
                          fontSize: r.reviewNameFont,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    StarRatingRow(rating: review.rating.toDouble(), r: r),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  review.formattedDate,
                  style: TextStyle(
                    fontSize: r.reviewDateFont,
                    color: Colors.grey.shade500,
                  ),
                ),
                SizedBox(height: r.fieldGap * 0.5),
                Text(
                  review.aboutStay,
                  style: TextStyle(
                    fontSize: r.reviewBodyFont,
                    color: Colors.black87,
                    height: 1.55,
                  ),
                ),
                SizedBox(height: r.fieldGap * 0.6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    if (review.verifiedStay) VerifiedBadge(r: r),
                    if (review.roomType.isNotEmpty)
                      RoomTypeBadge(roomType: review.roomType, r: r),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewDivider extends StatelessWidget {
  final R r;
  const ReviewDivider({super.key, required this.r});

  @override
  Widget build(BuildContext context) => Divider(
    height: r.reviewDividerH,
    thickness: r.reviewDividerH,
    indent: r.screenPadH,
    endIndent: r.screenPadH,
    color: Colors.grey.shade200,
  );
}

class ReviewSummaryHeader extends StatelessWidget {
  final ReviewsData data;
  final R r;
  const ReviewSummaryHeader({super.key, required this.data, required this.r});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: r.screenPadH,
        vertical: r.screenPadV,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Reviews (${data.count})',
              style: TextStyle(
                fontSize: r.reviewCountFont,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: r.reviewBadgePadH + 4,
              vertical: r.reviewBadgePadV + 2,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(r.reviewBadgeRadius),
              border: Border.all(
                color: const Color(0xFFFFC107).withOpacity(0.4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star_rounded,
                  color: const Color(0xFFFFC107),
                  size: r.reviewStarSize,
                ),
                const SizedBox(width: 4),
                Text(
                  data.averageRating.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: r.reviewRatingFont,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  ' / 5',
                  style: TextStyle(
                    fontSize: r.reviewAvgSubFont,
                    color: Colors.grey.shade500,
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

class ReviewList extends StatelessWidget {
  final List<ReviewModel> reviews;
  final R r;
  final bool? shrinkWrap;
  final ScrollPhysics? physics;

  const ReviewList({
    super.key,
    required this.reviews,
    required this.r,
    this.shrinkWrap,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: shrinkWrap ?? false,
      physics: physics,
      padding: EdgeInsets.only(bottom: r.sectionGap),
      itemCount: reviews.length,
      itemBuilder: (_, i) {
        return ReviewCard(review: reviews[i], r: r);
      },
    );
  }
}

class ReviewsScreen extends StatefulWidget {
  final String id;

  const ReviewsScreen({super.key, required this.id});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  @override
  void initState() {
    super.initState();

    context.read<ReviewBloc>().add(
      ReviewsRequested(propertyId: widget.id, page: 1, limit: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = R(MediaQuery.of(context).size.width);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.only(left: r.screenPadH * 0.5),
          child: AppBackButton(r: r),
        ),
        title: AppBarTitle(title: 'Reviews', r: r),
      ),
      body: BlocConsumer<ReviewBloc, ReviewState>(
        listener: (context, state) {
          if (state.reviewsError != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.reviewsError!)));
          }
        },
        builder: (context, state) {
          if (state.reviewsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.reviews.isEmpty) {
            return const Center(child: Text("No Reviews Found"));
          }
          return ReviewList(reviews: state.reviews, r: r);
        },
      ),
    );
  }
}
