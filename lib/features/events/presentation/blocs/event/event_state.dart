part of 'event_bloc.dart';

abstract class EventState {}

final class EventInitial extends EventState {}

final class EventLoading extends EventState {}

final class EventLoaded extends EventState {
  final List<Event> events;

  EventLoaded({required this.events});
}

final class EventError extends EventState {
  final String msg;

  EventError({required this.msg});
}
