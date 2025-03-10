part of 'notification_settings_bloc.dart';

abstract class NotificationEvent {}

class RegisterFcmToken extends NotificationEvent {}

class ToggleNotificationChannel extends NotificationEvent {
  final String channelId;
  final bool isEnabled;

  ToggleNotificationChannel(this.channelId, this.isEnabled);
}

class FetchNotificationSettings extends NotificationEvent {}
