import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:indhostels/bloc/Serach/search_bloc.dart';
import 'package:indhostels/data/models/accomodation/search_res.dart';
import 'package:indhostels/pages/category/category_screen.dart';
import 'package:indhostels/routing/route_constants.dart';
import 'package:indhostels/utils/widgets/app_hostel_card.dart';
import 'package:indhostels/utils/widgets/serachfelid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indhostels/utils/widgets/wisth_listbutton.dart';
import 'package:intl/intl.dart';

class HotelListingScreen extends StatefulWidget {
  const HotelListingScreen({super.key});

  @override
  State<HotelListingScreen> createState() => _HotelListingScreenState();
}

class _HotelListingScreenState extends State<HotelListingScreen> {
  final ScrollController _scrollController = ScrollController();
  SerachByCatRes? _apiResponse;
  FilterSelection? _activeFilter;
  @override
  void initState() {
    super.initState();

    final bloc = context.read<SearchBloc>();
    final state = bloc.state;

    bloc.add(
      SearchRequested(
        page: 1,
        limit: 10,
        stayType: ["hostels"],
        location: "hyderabad",
        checkInDate: state.checkInDate != null
            ? DateFormat('yyyy-MM-dd').format(state.checkInDate!)
            : null,
        checkOutDate: state.checkOutDate != null
            ? DateFormat('yyyy-MM-dd').format(state.checkOutDate!)
            : null,
      ),
    );

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final bloc = context.read<SearchBloc>();
    final state = bloc.state;

    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    const threshold = 200;

    if (position.pixels >= position.maxScrollExtent - threshold) {
      if (!bloc.hasMore || bloc.isFetching) return;

      bloc.add(
        SearchRequested(
          page: bloc.currentPage + 1,
          limit: 10,
          stayType: const ['hostels'],
          checkInDate: state.checkInDate != null
              ? DateFormat('yyyy-MM-dd').format(state.checkInDate!)
              : null,
          checkOutDate: state.checkOutDate != null
              ? DateFormat('yyyy-MM-dd').format(state.checkOutDate!)
              : null,
          roomType: _activeFilter?.selectedRoomTypes.isNotEmpty == true
              ? _activeFilter!.selectedRoomTypes.toList()
              : null,
          amenities: _activeFilter?.selectedAmenities.isNotEmpty == true
              ? _activeFilter!.selectedAmenities.toList()
              : null,
          category: _activeFilter?.selectedCategory,
          location: _activeFilter?.selectedLocation ?? state.city,
          minPrice: _activeFilter?.priceRange.start,
          maxPrice: _activeFilter?.priceRange.end,
        ),
      );
    }
  }

