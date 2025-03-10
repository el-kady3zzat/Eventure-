part of 'notification_settings_bloc.dart';

abstract class NotificationState {}

final class NotificationInitial extends NotificationState {}

// State when FCM token is registered successfully
class NotificationTokenRegistered extends NotificationState {}

// State when toggling notification channels
class NotificationChannelUpdated extends NotificationState {
  final String channelId;
  final bool isEnabled;

  NotificationChannelUpdated(this.channelId, this.isEnabled);
}

// State when fetching notification settings
class NotificationSettingsLoading extends NotificationState {}

class NotificationSettingsLoaded extends NotificationState {
  final Map<String, bool> notificationSettings;

  NotificationSettingsLoaded(this.notificationSettings);
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}
