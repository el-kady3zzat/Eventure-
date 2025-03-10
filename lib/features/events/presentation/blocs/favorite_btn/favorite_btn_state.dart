part of 'favorite_btn_bloc.dart';

abstract class FavoriteBtnState {}

final class FavoriteBtnInitial extends FavoriteBtnState {}

class FavoriteBtnLoading extends FavoriteBtnState {}

class FavoriteBtnLoaded extends FavoriteBtnState {
  final List<String> eventsId;
  FavoriteBtnLoaded(this.eventsId);
}

class FavoriteBtnError extends FavoriteBtnState {
  final String msg;
  FavoriteBtnError(this.msg);
}
