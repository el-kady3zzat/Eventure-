import 'package:eventure/features/events/domain/usecases/save_event/add_to_saved_ids.dart';
import 'package:eventure/features/events/domain/usecases/save_event/get_saved_ids.dart';
import 'package:eventure/features/events/domain/usecases/save_event/remove_from_saved_ids.dart';
import 'package:eventure/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'save_btn_event.dart';
part 'save_btn_state.dart';

class SaveBtnBloc extends Bloc<SaveBtnEvent, SaveBtnState> {
  final GetSavedIds _getSaveIds = getIt<GetSavedIds>();
  final AddToSavedIds _add = getIt<AddToSavedIds>();
  final RemoveFromSavedIds _remove = getIt<RemoveFromSavedIds>();

  SaveBtnBloc() : super(SaveBtnInitial()) {
    on<FetchSaveIds>(_fetchSaveIds);
    on<AddToSaveIds>(_addToSaveIds);
    on<RemoveFromSaveIds>(_removeFromSaveIds);

    // Fetch the Saved ids when the bloc is created
    add(FetchSaveIds());
  }

  Future<void> _fetchSaveIds(event, emit) async {
    emit(SaveBtnLoading());
    final eventsIds = await _getSaveIds.call();

    eventsIds.fold(
      (failure) => emit(SaveBtnError(failure.message)),
      (eventsIds) => emit(SaveBtnLoaded(eventsIds)),
    );
  }

  Future<void> _addToSaveIds(AddToSaveIds event, emit) async {
    try {
      if (state is SaveBtnLoaded) {
        final currentSaveIds = (state as SaveBtnLoaded).eventsId;
        await _add.call(event.eventId);
        emit(SaveBtnLoaded([...currentSaveIds, event.eventId]));
      }
    } catch (e) {
      emit(SaveBtnError(e.toString()));
    }
  }

  Future<void> _removeFromSaveIds(RemoveFromSaveIds event, emit) async {
    try {
      if (state is SaveBtnLoaded) {
        final currentSaveIds = (state as SaveBtnLoaded).eventsId;
        await _remove.call(event.eventId);
        emit(SaveBtnLoaded(
          currentSaveIds.where((id) => id != event.eventId).toList(),
        ));
      }
    } catch (e) {
      emit(SaveBtnError(e.toString()));
    }
  }
}
