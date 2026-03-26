import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:indhostels/data/models/accomodation/search_res.dart';
import 'package:indhostels/data/models/search/globelsearch_res.dart';
import 'package:indhostels/data/models/search/loction_serach_res.dart';
import 'package:indhostels/data/models/search/recent_views_res.dart';
import 'package:indhostels/data/repo/search_repo.dart';
import 'package:indhostels/exceptions/api_exceptions.dart';
import 'package:indhostels/services/apiservice/api_client.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository repository;

  List<Data> hotels = [];
  int currentPage = 1;
  bool hasMore = true;
  bool isFetching = false;

  List<Accomdations> globalHotels = [];
  int globalCurrentPage = 1;
  bool globalHasMore = true;
  bool globalIsFetching = false;

  List<LocationItem> _locationItems = [];
  List<String> _stayTypes = [];
  List<String> _roomTypes = [];
  List<String> _amenities = [];

  SearchBloc(this.repository) : super(SearchState.initial()) {
    on<SearchRequested>(_onSearchRequested);
    on<GlobalSearchRequested>(_onGlobalSearchRequested);
    on<RecentSearchRequested>(_onLoadRecentSearches);
    on<RecentViewsRequested>(_onLoadRecentViews);
    on<UpdateSearchParams>(_onUpdateSearchParams);

    on<LocationFetchAll>(_onLocationFetchAll);
    on<LocationSearchChanged>(_onLocationSearchChanged);
    on<LocationItemSelected>(_onLocationItemSelected);
    on<LocationSearchCleared>(_onLocationSearchCleared);
    on<ResetSearchEvent>(_onResetSearch);
  }

  Future<void> _onResetSearch(
    ResetSearchEvent event,
    Emitter<SearchState> emit,
  ) async {
    hotels.clear();
    globalHotels.clear();

    currentPage = 1;
    hasMore = true;
    isFetching = false;

    globalCurrentPage = 1;
    globalHasMore = true;
    globalIsFetching = false;

    _locationItems = [];
    _stayTypes = [];
    _roomTypes = [];
    _amenities = [];

    emit(SearchState.initial());
  }

  void _onUpdateSearchParams(
    UpdateSearchParams event,
    Emitter<SearchState> emit,
  ) {
    emit(
      state.copyWith(
        city: event.city ?? state.city,
        checkInDate: event.checkInDate ?? state.checkInDate,
        checkOutDate: event.checkOutDate ?? state.checkOutDate,
        guestCount: event.guestCount ?? state.guestCount,
        stayType: event.staytype ?? state.stayType,
      ),
    );
  }

  Future<void> _onSearchRequested(
    SearchRequested event,
    Emitter<SearchState> emit,
  ) async {
    if (isFetching) return;
    if (!hasMore && event.page != 1) return;

    isFetching = true;

    if (event.page == 1) {
      hotels.clear();
      hasMore = true;
      currentPage = 1;
      emit(state.copyWith(searchLoading: true, searchError: null));
    } else {
      emit(state.copyWith(searchMoreLoading: true));
    }

    try {
      final response = await repository.searchHotels(
        page: event.page,
        limit: event.limit,
        location: state.city?.toLowerCase(),
        checkInDate: event.checkInDate,
        checkOutDate: event.checkOutDate,
        category: event.category,
        stayType: event.stayType,
        roomType: event.roomType,
        amenities: event.amenities,
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
        rating: event.rating,
      );

      final List<Data> list = response.data ?? [];

      if (event.page == 1) {
        hotels = list;
      } else {
        hotels.addAll(list);
      }

      currentPage = event.page;
      hasMore = list.length == event.limit;
      response.data = hotels;

      emit(
        state.copyWith(
          searchLoading: false,
          searchMoreLoading: false,
          searchResponse: response,
        ),
      );
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          searchLoading: false,
          searchMoreLoading: false,
          searchError: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          searchLoading: false,
          searchMoreLoading: false,
          searchError: 'Something went wrong',
        ),
      );
    } finally {
      isFetching = false;
    }
  }

  Future<void> _onGlobalSearchRequested(
    GlobalSearchRequested event,
    Emitter<SearchState> emit,
  ) async {
    if (globalIsFetching) return;
    if (!globalHasMore && event.page != 1) return;

    globalIsFetching = true;

    if (event.page == 1) {
      globalHotels.clear();
      globalHasMore = true;
      globalCurrentPage = 1;
      emit(
        state.copyWith(
          globalLoading: true,
          searchMoreLoading: false,
          globalError: null,
        ),
      );
    } else {
      emit(state.copyWith(searchMoreLoading: true));
    }

    try {
      final response = await repository.globalSearch(
        text: event.text,
        page: event.page,
        limit: event.limit,
      );

      final List<Accomdations> list = response.data ?? [];

      if (event.page == 1) {
        globalHotels = list;
      } else {
        globalHotels.addAll(list);
      }

      globalCurrentPage = event.page;
      globalHasMore = list.length == event.limit;
      response.data = globalHotels;

      emit(
        state.copyWith(
          globalLoading: false,
          searchMoreLoading: false,
          globalResponse: response,
        ),
      );
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          globalLoading: false,
          searchMoreLoading: false,
          globalError: e.message,
        ),
      );
    } catch (e, s) {
      AppLogger.error("Error: $e");
      AppLogger.error("StackTrace: $s");
      emit(
        state.copyWith(
          globalLoading: false,
          searchMoreLoading: false,
          globalError: 'Something went wrong',
        ),
      );
    } finally {
      globalIsFetching = false;
    }
  }

  Future<void> _onLoadRecentSearches(
    RecentSearchRequested event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(recentLoading: true, recentError: null));
    try {
      final response = await repository.loadRecentSerches();
      if (response.success == true && response.statuscode == 200) {
        emit(
          state.copyWith(
            recentLoading: false,
            recentSearch: response.data?.searchtext ?? [],
          ),
        );
      } else {
        emit(
          state.copyWith(
            recentLoading: false,
            recentSearch: [],
            recentError: response.message ?? 'Failed to load searches',
          ),
        );
      }
    } catch (_) {
      emit(
        state.copyWith(
          recentLoading: false,
          recentError: 'Something went wrong',
        ),
      );
    }
  }

  Future<void> _onLoadRecentViews(
    RecentViewsRequested event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(viewedLoading: true, viewedError: null));

    try {
      final response = await repository.loadRecentViews();

      emit(
        state.copyWith(
          viewedLoading: false,
          recentlyViewed: response.accommodationdata ?? [],
        ),
      );
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        emit(
          state.copyWith(
            viewedLoading: false,
            recentlyViewed: [],
            viewedError: null,
          ),
        );
      } else {
        emit(state.copyWith(viewedLoading: false, viewedError: e.message));
      }
    } catch (_) {
      emit(
        state.copyWith(
          viewedLoading: false,
          viewedError: 'Something went wrong',
        ),
      );
    }
  }

  Future<void> _onLocationFetchAll(
    LocationFetchAll event,
    Emitter<SearchState> emit,
  ) async {
    if (_locationItems.isNotEmpty) {
      emit(_buildLocationIdleState());
      return;
    }

    emit(state.copyWith(locationLoading: true, locationError: null));

    try {
      final res = await repository.getLocations();
      _parseLocationResponse(res.data);
      emit(_buildLocationIdleState());
    } catch (e) {
      emit(state.copyWith(locationLoading: false, locationError: e.toString()));
    }
  }

  void _onLocationSearchChanged(
    LocationSearchChanged event,
    Emitter<SearchState> emit,
  ) {
    final q = event.query.trim();

    if (q.isEmpty) {
      emit(_buildLocationIdleState());
      return;
    }

    final lower = q.toLowerCase();
    final suggestions = <Suggestion>[];

    for (final loc in _locationItems) {
      if (loc.city.toLowerCase().contains(lower)) {
        suggestions.add(Suggestion(label: loc.city, type: SuggestionType.city));
      }
    }

    for (final loc in _locationItems) {
      for (final area in loc.areas.toSet()) {
        if (area.toLowerCase().contains(lower)) {
          suggestions.add(
            Suggestion(label: '$area, ${loc.city}', type: SuggestionType.area),
          );
        }
      }
    }

    for (final s in _stayTypes) {
      if (s.toLowerCase().contains(lower)) {
        suggestions.add(Suggestion(label: s, type: SuggestionType.stayType));
      }
    }

    for (final r in _roomTypes) {
      if (r.toLowerCase().contains(lower)) {
        suggestions.add(Suggestion(label: r, type: SuggestionType.roomType));
      }
    }

    for (final a in _amenities) {
      if (a.toLowerCase().contains(lower)) {
        suggestions.add(Suggestion(label: a, type: SuggestionType.amenity));
      }
    }

    emit(
      state.copyWith(
        locationSearchActive: true,
        locationSuggestions: suggestions,
      ),
    );
  }

  void _onLocationItemSelected(
    LocationItemSelected event,
    Emitter<SearchState> emit,
  ) {
    final recents = List<String>.from(state.locationRecentSearches);
    recents.remove(event.value);
    recents.insert(0, event.value);
    if (recents.length > 5) recents.removeLast();

    emit(_buildLocationIdleState(recents: recents));
  }

  void _onLocationSearchCleared(
    LocationSearchCleared event,
    Emitter<SearchState> emit,
  ) {
    emit(_buildLocationIdleState());
  }

  void _parseLocationResponse(LocationData data) {
    _locationItems = data.locations;

    _stayTypes = data.stayTypes.map((s) => s.stayType).toList();

    final seenRoom = <String>{};
    _roomTypes = data.roomTypes
        .where((r) => seenRoom.add(r.toLowerCase()))
        .toList();

    final seenAmenity = <String>{};
    _amenities = data.amenities
        .where((a) => seenAmenity.add(a.toLowerCase()))
        .toList();
  }

  SearchState _buildLocationIdleState({List<String>? recents}) {
    final recentsList = recents ?? state.locationRecentSearches;

    final popular = _locationItems
        .where((l) => l.areas.isNotEmpty)
        .take(6)
        .map(
          (l) => PopularCity(
            city: l.city,
            hotelCount: l.areas.toSet().length * 180,
          ),
        )
        .toList();

    return state.copyWith(
      locationLoading: false,
      locationSearchActive: false,
      locationSuggestions: const [],
      locationRecentSearches: recentsList,
      popularCities: popular,
    );
  }
}
