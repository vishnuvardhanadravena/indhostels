part of 'review_bloc.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

class ReviewsRequested extends ReviewEvent {
  final String propertyId;
  final int page;
  final int limit;

  const ReviewsRequested({
    required this.propertyId,
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [propertyId, page, limit];
}

class ReviewsNextPageRequested extends ReviewEvent {
  final String propertyId;
  final int page;
  final int limit;

  const ReviewsNextPageRequested({
    required this.propertyId,
    required this.page,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [propertyId, page, limit];
}