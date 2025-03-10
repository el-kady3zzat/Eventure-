import 'package:dartz/dartz.dart';
import 'package:eventure/core/errors/failure.dart';
import 'package:eventure/features/events/domain/repositories/notifications_repo.dart';
import 'package:eventure/injection.dart';

class GetNotificationSettingsUseCase {
  final notificationRepo = getIt<NotificationRepository>();

  Future<Either<Failure, Map<String, bool>>> call() async {
    return await notificationRepo.getNotificationSettings();
  }
}
