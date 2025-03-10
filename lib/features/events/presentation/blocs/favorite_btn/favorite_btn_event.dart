part of 'favorite_btn_bloc.dart';

abstract class FavoriteBtnEvent {}

class FetchFavoriteIds extends FavoriteBtnEvent {}

class AddToFavoriteIds extends FavoriteBtnEvent {
  final String eventId;
  AddToFavoriteIds(this.eventId);
}

class RemoveFromFavoriteIds extends FavoriteBtnEvent {
  final String eventId;
  RemoveFromFavoriteIds(this.eventId);
}
