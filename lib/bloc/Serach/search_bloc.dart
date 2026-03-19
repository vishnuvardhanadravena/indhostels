import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indhostels/data/models/search/recent_searchs_res.dart';
import 'package:indhostels/data/models/search/recent_views_res.dart';
import 'package:indhostels/data/repo/searchRepo.dart';
import 'package:bloc/bloc.dart';
import 'package:indhostels/data/models/accomodation/search_res.dart';
import 'package:indhostels/data/models/search/globelsearch_res.dart';
import 'package:indhostels/exceptions/api_exceptions.dart';

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

  SearchBloc(this.repository) : super(SearchState.initial()) {
    on<SearchRequested>(_onSearchRequested);
    on<GlobalSearchRequested>(_onGlobalSearchRequested);
    on<RecentSearchRequested>(_onLoadRecentSearchrs);
    on<RecentViewsRequested>(_onLoadRecentViews);
    on<UpdateSearchParams>((event, emit) {
      emit(
        state.copyWith(
          city: event.city ?? state.city,
          checkInDate: event.checkInDate ?? state.checkInDate,
          checkOutDate: event.checkOutDate ?? state.checkOutDate,
          guestCount: event.guestCount ?? state.guestCount,
        ),
      );
    });
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
    }

    try {
      final response = await repository.searchHotels(
        page: event.page,
        limit: event.limit,
        location: event.location?.toLowerCase(),
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

      emit(state.copyWith(searchLoading: false, searchResponse: response));
    } on ApiException catch (e) {
      emit(state.copyWith(searchLoading: false, searchError: e.message));
    } catch (_) {
      emit(
        state.copyWith(
          searchLoading: false,
          searchError: "Something went wrong",
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

      emit(state.copyWith(globalLoading: true, globalError: null));
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

      emit(state.copyWith(globalLoading: false, globalResponse: response));
    } on ApiException catch (e) {
      emit(state.copyWith(globalLoading: false, globalError: e.message));
    } catch (e, s) {
      print(e);
      print(s);
      emit(
        state.copyWith(
          globalLoading: false,
          globalError: "Something went wrong",
        ),
      );
    } finally {
      globalIsFetching = false;
    }
  }

  Future<void> _onLoadRecentSearchrs(
    RecentSearchRequested event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(recentLoading: true, recentError: null));

    try {
      final response = await repository.loadRecentSerches();

      if (response.success == true && response.statuscode == 200) {
        emit(state.copyWith(recentLoading: false, recentSearch: response.data));
      } else {
        emit(
          state.copyWith(
            recentLoading: false,
            recentError: response.message ?? "Failed to load searches",
          ),
        );
      }
    } catch (_) {
      emit(
        state.copyWith(
          recentLoading: false,
          recentError: "Something went wrong",
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

      if (response.success == true && response.statuscode == 200) {
        print(" ${response.accommodationdata!.length}");
        emit(
          state.copyWith(
            viewedLoading: false,
            recentlyViewed: response.accommodationdata,
          ),
        );
      } else {
        emit(
          state.copyWith(
            viewedLoading: false,
            viewedError: response.message ?? "Failed to load searches",
          ),
        );
      }
    } catch (_) {
      emit(
        state.copyWith(
          viewedLoading: false,
          viewedError: "Something went wrong",
        ),
      );
    }
  }
}
