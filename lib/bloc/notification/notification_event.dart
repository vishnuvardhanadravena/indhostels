part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

/// Fetch (or refresh) all notifications
class NotificationsFetchRequested extends NotificationEvent {
  const NotificationsFetchRequested();
}
class NotificationDetailRequested extends NotificationEvent {
  final String id;

  const NotificationDetailRequested(this.id);

  @override
  List<Object?> get props => [id];
}