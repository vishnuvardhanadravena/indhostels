import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indhostels/bloc/Serach/search_bloc.dart';
import 'package:indhostels/routing/route_constants.dart';

class RecentSearchModel {
  final String title;
  final String subtitle;

  const RecentSearchModel({required this.title, required this.subtitle});
}

class HotelModel {
  final String name;
  final String location;
  final double rating;
  final double pricePerNight;
  final String imageUrl;
  final String id;

  const HotelModel({
    required this.name,
    required this.location,
    required this.rating,
    required this.pricePerNight,
    required this.imageUrl,
    required this.id,
  });
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int page = 1;
  final int limit = 10;
  String currentQuery = "";

  final List<RecentSearchModel> _recentSearches = const [
    RecentSearchModel(
      title: 'Golden Sands Retreat',
      subtitle: 'Clearwater, FL',
    ),
    RecentSearchModel(title: 'Crystal Peak Lodge', subtitle: 'Aspen, CO'),
    RecentSearchModel(title: 'Coral Bay Resort', subtitle: 'Miami Beach, FL'),
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<SearchBloc>();

      bloc.add(RecentSearchRequested());
      bloc.add(RecentViewsRequested());
    });

    _scrollController.addListener(() {
      final bloc = context.read<SearchBloc>();

      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (bloc.globalHasMore && !bloc.globalIsFetching) {
          page++;

          bloc.add(
            GlobalSearchRequested(text: currentQuery, page: page, limit: limit),
          );
        }
      }
    });
  }

  void _clearAllRecentSearches() {
    setState(() {
      _recentSearches.clear();
    });
  }

  void _onSearch(String value) {
    if (value.isEmpty) {
      setState(() {});
      return;
    }

    page = 1;
    currentQuery = value;

    context.read<SearchBloc>().add(
      GlobalSearchRequested(text: value, page: page, limit: limit),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            return Column(
              children: [
                const SizedBox(height: 20),

                const PageTitle(title: 'Search'),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SearchBar(
                    controller: _searchController,
                    onChanged: _onSearch,
                  ),
                ),

                const SizedBox(height: 24),

                Expanded(
                  child: _searchController.text.isEmpty
                      ? _buildInitialUI(state)
                      : _buildSearchResults(state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInitialUI(SearchState state) {
    final recentSearchModels = (state.recentSearch?.searchtext ?? [])
        .map((e) => RecentSearchModel(title: e, subtitle: ""))
        .toList();
    final recentlyViewedHotels = (state.recentlyViewed ?? []).map((hotel) {
      return HotelModel(
        id: hotel.sId ?? "",
        name: hotel.propertyName ?? "",
        location: hotel.location?.area ?? "",
        rating: 0,
        pricePerNight:
            hotel.pricingIds?.isNotEmpty == true &&
                hotel.pricingIds!.first.pricing?.isNotEmpty == true
            ? (hotel.pricingIds!.first.pricing!.first.price ?? 0).toDouble()
            : 0.0,
        imageUrl: hotel.imagesUrl?.first ?? "",
      );
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.recentLoading) ...[
            const SectionHeader(title: 'Recent Searches'),
            const SizedBox(height: 8),
            const _RecentSearchShimmer(),
            const SizedBox(height: 24),
          ] else if (recentSearchModels.isNotEmpty) ...[
            SectionHeader(
              title: 'Recent Searches',
              actionText: 'Clear All',
              onActionTap: _clearAllRecentSearches,
            ),
            const SizedBox(height: 8),

            RecentSearchList(searches: recentSearchModels),

            const SizedBox(height: 24),
          ],

          const SectionHeader(title: 'Recently Viewed'),
          const SizedBox(height: 12),

          if (state.viewedLoading)
            const _RecentlyViewedShimmer()
          else if (state.viewedError != null)
            Center(child: Text(state.viewedError ?? "Something went worng"))
          else if (recentlyViewedHotels.isNotEmpty)
            RecentlyViewedList(
              hotels: recentlyViewedHotels,
              onTap: (id) {
                context.pushNamed(
                  RouteList.acommodationDetaiesScreen,
                  extra: {"id": id},
                );
              },
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSearchResults(SearchState state) {
    if (state.globalLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.globalError != null) {
      return Center(child: Text(state.globalError!));
    }

    final hotels = state.globalResponse?.data ?? [];

    if (hotels.isEmpty) {
      return const Center(child: Text("No rooms found"));
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: hotels.length,
      itemBuilder: (context, index) {
        final hotel = hotels[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              context.pushNamed(
                RouteList.acommodationDetaiesScreen,
                extra: {"id": hotel.sId},
              );
            },
            child: HotelCard(
              model: HotelModel(
                id: hotel.sId ?? "",
                name: hotel.propertyName ?? "",
                location: hotel.location?.area ?? "",
                rating: hotel.averageRating ?? 0,
                pricePerNight:
                    (hotel.pricingData != null &&
                        hotel.pricingData!.isNotEmpty &&
                        hotel.pricingData!.first.pricing != null &&
                        hotel.pricingData!.first.pricing!.isNotEmpty)
                    ? (hotel.pricingData!.first.pricing!.first.price ?? 0)
                          .toDouble()
                    : 0,
                imageUrl: hotel.imagesUrl?.first ?? "",
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RecentSearchShimmer extends StatelessWidget {
  const _RecentSearchShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

class _RecentlyViewedShimmer extends StatelessWidget {
  const _RecentlyViewedShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 90,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class PageTitle extends StatelessWidget {
  final String title;

  const PageTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }
}

/// Search input bar with a leading search icon and trailing filter icon.
class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onFilterTap;
  final Function(String)? onChanged;

  const SearchBar({
    super.key,
    required this.controller,
    this.hintText = 'Search hotels, PGs, hotels...',
    this.onFilterTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Icon(Icons.search, color: Colors.grey.shade500, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ),
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.tune, color: Colors.grey.shade600, size: 20),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }
}

/// Section header with an optional right-side action button.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        if (actionText != null)
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              actionText!,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFFE91E63),
              ),
            ),
          ),
      ],
    );
  }
}

/// Renders a list of recent search items.
class RecentSearchList extends StatelessWidget {
  final List<RecentSearchModel> searches;

  const RecentSearchList({super.key, required this.searches});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: searches
          .map((search) => RecentSearchItem(model: search))
          .toList(),
    );
  }
}

/// A single recent search row with a clock icon, title, and subtitle.
class RecentSearchItem extends StatelessWidget {
  final RecentSearchModel model;
  final VoidCallback? onTap;

  const RecentSearchItem({super.key, required this.model, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.access_time,
                color: Colors.grey.shade500,
                size: 18,
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  model.subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Renders a list of recently viewed hotel cards.
class RecentlyViewedList extends StatelessWidget {
  final List<HotelModel> hotels;
  final void Function(String id) onTap;

  const RecentlyViewedList({
    super.key,
    required this.hotels,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: hotels
          .map(
            (hotel) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => onTap(hotel.id),
                child: HotelCard(model: hotel),
              ),
            ),
          )
          .toList(),
    );
  }
}

class HotelCard extends StatelessWidget {
  final HotelModel model;
  final VoidCallback? onTap;

  const HotelCard({super.key, required this.model, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
              child: Image.network(
                model.imageUrl,
                width: 100,
                height: 95,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 100,
                  height: 95,
                  color: Colors.grey.shade200,
                  child: Icon(
                    Icons.hotel,
                    color: Colors.grey.shade400,
                    size: 32,
                  ),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 100,
                    height: 95,
                    color: Colors.grey.shade100,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.grey.shade400,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 14),

            // Hotel Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + Rating Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            model.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        StarRatingBadge(rating: model.rating),
                        const SizedBox(width: 12),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Location
                    Text(
                      model.location,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Price
                    HotelPriceTag(pricePerNight: model.pricePerNight),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Star rating badge showing a filled star + rating number.
class StarRatingBadge extends StatelessWidget {
  final double rating;

  const StarRatingBadge({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star, color: Color(0xFFFFC107), size: 16),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class HotelPriceTag extends StatelessWidget {
  final double pricePerNight;

  const HotelPriceTag({super.key, required this.pricePerNight});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '₹${pricePerNight.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: ' / 1 night',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
