part of 'bookings_bloc.dart';

class BookingsState extends Equatable {
  final bool bookingsLoading;
  final bool bookingsHistoryLoading;
  final bool bookingsMoreLoading;
  final bool hasReachedMax;
  final String? bookingsError;
  final String? bookingsHistoryError;
  final String? bookingsDetailsError;
  final bool bookingsDetailsLoading;
  final BookingDetail? bookingDetail;
  final List<BookingModel> bookings;
  final List<BookingModel> bookingshistory;
  final bool bookingshistoryMoreLoading;
  final bool historyhasReachedMax;
  final bool invoiceLoading;
  final bool invoiceSuccess;
  final String? invoiceError;
  final List<int>? invoiceBytes;

  final int totalPages;
  final int currentPage;
  final int totalOrders;
  final int historytotalPages;
  final int historycurrentPage;
  final int historytotalOrders;

  const BookingsState({
    this.bookingsLoading = false,
    this.bookingsHistoryLoading = false,
    this.bookingsMoreLoading = false,
    this.hasReachedMax = false,
    this.bookingshistoryMoreLoading = false,
    this.historyhasReachedMax = false,
    this.bookingsError,
    this.bookingsHistoryError,
    this.bookings = const [],
    this.bookingshistory = const [],
    this.totalPages = 1,
    this.currentPage = 1,
    this.totalOrders = 0,
    this.historytotalPages = 1,
    this.historycurrentPage = 1,
    this.historytotalOrders = 0,
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
    bool? bookingsHistoryLoading,
    bool? bookingsMoreLoading,
    bool? hasReachedMax,
    bool? bookingshistoryMoreLoading,
    bool? historyhasReachedMax,
    String? bookingsError,
    String? bookingsHistoryError,
    List<BookingModel>? bookings,
    List<BookingModel>? bookingshistory,
    int? totalPages,
    int? currentPage,
    int? totalOrders,
    int? historytotalPages,
    int? historycurrentPage,
    int? historytotalOrders,

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
      bookingsHistoryLoading:
          bookingsHistoryLoading ?? this.bookingsHistoryLoading,
      bookingsMoreLoading: bookingsMoreLoading ?? this.bookingsMoreLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      bookingshistoryMoreLoading:
          bookingshistoryMoreLoading ?? this.bookingshistoryMoreLoading,
      historyhasReachedMax: historyhasReachedMax ?? this.historyhasReachedMax,
      bookingsError: bookingsError,
      bookingsHistoryError: bookingsHistoryError,
      bookings: bookings ?? this.bookings,
      bookingshistory: bookingshistory ?? this.bookingshistory,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      totalOrders: totalOrders ?? this.totalOrders,
      historytotalPages: historytotalPages ?? this.historytotalPages,
      historycurrentPage: historycurrentPage ?? this.historycurrentPage,
      historytotalOrders: historytotalOrders ?? this.historytotalOrders,
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
    bookingsHistoryLoading,
    bookingsMoreLoading,
    hasReachedMax,
    bookingshistoryMoreLoading,
    historyhasReachedMax,
    bookingsError,
    bookingsHistoryError,
    bookings,
    bookingshistory,
    totalPages,
    currentPage,
    totalOrders,
    historytotalPages,
    historycurrentPage,
    historytotalOrders,
    bookingsDetailsLoading,
    bookingsDetailsError,
    bookingDetail,
    invoiceLoading,
    invoiceSuccess,
    invoiceError,
    invoiceBytes,
  ];
}
