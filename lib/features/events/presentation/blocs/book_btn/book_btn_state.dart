part of 'book_btn_bloc.dart';

abstract class BookBtnState {}

final class BookBtnInitial extends BookBtnState {}

class BookBtnLoading extends BookBtnState {}

class SeatsAvailabilityLoaded extends BookBtnState {
  final bool hasSeats;
  SeatsAvailabilityLoaded(this.hasSeats);
}

class BookBtnLoaded extends BookBtnState {
  final List<String> eventsId;
  BookBtnLoaded(this.eventsId);
}

class BookBtnError extends BookBtnState {
  final String msg;
  BookBtnError(this.msg);
}
