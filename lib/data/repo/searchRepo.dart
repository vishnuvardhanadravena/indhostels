import 'dart:async';
import 'dart:convert';
import 'package:indhostels/data/models/accomodation/search_res.dart';
import 'package:indhostels/data/models/search/globelsearch_res.dart';
import 'package:indhostels/data/models/search/loction_serach_res.dart';
import 'package:indhostels/data/models/search/recent_searchs_res.dart';
import 'package:indhostels/data/models/search/recent_views_res.dart';
import 'package:indhostels/services/apiservice/api_client.dart';
import 'package:indhostels/utils/constants/api_constants.dart';

class SearchRepository {
  final ApiClient api;

  SearchRepository(this.api);

  Timer? _debounce;

  Future<SerachByCatRes> searchHotels({
    int? page,
    int? limit,
    String? location,
    String? checkInDate,
    String? checkOutDate,
    String? category,
    List<String>? stayType,
    List<String>? roomType,
    List<String>? amenities,
    double? minPrice,
    double? maxPrice,
    double? rating,
  }) async {
    final Map<String, dynamic> query = {};

    if (page != null) query["page"] = page;
    if (limit != null) query["limit"] = limit;

    if (location != null && location.isNotEmpty) {
      query["location"] = location;
    }

    if (checkInDate != null) query["check_in_date"] = checkInDate;
    if (checkOutDate != null) query["check_out_date"] = checkOutDate;

    if (category != null) query["category"] = category;

    if (stayType != null && stayType.isNotEmpty) {
      query["staytype"] = jsonEncode(stayType);
    }

    if (roomType != null && roomType.isNotEmpty) {
      query["roomtype"] = jsonEncode(roomType);
    }

    if (amenities != null && amenities.isNotEmpty) {
      query["amenities"] = jsonEncode(amenities);
    }

    if (minPrice != null) query["minprice"] = minPrice;
    if (maxPrice != null) query["maxprice"] = maxPrice;
    if (rating != null) query["rating"] = rating;

    final response = await api.get(ApiConstants.searchHotels, query: query);

    return SerachByCatRes.fromJson(response.data);
  }

  Future<GlobalSearchResponse> globalSearch({
    required String text,
    required int page,
    required int limit,
  }) async {
    final query = {"search": text, "page": page, "limit": limit};

    final response = await api.get(ApiConstants.globalSearch, query: query);

    return GlobalSearchResponse.fromJson(response.data);
  }

  void debounceSearch({required Duration duration, required Function action}) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(duration, () {
      action();
    });
  }

  Future<RecentSearchesRes> loadRecentSerches() async {
  final response = await api.get(ApiConstants.recentSearches);

  return RecentSearchesRes.fromJson(response.data);
}
 Future<RecentViewsRes> loadRecentViews() async {
  final response = await api.get(ApiConstants.recentViews);

  return RecentViewsRes.fromJson(response.data);
}
 Future<LocationResponse> getLocations() async {
    final res = await api.get(ApiConstants.locations);

    final data = res.data;

    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to fetch locations');
    }

    return LocationResponse.fromJson(data);
  }
}
