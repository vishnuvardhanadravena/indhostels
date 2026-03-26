// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:indhostels/bloc/wishlist/wishlist_bloc.dart';
// import 'package:indhostels/routing/route_constants.dart';
// import 'package:indhostels/utils/shimmers/popular_hstl_shimmer.dart';
// import 'package:indhostels/utils/widgets/app_hostel_card.dart';
// import 'package:indhostels/utils/widgets/wisth_listbutton.dart';
// class Wishlistscreen extends StatefulWidget {
//   const Wishlistscreen({super.key});
//   @override
//   State<Wishlistscreen> createState() => _WishlistscreenState();
// }
// class _WishlistscreenState extends State<Wishlistscreen> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<WishlistBloc>().add(FetchWishlistEvent());
//   }
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isTablet = screenWidth > 600;
//     return Scaffold(
//       appBar: AppBar(title: const Text("My Wishlist")),
//       body: BlocBuilder<WishlistBloc, WishlistState>(
//         builder: (context, state) {
//           if (state.loading) {
//             return isTablet ? _buildTabletShimmer() : _buildMobileShimmer();
//           }
//           if (state.error != null) {
//             return Center(child: Text(state.error!));
//           }
//           if (state.items.isEmpty) {
//             return const Center(child: Text("No wishlist found"));
//           }
//           final hostels = state.items;
//           if (!isTablet) {
//             return ListView.builder(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//               itemCount: hostels.length,
//               itemBuilder: (context, i) {
//                 final hotel = hostels[i];

//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 12),
//                   child: AppHotelCard(
//                     onTap: () {
//                       context.pushNamed(
//                         RouteList.accommodationDetails,
//                         extra: {"id": hotel.accommodationId},
//                       );
//                     },
//                     trailingWidget: WishlistButton(
//                       accommodationId: hotel.accommodationId,
//                     ),
//                     amenities: hotel.details?.amenities ?? [],
//                     imageUrl: (hotel.details?.imagesUrl.isNotEmpty ?? false)
//                         ? hotel.details!.imagesUrl.first
//                         : null,
//                     location: hotel.details?.location.area ?? '',
//                     price: hotel.details?.pricingIds.isNotEmpty == true
//                         ? '${hotel.details!.pricingIds.first.pricing.first.price}'
//                         : '',
//                     title: hotel.details?.propertyName ?? 'N/A',
//                   ),
//                 );
//               },
//             );
//           }

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(12),
//             child: Wrap(
//               spacing: 12,
//               runSpacing: 12,
//               children: hostels.map((hotel) {
//                 return SizedBox(
//                   width: (screenWidth - 36) / 2,
//                   child: AppHotelCard(
//                     onTap: () {
//                       context.pushNamed(
//                         RouteList.accommodationDetails,
//                         extra: {"id": hotel.accommodationId},
//                       );
//                     },
//                     trailingWidget: WishlistButton(
//                       accommodationId: hotel.accommodationId,
//                     ),
//                     amenities: hotel.details?.amenities ?? [],
//                     imageUrl: (hotel.details?.imagesUrl.isNotEmpty ?? false)
//                         ? hotel.details!.imagesUrl.first
//                         : null,
//                     location: hotel.details?.location.area ?? '',
//                     price: hotel.details?.pricingIds.isNotEmpty == true
//                         ? '${hotel.details!.pricingIds.first.pricing.first.price}'
//                         : '',
//                     title: hotel.details?.propertyName ?? 'N/A',
//                   ),
//                 );
//               }).toList(),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildMobileShimmer() {
//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//       itemCount: 3,
//       itemBuilder: (context, index) {
//         return const Padding(
//           padding: EdgeInsets.only(bottom: 12),
//           child: PopularHotelCardShimmer(),
//         );
//       },
//     );
//   }

//   Widget _buildTabletShimmer() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(12),
//       child: Wrap(
//         spacing: 12,
//         runSpacing: 12,
//         children: List.generate(4, (index) {
//           return SizedBox(
//             width: (MediaQuery.of(context).size.width - 36) / 2,
//             child: const PopularHotelCardShimmer(),
//           );
//         }),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indhostels/bloc/wishlist/wishlist_bloc.dart';
import 'package:indhostels/data/models/wishlist/wish_list_res.dart';
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

  bool _isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 768;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);

    return Scaffold(
      appBar: AppBar(title: const Text("My Wishlist")),
      body: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          if (state.loading) {
            return _WishlistShimmer(isTablet: isTablet);
          }

          if (state.error != null) {
            return _ErrorView(message: state.error!);
          }

          if (state.items.isEmpty) {
            return const _EmptyView();
          }

          return _WishlistContent(items: state.items, isTablet: isTablet);
        },
      ),
    );
  }
}

class _WishlistContent extends StatelessWidget {
  final List<WishlistItem> items;
  final bool isTablet;

  const _WishlistContent({required this.items, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return isTablet ? _TabletLayout(items: items) : _MobileLayout(items: items);
  }
}

class _MobileLayout extends StatelessWidget {
  final List<WishlistItem> items;

  const _MobileLayout({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _WishlistCard(item: items[index]),
        );
      },
    );
  }
}

class _TabletLayout extends StatelessWidget {
  final List<WishlistItem> items;

  const _TabletLayout({required this.items});

  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        return _WishlistCard(item: items[index]);
      },
    );
  }
}

class _WishlistCard extends StatelessWidget {
  final WishlistItem item;

  const _WishlistCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final details = item.details;

    return AppHotelCard(
      onTap: () {
        context.pushNamed(
          RouteList.accommodationDetails,
          extra: {"id": item.accommodationId},
        );
      },
      trailingWidget: WishlistButton(accommodationId: item.accommodationId),
      amenities: details?.amenities ?? [],
      imageUrl: details?.primaryImage,
      location: details?.location.area ?? '',
      price: details?.priceFormatted ?? '',
      title: details?.propertyName ?? 'N/A',
    );
  }
}

class _WishlistShimmer extends StatelessWidget {
  final bool isTablet;

  const _WishlistShimmer({required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return isTablet
        ? GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (context, index) => const PopularHotelCardShimmer(),
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            itemCount: 3,
            itemBuilder: (context, index) {
              return const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: PopularHotelCardShimmer(),
              );
            },
          );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite_border, size: 40),
          SizedBox(height: 8),
          Text("No wishlist found"),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
