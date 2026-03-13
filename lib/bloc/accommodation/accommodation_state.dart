part of 'accommodation_bloc.dart';

class AccommodationState extends Equatable {
  final bool topHostelLoading;
  final bool budgetHostelLoading;
  final bool acommodationdetailesLoading;
  final bool lIkedAcommodationsLoading;

  final String? topHostelError;
  final String? budgetHostelError;
  final String? acommodationdetailesError;
  final String? lIkedAcommodationsError;

  final List<TopHstlData>? topHostels;
  final List<PopularHstlData>? budgetHostels;
  final Acommodation? acommodationdetailes;
  final List<LIkedAcommodations>? lIkedAcommodations;

  const AccommodationState({
    this.topHostelLoading = false,
    this.budgetHostelLoading = false,
    this.acommodationdetailesLoading = false,
    this.topHostelError,
    this.budgetHostelError,
    this.acommodationdetailesError,
    this.topHostels,
    this.budgetHostels,
    this.acommodationdetailes,
    this.lIkedAcommodations,
    this.lIkedAcommodationsError,
    this.lIkedAcommodationsLoading = false,
  });

  AccommodationState copyWith({
    bool? topHostelLoading,
    bool? budgetHostelLoading,
    bool? acommodationdetailesLoading,
    String? topHostelError,
    String? budgetHostelError,
    String? acommodationdetailesError,
    List<TopHstlData>? topHostels,
    List<PopularHstlData>? budgetHostels,
    Acommodation? acommodationdetailes,
    bool? lIkedAcommodationsLoading,
    String? lIkedAcommodationsError,
    List<LIkedAcommodations>? lIkedAcommodations,
  }) {
    return AccommodationState(
      topHostelLoading: topHostelLoading ?? this.topHostelLoading,
      budgetHostelLoading: budgetHostelLoading ?? this.budgetHostelLoading,
      acommodationdetailesLoading:
          acommodationdetailesLoading ?? this.acommodationdetailesLoading,
      topHostelError: topHostelError,
      budgetHostelError: budgetHostelError,
      acommodationdetailesError: acommodationdetailesError,
      topHostels: topHostels ?? this.topHostels,
      budgetHostels: budgetHostels ?? this.budgetHostels,
      acommodationdetailes: acommodationdetailes ?? this.acommodationdetailes,
      lIkedAcommodations: lIkedAcommodations ?? this.lIkedAcommodations,
      lIkedAcommodationsError:
          lIkedAcommodationsError ?? this.lIkedAcommodationsError,
      lIkedAcommodationsLoading:
          lIkedAcommodationsLoading ?? this.lIkedAcommodationsLoading,
    );
  }

  @override
  List<Object?> get props => [
    topHostelLoading,
    budgetHostelLoading,
    acommodationdetailesLoading,
    topHostelError,
    budgetHostelError,
    acommodationdetailesError,
    topHostels,
    budgetHostels,
    acommodationdetailes,
    lIkedAcommodations,
    lIkedAcommodationsError,
    lIkedAcommodationsLoading,
  ];
}
