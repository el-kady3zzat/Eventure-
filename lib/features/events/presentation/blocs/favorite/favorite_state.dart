part of 'favorite_bloc.dart';

abstract class FavoriteState {}

final class FavoriteEventsInitial extends FavoriteState {}

final class FavoriteEventsLoading extends FavoriteState {}

final class FavoriteEventsLoaded extends FavoriteState {
  final List<Event> events;

  FavoriteEventsLoaded({required this.events});
}

final class FavoriteEventsError extends FavoriteState {
  final String msg;

  FavoriteEventsError({required this.msg});
}
