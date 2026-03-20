part of 'support_bloc.dart';

class SupportState extends Equatable {
  // ── Support ticket form ───────────────────────────────────────────────────
  final bool isSubmitting;
  final String? error;
  final bool isSuccess;
  final String selectedCategory;
  final String? attachmentPath;
  final String? attachmentName;

  final List<SupportTicket> tickets;
  final bool isLoadingTickets;
  final String? ticketsError;
  final String activeTicketTab;

  // ── Reply ─────────────────────────────────────────────────────────────────
  final bool isReplying;
  final String? replyError;

  // ── Contact Us form ───────────────────────────────────────────────────────
  final bool contactUsSubmitting;
  final bool contactUsSuccess;
  final String? contactUsError;

  const SupportState({
    this.isSubmitting = false,
    this.error,
    this.isSuccess = false,
    this.selectedCategory = 'Booking Issue',
    this.attachmentPath,
    this.attachmentName,
    this.tickets = const [],
    this.isLoadingTickets = false,
    this.ticketsError,
    this.activeTicketTab = 'All',
    this.isReplying = false,
    this.replyError,
    this.contactUsSubmitting = false,
    this.contactUsSuccess = false,
    this.contactUsError,
  });

  List<String> get ticketCategories {
    final cats = tickets.map((t) => t.category).toSet().toList()..sort();
    return ['All', ...cats];
  }

  List<SupportTicket> get filteredTickets {
    if (activeTicketTab == 'All') return tickets;
    return tickets.where((t) => t.category == activeTicketTab).toList();
  }

  SupportState copyWith({
    bool? isSubmitting,
    String? error,
    bool? isSuccess,
    String? selectedCategory,
    String? attachmentPath,
    String? attachmentName,
    List<SupportTicket>? tickets,
    bool? isLoadingTickets,
    String? ticketsError,
    String? activeTicketTab,
    bool clearTicketsError = false,
    bool? isReplying,
    String? replyError,
    bool clearReplyError = false,
    bool? contactUsSubmitting,
    bool? contactUsSuccess,
    String? contactUsError,
    bool clearContactUsError = false,
  }) {
    return SupportState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      attachmentPath: attachmentPath ?? this.attachmentPath,
      attachmentName: attachmentName ?? this.attachmentName,
      tickets: tickets ?? this.tickets,
      isLoadingTickets: isLoadingTickets ?? this.isLoadingTickets,
      ticketsError:
          clearTicketsError ? null : (ticketsError ?? this.ticketsError),
      activeTicketTab: activeTicketTab ?? this.activeTicketTab,
      isReplying: isReplying ?? this.isReplying,
      replyError: clearReplyError ? null : (replyError ?? this.replyError),
      contactUsSubmitting: contactUsSubmitting ?? this.contactUsSubmitting,
      contactUsSuccess: contactUsSuccess ?? this.contactUsSuccess,
      contactUsError:
          clearContactUsError ? null : (contactUsError ?? this.contactUsError),
    );
  }

  @override
  List<Object?> get props => [
        isSubmitting,
        error,
        isSuccess,
        selectedCategory,
        attachmentPath,
        attachmentName,
        tickets,
        isLoadingTickets,
        ticketsError,
        activeTicketTab,
        isReplying,
        replyError,
        contactUsSubmitting,
        contactUsSuccess,
        contactUsError,
      ];
}