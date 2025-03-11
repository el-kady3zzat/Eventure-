part of 'edit_profile_bloc.dart';

// edit profile events
abstract class EditProfileEvent {}

class SaveEdits extends EditProfileEvent {
  final BuildContext context;
  final GlobalKey<FormState> formKey;
  final String name;
  final String email;
  final String? password;
  final String phoneNumber;

  SaveEdits({
    required this.context,
    required this.formKey,
    required this.name,
    required this.email,
    this.password,
    required this.phoneNumber,
  });
}

class EditUpdateAvatar extends EditProfileEvent {
  final String? image;
  bool isCamera;
  EditUpdateAvatar({this.image, required this.isCamera});
}

class EditImageUpdated extends EditProfileEvent {
  final Uint8List? image;

  EditImageUpdated({required this.image});
}

class EditProfileUpdated extends EditProfileEvent {
  final FSUser user;
  EditProfileUpdated(this.user);
}

class SubscribeProfile extends EditProfileEvent {}

class ProfileSubscriptionError extends EditProfileEvent {
  final String errorMessage;
  ProfileSubscriptionError(this.errorMessage);
}

class EditImageRemoved extends EditProfileEvent {
  EditImageRemoved();
}