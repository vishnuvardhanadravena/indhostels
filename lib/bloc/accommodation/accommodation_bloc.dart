import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:indhostels/data/models/accomodation/accomodation_details_res.dart';
import 'package:indhostels/data/models/accomodation/popular_hstl_res.dart';
import 'package:indhostels/data/models/accomodation/top_hstl_res.dart';
import 'package:indhostels/data/models/accomodation/user_liked_acommodation_res.dart';
import 'package:indhostels/data/repo/accomodation_repo.dart';
import 'package:indhostels/exceptions/api_exceptions.dart';
part 'accommodation_event.dart';
part 'accommodation_state.dart';

class AccommodationBloc extends Bloc<AccommodationEvent, AccommodationState> {
  final AccommodationRepository repository;

  AccommodationBloc(this.repository) : super(const AccommodationState()) {
    on<TopHStlRequested>(_onTopHStlRequested);
    on<BudgetHStlRequested>(_onBudgetHStlRequested);
    on<AcommodationDetailesRequested>(_onAcommodationDetailesRequested);
    on<LikedAcommodationRequested>(_onUserLikedAcommodationRequested);
  }

  Future<void> _onTopHStlRequested(
    TopHStlRequested event,
    Emitter<AccommodationState> emit,
  ) async {
    emit(state.copyWith(topHostelLoading: true, topHostelError: null));

    try {
      final response = await repository.getTophstl();

      if (response.statuscode == 200) {
        emit(
          state.copyWith(
            topHostelLoading: false,
            topHostels: response.data ?? [],
          ),
        );
      } else {
        emit(
          state.copyWith(
            topHostelLoading: false,
            topHostelError: "Failed to fetch data",
          ),
        );
      }
    } on ApiException catch (e) {
      emit(state.copyWith(topHostelLoading: false, topHostelError: e.message));
    } catch (_) {
      emit(
        state.copyWith(
          topHostelLoading: false,
          topHostelError: "Something went wrong",
        ),
      );
    }
  }

  Future<void> _onBudgetHStlRequested(
    BudgetHStlRequested event,
    Emitter<AccommodationState> emit,
  ) async {
    emit(state.copyWith(budgetHostelLoading: true, budgetHostelError: null));

    try {
      final response = await repository.getBudgetHstl(
        type: event.type,
        page: event.page,
        limit: event.limit,
      );

      if (response.statuscode == 200) {
        emit(
          state.copyWith(
            budgetHostelLoading: false,
            budgetHostels: response.data ?? [],
          ),
        );
      } else {
        emit(
          state.copyWith(
            budgetHostelLoading: false,
            budgetHostelError: "Failed to fetch data",
          ),
        );
      }
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          budgetHostelLoading: false,
          budgetHostelError: e.message,
        ),
      );
    } catch (e,s) {
      print("Budget-->${e}");
      print("Budget-->${s}");
      emit(
        state.copyWith(
          budgetHostelLoading: false,
          budgetHostelError: "Something went wrong",
        ),
      );
    }
  }

  Future<void> _onAcommodationDetailesRequested(
    AcommodationDetailesRequested event,
    Emitter<AccommodationState> emit,
  ) async {
    emit(
      state.copyWith(
        acommodationdetailesLoading: true,
        acommodationdetailes: null,
        
      ),
    );

    try {
      final response = await repository.getAcommodationDetailesById(event.id);

      if (response.statuscode == 200) {
        emit(
          state.copyWith(
            acommodationdetailesLoading: false,
            acommodationdetailes: response.data,
          ),
        );
      } else {
        emit(
          state.copyWith(
            acommodationdetailesLoading: false,
            acommodationdetailesError: "Failed to fetch data",
          ),
        );
      }
    } on ApiException catch (e, s) {
      print(e);
      print(s);
      emit(
        state.copyWith(
          acommodationdetailesLoading: false,
          acommodationdetailesError: e.message,
        ),
      );
    } catch (e, s) {
      print(e);
      print(s);
      emit(
        state.copyWith(
          acommodationdetailesLoading: false,
          acommodationdetailesError: "Something went wrong",
        ),
      );
    }
  }

  Future<void> _onUserLikedAcommodationRequested(
    LikedAcommodationRequested event,
    Emitter<AccommodationState> emit,
  ) async {
    emit(
      state.copyWith(lIkedAcommodationsLoading: true, lIkedAcommodations: null),
    );

    try {
      final response = await repository.getUserlikedAcommodations(event.type);

      if (response.statuscode == 200) {
        emit(
          state.copyWith(
            lIkedAcommodationsLoading: false,
            lIkedAcommodations: response.data,
          ),
        );
      } else {
        emit(
          state.copyWith(
            lIkedAcommodationsLoading: false,
            lIkedAcommodationsError: "Failed to fetch data",
          ),
        );
      }
    } on ApiException catch (e, s) {
      print(e);
      print(s);
      emit(
        state.copyWith(
          lIkedAcommodationsLoading: false,
          lIkedAcommodationsError: e.message,
        ),
      );
    } catch (e, s) {
      print(e);
      print(s);
      emit(
        state.copyWith(
          lIkedAcommodationsLoading: false,
          lIkedAcommodationsError: "Something went wrong",
        ),
      );
    }
  }
}
