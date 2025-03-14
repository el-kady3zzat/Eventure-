import 'package:dartz/dartz.dart';
import 'package:eventure/core/errors/failure.dart';
import 'package:eventure/features/events/data/datasources/event_datasource.dart';
import 'package:eventure/features/events/domain/entities/notification.dart';
import 'package:eventure/features/events/domain/repositories/notifications_repo.dart';
import 'package:eventure/injection.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final EventDatasource ds = getIt<EventDatasource>();

  @override
  Future<Either<Failure, void>> registerFcmToken() async {
    try {
      await ds.registerFcmToken();
      return const Right(null);
    } catch (e) {
      return Left(EventFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleNotificationChannel(
    String channelId,
    bool isEnabled,
  ) async {
    try {
      await ds.toggleNotificationChannel(channelId, isEnabled);
      return const Right(null);
    } catch (e) {
      return Left(EventFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, bool>>> getNotificationSettings() async {
    try {
      final settings = await ds.getNotificationSettings();
      return Right(settings);
    } catch (e) {
      return Left(EventFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EventureNotification>>> getNotifications() async {
    return await ds.getNotifications();
  }
}
