import 'package:eventure/features/events/domain/usecases/common/get_calendar_events.dart';
import 'package:eventure/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventure/features/events/domain/entities/event.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarEventsState> {
  final GetCalendarEvents _getCalendarEvents = getIt<GetCalendarEvents>();

  CalendarBloc() : super(CalendarInitial()) {
    on<FetchCalendarEvents>((event, emit) async {
      emit(CalendarLoading());

      final events = await _getCalendarEvents.call();

      events.fold(
        (failure) => emit(CalendarError(msg: failure.message)),
        (events) => emit(CalendarLoaded(events: events)),
      );
    });
  }
}
