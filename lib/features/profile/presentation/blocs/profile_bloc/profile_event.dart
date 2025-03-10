part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class LoadSavedEvents extends ProfileEvent {}

class ToggleShowEvents extends ProfileEvent {
  final bool showEvents;
  ToggleShowEvents(this.showEvents);
}