part of 'users_images_bloc.dart';

abstract class UsersImagesState {}

final class UsersImagesInitial extends UsersImagesState {}

final class UsersImagesLoading extends UsersImagesState {}

final class UsersImagesLoaded extends UsersImagesState {
  final List<String> images;
  UsersImagesLoaded({required this.images});
}

final class UsersImagesError extends UsersImagesState {
  final String msg;
  UsersImagesError({required this.msg});
}
