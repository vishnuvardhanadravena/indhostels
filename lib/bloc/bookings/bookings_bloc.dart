import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:indhostels/data/models/bookings/booking_details_res.dart';
import 'package:indhostels/data/models/bookings/booking_res.dart';
import 'package:indhostels/data/repo/bookings_repo.dart';
import 'package:indhostels/exceptions/api_exceptions.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

part 'bookings_event.dart';
part 'bookings_state.dart';

class BookingsBloc extends Bloc<BookingsEvent, BookingsState> {
  final BookingsRepository repository;

  BookingsBloc(this.repository) : super(const BookingsState()) {
    on<FetchBookings>(_fetchBookings);
    on<FetchBookingsHistory>(_fetchBookingsHistory);
    on<FetchBookingDetailes>(_fetchBookingDetails);
    on<InvoiceDownloadRequested>(_onInvoiceDownloadRequested);
    on<InvoiceReset>((event, emit) {
      emit(
        state.copyWith(
          invoiceSuccess: false,
          invoiceError: null,
          invoiceBytes: null,
        ),
      );
    });
  }
  Future<void> _fetchBookings(
    FetchBookings event,
    Emitter<BookingsState> emit,
  ) async {
    if (state.hasReachedMax && event.page != 1) return;

    if (event.page == 1) {
      emit(state.copyWith(bookingsLoading: true, bookingsError: null));
    } else {
      emit(state.copyWith(bookingsMoreLoading: true));
    }

    try {
      final response = await repository.getBookings(
        page: event.page,
        limit: event.limit,
      );

      final bookings = response.data;

      emit(
        state.copyWith(
          bookingsLoading: false,
          bookingsMoreLoading: false,
          bookings: event.page == 1
              ? bookings
              : [...state.bookings, ...bookings],
          currentPage: event.page,
          totalPages: response.totalPages,
          totalOrders: response.totalOrders,
          hasReachedMax: event.page >= response.totalPages,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          bookingsLoading: false,
          bookingsMoreLoading: false,
          bookingsError: e.toString(),
        ),
      );
    }
  }

  Future<void> _fetchBookingsHistory(
    FetchBookingsHistory event,
    Emitter<BookingsState> emit,
  ) async {
    if (state.historyhasReachedMax && event.page != 1) return;

    if (event.page == 1) {
      emit(
        state.copyWith(
          bookingsHistoryLoading: true,
          bookingsHistoryError: null,
        ),
      );
    } else {
      emit(state.copyWith(bookingshistoryMoreLoading: true));
    }

    try {
      final response = await repository.getBookingsHistory(
        page: event.page,
        limit: event.limit,
      );

      final bookings = response.data;

      emit(
        state.copyWith(
          bookingsHistoryLoading: false,
          bookingshistoryMoreLoading: false,
          bookingshistory: event.page == 1
              ? bookings
              : [...state.bookingshistory, ...bookings],
          historycurrentPage: event.page,
          historytotalPages: response.totalPages,
          historytotalOrders: response.totalOrders,
          historyhasReachedMax: event.page >= response.totalPages,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          bookingsHistoryLoading: false,
          bookingshistoryMoreLoading: false,
          bookingsHistoryError: e.toString(),
        ),
      );
    }
  }

  Future<void> _fetchBookingDetails(
    FetchBookingDetailes event,
    Emitter<BookingsState> emit,
  ) async {
    emit(
      state.copyWith(bookingsDetailsLoading: true, bookingsDetailsError: null),
    );

    try {
      final response = await repository.getBookingDetalies(id: event.id);

      emit(
        state.copyWith(
          bookingsDetailsLoading: false,
          bookingDetail: response.data,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          bookingsDetailsLoading: false,
          bookingsDetailsError: e.toString(),
        ),
      );
    }
  }

  Future<void> _onInvoiceDownloadRequested(
    InvoiceDownloadRequested event,
    Emitter<BookingsState> emit,
  ) async {
    emit(
      state.copyWith(
        invoiceLoading: true,
        invoiceSuccess: false,
        invoiceError: null,
      ),
    );

    try {
      final bytes = await repository.downloadInvoice(id: event.bookingId);

      emit(
        state.copyWith(
          invoiceLoading: false,
          invoiceSuccess: true,
          invoiceBytes: bytes,
        ),
      );
    } on ApiException catch (e) {
      emit(state.copyWith(invoiceLoading: false, invoiceError: e.message));
    } catch (_) {
      emit(
        state.copyWith(
          invoiceLoading: false,
          invoiceError: "Failed to download invoice",
        ),
      );
    }
  }
}

Future<void> saveToDownloads(List<int> bytes) async {
  if (Platform.isAndroid) {
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      throw Exception("Storage permission denied");
    }
  }

  Directory? dir;

  if (Platform.isAndroid) {
    dir = Directory('/storage/emulated/0/Download');
  } else {
    dir = await getApplicationDocumentsDirectory();
  }

  final file = File(
    '${dir.path}/invoice_${DateTime.now().millisecondsSinceEpoch}.pdf',
  );

  await file.writeAsBytes(bytes);

  await OpenFile.open(file.path);
}
