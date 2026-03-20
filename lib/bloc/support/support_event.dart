part of 'support_bloc.dart';

abstract class SupportEvent extends Equatable {
  const SupportEvent();

  @override
  List<Object?> get props => [];
}

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

class FetchTicketsRequested extends SupportEvent {
  const FetchTicketsRequested();
}

class TicketCategoryTabChanged extends SupportEvent {
  final String category;
  const TicketCategoryTabChanged(this.category);

  @override
  List<Object?> get props => [category];
}

// ── Contact Us ────────────────────────────────────────────────────────────────

/// Submit the contact-us form
class ContactUsSubmitRequested extends SupportEvent {
  final String fullName;
  final String email;
  final String phone;
  final String subject;
  final String message;

  const ContactUsSubmitRequested({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.subject,
    required this.message,
  });

  @override
  List<Object?> get props => [fullName, email, phone, subject, message];
}

/// Reset contact-us form state (clears success / error)
class ContactUsResetRequested extends SupportEvent {
  const ContactUsResetRequested();
}
class TicketReplyRequested extends SupportEvent {
  final String ticketId;
  final String message;

  const TicketReplyRequested({
    required this.ticketId,
    required this.message,
  });

  @override
  List<Object?> get props => [ticketId, message];
}