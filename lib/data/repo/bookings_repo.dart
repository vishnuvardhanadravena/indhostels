import 'package:dio/dio.dart';
import 'package:indhostels/data/models/bookings/booking_details_res.dart';
import 'package:indhostels/data/models/bookings/booking_res.dart';
import 'package:indhostels/exceptions/api_exceptions.dart';
import 'package:indhostels/services/apiservice/api_client.dart';
import 'package:indhostels/utils/constants/api_constants.dart';

class BookingsRepository {
  final ApiClient api;
  BookingsRepository(this.api);
  Future<BookingsResponse> getBookings({
    required int page,
    required int limit,
  }) async {
    final response = await api.get(
      ApiConstants.myBookings,
      query: {"page": page, "limit": limit, "status": true},
    );

    return BookingsResponse.fromJson(response.data);
  }

  Future<BookingsResponse> getBookingsHistory({
    required int page,
    required int limit,
  }) async {
    final response = await api.get(
      ApiConstants.myBookings,
      query: {"page": page, "limit": limit},
    );

    return BookingsResponse.fromJson(response.data);
  }

  Future<BookingDetailResponse> getBookingDetalies({required String id}) async {
    final response = await api.get(ApiConstants.bookingDetails(id));

    return BookingDetailResponse.fromJson(response.data);
  }

  Future<Map<String, dynamic>> createBooking({
    required String propertyId,
    required String roomId,
    required Map<String, dynamic> body,
  }) async {
    final res = await api.post(
      ApiConstants.createBooking(propertyId, roomId),
      data: body,
    );

    final data = res.data;

    if (data["success"] != true) {
      throw Exception(data["message"]);
    }

    return data["order"];
  }

  Future<void> verifyPayment({required Map<String, dynamic> body}) async {
    final res = await api.post(ApiConstants.verifyPayment, data: body);

    if (res.data["success"] != true) {
      throw Exception(res.data["message"] ?? "Verification failed");
    }
  }

  Future<List<int>> downloadInvoice({required String id}) async {
    final res = await api.post(
      ApiConstants.downloadInvoice(id),
      options: Options(responseType: ResponseType.bytes),
    );
    return res.data;
  }

  Future<CancelBookingResponse> cancelBooking({required String id}) async {
    final res = await api.put(ApiConstants.cancelBooking(id));

    final data = res.data as Map<String, dynamic>;

    final response = CancelBookingResponse.fromJson(data);

    return response;
  }
}

class CancelBookingResponse {
  final bool success;
  final String message;

  CancelBookingResponse({required this.success, required this.message});

  factory CancelBookingResponse.fromJson(Map<String, dynamic> json) {
    return CancelBookingResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
    );
  }
}
