part of 'save_btn_bloc.dart';

abstract class SaveBtnState {}

final class SaveBtnInitial extends SaveBtnState {}

class SaveBtnLoading extends SaveBtnState {}

class SaveBtnLoaded extends SaveBtnState {
  final List<String> eventsId;
  SaveBtnLoaded(this.eventsId);
}

class SaveBtnError extends SaveBtnState {
  final String msg;
  SaveBtnError(this.msg);
}
