import 'package:eventure/features/events/domain/entities/event.dart';
import 'package:eventure/features/events/domain/usecases/common/get_events.dart';
import 'package:eventure/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final GetEvents _getEvents = getIt<GetEvents>();

  EventBloc() : super(EventInitial()) {
    on<FetchEvents>((event, emit) async {
      emit(EventLoading());

      final events = await _getEvents.call();

      events.fold(
        (failure) => emit(EventError(msg: failure.message)),
        (events) => emit(EventLoaded(events: events)),
      );
    });
  }
}
