part of 'events_cubit.dart';

abstract class EventsState {}

class EventsInitial extends EventsState {}

class EventsLoading extends EventsState {}

class EventsLoaded extends EventsState {
  final List<FSEvent> events;
  EventsLoaded(this.events);
}

class EventsError extends EventsState {
  final String message;
  EventsError(this.message);
}

class AddEventLoading extends EventsState {}

class AddEventError extends EventsState {
  final String message;
  AddEventError(this.message);
}

class AddEventSuccess extends EventsState {}
