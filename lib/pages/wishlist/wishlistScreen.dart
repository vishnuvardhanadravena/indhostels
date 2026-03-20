import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indhostels/bloc/wishlist/wishlist_bloc.dart';
import 'package:indhostels/routing/route_constants.dart';
import 'package:indhostels/utils/shimmers/popular_hstl_shimmer.dart';
import 'package:indhostels/utils/widgets/app_hostel_card.dart';
import 'package:indhostels/utils/widgets/wisth_listbutton.dart';

class Wishlistscreen extends StatefulWidget {
  const Wishlistscreen({super.key});

  @override
  State<Wishlistscreen> createState() => _WishlistscreenState();
}

class _WishlistscreenState extends State<Wishlistscreen> {
  @override
  void initState() {
    super.initState();
    context.read<WishlistBloc>().add(FetchWishlistEvent());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(title: const Text("My Wishlist")),
      body: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          if (state.loading) {
            return isTablet ? _buildTabletShimmer() : _buildMobileShimmer();
          }

          if (state.error != null) {
            return Center(child: Text(state.error!));
          }

          if (state.items.isEmpty) {
            return const Center(child: Text("No wishlist found"));
          }

          final hostels = state.items;

          /// 📱 MOBILE LIST (NO FIXED HEIGHT)
          if (!isTablet) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              itemCount: hostels.length,
              itemBuilder: (context, i) {
                final hotel = hostels[i];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppHotelCard(
                    onTap: () {
                      context.pushNamed(
                        RouteList.accommodationDetails,
                        extra: {"id": hotel.accommodationId},
                      );
                    },
                    trailingWidget: WishlistButton(
                      accommodationId: hotel.accommodationId,
                    ),
                    amenities: hotel.details?.amenities ?? [],
                    imageUrl: hotel.details?.imagesUrl.first,
                    location: hotel.details?.location.area ?? '',
                    price:
                        '${hotel.details?.pricingIds.first.pricing.first.price ?? ''}',
                    title: hotel.details?.propertyName ?? 'N/A',
                  ),
                );
              },
            );
          }

          /// 💻 TABLET GRID (SAFE HEIGHT)
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: hostels.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              mainAxisExtent: 320, // ✅ prevents overflow
            ),
            itemBuilder: (context, i) {
              final hotel = hostels[i];

              return AppHotelCard(
                onTap: () {
                  context.pushNamed(
                    RouteList.accommodationDetails,
                    extra: {"id": hotel.accommodationId},
                  );
                },
                trailingWidget: WishlistButton(
                  accommodationId: hotel.details?.id ?? "",
                ),
                amenities: hotel.details?.amenities ?? [],
                imageUrl: hotel.details?.imagesUrl.first,
                location: hotel.details?.location.area ?? '',
                price:
                    '${hotel.details?.pricingIds.first.pricing.first.price ?? ''}',
                title: hotel.details?.propertyName ?? 'N/A',
              );
            },
          );
        },
      ),
    );
  }

  /// 📱 MOBILE SHIMMER (NO ASPECT RATIO)
  Widget _buildMobileShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      itemCount: 3,
      itemBuilder: (_, __) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: PopularHotelCardShimmer(),
        );
      },
    );
  }

  /// 💻 TABLET SHIMMER
  Widget _buildTabletShimmer() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        mainAxisExtent: 320,
      ),
      itemBuilder: (_, __) {
        return const PopularHotelCardShimmer();
      },
    );
  }
}
