part of 'calendar_bloc.dart';

abstract class CalendarEventsState {}

final class CalendarInitial extends CalendarEventsState {}

final class CalendarLoading extends CalendarEventsState {}

final class CalendarLoaded extends CalendarEventsState {
  final List<Event> events;

  CalendarLoaded({required this.events});
}

final class CalendarError extends CalendarEventsState {
  final String msg;

  CalendarError({required this.msg});
}
