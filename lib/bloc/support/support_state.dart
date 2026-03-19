// lib/bloc/support/support_state.dart
part of 'support_bloc.dart';

class SupportState extends Equatable {
  // ── Existing Fields ────────────────────────────────────────────────────────
  final bool isSubmitting;
  final String? error;
  final bool isSuccess;
  final String selectedCategory;
  final String? attachmentPath;
  final String? attachmentName;

  // ── New Ticket Viewing Fields ──────────────────────────────────────────────
  final List<SupportTicket> tickets;
  final bool isLoadingTickets;
  final String? ticketsError;
  final String activeTicketTab; // currently selected category tab

  const SupportState({
    this.isSubmitting = false,
    this.error,
    this.isSuccess = false,
    this.selectedCategory = 'Booking Issue',
    this.attachmentPath,
    this.attachmentName,
    // new
    this.tickets = const [],
    this.isLoadingTickets = false,
    this.ticketsError,
    this.activeTicketTab = 'All',
  });

  /// Returns distinct categories extracted from loaded tickets.
  List<String> get ticketCategories {
    final cats = tickets.map((t) => t.category).toSet().toList()..sort();
    return ['All', ...cats];
  }

  /// Tickets filtered by [activeTicketTab].
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
    // new
    List<SupportTicket>? tickets,
    bool? isLoadingTickets,
    String? ticketsError,
    String? activeTicketTab,
    bool clearTicketsError = false,
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
      ticketsError: clearTicketsError ? null : (ticketsError ?? this.ticketsError),
      activeTicketTab: activeTicketTab ?? this.activeTicketTab,
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
      ];
}