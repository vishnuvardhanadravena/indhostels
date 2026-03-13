part of 'accommodation_bloc.dart';

abstract class AccommodationEvent extends Equatable {
  const AccommodationEvent();

  @override
  List<Object?> get props => [];
}

class TopHStlRequested extends AccommodationEvent {
  const TopHStlRequested();
}

class BudgetHStlRequested extends AccommodationEvent {
  final String type;
  final int page;
  final int limit;

  const BudgetHStlRequested({
    required this.type,
    required this.page,
    required this.limit,
  });

  @override
  List<Object?> get props => [type, page, limit];
}

class AcommodationDetailesRequested extends AccommodationEvent {
  final String id;
  const AcommodationDetailesRequested({required this.id});
  @override
  List<Object?> get props => [id];
}

class LikedAcommodationRequested extends AccommodationEvent {
  final String type;
  const LikedAcommodationRequested({required this.type});
  @override
  List<Object?> get props => [type];
}
