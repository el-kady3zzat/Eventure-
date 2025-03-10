import 'package:dartz/dartz.dart';
import 'package:eventure/core/errors/failure.dart';
import 'package:eventure/features/events/domain/usecases/notifications/get_notification_settings.dart';
import 'package:eventure/features/events/domain/usecases/notifications/register_fcm_token.dart';
import 'package:eventure/features/events/domain/usecases/notifications/toggle_notification_channel.dart';
import 'package:eventure/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationSettingsBloc
    extends Bloc<NotificationEvent, NotificationState> {
  final RegisterFcmTokenUseCase register = getIt<RegisterFcmTokenUseCase>();
  final ToggleNotificationChannelUseCase toggle =
      getIt<ToggleNotificationChannelUseCase>();
  final GetNotificationSettingsUseCase getNotificationSettings =
      getIt<GetNotificationSettingsUseCase>();

  NotificationSettingsBloc() : super(NotificationInitial()) {
    on<RegisterFcmToken>(_onRegisterFcmToken);
    on<ToggleNotificationChannel>(_onToggleNotificationChannel);
    on<FetchNotificationSettings>(_onFetchNotificationSettings);
  }

  Future<void> _onRegisterFcmToken(
    RegisterFcmToken event,
    Emitter<NotificationState> emit,
  ) async {
    final Either<Failure, void> result = await register();

    result.fold(
      (failure) => emit(NotificationError(failure.toString())),
      (_) => emit(NotificationTokenRegistered()),
    );
  }

  Future<void> _onToggleNotificationChannel(
    ToggleNotificationChannel event,
    Emitter<NotificationState> emit,
  ) async {
    final currentState = state;
    if (currentState is NotificationSettingsLoaded) {
      final newSettings =
          Map<String, bool>.from(currentState.notificationSettings);
      newSettings[event.channelId] = event.isEnabled;
      emit(NotificationSettingsLoaded(newSettings)); // Optimistically update UI

      final result = await toggle(event.channelId, event.isEnabled);
      result.fold(
        (failure) =>
            emit(NotificationError(failure.toString())), // Handle failure
        (_) =>
            emit(NotificationChannelUpdated(event.channelId, event.isEnabled)),
      );
    }

    // final Either<Failure, void> result =
    //     await toggle(event.channelId, event.isEnabled);

    // result.fold(
    //   (failure) => emit(NotificationError(failure.toString())),
    //   (_) => emit(NotificationChannelUpdated(event.channelId, event.isEnabled)),
    // );
  }

  Future<void> _onFetchNotificationSettings(
    FetchNotificationSettings event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await getNotificationSettings.call();

    result.fold(
      (failure) => emit(NotificationError(failure.toString())),
      (settings) => emit(NotificationSettingsLoaded(settings)),
    );
  }
}
