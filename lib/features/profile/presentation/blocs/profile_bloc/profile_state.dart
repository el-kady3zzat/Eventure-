part of 'profile_bloc.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class SavedEventLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final FSUser? user;
  final Uint8List? image;
  List<EventEntity>? savedEvents;
  bool? showEvents;
  ProfileLoaded(
      {this.user, this.image, this.savedEvents, this.showEvents = false});
}

class SavedEventsLoaded extends ProfileState {
  final List<EventEntity> savedEvents;

  SavedEventsLoaded({required this.savedEvents});
}

class ProfileError extends ProfileState {
  final String errorMessage;
  ProfileError(this.errorMessage);
}

class ProfileImageLoading extends ProfileState {}

class ProfileImageLoaded extends ProfileState {
  final Uint8List? image;
  ProfileImageLoaded({required this.image});
}

class ShowEventsUpdated extends ProfileState {
  final bool showEvents;
  ShowEventsUpdated(this.showEvents);
}

class ProfileImageUploaded extends ProfileState {
  final Uint8List image;
  ProfileImageUploaded({required this.image});
}

class ProfileImageRemoved extends ProfileState {
  ProfileImageRemoved();
}

class ProfileImageError extends ProfileState {
  final String errorMessage;
  ProfileImageError(this.errorMessage);
}