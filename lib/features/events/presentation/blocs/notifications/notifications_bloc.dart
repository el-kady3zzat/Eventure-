import 'package:eventure/features/events/domain/usecases/notifications/get_notifications.dart';
import 'package:eventure/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventure/features/events/domain/entities/notification.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetNotificationsUseCase _notifications =
      getIt<GetNotificationsUseCase>();

  NotificationsBloc() : super(NotificationsLoading()) {
    on<FetchNotifications>((event, emit) async {
      emit(NotificationsLoading());
      final notifications = await _notifications.call();

      notifications.fold(
        (fialure) => emit(NotificationError(fialure.message)),
        (notifications) => emit(NotificationsLoaded(notifications)),
      );
    });
  }
}
