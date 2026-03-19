part of 'bookings_bloc.dart';

abstract class BookingsEvent extends Equatable {
  const BookingsEvent();

  @override
  List<Object?> get props => [];
}

class FetchBookings extends BookingsEvent {
  final int page;
  final int limit;

  const FetchBookings({this.page = 1, this.limit = 10});

  @override
  List<Object?> get props => [page, limit];
}

class FetchBookingDetailes extends BookingsEvent {
  final String id;

  const FetchBookingDetailes(this.id);

  @override
  List<Object?> get props => [id];
}
class InvoiceDownloadRequested extends BookingsEvent {
  final String bookingId;

  const InvoiceDownloadRequested({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];
}
class InvoiceReset extends BookingsEvent {
  const InvoiceReset();

  @override
  List<Object?> get props => [];
}