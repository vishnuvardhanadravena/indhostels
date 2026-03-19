// lib/bloc/support/support_event.dart
part of 'support_bloc.dart';

abstract class SupportEvent extends Equatable {
  const SupportEvent();

  @override
  List<Object?> get props => [];
}

// ── Existing Events ─────────────────────────────────────────────────────────

class SupportCategoryChanged extends SupportEvent {
  final String category;
  const SupportCategoryChanged(this.category);

  @override
  List<Object?> get props => [category];
}

class SupportAttachmentPicked extends SupportEvent {
  final String path;
  final String name;
  const SupportAttachmentPicked({required this.path, required this.name});

  @override
  List<Object?> get props => [path, name];
}

class SupportAttachmentCleared extends SupportEvent {
  const SupportAttachmentCleared();
}

class SupportSubmitRequested extends SupportEvent {
  final String bookingId;
  final String subject;
  final String message;

  const SupportSubmitRequested({
    required this.bookingId,
    required this.subject,
    required this.message,
  });

  @override
  List<Object?> get props => [bookingId, subject, message];
}

class SupportResetRequested extends SupportEvent {
  const SupportResetRequested();
}

// ── New Ticket Viewing Events ────────────────────────────────────────────────

/// Triggers fetching all tickets from the API.
class FetchTicketsRequested extends SupportEvent {
  const FetchTicketsRequested();
}

/// Switches the active category tab on the tickets screen.
class TicketCategoryTabChanged extends SupportEvent {
  final String category;
  const TicketCategoryTabChanged(this.category);

  @override
  List<Object?> get props => [category];
}