  void _onHotelTap(Data hotel) {
    context.pushNamed(RouteList.accommodationDetails, extra: {"id": hotel.sId});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4FB),
      body: SafeArea(
        child: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            final hotels = state.searchResponse?.data ?? [];
            _apiResponse = state.searchResponse;
            final city = state.city ?? "Hyderabad";

            final checkIn = state.checkInDate != null
                ? DateFormat('dd MMM').format(state.checkInDate!)
                : "";

            final checkOut = state.checkOutDate != null
                ? DateFormat('dd MMM').format(state.checkOutDate!)
                : "";

            final dateRange = "$checkIn - $checkOut";
            return RefreshIndicator(
              onRefresh: () async {
                final bloc = context.read<SearchBloc>();
                final state = bloc.state;
                bloc.add(
                  SearchRequested(
                    page: 1,
                    limit: 10,
                    stayType: const ['hostels'],

                    checkInDate: state.checkInDate != null
                        ? DateFormat('yyyy-MM-dd').format(state.checkInDate!)
                        : null,

                    checkOutDate: state.checkOutDate != null
                        ? DateFormat('yyyy-MM-dd').format(state.checkOutDate!)
                        : null,

                    roomType:
                        _activeFilter?.selectedRoomTypes.isNotEmpty == true
                        ? _activeFilter!.selectedRoomTypes.toList()
                        : null,

                    amenities:
                        _activeFilter?.selectedAmenities.isNotEmpty == true
                        ? _activeFilter!.selectedAmenities.toList()
                        : null,

                    category: _activeFilter?.selectedCategory,
                    location: _activeFilter?.selectedLocation ?? state.city,
                    minPrice: _activeFilter?.priceRange.start,
                    maxPrice: _activeFilter?.priceRange.end,
                  ),
                );
              },
              color: Colors.white,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TopSection(
                      city: city,
                      dateRange: dateRange,
                      filters: _activeFilter,
                    ),

                    SearchFilterBar(
                      filters: _apiResponse?.filters,
                      onSearch: (query) {},
                      activeSelection: _activeFilter,
                      onFilterChanged: (FilterSelection sel) async {
                        _activeFilter = sel;
                        context.read<SearchBloc>().add(
                          SearchRequested(
                            page: 1,
                            limit: 10,
                            stayType: ['hostels'],
                            checkInDate: state.checkInDate != null
                                ? DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(state.checkInDate!)
                                : null,

                            checkOutDate: state.checkOutDate != null
                                ? DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(state.checkOutDate!)
                                : null,

                            roomType: sel.selectedRoomTypes.isNotEmpty
                                ? sel.selectedRoomTypes.toList()
                                : null,
                            amenities: sel.selectedAmenities.isNotEmpty
                                ? sel.selectedAmenities.toList()
                                : null,
                            category: sel.selectedCategory,
                            location: sel.selectedLocation,
                            minPrice: sel.priceRange.start,
                            maxPrice: sel.priceRange.end,
                          ),
                        );

                        await Future.delayed(const Duration(milliseconds: 700));

                        return _apiResponse?.filters;
                      },
                      onFilterApplied: (sel) {
                        _activeFilter = sel;
                      },
                    ),

                    ListingHeader(
                      city: state.city ?? "hyderabad",
                      count: hotels.length,
                    ),

                    _buildListArea(state, hotels),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListArea(SearchState state, List<Data> hotels) {
    if (state.searchLoading && hotels.isEmpty) {
      return _buildSkeletonList();
    }

    if (state.searchError != null && hotels.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            state.searchError!,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    if (hotels.isEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off, size: 40, color: Colors.grey),
              SizedBox(height: 10),
              Text("No properties found", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        buildHotelList(context, hotels),

        if (state.searchLoading)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Widget _buildSkeletonList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (_, __) => const _HotelCardSkeleton(),
    );
  }

  Widget buildHotelList(BuildContext context, List<Data> hotels) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    if (isTablet) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: hotels.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (context, index) {
          final hotel = hotels[index];

          return GestureDetector(
            onTap: () => _onHotelTap(hotel),
            child: AppHotelCard(
              imageUrl: hotel.imagesUrl?.isNotEmpty == true
                  ? hotel.imagesUrl?.first
                  : null,
              title: hotel.propertyName,
              location: hotel.location?.area,
              rating: hotel.averageRating,
              price: hotel.pricingIds?.isNotEmpty == true
                  ? hotel.pricingIds!.first.pricing?.isNotEmpty == true
                        ? hotel.pricingIds!.first.pricing!.first.price
                                  ?.toString() ??
                              "0"
                        : "0"
                  : "N/A",
              amenities: hotel.amenities,
              trailingWidget: WishlistButton(accommodationId: hotel.sId ?? ""),
            ),
          );
        },
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: hotels.length,
      itemBuilder: (context, index) {
        return buildHotelItem(context, hotels[index]);
      },
    );
  }

  Widget buildHotelItem(BuildContext context, Data hotel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      child: AppHotelCard(
        onTap: () => _onHotelTap(hotel),
        imageUrl: hotel.imagesUrl?.isNotEmpty == true
            ? hotel.imagesUrl?.first
            : null,
        title: hotel.propertyName,
        location: hotel.location?.area,
        rating: hotel.averageRating,
        price: hotel.pricingIds?.isNotEmpty == true
            ? hotel.pricingIds!.first.pricing?.isNotEmpty == true
                  ? hotel.pricingIds!.first.pricing!.first.price?.toString() ??
                        "0"
                  : "0"
            : "N/A",
        amenities: hotel.amenities,
        trailingWidget: WishlistButton(accommodationId: hotel.sId ?? ""),
      ),
    );
  }
}

class _TopSection extends StatelessWidget {
  final String city;
  final String dateRange;
  final FilterSelection? filters;

  const _TopSection({
    required this.city,
    required this.dateRange,
    required this.filters,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFEAE8F8),
          // border: Border.all(),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        size: 18,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          city,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              dateRange,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF666666),
                              ),
                            ),

                            TextButton(
                              onPressed: () {
                                showSearchTopSheet(
                                  context,
                                  activeFilter: filters,
                                );
                              },
                              style: ButtonStyle(
                                padding: WidgetStateProperty.all(
                                  const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 0,
                                  ),
                                ),
                                overlayColor: WidgetStateProperty.resolveWith((
                                  states,
                                ) {
                                  if (states.contains(WidgetState.hovered)) {
                                    return Colors.blue.withOpacity(0.1);
                                  }
                                  return null;
                                }),
                              ),
                              child: const Text("Edit"),
                            ),
                          ],
                        ),
                      ],
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

