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
class ReviewCreateRequested extends ReviewEvent {
  final String propertyId;
  final int rating;
  final String aboutStay;
  final bool verifiedStay;
  final String stayDate;
  final String roomType;

  const ReviewCreateRequested({
    required this.propertyId,
    required this.rating,
    required this.aboutStay,
    required this.verifiedStay,
    required this.stayDate,
    required this.roomType,
  });

  @override
  List<Object?> get props =>
      [propertyId, rating, aboutStay, verifiedStay, stayDate, roomType];
}