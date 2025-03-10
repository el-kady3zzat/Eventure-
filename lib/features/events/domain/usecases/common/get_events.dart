import 'package:dartz/dartz.dart';
import 'package:eventure/core/errors/failure.dart';
import 'package:eventure/features/events/domain/entities/event.dart';
import 'package:eventure/features/events/domain/repositories/event_repo.dart';
import 'package:eventure/injection.dart';

class GetEvents {
  final eventRepo = getIt<EventRepo>();

  Future<Either<Failure, List<Event>>> call() {
    return eventRepo.getEvents();
  }
}
