import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:indhostels/data/models/notification/notification_res.dart';
import 'package:indhostels/data/repo/notification_repo.dart';



part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;

  NotificationBloc(this.repository) : super(const NotificationState()) {
    on<NotificationsFetchRequested>(_onFetchRequested);
    on<NotificationDetailRequested>(_onDetailRequested);
  }
Future<void> _onDetailRequested(
  NotificationDetailRequested event,
  Emitter<NotificationState> emit,
) async {
  emit(state.copyWith(detailLoading: true, clearError: true));

  try {
    final res = await repository.getNotificationById(event.id);

    emit(
      state.copyWith(
        detailLoading: false,
        selectedNotification: res.data,
      ),
    );
  } catch (e) {
    emit(
      state.copyWith(
        detailLoading: false,
        detailError: e.toString(),
      ),
    );
  }
}

  Future<void> _onFetchRequested(
    NotificationsFetchRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final response = await repository.getNotifications();

      if (response.success && response.statusCode == 200) {
        final grouped = _groupByDate(response.data);
        emit(
          state.copyWith(
            isLoading: false,
            notifications: response.data,
            grouped: grouped,
            notificationsCount: response.notificationsCount,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            error: response.message.isNotEmpty
                ? response.message
                : 'Failed to fetch notifications',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString(),
        ),
      );
    }
  }


  Map<String, List<NotificationModel>> _groupByDate(
    List<NotificationModel> notifications,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final Map<String, List<NotificationModel>> result = {};

    for (final n in notifications) {
      final d = DateTime(
        n.createdAt.year,
        n.createdAt.month,
        n.createdAt.day,
      );

      final String label;
      if (d == today) {
        label = 'Today (${_fmtLabel(today)})';
      } else if (d == yesterday) {
        label = 'Yesterday (${_fmtLabel(yesterday)})';
      } else {
        label = _fmtLabel(d);
      }

      result.putIfAbsent(label, () => []).add(n);
    }

    return result;
  }

  String _fmtLabel(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.year.toString().substring(2)}';
}