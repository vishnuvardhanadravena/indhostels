abstract class AccommodationEvent {}

final class TopHStlRequested extends AccommodationEvent {
  TopHStlRequested();
}

final class BudgetHStlRequested extends AccommodationEvent {
  final String type;
  final int page;
  final int limit;
  BudgetHStlRequested({
    required this.type,
    required this.page,
    required this.limit,
  });
}
