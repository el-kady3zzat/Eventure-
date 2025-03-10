part of 'users_images_bloc.dart';

abstract class UsersImagesEvent {}

class LoadUsersImages extends UsersImagesEvent {
  final String eventId;

  LoadUsersImages({required this.eventId});
}
