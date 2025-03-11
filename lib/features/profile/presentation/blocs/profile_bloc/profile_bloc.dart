import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventure/features/auth/firebase/firebase_auth_services.dart';
import 'package:eventure/features/auth/models/fire_store_user_model.dart';
import 'package:eventure/features/profile/domain/entities/event_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseService().currentUser;
  bool showEvents = false;
  FSUser? user;
  List<EventEntity> savedEvents = [];
  Uint8List? image;
  Uint8List? headerImage;
  String firstName = "";

  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_loadProfile);
    on<LoadSavedEvents>(_loadSavedEvents);
    on<ToggleShowEvents>((event, emit) {
      showEvents = event.showEvents;
      emit(ShowEventsUpdated(showEvents));

      if (showEvents) {
        add(LoadSavedEvents());
      } else {
        add(LoadProfile());
      }
    });
    add(LoadProfile());
  }

  /// Fetch user profile data
  void _loadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    if (currentUser == null) {
      emit(ProfileError("No user found"));
      return;
    }

    try {
      emit(ProfileLoading());

      DocumentSnapshot doc =
          await _firestore.collection('users').doc(currentUser!.uid).get();

      if (doc.exists) {
        FSUser user = FSUser.fromFirestore(doc);

        emit(ProfileLoaded(user: user, savedEvents: savedEvents));
      } else {
        emit(ProfileError("User data not found"));
      }
    } catch (e) {
      emit(ProfileError("Error loading profile: ${e.toString()}"));
    }
  }

  void _loadSavedEvents(
      LoadSavedEvents event, Emitter<ProfileState> emit) async {
    if (currentUser == null) {
      emit(ProfileError("No user found"));
      return;
    }

    try {
      emit(SavedEventLoading());

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser!.uid).get();

      if (!userDoc.exists) {
        emit(ProfileError("User data not found"));
        return;
      }

      List<String> savedEventIds =
          List<String>.from(userDoc.get('savedEvents') ?? []);
      savedEventIds = savedEventIds.map((id) => id.trim()).toList();

      List<EventEntity> savedEvents = [];

      for (String eventId in savedEventIds) {
        DocumentSnapshot eventDoc =
            await _firestore.collection('events').doc(eventId).get();

        if (eventDoc.exists && eventDoc.data() != null) {
          try {
            EventEntity event = EventEntity.fromFirestore(eventDoc);
            savedEvents.add(event);
          } catch (e) {
            print(" Error parsing event data: $e");
          }
        } else {
          print("Event not found for ID: '$eventId'");
        }
      }

      emit(SavedEventsLoaded(savedEvents: savedEvents));
    } catch (e) {
      emit(ProfileError("Error loading saved events: ${e.toString()}"));
    }
  }

  /// Logout
  void logout() {
    FirebaseService().signOut();
  }
}