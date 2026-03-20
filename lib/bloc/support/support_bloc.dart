import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:indhostels/data/repo/reviews_support_repo.dart';

part 'support_event.dart';
part 'support_state.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  final ReviewRepository repository;

  SupportBloc(this.repository) : super(const SupportState()) {
    on<SupportCategoryChanged>(_onCategoryChanged);
    on<SupportAttachmentPicked>(_onAttachmentPicked);
    on<SupportAttachmentCleared>(_onAttachmentCleared);
    on<SupportSubmitRequested>(_onSubmitRequested);
    on<SupportResetRequested>(_onResetRequested);
    on<FetchTicketsRequested>(_onFetchTickets);
    on<TicketCategoryTabChanged>(_onTicketCategoryTabChanged);
    on<TicketReplyRequested>(_onTicketReply);

    on<ContactUsSubmitRequested>(_onContactUsSubmit);
    on<ContactUsResetRequested>(_onContactUsReset);
  }


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
      // preserve contact-us state
      contactUsSubmitting: state.contactUsSubmitting,
      contactUsSuccess: state.contactUsSuccess,
      contactUsError: state.contactUsError,
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

  Future<void> _onFetchTickets(
    FetchTicketsRequested event,
    Emitter<SupportState> emit,
  ) async {
    emit(state.copyWith(isLoadingTickets: true, clearTicketsError: true));

    try {
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


  Future<void> _onContactUsSubmit(
    ContactUsSubmitRequested event,
    Emitter<SupportState> emit,
  ) async {
    emit(state.copyWith(
      contactUsSubmitting: true,
      contactUsSuccess: false,
      clearContactUsError: true,
    ));

    try {
      final response = await repository.submitContactUs(
        fullName: event.fullName,
        email: event.email,
        phone: event.phone,
        subject: event.subject,
        message: event.message,
      );

      if (response['success'] == true) {
        emit(state.copyWith(
          contactUsSubmitting: false,
          contactUsSuccess: true,
          clearContactUsError: true,
        ));
      } else {
        emit(state.copyWith(
          contactUsSubmitting: false,
          contactUsSuccess: false,
          contactUsError:
              response['message'] ?? 'Failed to submit. Please try again.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        contactUsSubmitting: false,
        contactUsSuccess: false,
        contactUsError: e.toString(),
      ));
    }
  }

  void _onContactUsReset(
    ContactUsResetRequested event,
    Emitter<SupportState> emit,
  ) {
    emit(state.copyWith(
      contactUsSubmitting: false,
      contactUsSuccess: false,
      clearContactUsError: true,
    ));
  }
  // In constructor, register:


// Handler:
Future<void> _onTicketReply(
  TicketReplyRequested event,
  Emitter<SupportState> emit,
) async {
  emit(state.copyWith(isReplying: true, clearReplyError: true));

  try {
    final response = await repository.replyToTicket(
      ticketId: event.ticketId,
      message: event.message,
    );

    final replyData = response['data'] as Map<String, dynamic>;
    final newMsg = TicketMessage(
      sender: replyData['sender'] as String? ?? 'user',
      message: replyData['message'] as String? ?? event.message,
    );

    final updatedTickets = state.tickets.map((t) {
      if (t.id == event.ticketId) {
        return SupportTicket(
          id: t.id,
          category: t.category,
          subject: t.subject,
          status: t.status,
          createdAt: t.createdAt,
          messages: [...t.messages, newMsg],
        );
      }
      return t;
    }).toList();

    emit(state.copyWith(
      isReplying: false,
      tickets: updatedTickets,
      clearReplyError: true,
    ));
  } catch (e) {
    emit(state.copyWith(
      isReplying: false,
      replyError: e.toString(),
    ));
  }
}
}