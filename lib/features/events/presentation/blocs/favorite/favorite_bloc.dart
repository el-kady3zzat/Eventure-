import 'package:eventure/features/events/domain/usecases/favorite/get_favorite_events.dart';
import 'package:eventure/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventure/features/events/domain/entities/event.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final GetFavoriteEvents _getFavoriteEvents = getIt<GetFavoriteEvents>();

  FavoriteBloc() : super(FavoriteEventsInitial()) {
    on<FetchFavoriteEvents>((event, emit) async {
      emit(FavoriteEventsLoading());

      final events = await _getFavoriteEvents.call();

      events.fold(
        (failure) => emit(FavoriteEventsError(msg: failure.message)),
        (events) => emit(FavoriteEventsLoaded(events: events)),
      );
    });
  }
}
