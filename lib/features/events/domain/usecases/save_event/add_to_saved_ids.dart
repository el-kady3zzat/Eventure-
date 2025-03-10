import 'package:dartz/dartz.dart';
import 'package:eventure/core/errors/failure.dart';
import 'package:eventure/features/events/domain/repositories/event_repo.dart';
import 'package:eventure/injection.dart';

class AddToSavedIds {
  final eventRepo = getIt<EventRepo>();

  Future<Either<Failure, void>> call(String eventId) {
    return eventRepo.addToSave(eventId);
  }
}
