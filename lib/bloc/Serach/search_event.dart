part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchRequested extends SearchEvent {
  final int page;
  final int limit;
  final String? location;

  final String? checkInDate;
  final String? checkOutDate;
  final String? category;
  final List<String>? stayType;
  final List<String>? roomType;
  final List<String>? amenities;
  final double? minPrice;
  final double? maxPrice;
  final double? rating;

  const SearchRequested({
    required this.page,
    required this.limit,
    this.location,
    this.checkInDate,
    this.checkOutDate,
    this.category,
    this.stayType,
    this.roomType,
    this.amenities,
    this.minPrice,
    this.maxPrice,
    this.rating,
  });

  @override
  List<Object?> get props => [
    page,
    limit,
    location,
    checkInDate,
    checkOutDate,
    category,
    stayType,
    roomType,
    amenities,
    minPrice,
    maxPrice,
    rating,
  ];
}

class GlobalSearchRequested extends SearchEvent {
  final String text;
  final int page;
  final int limit;

  const GlobalSearchRequested({
    required this.text,
    required this.page,
    required this.limit,
  });

  @override
  List<Object?> get props => [text, page, limit];
}

class RecentSearchRequested extends SearchEvent {}

class RecentViewsRequested extends SearchEvent {}
class UpdateSearchParams extends SearchEvent {

  final String? city;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final int? guestCount;

  const UpdateSearchParams({
    this.city,
    this.checkInDate,
    this.checkOutDate,
    this.guestCount,
  });
}