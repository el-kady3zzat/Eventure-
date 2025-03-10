// Abstract repository contract (interface)
// This defines what our data layer should implement
import 'package:dartz/dartz.dart';
import 'package:eventure/core/errors/failure.dart';
import 'package:eventure/features/events/domain/entities/event.dart';

abstract class EventRepo {
  Future<Either<Failure, Map<String, dynamic>>> getCurrentUser();

  Future<Either<Failure, List<Event>>> getEvents();

  Future<Either<Failure, List<Event>>> getCalendarEvents();

  Future<Either<Failure, List<Event>>> getFavoriteEvents();

  Future<Either<Failure, bool>> isEventHasSeats(String eventId);

  // Stream<Either<Failure, bool>> isEventHasSeats(String eventId);

  Stream<Either<Failure, List<String>>> registeredUsersImages(eventId);

  //////////////////////////////////////////////////////////////////////////////

  Future<Either<Failure, List<String>>> getFavoriteIds();

  Future<Either<Failure, void>> addToFavorites(String eventId);

  Future<Either<Failure, void>> removeFromFavorites(String eventId);

  //////////////////////////////////////////////////////////////////////////////

  Future<Either<Failure, List<String>>> getBookIds();

  Future<Either<Failure, void>> addToBook(String eventId);

  Future<Either<Failure, void>> removeBook(String eventId);

  //////////////////////////////////////////////////////////////////////////////

  Future<Either<Failure, List<String>>> getSavedIds();

  Future<Either<Failure, void>> addToSave(String eventId);

  Future<Either<Failure, void>> removeFromSave(String eventId);
}
