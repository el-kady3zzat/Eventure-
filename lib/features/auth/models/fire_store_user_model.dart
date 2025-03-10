import 'package:cloud_firestore/cloud_firestore.dart';

class FSUser {
  final String uid;
  final String name;
  final String email;
  final String password;
  final String phone;
  final String image;
  final String location;
  final String role;
  final List<String> bookedEvents;
  final List<String> favEvents;
  final List<String> savedEvents;
  String? fcmToken;

  FSUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    this.image = '',
    this.location = 'Egypt',
    this.role = 'client',
    List<String>? bookedEvents,
    List<String>? favEvents,
    List<String>? savedEvents,
    this.fcmToken,
  })  : bookedEvents = bookedEvents ?? [],
        favEvents = favEvents ?? [],
        savedEvents = savedEvents ?? [];

  factory FSUser.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FSUser(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      phone: data['phone'] ?? '',
      image: data['image'] ?? '',
      location: data['location'] ?? 'Egypt',
      role: data['role'] ?? 'client',
      bookedEvents: List<String>.from(data['bookedEvents'] ?? []),
      favEvents: List<String>.from(data['favEvents'] ?? []),
      savedEvents: List<String>.from(data['savedEvents'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() => {
        "id": uid,
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
        "image": image,
        "location": location,
        "role": role,
        "bookedEvents": bookedEvents,
        "favEvents": favEvents,
        "savedEvents": savedEvents,
      };

  // Create a copy of FSUser with modified fields
  FSUser copyWith({
    String? uid,
    String? name,
    String? email,
    String? password,
    String? phone,
    String? image,
    String? location,
    String? role,
    List<String>? bookedEvents,
    List<String>? favEvents,
    List<String>? savedEvents,
  }) {
    return FSUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      location: location ?? this.location,
      role: role ?? this.role,
      bookedEvents: bookedEvents ?? this.bookedEvents,
      favEvents: favEvents ?? this.favEvents,
      savedEvents: savedEvents ?? this.savedEvents,
    );
  }

  // Helper methods
  bool hasBookedEvent(String eventId) => bookedEvents.contains(eventId);
  bool hasFavEvent(String eventId) => favEvents.contains(eventId);
  bool hasSavedEvent(String eventId) => savedEvents.contains(eventId);
}
