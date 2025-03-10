import 'package:eventure/features/events/domain/usecases/booking/add_to_book.dart';
import 'package:eventure/features/events/domain/usecases/booking/get_book_ids.dart';
import 'package:eventure/features/events/domain/usecases/booking/remove_book.dart';
import 'package:eventure/features/events/domain/usecases/booking/seats_availability.dart';
import 'package:eventure/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'book_btn_event.dart';
part 'book_btn_state.dart';

class BookBtnBloc extends Bloc<BookBtnEvent, BookBtnState> {
  final GetBookIds _getBookIds = getIt<GetBookIds>();
  final SeatsAvailability _seatsAvailability = getIt<SeatsAvailability>();
  final AddToBook _add = getIt<AddToBook>();
  final RemoveBook _removeBook = getIt<RemoveBook>();

  BookBtnBloc() : super(BookBtnInitial()) {
    on<FetchBookIds>(_fetchBookIds);
    on<AddToBookIds>(_addToBookIds);
    on<RemoveFromBookIds>(_removeFromBookIds);

    // Fetch the Book ids when the bloc is created
    add(FetchBookIds());
  }

  Future<void> _fetchBookIds(event, emit) async {
    emit(BookBtnLoading());
    final eventsIds = await _getBookIds.call();

    eventsIds.fold(
      (failure) => emit(BookBtnError(failure.message)),
      (eventsIds) => emit(BookBtnLoaded(eventsIds)),
    );
  }

  Future<bool> checkSeatsAvailability(String eventId) async {
    final hasSeats = await _seatsAvailability.call(eventId);

    return hasSeats.fold(
      (failure) => false,
      (hasSeats) => hasSeats,
    );
  }

  Future<void> _addToBookIds(AddToBookIds event, emit) async {
    try {
      if (state is BookBtnLoaded) {
        final currentBookIds = (state as BookBtnLoaded).eventsId;
        emit(BookBtnLoading());
        await _add.call(event.eventId);
        emit(BookBtnLoaded([...currentBookIds, event.eventId]));
      }
    } catch (e) {
      emit(BookBtnError(e.toString()));
    }
  }

  Future<void> _removeFromBookIds(RemoveFromBookIds event, emit) async {
    try {
      if (state is BookBtnLoaded) {
        final currentBookIds = (state as BookBtnLoaded).eventsId;
        emit(BookBtnLoading());
        await _removeBook.call(event.eventId);
        emit(BookBtnLoaded(
          currentBookIds.where((id) => id != event.eventId).toList(),
        ));
      }
    } catch (e) {
      emit(BookBtnError(e.toString()));
    }
  }
}
