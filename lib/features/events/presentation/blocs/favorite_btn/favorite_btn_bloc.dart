import 'package:eventure/features/events/domain/usecases/favorite/favorite_add.dart';
import 'package:eventure/features/events/domain/usecases/favorite/favorite_remove.dart';
import 'package:eventure/features/events/domain/usecases/favorite/get_favorite_ids.dart';
import 'package:eventure/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'favorite_btn_event.dart';
part 'favorite_btn_state.dart';

class FavoriteBtnBloc extends Bloc<FavoriteBtnEvent, FavoriteBtnState> {
  final GetFavoriteIds _getFavoriteIds = getIt<GetFavoriteIds>();
  final FavoriteAdd _add = getIt<FavoriteAdd>();
  final FavoriteRemove _remove = getIt<FavoriteRemove>();

  FavoriteBtnBloc() : super(FavoriteBtnInitial()) {
    on<FetchFavoriteIds>(_fetchFavoriteIds);
    on<AddToFavoriteIds>(_addToFavoriteIds);
    on<RemoveFromFavoriteIds>(_removeFromFavoriteIds);

    // Fetch the favorite ids when the bloc is created
    add(FetchFavoriteIds());
  }

  Future<void> _fetchFavoriteIds(event, emit) async {
    emit(FavoriteBtnLoading());
    final eventsIds = await _getFavoriteIds.call();

    eventsIds.fold(
      (failure) => emit(FavoriteBtnError(failure.message)),
      (eventsIds) => emit(FavoriteBtnLoaded(eventsIds)),
    );
  }

  Future<void> _addToFavoriteIds(AddToFavoriteIds event, emit) async {
    try {
      if (state is FavoriteBtnLoaded) {
        final currentFavoriteIds = (state as FavoriteBtnLoaded).eventsId;
        await _add.call(event.eventId);
        emit(FavoriteBtnLoaded([...currentFavoriteIds, event.eventId]));
      }
    } catch (e) {
      emit(FavoriteBtnError(e.toString()));
    }
  }

  Future<void> _removeFromFavoriteIds(RemoveFromFavoriteIds event, emit) async {
    try {
      if (state is FavoriteBtnLoaded) {
        final currentFavoriteIds = (state as FavoriteBtnLoaded).eventsId;
        await _remove.call(event.eventId);
        emit(FavoriteBtnLoaded(
          currentFavoriteIds.where((id) => id != event.eventId).toList(),
        ));
      }
    } catch (e) {
      emit(FavoriteBtnError(e.toString()));
    }
  }
}
