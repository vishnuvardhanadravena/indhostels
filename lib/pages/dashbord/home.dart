import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indhostels/bloc/Serach/search_bloc.dart';
import 'package:indhostels/bloc/accommodation/accommodation_bloc.dart';
import 'package:indhostels/bloc/profile/profile_bloc.dart';
import 'package:indhostels/data/models/accomodation/popular_hstl_res.dart';
import 'package:indhostels/pages/dashbord/search.dart';
import 'package:indhostels/routing/route_constants.dart';
import 'package:indhostels/utils/shimmers/popular_hstl_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:indhostels/utils/widgets/app_hostel_card.dart';
import 'package:indhostels/utils/widgets/wisth_listbutton.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 0;
  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;
  String searchText = "";
  final ScrollController _scrollController = ScrollController();

  int page = 1;
  final int limit = 10;
  bool isFetchingMore = false;

  final List<_CategoryTab> _categories = const [
    // _CategoryTab(label: 'Hotel', icon: Icons.hotel),
    _CategoryTab(label: 'PG', icon: Icons.apartment),
    _CategoryTab(label: 'Hostel', icon: Icons.bed),
  ];
  @override
  void initState() {
    super.initState();
    loadData();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!isFetchingMore) {
        isFetchingMore = true;
        page++;

        context.read<SearchBloc>().add(
          GlobalSearchRequested(text: searchText, page: page, limit: limit),
        );
      }
    }
  }

  void loadData() {
    final bloc = context.read<AccommodationBloc>();

    bloc.add(TopHStlRequested());
    bloc.add(const BudgetHStlRequested(type: "budget", page: 1, limit: 10));
  }

  void _onSearch(String value) {
    setState(() {
      searchText = value;
      isSearching = value.isNotEmpty;
      page = 1;
    });

    if (value.isNotEmpty) {
      context.read<SearchBloc>().add(
        GlobalSearchRequested(text: value, page: 1, limit: limit),
      );
    }
  }

  void _onchanged(String value) {
    setState(() {
      searchText = value;
      isSearching = value.isNotEmpty;
      page = 1;
    });
  }

  Widget _buildSearchResults() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state.globalLoading && page == 1) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.globalError != null) {
          return Center(child: Text(state.globalError!));
        }

        final hotels = state.globalResponse?.data ?? [];

        if (hotels.isEmpty) {
          return const Center(child: Text("No results found"));
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16),

          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),

          itemCount: hotels.length + 1,

          itemBuilder: (context, index) {
            if (index == hotels.length) {
              return state.globalLoading
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : const SizedBox();
            }

            final hotel = hotels[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () {
                  context.pushNamed(
                    RouteList.accommodationDetails,
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final listHeight = screenWidth > 600
        ? screenHeight * 0.4
        : screenHeight * 0.4;

    final cardWidth = screenWidth > 600
        ? screenWidth * 0.30
        : screenWidth * 0.8;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AccommodationBloc, AccommodationState>(
        listener: (context, state) {
          if (state.topHostelError != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.topHostelError!)));
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.37,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 182, 154, 235),
                        Color(0xFFE8E0F8),
                        Colors.white,
                      ],
                      stops: [0.0, 0.6, 1.0],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(16, top + 12, 16, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 14,
                                        color: Color(0xFF7B5EA7),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Hyderabad',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF333333),
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 16,
                                        color: Color(0xFF7B5EA7),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.notifications_none,
                                    size: 20,
                                    color: Color(0xFF555555),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF7B5EA7),
                                        Color(0xFF9B7FBF),
                                      ],
                                    ),
                                  ),
                                  child: ClipOval(
                                    child:
                                        (UserSession().user?.profileUrl !=
                                                null &&
                                            UserSession()
                                                .user!
                                                .profileUrl!
                                                .isNotEmpty &&
                                            UserSession().user!.profileUrl!
                                                .startsWith('http'))
                                        ? Image.network(
                                            UserSession().user!.profileUrl!,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                const Icon(
                                                  Icons.person,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                          )
                                        : const Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 12),
                                  const Icon(
                                    Icons.search,
                                    color: Color(0xFFAAAAAA),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      onChanged: (value) {
                                        if (value == "") {
                                          setState(() {
                                            searchText = "";
                                            isSearching = false;
                                          });
                                        }
                                      },
                                      decoration: const InputDecoration(
                                        hintText:
                                            'Search hotels, PGs, hostels...',
                                        hintStyle: TextStyle(
                                          color: Color(0xFFBBBBBB),
                                          fontSize: 13,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () =>
                                        _onSearch(_searchController.text),
                                    child: Container(
                                      margin: const EdgeInsets.all(6),
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF7B5EA7),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.search_rounded,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 10),
                            !isSearching && searchText == ""
                                ? SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.05,
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: _categories.length,
                                        itemBuilder: (context, i) {
                                          final isSelected =
                                              i == _selectedCategory;

                                          return GestureDetector(
                                            onTap: () {
                                              setState(
                                                () => _selectedCategory = i,
                                              );
                                              context.pushNamed(
                                                RouteList.categoryScreen,
                                                extra: {
                                                  "title": _categories[i].label,
                                                },
                                              );
                                            },

                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 200,
                                              ),
                                              margin: EdgeInsets.only(
                                                right:
                                                    i < _categories.length - 1
                                                    ? 8
                                                    : 0,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 10,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? Colors.white
                                                    : Colors.white.withOpacity(
                                                        0.45,
                                                      ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                      Radius.circular(12),
                                                    ),
                                                boxShadow: isSelected
                                                    ? [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                0.08,
                                                              ),
                                                          blurRadius: 6,
                                                          offset: const Offset(
                                                            0,
                                                            -2,
                                                          ),
                                                        ),
                                                      ]
                                                    : [],
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    _categories[i].icon,
                                                    size: 18,
                                                    color: isSelected
                                                        ? const Color(
                                                            0xFF7B5EA7,
                                                          )
                                                        : const Color(
                                                            0xFF888888,
                                                          ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    _categories[i].label,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: isSelected
                                                          ? FontWeight.w700
                                                          : FontWeight.w500,
                                                      color: isSelected
                                                          ? const Color(
                                                              0xFF7B5EA7,
                                                            )
                                                          : const Color(
                                                              0xFF888888,
                                                            ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                      !isSearching && searchText == ""
                          ? Column(
                              children: [
                                BlocBuilder<
                                  AccommodationBloc,
                                  AccommodationState
                                >(
                                  buildWhen: (previous, current) =>
                                      previous.topHostelLoading !=
                                          current.topHostelLoading ||
                                      previous.topHostels !=
                                          current.topHostels ||
                                      previous.topHostelError !=
                                          current.topHostelError,
                                  builder: (context, state) {
                                    if (state.topHostelLoading) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _SectionHeader(
                                            title: 'Popular Hostels',
                                            onViewAll: () {
                                              context.pushNamed(
                                                RouteList.categoryScreen,
                                                extra: {"title": 'Hostel'},
                                              );
                                            },
                                          ),
                                          SizedBox(
                                            height: listHeight,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: 3,
                                              itemBuilder: (_, __) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 10,
                                                        right: 12,
                                                      ),
                                                  child: SizedBox(
                                                    width: cardWidth,
                                                    child:
                                                        const PopularHotelCardShimmer(),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    }

                                    if (state.topHostelError != null) {
                                      return const Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Center(
                                          child: Text("Unable to load data"),
                                        ),
                                      );
                                    }

                                    final hostels = state.topHostels ?? [];

                                    if (hostels.isEmpty) {
                                      return const SizedBox();
                                    }

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _SectionHeader(
                                          title: 'Popular Hostels',
                                          onViewAll: () {
                                            context.pushNamed(
                                              RouteList.categoryScreen,
                                              extra: {"title": 'Hostel'},
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          height: listHeight,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: hostels.length,
                                            itemBuilder: (_, i) {
                                              final hotel = hostels[i];

                                              return GestureDetector(
                                                onTap: () {
                                                  context.pushNamed(
                                                    RouteList
                                                        .accommodationDetails,
                                                    extra: {"id": hotel.id},
                                                  );
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 10,
                                                        right: 12,
                                                      ),
                                                  child: SizedBox(
                                                    width: cardWidth,
                                                    child: AppHotelCard(
                                                      trailingWidget:
                                                          WishlistButton(
                                                            accommodationId:
                                                                hotel.id ?? "",
                                                          ),
                                                      amenities:
                                                          hotel.amenities ?? [],
                                                      imageUrl: hotel
                                                          .imagesUrl
                                                          ?.first,
                                                      location:
                                                          hotel
                                                              .location
                                                              ?.area ??
                                                          '',
                                                      price:
                                                          '₹${hotel.pricingData?.first.pricing?.first.price ?? ''}',
                                                      rating:
                                                          hotel.averageRating ??
                                                          0,
                                                      title:
                                                          hotel.propertyName ??
                                                          '',
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                _SectionHeader(
                                  title: "Budget-Friendly PG's",
                                  onViewAll: () {
                                    context.pushNamed(
                                      RouteList.categoryScreen,
                                      extra: {"title": 'PG'},
                                    );
                                  },
                                ),
                                BlocBuilder<
                                  AccommodationBloc,
                                  AccommodationState
                                >(
                                  buildWhen: (previous, current) =>
                                      previous.budgetHostelLoading !=
                                          current.budgetHostelLoading ||
                                      previous.budgetHostels !=
                                          current.budgetHostels ||
                                      previous.budgetHostelError !=
                                          current.budgetHostelError,
                                  builder: (context, state) {
                                    if (state.budgetHostelLoading) {
                                      return SizedBox(
                                        height: listHeight,
                                        child: ListView.builder(
                                          itemCount: 6,
                                          itemBuilder: (_, __) =>
                                              const PGListTileSkeleton(),
                                        ),
                                      );
                                    }

                                    if (state.budgetHostelError != null) {
                                      return const Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Center(
                                          child: Text(
                                            "Something went wrong please try again later",
                                          ),
                                        ),
                                      );
                                    }

                                    final hostels = state.budgetHostels ?? [];

                                    if (hostels.isEmpty) {
                                      return const SizedBox();
                                    }

                                    /// DATA
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ...hostels.map(
                                          (hotel) => GestureDetector(
                                            onTap: () {
                                              context.pushNamed(
                                                RouteList.accommodationDetails,
                                                extra: {"id": hotel.sId},
                                              );
                                            },
                                            child: _PGListTile(hotel: hotel),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                SizedBox(height: bottom + 24),
                              ],
                            )
                          : _buildSearchResults(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CategoryTab {
  final String label;
  final IconData icon;
  const _CategoryTab({required this.label, required this.icon});
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;

  const _SectionHeader({required this.title, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF222222),
              ),
            ),
          ),
          GestureDetector(
            onTap: onViewAll,
            child: const Row(
              children: [
                Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF7B5EA7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 2),
                Icon(Icons.chevron_right, size: 16, color: Color(0xFF7B5EA7)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PGListTile extends StatelessWidget {
  final PopularHstlData hotel;

  const _PGListTile({required this.hotel});

  @override
  Widget build(BuildContext context) {
    final imageUrl = (hotel.imagesUrl != null && hotel.imagesUrl!.isNotEmpty)
        ? hotel.imagesUrl!.first
        : "";

    final price =
        hotel.pricingData?.first.pricing?.first.price?.toString() ?? "0";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        children: [
          /// IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              bottomLeft: Radius.circular(14),
            ),
            child: SizedBox(
              width: 90,
              height: 90,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,

                /// LOADING
                placeholder: (context, url) => Container(
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),

                /// ERROR
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 28,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),

          /// INFO
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// TITLE + RATING
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          hotel.propertyName ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Color(0xFF222222),
                          ),
                        ),
                      ),
                      RatingBadge(
                        rating: hotel.averageRating ?? 0,
                        compact: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  /// LOCATION
                  Text(
                    hotel.location?.area ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF999999),
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// PRICE
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '₹$price',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF222222),
                          ),
                        ),
                        const TextSpan(
                          text: ' / night',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HotelImagePlaceholder extends StatelessWidget {
  final String imageUrl;
  final Color color;

  const _HotelImagePlaceholder({required this.imageUrl, required this.color});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,

      placeholder: (context, url) => Container(
        color: color.withOpacity(0.25),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),

      errorWidget: (context, url, error) => Container(
        color: color.withOpacity(0.25),
        child: Icon(Icons.hotel, size: 32, color: color.withOpacity(0.5)),
      ),
    );
  }
}

// class _RoomPainter extends CustomPainter {
//   final Color color;
//   const _RoomPainter({required this.color});
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()..color = color.withOpacity(0.15);
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromLTWH(
//           size.width * 0.1,
//           size.height * 0.55,
//           size.width * 0.8,
//           size.height * 0.3,
//         ),
//         const Radius.circular(4),
//       ),
//       paint,
//     );
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromLTWH(
//           size.width * 0.15,
//           size.height * 0.45,
//           size.width * 0.25,
//           size.height * 0.15,
//         ),
//         const Radius.circular(4),
//       ),
//       paint,
//     );
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromLTWH(
//           size.width * 0.55,
//           size.height * 0.45,
//           size.width * 0.25,
//           size.height * 0.15,
//         ),
//         const Radius.circular(4),
//       ),
//       paint,
//     );
//   }
//   @override
//   bool shouldRepaint(_) => false;
// }