void showSearchTopSheet(
  BuildContext context, {
  required FilterSelection? activeFilter,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "SearchSheet",
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),

    pageBuilder: (context, animation, secondaryAnimation) {
      return Align(
        alignment: Alignment.topCenter,
        child: Material(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
          child: SafeArea(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                final start = state.checkInDate ?? DateTime.now();
                final end =
                    state.checkOutDate ??
                    DateTime.now().add(const Duration(days: 1));

                final range = DateTimeRange(start: start, end: end);
                final nights = range.end.difference(range.start).inDays;

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Expanded(
                            child: Center(
                              child: Text(
                                "Hotels",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 40),
                        ],
                      ),

                      const Divider(),

                      SearchCard(
                        city: (state.city != null && state.city!.isNotEmpty)
                            ? state.city!
                            : "hyderabad",

                        dateRange: range,
                        nights: nights,
                        formatDate: (d) => DateFormat('dd MMM, yy').format(d),

                        onCityTap: () async {
                          final result = await context.pushNamed<String>(
                            RouteList.serachLocation,
                          );

                          if (result != null && result.isNotEmpty) {
                            context.read<SearchBloc>().add(
                              UpdateSearchParams(city: result),
                            );
                          }
                        },

                        onDateTap: () async {
                          final result =
                              await showModalBottomSheet<DateTimeRange>(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => DateRangePickerSheet(
                                  initialRange: range,
                                  type: state.stayType,
                                ),
                              );

                          if (result != null) {
                            context.read<SearchBloc>().add(
                              UpdateSearchParams(
                                checkInDate: result.start,
                                checkOutDate: result.end,
                              ),
                            );
                          }
                        },

                        onSearch: () {
                          final city =
                              (state.city != null && state.city!.isNotEmpty)
                              ? state.city!
                              : "hyderabad";

                          final checkIn = range.start;
                          final checkOut = range.end;

                          context.read<SearchBloc>().add(
                            SearchRequested(
                              page: 1,
                              limit: 10,
                              stayType: const ['hostels'],

                              checkInDate: DateFormat(
                                'yyyy-MM-dd',
                              ).format(checkIn),
                              checkOutDate: DateFormat(
                                'yyyy-MM-dd',
                              ).format(checkOut),

                              roomType:
                                  activeFilter?.selectedRoomTypes.isNotEmpty ==
                                      true
                                  ? activeFilter!.selectedRoomTypes.toList()
                                  : null,

                              amenities:
                                  activeFilter?.selectedAmenities.isNotEmpty ==
                                      true
                                  ? activeFilter!.selectedAmenities.toList()
                                  : null,

                              category: activeFilter?.selectedCategory,

                              location: activeFilter?.selectedLocation ?? city,

                              minPrice: activeFilter?.priceRange.start,
                              maxPrice: activeFilter?.priceRange.end,
                            ),
                          );

                          Navigator.pop(context);
                        },

                        isSearching: state.searchLoading,
                      ),

                      const SizedBox(height: 10),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    },

    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );
}

class ListingHeader extends StatelessWidget {
  final String city;
  final int count;

  const ListingHeader({super.key, required this.city, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
          children: [
            const TextSpan(text: 'Showing Properties in '),
            TextSpan(
              text: city,
              style: const TextStyle(color: Color(0xFF5B4FCF)),
            ),
          ],
        ),
      ),
    );
  }
}

class _HotelCardSkeleton extends StatelessWidget {
  const _HotelCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}

class HotelModel {
  final String id;
  final String name;
  final String location;
  final double rating;
  final int pricePerNight;
  final String currency;
  final List<String> amenities;
  final List<String> imageUrls;
  bool isFavorite;

  HotelModel({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.pricePerNight,
    this.currency = '₹',
    required this.amenities,
    required this.imageUrls,
    this.isFavorite = false,
  });

  HotelModel copyWith({bool? isFavorite}) => HotelModel(
    id: id,
    name: name,
    location: location,
    rating: rating,
    pricePerNight: pricePerNight,
    currency: currency,
    amenities: amenities,
    imageUrls: imageUrls,
    isFavorite: isFavorite ?? this.isFavorite,
  );
}
