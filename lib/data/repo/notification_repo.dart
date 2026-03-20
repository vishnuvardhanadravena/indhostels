import 'package:indhostels/data/models/notification/notification_res.dart';
import 'package:indhostels/services/apiservice/api_client.dart';
import 'package:indhostels/utils/constants/api_constants.dart';

class NotificationRepository {
  final ApiClient api;
  NotificationRepository(this.api);

  Future<NotificationResponse> getNotifications() async {
    final response = await api.get(ApiConstants.getNotifications);
    return NotificationResponse.fromJson(response.data);
  }
   Future<NotificationDetailResponse> getNotificationById(String id) async {
    final response = await api.get(
      ApiConstants.getNotificationById(id),
    );

    return NotificationDetailResponse.fromJson(response.data);
  }
}
