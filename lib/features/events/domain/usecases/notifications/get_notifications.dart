import 'package:dartz/dartz.dart';
import 'package:eventure/core/errors/failure.dart';
import 'package:eventure/features/events/domain/entities/notification.dart';
import 'package:eventure/features/events/domain/repositories/notifications_repo.dart';
import 'package:eventure/injection.dart';

class GetNotificationsUseCase {
  final notificationRepo = getIt<NotificationRepository>();

  Future<Either<Failure, List<EventureNotification>>> call() {
    return notificationRepo.getNotifications();
  }
}
