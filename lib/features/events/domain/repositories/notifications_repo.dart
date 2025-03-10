import 'package:dartz/dartz.dart';
import 'package:eventure/core/errors/failure.dart';
import 'package:eventure/features/events/domain/entities/notification.dart';

abstract class NotificationRepository {
  Future<Either<Failure, void>> registerFcmToken();
  Future<Either<Failure, void>> toggleNotificationChannel(
    String channelId,
    bool isEnabled,
  );
  Future<Either<Failure, Map<String, bool>>> getNotificationSettings();

  Future<Either<Failure, List<Notification>>> getNotifications();
}
