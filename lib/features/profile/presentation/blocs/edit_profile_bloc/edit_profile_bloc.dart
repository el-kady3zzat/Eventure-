import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eventure/features/auth/firebase/firebase_auth_services.dart';
import 'package:eventure/features/auth/models/fire_store_user_model.dart';
import 'package:eventure/features/events/presentation/pages/home_page.dart';
import 'package:eventure/features/profile/presentation/widgets/edit_profile_page/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(EditInitial()) {
    on<SaveEdits>(_onSaveEdits);
    on<EditUpdateAvatar>(_updateAvatar);
    on<SubscribeProfile>(_subscribeProfile);
    on<EditImageRemoved>(_removeAvatar);
    on<EditProfileUpdated>((event, emit) {
      emit(EditProfileLoaded(user: event.user));
    });

    on<ProfileSubscriptionError>((event, emit) {
      emit(EditProfileError(event.errorMessage));
    });

    on<EditImageUpdated>((event, emit) {
      emit(EditProfileImageLoaded(image: event.image));
    });
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseService().currentUser;
  FSUser? cUser;
  Uint8List? image;
  String firstName = "";
  StreamSubscription<FSUser?>? _userSubscription;

  void _subscribeProfile(
      SubscribeProfile event, Emitter<EditProfileState> emit) {
    if (currentUser == null) {
      debugPrint(" No user found");
      return;
    }

    _userSubscription?.cancel();
    _userSubscription = getUserDataStream(currentUser!.uid).listen(
      (user) {
        if (user != null) {
          cUser = user;
          firstName = user.name.split(" ").first;

          // Decode Base64 string to Uint8List
          if (user.image.isNotEmpty) {
            image = base64Decode(user.image);
          }

          add(EditProfileUpdated(user));
          add(EditImageUpdated(image: image));
        } else {
          add(ProfileSubscriptionError(" User data not found"));
        }
      },
      onError: (error) {
        add(ProfileSubscriptionError(error.toString()));
      },
    );
  }

  Stream<FSUser?> getUserDataStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return FSUser.fromFirestore(doc);
      }
      return null;
    });
  }

  Future<void> _onSaveEdits(
      SaveEdits event, Emitter<EditProfileState> emit) async {
    emit(EditLoading());

    try {
      await saveEdits(event.context, event.formKey, event.name, event.email,
          event.password, event.phoneNumber);
      emit(EditSuccess());
    } catch (e) {
      emit(EditError(e.toString()));
    }
  }

  Future<void> saveEdits(
    BuildContext context,
    GlobalKey<FormState> formKey,
    String name,
    String email,
    String? password,
    String phoneNumber,
  ) async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(currentUser!.uid).get();

    Map<String, dynamic> currentData = userDoc.data() as Map<String, dynamic>;

    bool isChanged = name != currentData['name'] ||
        email != currentData['email'] ||
        phoneNumber != currentData['phone'];

    if (!isChanged) {
      CustomSnackBar.showWarning(
          context: context, message: 'No changes found!');
      return;
    }

    try {
      await FirebaseService().updateUserData({
        'name': name,
        'email': email,
        'phone': phoneNumber,
      }, password: password);

      if (!context.mounted) return;
      CustomSnackBar.showSuccess(
          context: context, message: 'messages.edited_successfully'.tr());
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePage()),
        (route) => false,
      );
    } catch (e) {
      debugPrint(' Error during edit: $e');
      CustomSnackBar.showError(
          context: context, message: 'Edit failed: ${e.toString()}');
    }
  }

  /// Pick and update avatar
  Future<void> _updateAvatar(
      EditUpdateAvatar event, Emitter<EditProfileState> emit) async {
    emit(AvatarUpdating());

    try {
      emit(EditProfileImageLoading());
      final XFile? pickedFile = await ImagePicker().pickImage(
        source: event.isCamera ? ImageSource.camera : ImageSource.gallery,
      );

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        Uint8List imageBytes = await imageFile.readAsBytes();
        String encodedImage = base64Encode(imageBytes);

        // Save user image to Firestore
        await _firestore
            .collection('users')
            .doc(currentUser!.uid)
            .set({'image': encodedImage}, SetOptions(merge: true));

        // Emit empty state to force UI rebuild
        emit(EditProfileImageLoaded(image: null));

        emit(EditProfileImageLoaded(image: Uint8List.fromList(imageBytes)));
        emit(EditProfileImageUploaded(image: Uint8List.fromList(imageBytes)));
      } else {
        emit(EditProfileImageError("No image selected"));
      }
    } catch (e) {
      emit(EditProfileImageError("Failed to update avatar: ${e.toString()}"));
    }
  }

  // remove profile pic
  Future<void> _removeAvatar(
      EditImageRemoved event, Emitter<EditProfileState> emit) async {
    await FirebaseService().removeImageField();
    emit(EditProfileImageRemoved());
  }
}
