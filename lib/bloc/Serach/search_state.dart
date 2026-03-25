part of 'search_bloc.dart';

enum SuggestionType { city, area, stayType, roomType, amenity }

class Suggestion extends Equatable {
  final String label;
  final SuggestionType type;
  const Suggestion({required this.label, required this.type});

  @override
  List<Object?> get props => [label, type];
}

class PopularCity extends Equatable {
  final String city;
  final int hotelCount;
  const PopularCity({required this.city, required this.hotelCount});

  @override
  List<Object?> get props => [city, hotelCount];
}

class SearchState extends Equatable {
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
  final List<String>? recentSearch;
  final List<Accommodationdata>? recentlyViewed;

  final bool locationLoading;
  final String? locationError;

  final List<Suggestion>? locationSuggestions;
  final List<String> locationRecentSearches;
  final List<PopularCity> popularCities;

  final bool locationSearchActive;
  final String stayType;

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
    this.locationLoading = false,
    this.locationError,
    this.locationSuggestions,
    this.locationRecentSearches = const [],
    this.popularCities = const [],
    this.locationSearchActive = false,
    this.stayType = "hotel",
  });

  factory SearchState.initial() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return SearchState(
      city: 'hyderabad',
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
    bool? searchLoading,
    bool? searchMoreLoading,
    bool? globalLoading,
    bool? recentLoading,
    bool? viewedLoading,
    String? searchError,
    String? globalError,
    String? recentError,
    String? viewedError,
    SerachByCatRes? searchResponse,
    GlobalSearchResponse? globalResponse,
    List<String>? recentSearch,
    List<Accommodationdata>? recentlyViewed,
    bool? locationLoading,
    String? locationError,
    List<Suggestion>? locationSuggestions,
    List<String>? locationRecentSearches,
    List<PopularCity>? popularCities,
    bool? locationSearchActive,
    String? stayType,
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
      locationLoading: locationLoading ?? this.locationLoading,
      locationError: locationError,
      locationSuggestions: locationSuggestions ?? this.locationSuggestions,
      locationRecentSearches:
          locationRecentSearches ?? this.locationRecentSearches,
      popularCities: popularCities ?? this.popularCities,
      locationSearchActive: locationSearchActive ?? this.locationSearchActive,
      stayType: stayType ?? this.stayType,
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
    locationLoading,
    locationError,
    locationSuggestions,
    locationRecentSearches,
    popularCities,
    locationSearchActive,
    stayType,
  ];
}
