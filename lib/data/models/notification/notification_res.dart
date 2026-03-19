class NotificationModel {
  final String id;
  final String notificationTitle;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NotificationModel({
    required this.id,
    required this.notificationTitle,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? '',
      notificationTitle: json['notificationtitle'] ?? '',
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  static DateTime _parseDate(String? raw) {
    if (raw == null) return DateTime.now();
    try {
      final parts = raw.split('/');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]),
          int.parse(parts[0]),
          int.parse(parts[1]),
        );
      }
    } catch (_) {}
    return DateTime.now();
  }
}

class NotificationResponse {
  final bool success;
  final int statusCode;
  final String message;
  final List<NotificationModel> data;
  final int notificationsCount;

  const NotificationResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.notificationsCount,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      success: json['success'] ?? false,
      statusCode: json['statuscode'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      notificationsCount: json['notificationscount'] ?? 0,
    );
  }
}
enum NotificationType {
  booking,
  offer,
  payment,
  cancellation,
  review,
  general,

}
NotificationType getNotificationType(String title) {
  final t = title.toLowerCase();

  if (t.contains('booking') || t.contains('confirmed')) {
    return NotificationType.booking;
  } else if (t.contains('discount') || t.contains('%') || t.contains('offer')) {
    return NotificationType.offer;
  } else if (t.contains('payment') || t.contains('paid')) {
    return NotificationType.payment;
  } else if (t.contains('cancel')) {
    return NotificationType.cancellation;
  } else if (t.contains('review') || t.contains('rating')) {
    return NotificationType.review;
  }

  return NotificationType.general;
}
class NotificationDetailResponse {
  final bool success;
  final int statusCode;
  final String message;
  final NotificationDetail data;
  final int notificationsCount;

  NotificationDetailResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.notificationsCount,
  });

  factory NotificationDetailResponse.fromJson(Map<String, dynamic> json) {
    return NotificationDetailResponse(
      success: json['success'] ?? false,
      statusCode: json['statuscode'] ?? 0,
      message: json['message'] ?? '',
      data: NotificationDetail.fromJson(json['data'] ?? {}),
      notificationsCount: json['notificationscount'] ?? 0,
    );
  }
}
class NotificationDetail {
  final String id;
  final String notificationtitle;
  final String notificationmessage;
  final String notificationtype;
  final String notificationstatus;
  final bool sendnow;
  final DateTime scheduletime;
  final String createdby;
  final String deliveryStatus;
  final List<NotificationDelivery> deliveredTo;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationDetail({
    required this.id,
    required this.notificationtitle,
    required this.notificationmessage,
    required this.notificationtype,
    required this.notificationstatus,
    required this.sendnow,
    required this.scheduletime,
    required this.createdby,
    required this.deliveryStatus,
    required this.deliveredTo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationDetail.fromJson(Map<String, dynamic> json) {
    return NotificationDetail(
      id: json['_id'] ?? '',
      notificationtitle: json['notificationtitle'] ?? '',
      notificationmessage: json['notificationmessage'] ?? '',
      notificationtype: json['notificationtype'] ?? '',
      notificationstatus: json['notificationstatus'] ?? '',
      sendnow: json['sendnow'] ?? false,
      scheduletime: DateTime.parse(json['scheduletime']),
      createdby: json['createdby'] ?? '',
      deliveryStatus: json['delivery_status'] ?? '',
      deliveredTo: (json['notification_deliverd_to'] as List<dynamic>?)
              ?.map((e) => NotificationDelivery.fromJson(e))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
class NotificationDelivery {
  final String userId;
  final bool read;
  final String id;

  NotificationDelivery({
    required this.userId,
    required this.read,
    required this.id,
  });

  factory NotificationDelivery.fromJson(Map<String, dynamic> json) {
    return NotificationDelivery(
      userId: json['userid'] ?? '',
      read: json['read'] ?? false,
      id: json['_id'] ?? '',
    );
  }
}