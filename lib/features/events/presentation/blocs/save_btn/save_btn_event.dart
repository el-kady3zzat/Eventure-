part of 'save_btn_bloc.dart';

abstract class SaveBtnEvent {}

class FetchSaveIds extends SaveBtnEvent {}

class AddToSaveIds extends SaveBtnEvent {
  final String eventId;
  AddToSaveIds(this.eventId);
}

class RemoveFromSaveIds extends SaveBtnEvent {
  final String eventId;
  RemoveFromSaveIds(this.eventId);
}
