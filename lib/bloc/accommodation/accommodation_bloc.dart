import 'package:bloc/bloc.dart';
import 'package:indhostels/bloc/accommodation/accommodation_event.dart';
import 'package:indhostels/bloc/accommodation/accommodation_state.dart';
import 'package:indhostels/data/repo/accomodation_repo.dart';
import 'package:indhostels/exceptions/api_exceptions.dart';

class AccommodationBloc extends Bloc<AccommodationEvent, AccommodationState> {
  final AccommodationRepository repository;

  AccommodationBloc(this.repository) : super(AccommodationInitial()) {
    on<TopHStlRequested>(_onTopHStlRequested);
    on<BudgetHStlRequested>(_onBudgetHStlRequested);
  }

  Future<void> _onTopHStlRequested(
    TopHStlRequested event,
    Emitter<AccommodationState> emit,
  ) async {
    emit(TopHStlLoading());

    try {
      final response = await repository.getTophstl();

      if (response.statuscode == 200) {
        final list = response.data ?? [];

        emit(TopHStlSuccess(list));
      } else {
        emit(TopHStlError("Failed to fetch data"));
      }
    } on ApiException catch (e) {
      emit(TopHStlError(e.message));
    } catch (e) {
      emit(TopHStlError("Something went wrong"));
    } finally {
      this.add(BudgetHStlRequested(limit: 10, page: 1, type: "budget"));
    }
  }

  Future<void> _onBudgetHStlRequested(
    BudgetHStlRequested event,
    Emitter<AccommodationState> emit,
  ) async {
    emit(BudgetHStlLoading());

    try {
      final response = await repository.getBudgetHstl(
        type: event.type,
        page: event.page,
        limit: event.limit,
      );

      if (response.statuscode == 200) {
        final list = response.data ?? [];

        emit(BudgetHStlSuccess(list));
      } else {
        emit(BudgetHStlError("Failed to fetch data"));
      }
    } on ApiException catch (e) {
      emit(BudgetHStlError(e.message));
    } catch (e) {
      emit(BudgetHStlError("Something went wrong"));
    }
  }
}
