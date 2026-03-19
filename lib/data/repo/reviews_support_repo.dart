import 'package:dio/dio.dart';
import 'package:indhostels/data/models/ReviewsAndSupport/reviews_res.dart';
import 'package:indhostels/data/models/ReviewsAndSupport/support_res.dart';
import 'package:indhostels/services/apiservice/api_client.dart';
import 'package:indhostels/utils/constants/api_constants.dart';

class ReviewRepository {
  final ApiClient api;

  ReviewRepository(this.api);

  Future<ReviewsRes> getReviews({
    required String propertyId,
    required int page,
    required int limit,
  }) async {
    final response = await api.get(
      ApiConstants.reviews(propertyId),
      query: {"page": page, "limit": limit},
    );

    return ReviewsRes.fromJson(response.data);
  }

  Future<Map<String, dynamic>> createReview({
    required String propertyId,
    required int rating,
    required String aboutStay,
    required bool verifiedStay,
    required String stayDate,
    required String roomType,
  }) async {
    final response = await api.post(
      ApiConstants.createReview(propertyId),
      data: {
        "rating": rating,
        "aboutstay": aboutStay,
        "verifiedstay": verifiedStay,
        "staydate": stayDate,
        "roomtype": roomType,
      },
    );

    return response.data;
  }

  Future<SupportResponse> createTicket({
    required String category,
    required String bookingId,
    required String subject,
    required String message,
    String? attachmentPath,
  }) async {
    final formData = FormData.fromMap({
      'category': category,
      'bookingid': bookingId,
      'subject': subject,
      'message': message,
      if (attachmentPath != null)
        'attachment': await MultipartFile.fromFile(attachmentPath),
    });

    final response = await api.post(ApiConstants.createissue(), data: formData);
    return SupportResponse.fromJson(response.data);
  }

  Future<List<SupportTicket>> getTickets() async {
    final response = await api.get(ApiConstants.getticketmessges());
    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> list = data['data'] as List<dynamic>? ?? [];
      return list
          .map((e) => SupportTicket.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception(
      (response.data as Map?)?['message'] ?? 'Failed to fetch tickets',
    );
  }
}

class TicketMessage {
  final String sender;
  final String message;

  const TicketMessage({required this.sender, required this.message});

  factory TicketMessage.fromJson(Map<String, dynamic> json) {
    return TicketMessage(
      sender: json['sender'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );
  }
}

class SupportTicket {
  final String id;
  final String category;
  final String subject;
  final String status;
  final DateTime createdAt;
  final List<TicketMessage> messages;

  const SupportTicket({
    required this.id,
    required this.category,
    required this.subject,
    required this.status,
    required this.createdAt,
    required this.messages,
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket(
      id: json['_id'] as String? ?? '',
      category: json['category'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      status: json['status'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      messages: (json['messages'] as List<dynamic>? ?? [])
          .map((m) => TicketMessage.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }

  String get lastMessage =>
      messages.isNotEmpty ? messages.last.message : 'No messages';

  bool get isResolved => status == 'Resolved';
}
