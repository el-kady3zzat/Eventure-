import 'package:dartz/dartz.dart';
import 'package:eventure/core/errors/failure.dart';
import 'package:eventure/features/events/data/datasources/event_datasource.dart';
import 'package:eventure/features/events/domain/entities/event.dart';
import 'package:eventure/features/events/domain/repositories/event_repo.dart';
import 'package:eventure/injection.dart';

class EventRepoImpl implements EventRepo {
  final EventDatasource ds = getIt<EventDatasource>();

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCurrentUser() async {
    return await ds.getCurrentUser();
  }

  @override
  Future<Either<Failure, List<Event>>> getEvents() async {
    return await ds.getEvents();
  }

  @override
  Future<Either<Failure, List<Event>>> getCalendarEvents() async {
    return await ds.getCalndarEvents();
  }

  @override
  Future<Either<Failure, List<Event>>> getFavoriteEvents() async {
    return await ds.getFavoriteEvents();
  }

  @override
  Future<Either<Failure, bool>> isEventHasSeats(String eventId) async {
    return await ds.isEventHasSeats(eventId);
  }

  @override
  Stream<Either<Failure, List<String>>> registeredUsersImages(eventId) {
    return ds.registeredUsersImages(eventId);
  }

  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<Either<Failure, List<String>>> getFavoriteIds() async {
    return await ds.getFavoriteIds();
  }

  @override
  Future<Either<Failure, void>> addToFavorites(String eventId) async {
    return await ds.addToFavorite(eventId);
  }

  @override
  Future<Either<Failure, void>> removeFromFavorites(String eventId) async {
    return await ds.removeFromFavorite(eventId);
  }

  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<Either<Failure, List<String>>> getBookIds() async {
    return await ds.getBookIds();
  }

  @override
  Future<Either<Failure, void>> addToBook(String eventId) async {
    return await ds.addToBook(eventId);
  }

  @override
  Future<Either<Failure, void>> removeBook(String eventId) async {
    return await ds.removeBook(eventId);
  }

  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<Either<Failure, void>> addToSave(String eventId) async {
    return await ds.addToSave(eventId);
  }

  @override
  Future<Either<Failure, List<String>>> getSavedIds() async {
    return await ds.getSavedIds();
  }

  @override
  Future<Either<Failure, void>> removeFromSave(String eventId) async {
    return await ds.removeFromSave(eventId);
  }
}
