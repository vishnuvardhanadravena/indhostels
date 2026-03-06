abstract class AccommodationState {}

final class AccommodationInitial extends AccommodationState {}

final class TopHStlLoading extends AccommodationState {}

final class TopHStlSuccess extends AccommodationState {
  final List<dynamic> hostels;

  TopHStlSuccess(this.hostels);
}

final class TopHStlError extends AccommodationState {
  final String message;

  TopHStlError(this.message);
}
final class BudgetHStlLoading extends AccommodationState {}

final class BudgetHStlSuccess extends AccommodationState {
  final List<dynamic> hostels;

  BudgetHStlSuccess(this.hostels);
}

final class BudgetHStlError extends AccommodationState {
  final String message;

  BudgetHStlError(this.message);
}