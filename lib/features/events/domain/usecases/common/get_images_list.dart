import 'package:dartz/dartz.dart';
import 'package:eventure/core/errors/failure.dart';
import 'package:eventure/features/events/domain/repositories/event_repo.dart';
import 'package:eventure/injection.dart';

class GetImagesList {
  final eventRepo = getIt<EventRepo>();

  Stream<Either<Failure, List<String>>> call(eventId) {
    return eventRepo.registeredUsersImages(eventId);
  }
}
