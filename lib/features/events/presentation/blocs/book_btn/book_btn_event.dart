part of 'book_btn_bloc.dart';

abstract class BookBtnEvent {}

class FetchBookIds extends BookBtnEvent {}

class GetSeatsCount extends BookBtnEvent {
  final String eventId;

  GetSeatsCount({required this.eventId});
}

class CheckSeatsAvailability extends BookBtnEvent {
  final String eventId;
  CheckSeatsAvailability(this.eventId);
}

class AddToBookIds extends BookBtnEvent {
  final String eventId;
  AddToBookIds(this.eventId);
}

class RemoveFromBookIds extends BookBtnEvent {
  final String eventId;
  RemoveFromBookIds(this.eventId);
}
