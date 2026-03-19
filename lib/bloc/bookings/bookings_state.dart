part of 'bookings_bloc.dart';

class BookingsState extends Equatable {
  final bool bookingsLoading;
  final bool bookingsMoreLoading;
  final bool hasReachedMax;
  final String? bookingsError;
  final String? bookingsDetailsError;
  final bool bookingsDetailsLoading;
  final BookingDetail? bookingDetail;
  final List<BookingModel> bookings;
  final bool invoiceLoading;
final bool invoiceSuccess;
final String? invoiceError;
final List<int>? invoiceBytes;

  final int totalPages;
  final int currentPage;
  final int totalOrders;

  const BookingsState({
    this.bookingsLoading = false,
    this.bookingsMoreLoading = false,
    this.hasReachedMax = false,
    this.bookingsError,
    this.bookings = const [],
    this.totalPages = 1,
    this.currentPage = 1,
    this.totalOrders = 0,
    this.bookingsDetailsLoading = false,
    this.bookingsDetailsError,
    this.bookingDetail,
    this.invoiceLoading = false,
this.invoiceSuccess = false,
this.invoiceError,
this.invoiceBytes,
  });

  BookingsState copyWith({
    bool? bookingsLoading,
    bool? bookingsMoreLoading,
    bool? hasReachedMax,
    String? bookingsError,
    List<BookingModel>? bookings,
    int? totalPages,
    int? currentPage,
    int? totalOrders,
    String? bookingsDetailsError,
    bool? bookingsDetailsLoading,
    BookingDetail? bookingDetail,
    bool? invoiceLoading,
bool? invoiceSuccess,
String? invoiceError,
List<int>? invoiceBytes,
  }) {
    return BookingsState(
      bookingsLoading: bookingsLoading ?? this.bookingsLoading,
      bookingsMoreLoading: bookingsMoreLoading ?? this.bookingsMoreLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      bookingsError: bookingsError,
      bookings: bookings ?? this.bookings,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      totalOrders: totalOrders ?? this.totalOrders,
      bookingsDetailsError: bookingsDetailsError ?? this.bookingsDetailsError,
      bookingsDetailsLoading:
          bookingsDetailsLoading ?? this.bookingsDetailsLoading,
      bookingDetail: bookingDetail ?? this.bookingDetail,
      invoiceLoading: invoiceLoading ?? this.invoiceLoading,
invoiceSuccess: invoiceSuccess ?? this.invoiceSuccess,
invoiceError: invoiceError,
invoiceBytes: invoiceBytes ?? this.invoiceBytes,
    );
  }

  @override
  List<Object?> get props => [
    bookingsLoading,
    bookingsMoreLoading,
    hasReachedMax,
    bookingsError,
    bookings,
    totalPages,
    currentPage,
    totalOrders,
    bookingsDetailsLoading,
    bookingsDetailsError,
    bookingDetail,
    invoiceLoading,
invoiceSuccess,
invoiceError,
invoiceBytes,
  ];
}
