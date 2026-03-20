part of 'search_bloc.dart';

class SearchState extends Equatable {
  /// SEARCH PARAMS
  final String? city;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final int guestCount;

  final bool searchLoading;
  final bool searchMoreLoading;
  final bool globalLoading;
  final bool recentLoading;
  final bool viewedLoading;

  final String? searchError;
  final String? globalError;
  final String? recentError;
  final String? viewedError;

  final SerachByCatRes? searchResponse;
  final GlobalSearchResponse? globalResponse;
  final Searches? recentSearch;
  final List<Accommodationdata>? recentlyViewed;

  const SearchState({
    this.city,
    this.checkInDate,
    this.checkOutDate,
    this.guestCount = 1,
    this.searchLoading = false,
    this.searchMoreLoading = false,
    this.globalLoading = false,
    this.recentLoading = false,
    this.viewedLoading = false,
    this.searchError,
    this.globalError,
    this.recentError,
    this.viewedError,
    this.searchResponse,
    this.globalResponse,
    this.recentSearch,
    this.recentlyViewed,
  });

  factory SearchState.initial() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return SearchState(
      city: "hyderabad",
      checkInDate: today,
      checkOutDate: today.add(const Duration(days: 5)),
      guestCount: 1,
    );
  }

  SearchState copyWith({
    String? city,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    int? guestCount,
    bool? searchMoreLoading,
    bool? searchLoading,
    bool? globalLoading,
    bool? recentLoading,
    bool? viewedLoading,
    String? searchError,
    String? globalError,
    String? recentError,
    String? viewedError,
    SerachByCatRes? searchResponse,
    GlobalSearchResponse? globalResponse,
    Searches? recentSearch,
    List<Accommodationdata>? recentlyViewed,
  }) {
    return SearchState(
      city: city ?? this.city,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      guestCount: guestCount ?? this.guestCount,
      searchLoading: searchLoading ?? this.searchLoading,
      searchMoreLoading: searchMoreLoading ?? this.searchMoreLoading,
      globalLoading: globalLoading ?? this.globalLoading,
      recentLoading: recentLoading ?? this.recentLoading,
      viewedLoading: viewedLoading ?? this.viewedLoading,
      searchError: searchError,
      globalError: globalError,
      recentError: recentError,
      viewedError: viewedError,
      searchResponse: searchResponse ?? this.searchResponse,
      globalResponse: globalResponse ?? this.globalResponse,
      recentSearch: recentSearch ?? this.recentSearch,
      recentlyViewed: recentlyViewed ?? this.recentlyViewed,
    );
  }

  @override
  List<Object?> get props => [
    city,
    checkInDate,
    checkOutDate,
    guestCount,
    searchLoading,
    searchMoreLoading,
    globalLoading,
    recentLoading,
    viewedLoading,
    searchError,
    globalError,
    recentError,
    viewedError,
    searchResponse,
    globalResponse,
    recentSearch,
    recentlyViewed,
  ];
}
