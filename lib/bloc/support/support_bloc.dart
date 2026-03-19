// lib/bloc/support/support_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:indhostels/data/repo/reviews_support_repo.dart';

part 'support_event.dart';
part 'support_state.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  final ReviewRepository repository;

  SupportBloc(this.repository) : super(const SupportState()) {
    // ── Existing Handlers ──────────────────────────────────────────────────
    on<SupportCategoryChanged>(_onCategoryChanged);
    on<SupportAttachmentPicked>(_onAttachmentPicked);
    on<SupportAttachmentCleared>(_onAttachmentCleared);
    on<SupportSubmitRequested>(_onSubmitRequested);
    on<SupportResetRequested>(_onResetRequested);

    // ── New Ticket Handlers ────────────────────────────────────────────────
    on<FetchTicketsRequested>(_onFetchTickets);
    on<TicketCategoryTabChanged>(_onTicketCategoryTabChanged);
  }

  // ── Existing Handlers ──────────────────────────────────────────────────────

  void _onCategoryChanged(
    SupportCategoryChanged event,
    Emitter<SupportState> emit,
  ) {
    emit(state.copyWith(selectedCategory: event.category, error: null));
  }

  void _onAttachmentPicked(
    SupportAttachmentPicked event,
    Emitter<SupportState> emit,
  ) {
    emit(state.copyWith(
      attachmentPath: event.path,
      attachmentName: event.name,
      error: null,
    ));
  }

  void _onAttachmentCleared(
    SupportAttachmentCleared event,
    Emitter<SupportState> emit,
  ) {
    emit(SupportState(
      isSubmitting: state.isSubmitting,
      isSuccess: state.isSuccess,
      selectedCategory: state.selectedCategory,
      error: null,
      attachmentPath: null,
      attachmentName: null,
      tickets: state.tickets,
      isLoadingTickets: state.isLoadingTickets,
      activeTicketTab: state.activeTicketTab,
    ));
  }

  void _onResetRequested(
    SupportResetRequested event,
    Emitter<SupportState> emit,
  ) {
    emit(const SupportState());
  }

  Future<void> _onSubmitRequested(
    SupportSubmitRequested event,
    Emitter<SupportState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, error: null, isSuccess: false));

    try {
      final response = await repository.createTicket(
        category: state.selectedCategory,
        bookingId: event.bookingId,
        subject: event.subject,
        message: event.message,
        attachmentPath: state.attachmentPath,
      );

      if (response.success && response.statusCode == 200) {
        emit(state.copyWith(isSubmitting: false, isSuccess: true, error: null));
      } else {
        emit(state.copyWith(
          isSubmitting: false,
          isSuccess: false,
          error: response.message.isNotEmpty
              ? response.message
              : 'Failed to submit ticket',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        error: e.toString(),
      ));
    }
  }

  // ── New Ticket Handlers ────────────────────────────────────────────────────

  Future<void> _onFetchTickets(
    FetchTicketsRequested event,
    Emitter<SupportState> emit,
  ) async {
    emit(state.copyWith(
      isLoadingTickets: true,
      clearTicketsError: true,
    ));

    try {
      // repository.getTickets() should return a list of SupportTicket
      final tickets = await repository.getTickets();
      emit(state.copyWith(
        isLoadingTickets: false,
        tickets: tickets,
        clearTicketsError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingTickets: false,
        ticketsError: e.toString(),
      ));
    }
  }

  void _onTicketCategoryTabChanged(
    TicketCategoryTabChanged event,
    Emitter<SupportState> emit,
  ) {
    emit(state.copyWith(activeTicketTab: event.category));
  }
}