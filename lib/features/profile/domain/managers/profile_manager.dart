import 'package:eventure/features/profile/presentation/blocs/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// profile logic
class ProfileManager {
  void uploadImage(BuildContext context, bool isCam) {
    context.read<EditProfileBloc>().add(EditUpdateAvatar(isCamera: isCam));
  }

  void removeImage(BuildContext context) {
    context.read<EditProfileBloc>().add(EditImageRemoved());
  }
}