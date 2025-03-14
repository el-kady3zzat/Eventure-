part of 'notifications_bloc.dart';

abstract class NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<EventureNotification> notifications;
  NotificationsLoaded(this.notifications);
}

class NotificationError extends NotificationsState {
  final String message;
  NotificationError(this.message);
}
