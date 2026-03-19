part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  final bool isLoading;
  final String? error;

  final List<NotificationModel> notifications;

  final Map<String, List<NotificationModel>> grouped;

  final int notificationsCount;
  final NotificationDetail? selectedNotification;
  final bool detailLoading;
  final String? detailError;

  const NotificationState({
    this.isLoading = false,
    this.error,
    this.notifications = const [],
    this.grouped = const {},
    this.notificationsCount = 0,
    this.selectedNotification,
    this.detailLoading = false,
    this.detailError,
  });

  NotificationState copyWith({
    bool? isLoading,
    String? error,
    List<NotificationModel>? notifications,
    Map<String, List<NotificationModel>>? grouped,
    int? notificationsCount,
    bool clearError = false,
    NotificationDetail? selectedNotification,
    bool? detailLoading,
    String? detailError,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      notifications: notifications ?? this.notifications,
      grouped: grouped ?? this.grouped,
      notificationsCount: notificationsCount ?? this.notificationsCount,
      selectedNotification: selectedNotification ?? this.selectedNotification,
      detailLoading: detailLoading ?? this.detailLoading,
      detailError: clearError ? null : (detailError ?? this.detailError),
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    error,
    notifications,
    grouped,
    notificationsCount,
    selectedNotification,
    detailLoading,
    detailError,
  ];
}
