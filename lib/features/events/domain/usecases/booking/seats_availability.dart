import 'package:dartz/dartz.dart';
import 'package:eventure/core/errors/failure.dart';
import 'package:eventure/features/events/domain/repositories/event_repo.dart';
import 'package:eventure/injection.dart';

class SeatsAvailability {
  final eventRepo = getIt<EventRepo>();

  Future<Either<Failure, bool>> call(String eventId) {
    return eventRepo.isEventHasSeats(eventId);
  }
}
